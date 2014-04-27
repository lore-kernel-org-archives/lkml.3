Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbaD0KKV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 06:10:21 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:35887 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753219AbaD0KKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 06:10:19 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqcWAJrWXFNbslH1/2dsb2JhbABZgwaDOqhHAwEBAQEBBAGZcgICgQgXdIJTExwjGIECJBOIRQHKNYVaiH+EQAEDjnyKDwGSXoMzOw
Date: Sun, 27 Apr 2014 12:12:19 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, anton <anton@tuxera.com>
Subject: [PATCH 1/1] fs/ntfs/mft.c: fix 2 sparse warnings
Message-Id: <20140427121219.02069e58cd40f1b78e8b5971@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs/ntfs/mft.c:471:33: warning: Variable length array is used.
fs/ntfs/mft.c:676:33: warning: Variable length array is used.

This is untested.

Cc: Anton Altaparmakov <anton@tuxera.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ntfs/mft.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index 3014a36..eddb739 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -468,7 +468,7 @@ int ntfs_sync_mft_mirror(ntfs_volume *vol, const unsigned long mft_no,
 	struct page *page;
 	unsigned int blocksize = vol->sb->s_blocksize;
 	int max_bhs = vol->mft_record_size / blocksize;
-	struct buffer_head *bhs[max_bhs];
+	struct buffer_head **bhs;
 	struct buffer_head *bh, *head;
 	u8 *kmirr;
 	runlist_element *rl;
@@ -478,11 +478,14 @@ int ntfs_sync_mft_mirror(ntfs_volume *vol, const unsigned long mft_no,
 
 	ntfs_debug("Entering for inode 0x%lx.", mft_no);
 	BUG_ON(!max_bhs);
-	if (unlikely(!vol->mftmirr_ino)) {
+	bhs = kmalloc(max_bhs * sizeof(struct buffer_head *), GFP_NOFS);
+	if (unlikely(!bhs || !vol->mftmirr_ino)) {
 		/* This could happen during umount... */
 		err = ntfs_sync_mft_mirror_umount(vol, mft_no, m);
-		if (likely(!err))
+		if (likely(!err)) {
+			kfree(bhs);
 			return err;
+		}
 		goto err_out;
 	}
 	/* Get the page containing the mirror copy of the mft record @m. */
@@ -632,6 +635,7 @@ err_out:
 				"after umounting to correct this.", -err);
 		NVolSetErrors(vol);
 	}
+	kfree(bhs);
 	return err;
 }
 
@@ -673,7 +677,7 @@ int write_mft_record_nolock(ntfs_inode *ni, MFT_RECORD *m, int sync)
 	unsigned int blocksize = vol->sb->s_blocksize;
 	unsigned char blocksize_bits = vol->sb->s_blocksize_bits;
 	int max_bhs = vol->mft_record_size / blocksize;
-	struct buffer_head *bhs[max_bhs];
+	struct buffer_head **bhs;
 	struct buffer_head *bh, *head;
 	runlist_element *rl;
 	unsigned int block_start, block_end, m_start, m_end;
@@ -689,7 +693,8 @@ int write_mft_record_nolock(ntfs_inode *ni, MFT_RECORD *m, int sync)
 	 * There is no danger of races since the caller is holding the locks
 	 * for the mft record @m and the page it is in.
 	 */
-	if (!NInoTestClearDirty(ni))
+	bhs = kmalloc(max_bhs * sizeof(struct buffer_head *), GFP_NOFS);
+	if (!bhs || !NInoTestClearDirty(ni))
 		goto done;
 	bh = head = page_buffers(page);
 	BUG_ON(!bh);
@@ -820,6 +825,7 @@ int write_mft_record_nolock(ntfs_inode *ni, MFT_RECORD *m, int sync)
 		goto err_out;
 	}
 done:
+	kfree(bhs);
 	ntfs_debug("Done.");
 	return 0;
 cleanup_out:
@@ -840,6 +846,7 @@ err_out:
 		err = 0;
 	} else
 		NVolSetErrors(vol);
+	kfree(bhs);
 	return err;
 }
 
-- 
1.8.4.5

