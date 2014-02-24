Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbaBXWBX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 17:01:23 -0500
Received: from smtprelay0228.hostedemail.com ([216.40.44.228]:42078 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753051AbaBXWAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 17:00:45 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:2:41:69:355:379:541:800:901:960:967:973:988:989:1260:1345:1359:1437:1535:1605:1730:1747:1777:1792:2198:2199:2393:2525:2538:2561:2564:2682:2685:2859:2892:2894:2895:2898:2899:2901:2910:2923:2924:2925:2926:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3657:3865:3866:3867:3868:3871:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4050:4119:4321:4605:5007:6119:6261:7774:7809:7875:7903:9010:9025:9040:10004:10026:10848:11026:11473:11658:11855:11914:12043:12294:12296:12438:12517:12519:12555:12679:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: lake78_2375313e5bc09
X-Filterd-Recvd-Size: 8229
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Kentaro Takeda <takedakn@nttdata.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org
Subject: [PATCH 7/8] security: tomoyo: Use a more current logging style
Date: Mon, 24 Feb 2014 14:00:00 -0800
Message-Id: <821a3d8fe98a08cbb3fa1be24b083bf1fb6cdc45.1393279025.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1393279025.git.joe@perches.com>
References: <cover.1393279025.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert printks to pr_<level>
Add pr_fmt to prefix output with "tomoyo: "
Coalesce formats.

Signed-off-by: Joe Perches <joe@perches.com>
---
 security/tomoyo/common.c      | 23 ++++++++++-------------
 security/tomoyo/domain.c      |  8 ++++----
 security/tomoyo/load_policy.c |  9 +++++----
 security/tomoyo/memory.c      |  7 ++++---
 security/tomoyo/tomoyo.c      |  4 +++-
 security/tomoyo/util.c        |  7 ++++---
 6 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/security/tomoyo/common.c b/security/tomoyo/common.c
index 283862a..f18d73c 100644
--- a/security/tomoyo/common.c
+++ b/security/tomoyo/common.c
@@ -4,6 +4,8 @@
  * Copyright (C) 2005-2011  NTT DATA CORPORATION
  */
 
+#define pr_fmt(fmt) "tomoyo: " fmt
+
 #include <linux/uaccess.h>
 #include <linux/slab.h>
 #include <linux/security.h>
@@ -945,8 +947,8 @@ static bool tomoyo_manager(void)
 		static pid_t last_pid;
 		const pid_t pid = current->pid;
 		if (last_pid != pid) {
-			printk(KERN_WARNING "%s ( %s ) is not permitted to "
-			       "update policies.\n", domainname->name, exe);
+			pr_warn("%s ( %s ) is not permitted to update policies\n",
+				domainname->name, exe);
 			last_pid = pid;
 		}
 	}
@@ -2702,29 +2704,24 @@ void tomoyo_check_profile(void)
 	struct tomoyo_domain_info *domain;
 	const int idx = tomoyo_read_lock();
 	tomoyo_policy_loaded = true;
-	printk(KERN_INFO "TOMOYO: 2.5.0\n");
+	pr_info("TOMOYO: 2.5.0\n");
 	list_for_each_entry_rcu(domain, &tomoyo_domain_list, list) {
 		const u8 profile = domain->profile;
 		const struct tomoyo_policy_namespace *ns = domain->ns;
 		if (ns->profile_version != 20110903)
-			printk(KERN_ERR
-			       "Profile version %u is not supported.\n",
+			pr_err("Profile version %u is not supported\n",
 			       ns->profile_version);
 		else if (!ns->profile_ptr[profile])
-			printk(KERN_ERR
-			       "Profile %u (used by '%s') is not defined.\n",
+			pr_err("Profile %u (used by '%s') is not defined\n",
 			       profile, domain->domainname->name);
 		else
 			continue;
-		printk(KERN_ERR
-		       "Userland tools for TOMOYO 2.5 must be installed and "
-		       "policy must be initialized.\n");
-		printk(KERN_ERR "Please see http://tomoyo.sourceforge.jp/2.5/ "
-		       "for more information.\n");
+		pr_err("Userland tools for TOMOYO 2.5 must be installed and policy must be initialized\n");
+		pr_err("Please see http://tomoyo.sourceforge.jp/2.5/ for more information\n");
 		panic("STOP!");
 	}
 	tomoyo_read_unlock(idx);
-	printk(KERN_INFO "Mandatory Access Control activated.\n");
+	pr_info("Mandatory Access Control activated\n");
 }
 
 /**
diff --git a/security/tomoyo/domain.c b/security/tomoyo/domain.c
index 3865145..a150642 100644
--- a/security/tomoyo/domain.c
+++ b/security/tomoyo/domain.c
@@ -4,6 +4,8 @@
  * Copyright (C) 2005-2011  NTT DATA CORPORATION
  */
 
+#define pr_fmt(fmt) "tomoyo: " fmt
+
 #include "common.h"
 #include <linux/binfmts.h>
 #include <linux/slab.h>
@@ -819,8 +821,7 @@ force_jump_domain:
 	if (domain)
 		retval = 0;
 	else if (reject_on_transition_failure) {
-		printk(KERN_WARNING "ERROR: Domain '%s' not ready.\n",
-		       ee->tmp);
+		pr_warn("ERROR: Domain '%s' not ready\n", ee->tmp);
 		retval = -ENOMEM;
 	} else if (ee->r.mode == TOMOYO_CONFIG_ENFORCING)
 		retval = -ENOMEM;
@@ -831,8 +832,7 @@ force_jump_domain:
 			ee->r.granted = false;
 			tomoyo_write_log(&ee->r, "%s", tomoyo_dif
 					 [TOMOYO_DIF_TRANSITION_FAILED]);
-			printk(KERN_WARNING
-			       "ERROR: Domain '%s' not defined.\n", ee->tmp);
+			pr_warn("ERROR: Domain '%s' not defined\n", ee->tmp);
 		}
 	}
  out:
