Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbaCYRoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:44:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55831 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754884AbaCYRVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:21:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 24/81] cifs: ensure that uncached writes handle unmapped areas correctly
Date: Tue, 25 Mar 2014 10:15:37 -0700
Message-Id: <1395767794-5012-25-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/cifs/file.c | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index ae62632..d1574bf 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2352,7 +2352,7 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 		 unsigned long nr_segs, loff_t *poffset)
 {
 	unsigned long nr_pages, i;
-	size_t copied, len, cur_len;
+	size_t bytes, copied, len, cur_len;
 	ssize_t total_written = 0;
 	loff_t offset;
 	struct iov_iter it;
@@ -2407,14 +2407,45 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 
 		save_len = cur_len;
 		for (i = 0; i < nr_pages; i++) {
-			copied = min_t(const size_t, cur_len, PAGE_SIZE);
+			bytes = min_t(const size_t, cur_len, PAGE_SIZE);
 			copied = iov_iter_copy_from_user(wdata->pages[i], &it,
-							 0, copied);
+							 0, bytes);
 			cur_len -= copied;
 			iov_iter_advance(&it, copied);
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
+			for (i = 0; i < nr_pages; i++)
+				put_page(wdata->pages[i]);
+			kfree(wdata);
+			rc = -EFAULT;
+			break;
+		}
+
+		/*
+		 * i + 1 now represents the number of pages we actually used in
+		 * the copy phase above. Bring nr_pages down to that, and free
+		 * any pages that we didn't use.
+		 */
+		for ( ; nr_pages > i + 1; nr_pages--)
+			put_page(wdata->pages[nr_pages - 1]);
+
 		wdata->sync_mode = WB_SYNC_ALL;
 		wdata->nr_pages = nr_pages;
 		wdata->offset = (__u64)offset;
-- 
1.8.3.2

