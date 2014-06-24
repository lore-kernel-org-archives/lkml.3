Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaFXCex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 22:34:53 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:17516 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaFXCev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 22:34:51 -0400
X-AuditID: cbfee61b-f79f86d00000144c-e2-53a8e3c9b4f9
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH] f2fs: fix error path in init_inode_metadata
Date: Tue, 24 Jun 2014 10:34:00 +0800
Message-id: <001401cf8f54$dedfafa0$9c9f0ee0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac+PTMGekTqxqIdmRd2ll4qnrytu6A==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsVy+t9jQd2Tj1cEGzx/bWVxbV8jk8WT9bOY
	LS4tcrfYs/cki8XlXXPYHFg9Nq3qZPPYveAzk0ffllWMHp83yQWwRHHZpKTmZJalFunbJXBl
	fL98kKlgNWfFlwdsDYzH2bsYOTkkBEwkHmz/xARhi0lcuLeeDcQWEpjOKNH1vRLC/sEo0Xuc
	F8RmE1CRWN7xH6xeRMBLYtL+EywgNrNApsS9phnMXYwcHMICbhIzP7qChFkEVCW2f3sLVs4r
	YCnx7cAxZghbUOLH5HtQrVoS63ceZ4Kw5SU2r3nLDHGOgsSOs68ZIVbpSVx6vZcdokZcYuOR
	WywTGAVmIRk1C8moWUhGzULSsoCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcFg/k97B
	uKrB4hCjAAejEg9vROCKYCHWxLLiytxDjBIczEoivIEbgEK8KYmVValF+fFFpTmpxYcYpTlY
	lMR5D7ZaBwoJpCeWpGanphakFsFkmTg4pRoYKw5LzSj/JfWQaWkYo5ZrPOvDDdGtn7LzJkUy
	Twzlb/de9C74dG2L3YUV/+ddY/s9d0brU/Vprff2HV7c7vNH0Of3t3nfA3k8G7Jm6cb2uitk
	z1m5NeyPnfWWZbWz4j77rLmrwcoj1mMuw8W93H76mQgm60XqwbobeY5WGFu9eWMuub7jjJOI
	EktxRqKhFnNRcSIAHw8yEmcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we fail in this path:
->init_inode_metadata
  ->make_empty_dir
    ->get_new_data_page
      ->grab_cache_page return -ENOMEM

We will bug on in error path of init_inode_metadata when call remove_inode_page
because i_block = 2 (one inode block will be released later & one dentry block).

We should release the dentry block in init_inode_metadata to avoid this BUG_ON,
and avoid leak of dentry block resource, because we never have second chance to
release that block in ->evict_inode as in upper error path we make this inode
'bad'.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
index 09760d5..3677f41 100644
--- a/fs/f2fs/dir.c
+++ b/fs/f2fs/dir.c
@@ -384,11 +384,11 @@ static struct page *init_inode_metadata(struct inode *inode,
 
 put_error:
 	f2fs_put_page(page, 1);
+error:
 	/* once the failed inode becomes a bad inode, i_mode is S_IFREG */
 	truncate_inode_pages(&inode->i_data, 0);
 	truncate_blocks(inode, 0);
 	remove_dirty_dir_inode(inode);
-error:
 	remove_inode_page(inode);
 	return ERR_PTR(err);
 }
-- 
1.7.9.5


