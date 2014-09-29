Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbaI2XJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 19:09:09 -0400
Received: from smtprelay0233.hostedemail.com ([216.40.44.233]:46125 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755159AbaI2XJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 19:09:05 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3867:3868:3871:4321:5007:6261:10004:10026:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fork28_14e8136ad9f45
X-Filterd-Recvd-Size: 2071
From: Joe Perches <joe@perches.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/7] debugfs: Fix misuse of seq_printf return value
Date: Mon, 29 Sep 2014 16:08:26 -0700
Message-Id: <2634b19eb1c04a9d31148c1fe6f1f3819be95349.1412031505.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1412031505.git.joe@perches.com>
References: <20140929124246.3e39dac8@gandalf.local.home> <cover.1412031505.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding repeated -1 to the return is not correct.

Use seq_is_full to test for unnecessary seq_printf uses
and always return 0.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/debugfs/file.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/debugfs/file.c b/fs/debugfs/file.c
index 76c08c2..c24e578 100644
--- a/fs/debugfs/file.c
+++ b/fs/debugfs/file.c
@@ -695,15 +695,17 @@ EXPORT_SYMBOL_GPL(debugfs_create_u32_array);
 int debugfs_print_regs32(struct seq_file *s, const struct debugfs_reg32 *regs,
 			   int nregs, void __iomem *base, char *prefix)
 {
-	int i, ret = 0;
+	int i;
 
 	for (i = 0; i < nregs; i++, regs++) {
-		if (prefix)
-			ret += seq_printf(s, "%s", prefix);
-		ret += seq_printf(s, "%s = 0x%08x\n", regs->name,
-				  readl(base + regs->offset));
+		seq_printf(s, "%s%s = 0x%08x\n",
+			   prefix ? prefix : "",
+			   regs->name, readl(base + regs->offset));
+		if (seq_is_full(s))
+			break;
 	}
-	return ret;
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(debugfs_print_regs32);
 
-- 
1.8.1.2.459.gbcd45b4.dirty

