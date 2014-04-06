Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbaDFXks (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 19:40:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59428 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754148AbaDFXjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 19:39:06 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jeff Layton" <jlayton@redhat.com>,
        "Steve French" <smfrench@gmail.com>,
        "Al Viro" <viro@zeniv.linux.org.uk>,
        "Pavel Shilovsky" <piastry@etersoft.ru>
Date: Mon, 07 Apr 2014 00:35:48 +0100
Message-ID: <lsq.1396827348.486893332@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 17/18] cifs: ensure that uncached writes handle
 unmapped areas correctly
In-Reply-To: <lsq.1396827347.462803115@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.2.102
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.57-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@redhat.com>

commit 5d81de8e8667da7135d3a32a964087c0faf5483f upstream.

It's possible for userland to pass down an iovec via writev() that has a
bogus user pointer in it. If that happens and we're doing an uncached
write, then we can end up getting less bytes than we expect from the
call to iov_iter_copy_from_user. This is CVE-2014-0069

cifs_iovec_write isn't set up to handle that situation however. It'll
blindly keep chugging through the page array and not filling those pages
with anything useful. Worse yet, we'll later end up with a negative
number in wdata->tailsz, which will confuse the sending routines and
cause an oops at the very least.

Fix this by having the copy phase of cifs_iovec_write stop copying data
in this situation and send the last write as a short one. At the same
time, we want to avoid sending a zero-length write to the server, so
break out of the loop and set rc to -EFAULT if that happens. This also
allows us to handle the case where no address in the iovec is valid.

[Note: Marking this for stable on v3.4+ kernels, but kernels as old as
       v2.6.38 may have a similar problem and may need similar fix]

Reviewed-by: Pavel Shilovsky <piastry@etersoft.ru>
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Steve French <smfrench@gmail.com>
[bwh: Backported to 3.2:
 - Adjust context
 - s/nr_pages/npages/
 - s/wdata->pages/pages/
 - In case of an error with no data copied, we must kunmap() page 0,
   but in neither case should we free anything else]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/cifs/file.c | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2107,7 +2107,7 @@ cifs_iovec_write(struct file *file, cons
 {
 	unsigned int written;
 	unsigned long num_pages, npages, i;
-	size_t copied, len, cur_len;
+	size_t bytes, copied, len, cur_len;
 	ssize_t total_written = 0;
 	struct kvec *to_send;
 	struct page **pages;
@@ -2165,17 +2165,44 @@ cifs_iovec_write(struct file *file, cons
 	do {
 		size_t save_len = cur_len;
 		for (i = 0; i < npages; i++) {
-			copied = min_t(const size_t, cur_len, PAGE_CACHE_SIZE);
+			bytes = min_t(const size_t, cur_len, PAGE_CACHE_SIZE);
 			copied = iov_iter_copy_from_user(pages[i], &it, 0,
-							 copied);
+							 bytes);
 			cur_len -= copied;
 			iov_iter_advance(&it, copied);
 			to_send[i+1].iov_base = kmap(pages[i]);
 			to_send[i+1].iov_len = copied;
+			/*
+			 * If we didn't copy as much as we expected, then that
+			 * may mean we trod into an unmapped area. Stop copying
+			 * at that point. On the next pass through the big
+			 * loop, we'll likely end up getting a zero-length
+			 * write and bailing out of it.
+			 */
+			if (copied < bytes)
+				break;
 		}
 
 		cur_len = save_len - cur_len;
 
+		/*
+		 * If we have no data to send, then that probably means that
+		 * the copy above failed altogether. That's most likely because
+		 * the address in the iovec was bogus. Set the rc to -EFAULT,
+		 * free anything we allocated and bail out.
+		 */
+		if (!cur_len) {
+			kunmap(pages[0]);
+			rc = -EFAULT;
+			break;
+		}
+
+		/*
+		 * i + 1 now represents the number of pages we actually used in
+		 * the copy phase above.
+		 */
+		npages = i + 1;
+
 		do {
 			if (open_file->invalidHandle) {
 				rc = cifs_reopen_file(open_file, false);

