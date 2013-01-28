Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab3A1Q55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 11:57:57 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:45651 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab3A1Q5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 11:57:54 -0500
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-security-module@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>
Subject: [PATCH 15/15] MODSIGN: Always enforce module signing in a Secure Boot environment
Date: Mon, 28 Jan 2013 11:42:39 -0500
Message-Id: <1359391359-25783-16-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
References: <1359391359-25783-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:6267:20ff:fec3:2318
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@redhat.com>

If a machine is booted into a Secure Boot environment, we need to
protect the trust model.  This requires that all modules be signed
with a key that is in the kernel's _modsign keyring.  The checks for
this are already done via the 'sig_enforce' module parameter.  Make
this visible within the kernel and force it to be true.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 kernel/cred.c   | 8 ++++++++
 kernel/module.c | 4 ++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/kernel/cred.c b/kernel/cred.c
index c3f4e3e..c5554e0 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -565,11 +565,19 @@ void __init cred_init(void)
 				     0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
 }
 
+#ifdef CONFIG_MODULE_SIG
+extern bool sig_enforce;
+#endif
+
 void __init secureboot_enable()
 {
 	pr_info("Secure boot enabled\n");
 	cap_lower((&init_cred)->cap_bset, CAP_COMPROMISE_KERNEL);
 	cap_lower((&init_cred)->cap_permitted, CAP_COMPROMISE_KERNEL);
+#ifdef CONFIG_MODULE_SIG
+	/* Enable module signature enforcing */
+	sig_enforce = true;
+#endif
 }
 
 /* Dummy Secure Boot enable option to fake out UEFI SB=1 */
diff --git a/kernel/module.c b/kernel/module.c
index eab0827..93a16dc 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -109,9 +109,9 @@ struct list_head *kdb_modules = &modules; /* kdb needs the list of modules */
 
 #ifdef CONFIG_MODULE_SIG
 #ifdef CONFIG_MODULE_SIG_FORCE
-static bool sig_enforce = true;
+bool sig_enforce = true;
 #else
-static bool sig_enforce = false;
+bool sig_enforce = false;
 
 static int param_set_bool_enable_only(const char *val,
 				      const struct kernel_param *kp)
-- 
1.8.0.2

