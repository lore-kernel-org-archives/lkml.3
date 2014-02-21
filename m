Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbaBUWTf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 17:19:35 -0500
Received: from smtprelay0098.hostedemail.com ([216.40.44.98]:49609 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752899AbaBUWTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 17:19:34 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:69:355:379:541:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3866:3867:3870:3874:4605:5007:6119:7652:9592:10004:10400:10848:11026:11658:11914:12043:12296:12438:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: paste99_190f857ebe113
X-Filterd-Recvd-Size: 2802
Message-ID: <1393021170.2594.24.camel@joe-AO722>
Subject: [PATCH] capability: Use current logging styles
From: Joe Perches <joe@perches.com>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: linux-security-module <linux-security-module@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 21 Feb 2014 14:19:30 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prefix logging output with "capability: " via pr_fmt.
Convert printks to pr_<level>.
Use pr_<level>_once instead of guard flags.
Coalesce formats.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/capability.c | 29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/kernel/capability.c b/kernel/capability.c
index 34019c5..a8d63df 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -7,6 +7,8 @@
  * 30 May 2002:	Cleanup, Robert M. Love <rml@tech9.net>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/audit.h>
 #include <linux/capability.h>
 #include <linux/mm.h>
@@ -42,15 +44,10 @@ __setup("no_file_caps", file_caps_disable);
 
 static void warn_legacy_capability_use(void)
 {
-	static int warned;
-	if (!warned) {
-		char name[sizeof(current->comm)];
-
-		printk(KERN_INFO "warning: `%s' uses 32-bit capabilities"
-		       " (legacy support in use)\n",
-		       get_task_comm(name, current));
-		warned = 1;
-	}
+	char name[sizeof(current->comm)];
+
+	pr_info_once("warning: `%s' uses 32-bit capabilities (legacy support in use)\n",
+		     get_task_comm(name, current));
 }
 
 /*
@@ -71,16 +68,10 @@ static void warn_legacy_capability_use(void)
 
 static void warn_deprecated_v2(void)
 {
-	static int warned;
+	char name[sizeof(current->comm)];
 
-	if (!warned) {
-		char name[sizeof(current->comm)];
-
-		printk(KERN_INFO "warning: `%s' uses deprecated v2"
-		       " capabilities in a way that may be insecure.\n",
-		       get_task_comm(name, current));
-		warned = 1;
-	}
+	pr_info_once("warning: `%s' uses deprecated v2 capabilities in a way that may be insecure\n",
+		     get_task_comm(name, current));
 }
 
 /*
@@ -380,7 +371,7 @@ bool has_capability_noaudit(struct task_struct *t, int cap)
 bool ns_capable(struct user_namespace *ns, int cap)
 {
 	if (unlikely(!cap_valid(cap))) {
-		printk(KERN_CRIT "capable() called with invalid cap=%u\n", cap);
+		pr_crit("capable() called with invalid cap=%u\n", cap);
 		BUG();
 	}
 