diff --git a/security/tomoyo/load_policy.c b/security/tomoyo/load_policy.c
index 078fac0..f5f5a06 100644
--- a/security/tomoyo/load_policy.c
+++ b/security/tomoyo/load_policy.c
@@ -4,6 +4,8 @@
  * Copyright (C) 2005-2011  NTT DATA CORPORATION
  */
 
+#define pr_fmt(fmt) "tomoyo: " fmt
+
 #include "common.h"
 
 #ifndef CONFIG_SECURITY_TOMOYO_OMIT_USERSPACE_LOADER
@@ -39,8 +41,8 @@ static bool tomoyo_policy_loader_exists(void)
 	if (!tomoyo_loader)
 		tomoyo_loader = CONFIG_SECURITY_TOMOYO_POLICY_LOADER;
 	if (kern_path(tomoyo_loader, LOOKUP_FOLLOW, &path)) {
-		printk(KERN_INFO "Not activating Mandatory Access Control "
-		       "as %s does not exist.\n", tomoyo_loader);
+		pr_info("Not activating Mandatory Access Control as %s does not exist\n",
+			tomoyo_loader);
 		return false;
 	}
 	path_put(&path);
@@ -95,8 +97,7 @@ void tomoyo_load_policy(const char *filename)
 	if (!tomoyo_policy_loader_exists())
 		return;
 	done = true;
-	printk(KERN_INFO "Calling %s to load policy. Please wait.\n",
-	       tomoyo_loader);
+	pr_info("Calling %s to load policy. Please wait.\n", tomoyo_loader);
 	argv[0] = (char *) tomoyo_loader;
 	argv[1] = NULL;
 	envp[0] = "HOME=/";
diff --git a/security/tomoyo/memory.c b/security/tomoyo/memory.c
index 0e99571..b9bc828 100644
--- a/security/tomoyo/memory.c
+++ b/security/tomoyo/memory.c
@@ -4,6 +4,8 @@
  * Copyright (C) 2005-2011  NTT DATA CORPORATION
  */
 
+#define pr_fmt(fmt) "tomoyo: " fmt
+
 #include <linux/hash.h>
 #include <linux/slab.h>
 #include "common.h"
@@ -19,12 +21,11 @@ void tomoyo_warn_oom(const char *function)
 	static pid_t tomoyo_last_pid;
 	const pid_t pid = current->pid;
 	if (tomoyo_last_pid != pid) {
-		printk(KERN_WARNING "ERROR: Out of memory at %s.\n",
-		       function);
+		pr_warn("ERROR: Out of memory at %s\n", function);
 		tomoyo_last_pid = pid;
 	}
 	if (!tomoyo_policy_loaded)
-		panic("MAC Initialization failed.\n");
+		panic("MAC Initialization failed\n");
 }
 
 /* Memoy currently used by policy/audit log/query. */
diff --git a/security/tomoyo/tomoyo.c b/security/tomoyo/tomoyo.c
index f0b756e..d363805 100644
--- a/security/tomoyo/tomoyo.c
+++ b/security/tomoyo/tomoyo.c
@@ -4,6 +4,8 @@
  * Copyright (C) 2005-2011  NTT DATA CORPORATION
  */
 
+#define pr_fmt(fmt) "tomoyo: " fmt
+
 #include <linux/security.h>
 #include "common.h"
 
@@ -552,7 +554,7 @@ static int __init tomoyo_init(void)
 	/* register ourselves with the security framework */
 	if (register_security(&tomoyo_security_ops))
 		panic("Failure registering TOMOYO Linux");
-	printk(KERN_INFO "TOMOYO Linux initialized\n");
+	pr_info("TOMOYO Linux initialized\n");
 	cred->security = &tomoyo_kernel_domain;
 	tomoyo_mm_init();
 	return 0;
diff --git a/security/tomoyo/util.c b/security/tomoyo/util.c
index 2952ba5..4d4131c 100644
--- a/security/tomoyo/util.c
+++ b/security/tomoyo/util.c
@@ -4,6 +4,8 @@
  * Copyright (C) 2005-2011  NTT DATA CORPORATION
  */
 
+#define pr_fmt(fmt) "tomoyo: " fmt
+
 #include <linux/slab.h>
 #include "common.h"
 
@@ -1077,9 +1079,8 @@ bool tomoyo_domain_quota_is_ok(struct tomoyo_request_info *r)
 		domain->flags[TOMOYO_DIF_QUOTA_WARNED] = true;
 		/* r->granted = false; */
 		tomoyo_write_log(r, "%s", tomoyo_dif[TOMOYO_DIF_QUOTA_WARNED]);
-		printk(KERN_WARNING "WARNING: "
-		       "Domain '%s' has too many ACLs to hold. "
-		       "Stopped learning mode.\n", domain->domainname->name);
+		pr_warn("WARNING: Domain '%s' has too many ACLs to hold - stopped learning mode\n",
+			domain->domainname->name);
 	}
 	return false;
 }
-- 
1.8.1.2.459.gbcd45b4.dirty

