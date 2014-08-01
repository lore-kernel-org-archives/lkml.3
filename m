Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513AbaHAMu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 08:50:57 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:54119 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755106AbaHAMu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 08:50:56 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtAIAE+M21NXQwj+/2dsb2JhbABbgw2BKa5DBQEBAQEBAQUBbqQXgQgXd4QxLyOBGjeIRgHJfheFfIlQHYQ1BZBViyWUWoNLOy8
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Fengguang Wu <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: [RFC 1/1] fs/befs/linuxvfs.c: check superblock before dump operation
Date: Fri,  1 Aug 2014 14:50:24 +0200
Message-Id: <1406897424-3048-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

befs_dump_super_block was called between befs_load_sb and befs_check_sb.
It has been reported to crash (5/900) with null block testing.

This patch loads, checks and only dump superblock if it's a valid one then
brelse bh.

(befs_dump_super_block uses disk_sb (bh->b_data) so it seems we need to call
it before brelse(bh) but I don't know why befs_check_sb was called
after brelse. Another thing I don't understand is why this problem appears now).

Reported-By: Fengguang Wu <fengguang.wu@intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/befs/linuxvfs.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index a16fbd4..633d5ff 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -834,16 +834,14 @@ befs_fill_super(struct super_block *sb, void *data, int silent)
 		    (befs_super_block *) ((void *) bh->b_data + x86_sb_off);
 	}
 
-	if (befs_load_sb(sb, disk_sb) != BEFS_OK)
+	if ((befs_load_sb(sb, disk_sb) != BEFS_OK) ||
+	    (befs_check_sb(sb) != BEFS_OK))
 		goto unacquire_bh;
 
 	befs_dump_super_block(sb, disk_sb);
 
 	brelse(bh);
 
-	if (befs_check_sb(sb) != BEFS_OK)
-		goto unacquire_priv_sbp;
-
 	if( befs_sb->num_blocks > ~((sector_t)0) ) {
 		befs_error(sb, "blocks count: %llu "
 			"is larger than the host can use",
-- 
1.8.4.5

