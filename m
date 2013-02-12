Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933582Ab3BLRfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 12:35:12 -0500
Received: from mail.tpi.com ([70.99.223.143]:4427 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933428Ab3BLRfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 12:35:08 -0500
From: Tim Gardner <tim.gardner@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Tim Gardner <tim.gardner@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH linux-next] befs: befs_fill_super(): remove unreachable code
Date: Tue, 12 Feb 2013 10:34:47 -0700
Message-Id: <1360690488-60060-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

befs_sb->num_blocks is of base type u64 which is the same as sector_t.
Therefore, num_blocks can never be larger then the maximum
value of sector_t.

smatch analysis:

fs/befs/linuxvfs.c:851 befs_fill_super() warn: impossible
 condition '(befs_sb->num_blocks > ~(0)) => (0-u64max > u64max)'

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 fs/befs/linuxvfs.c |    7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index 2b3bda8..2ce5705 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -848,13 +848,6 @@ befs_fill_super(struct super_block *sb, void *data, int silent)
 	if (befs_check_sb(sb) != BEFS_OK)
 		goto unacquire_priv_sbp;
 
-	if( befs_sb->num_blocks > ~((sector_t)0) ) {
-		befs_error(sb, "blocks count: %Lu "
-			"is larger than the host can use",
-			befs_sb->num_blocks);
-		goto unacquire_priv_sbp;
-	}
-
 	/*
 	 * set up enough so that it can read an inode
 	 * Fill in kernel superblock fields from private sb
-- 
1.7.9.5

