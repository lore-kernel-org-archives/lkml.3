Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751138AbaKPUJk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 15:09:40 -0500
Received: from smtprelay0086.hostedemail.com ([216.40.44.86]:36077 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750997AbaKPUJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 15:09:37 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:3867:3868:4419:4605:5007:6119:6261:9592:10004:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:13311:13357:13868:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: act09_53bcc86b8ba60
X-Filterd-Recvd-Size: 2834
From: Joe Perches <joe@perches.com>
To: Ionut Alexa <ionut.m.alexa@gmail.com>, linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [UNNECESSARY PATCH 04/16] signal: Use pr_<level>
Date: Sun, 16 Nov 2014 12:09:11 -0800
Message-Id: <e3c505c1b807c150a49e95d442d9fea2e77bdd6c.1416167046.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141116180059.GS7996@ZenIV.linux.org.uk>
References: <20141116180059.GS7996@ZenIV.linux.org.uk>
In-Reply-To: <cover.1416167046.git.joe@perches.com>
References: <cover.1416167046.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the more current logging style.

Add pr_fmt to prefix messages with "signal: "
Remove local use of DEFINE_RATELIMIT_STATE and __ratelimit and
use pr_info_ratelimited instead.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/signal.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 969c6ba..0efde2d 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -10,6 +10,8 @@
  *		to allow signals to be sent reliably.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/slab.h>
 #include <linux/export.h>
 #include <linux/init.h>
@@ -216,16 +218,11 @@ int next_signal(struct sigpending *pending, sigset_t *mask)
 
 static inline void print_dropped_signal(int sig)
 {
-	static DEFINE_RATELIMIT_STATE(ratelimit_state, 5 * HZ, 10);
-
 	if (!print_fatal_signals)
 		return;
 
-	if (!__ratelimit(&ratelimit_state))
-		return;
-
-	printk(KERN_INFO "%s/%d: reached RLIMIT_SIGPENDING, dropped signal %d\n",
-	       current->comm, current->pid, sig);
+	pr_info_ratelimited("%s/%d: reached RLIMIT_SIGPENDING, dropped signal %d\n",
+			    current->comm, current->pid, sig);
 }
 
 /**
@@ -1147,10 +1144,10 @@ static void print_fatal_signal(int signr)
 {
 	struct pt_regs *regs = signal_pt_regs();
 
-	printk(KERN_INFO "potentially unexpected fatal signal %d.\n", signr);
+	pr_info("potentially unexpected fatal signal %d\n", signr);
 
 #if defined(__i386__) && !defined(__arch_um__)
-	printk(KERN_INFO "code at %08lx: ", regs->ip);
+	pr_info("code at %08lx:", regs->ip);
 	{
 		int i;
 
@@ -1159,10 +1156,10 @@ static void print_fatal_signal(int signr)
 
 			if (get_user(insn, (unsigned char *)(regs->ip + i)))
 				break;
-			printk(KERN_CONT "%02x ", insn);
+			pr_cont(" %02x", insn);
 		}
 	}
-	printk(KERN_CONT "\n");
+	pr_cont("\n");
 #endif
 	preempt_disable();
 	show_regs(regs);
-- 
2.1.2

