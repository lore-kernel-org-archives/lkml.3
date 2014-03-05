Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267AbaCEOhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:37:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41581 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758200AbaCEOhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:37:31 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jeff Layton <jlayton@redhat.com>, Steve French <smfrench@gmail.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 13/62] cifs: ensure that uncached writes handle unmapped areas correctly
Date: Wed,  5 Mar 2014 14:36:17 +0000
Message-Id: <1394030226-26652-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
References: <1394030226-26652-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.32 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/cifs/file.c | 37 ++++++++++++++++++++++++++++++++++---
 1 file changed, 34 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 8a0f553..bd7d67c 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2238,7 +2238,7 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 		 unsigned long nr_segs, loff_t *poffset)
 {
 	unsigned long nr_pages, i;
-	size_t copied, len, cur_len;
+	size_t bytes, copied, len, cur_len;
 	ssize_t total_written = 0;
 	loff_t offset;
 	struct iov_iter it;
@@ -2289,14 +2289,45 @@ cifs_iovec_write(struct file *file, const struct iovec *iov,
 
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
1.9.0

