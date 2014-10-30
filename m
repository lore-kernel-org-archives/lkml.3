Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684AbaJ3SMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 14:12:08 -0400
Received: from smtprelay0039.hostedemail.com ([216.40.44.39]:35415 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758593AbaJ3SMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 14:12:03 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:968:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3354:3865:3866:3867:3868:4321:4419:4605:5007:6119:6261:7808:7904:8603:9592:10004:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:13095:13161:13229:14093:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: loss66_68e2e2924310e
X-Filterd-Recvd-Size: 3398
From: Joe Perches <joe@perches.com>
To: Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] printk: Remove used-once early_vprintk
Date: Thu, 30 Oct 2014 11:11:52 -0700
Message-Id: <0e98acd69b38b9a40aecae6115bf1c6c0c923c99.1414691783.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <cover.1414691783.git.joe@perches.com>
References: <cover.1414691783.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eliminate the unlikely possibility of message interleaving
for early_printk/early_vprintk use.

early_vprintk can be done via the %pV extension so remove
this unnecessary function and change early_printk to have
the equivalent vprintk code.

All uses of early_printk already end with a newline so also
remove the unnecessary newline from the early_printk function.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/tile/kernel/early_printk.c | 19 +++++++++++++------
 include/linux/printk.h          |  1 -
 kernel/printk/printk.c          | 19 ++++++++-----------
 3 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/arch/tile/kernel/early_printk.c b/arch/tile/kernel/early_printk.c
index b608e00..aefb2c0 100644
--- a/arch/tile/kernel/early_printk.c
+++ b/arch/tile/kernel/early_printk.c
@@ -43,13 +43,20 @@ static struct console early_hv_console = {
 
 void early_panic(const char *fmt, ...)
 {
-	va_list ap;
+	struct va_format vaf;
+	va_list args;
+
 	arch_local_irq_disable_all();
-	va_start(ap, fmt);
-	early_printk("Kernel panic - not syncing: ");
-	early_vprintk(fmt, ap);
-	early_printk("\n");
-	va_end(ap);
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	early_printk("Kernel panic - not syncing: %pV", &vaf);
+
+	va_end(args);
+
 	dump_stack();
 	hv_halt();
 }
diff --git a/include/linux/printk.h b/include/linux/printk.h
index d78125f..3dd489f 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -118,7 +118,6 @@ int no_printk(const char *fmt, ...)
 #ifdef CONFIG_EARLY_PRINTK
 extern asmlinkage __printf(1, 2)
 void early_printk(const char *fmt, ...);
-void early_vprintk(const char *fmt, va_list ap);
 #else
 static inline __printf(1, 2) __cold
 void early_printk(const char *s, ...) { }
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index ced2b84..4815c98 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1881,23 +1881,20 @@ static size_t cont_print_text(char *text, size_t size) { return 0; }
 #ifdef CONFIG_EARLY_PRINTK
 struct console *early_console;
 
-void early_vprintk(const char *fmt, va_list ap)
-{
-	if (early_console) {
-		char buf[512];
-		int n = vscnprintf(buf, sizeof(buf), fmt, ap);
-
-		early_console->write(early_console, buf, n);
-	}
-}
-
 asmlinkage __visible void early_printk(const char *fmt, ...)
 {
 	va_list ap;
+	char buf[512];
+	int n;
+
+	if (!early_console)
+		return;
 
 	va_start(ap, fmt);
-	early_vprintk(fmt, ap);
+	n = vscnprintf(buf, sizeof(buf), fmt, ap);
 	va_end(ap);
+
+	early_console->write(early_console, buf, n);
 }
 #endif
 
-- 
2.1.2

