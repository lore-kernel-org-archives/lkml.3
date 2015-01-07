Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894AbbAGBv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 20:51:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46224 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467AbbAGBvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 20:51:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Changman Lee <cm224.lee@samsung.com>, Jan Kara <jack@suse.cz>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 3.18 19/84] f2fs: fix possible data corruption in f2fs_write_begin()
Date: Tue,  6 Jan 2015 17:49:22 -0800
Message-Id: <20150107014029.625226408@linuxfoundation.org>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <20150107014029.012974975@linuxfoundation.org>
References: <20150107014029.012974975@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit 9234f3190bf8b25b11b105191d408ac50a107948 upstream.

f2fs_write_begin() doesn't initialize the 'dn' variable if the inode has
inline data. However it uses its contents to decide whether it should
just zero out the page or load data to it. Thus if we are unlucky we can
zero out page contents instead of loading inline data into a page.

CC: Changman Lee <cm224.lee@samsung.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/f2fs/data.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -1007,21 +1007,19 @@ inline_data:
 		goto out;
 	}
 
-	if (dn.data_blkaddr == NEW_ADDR) {
+	if (f2fs_has_inline_data(inode)) {
+		err = f2fs_read_inline_data(inode, page);
+		if (err) {
+			page_cache_release(page);
+			goto fail;
+		}
+	} else if (dn.data_blkaddr == NEW_ADDR) {
 		zero_user_segment(page, 0, PAGE_CACHE_SIZE);
 	} else {
-		if (f2fs_has_inline_data(inode)) {
-			err = f2fs_read_inline_data(inode, page);
-			if (err) {
-				page_cache_release(page);
-				goto fail;
-			}
-		} else {
-			err = f2fs_submit_page_bio(sbi, page, dn.data_blkaddr,
-							READ_SYNC);
-			if (err)
-				goto fail;
-		}
+		err = f2fs_submit_page_bio(sbi, page, dn.data_blkaddr,
+					   READ_SYNC);
+		if (err)
+			goto fail;
 
 		lock_page(page);
 		if (unlikely(!PageUptodate(page))) {


