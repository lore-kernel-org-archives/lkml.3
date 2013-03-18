Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933393Ab3CRVdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:33:01 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:35930 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab3CRVcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:32:54 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
        kexec@lists.infradead.org, linux-pci@vger.kernel.org,
        Josh Boyer <jwboyer@redhat.com>
Subject: [PATCH 03/12] Secure boot: Add a dummy kernel parameter that will switch on Secure Boot mode
Date: Mon, 18 Mar 2013 17:32:24 -0400
Message-Id: <1363642353-30749-3-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
References: <1363642353-30749-1-git-send-email-matthew.garrett@nebula.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 2001:470:1f07:1371:e0f4:3a1:9c35:d688
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@redhat.com>

This forcibly drops CAP_COMPROMISE_KERNEL from both cap_permitted and cap_bset
in the init_cred struct, which everything else inherits from.  This works on
any machine and can be used to develop even if the box doesn't have UEFI.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---
 Documentation/kernel-parameters.txt |  7 +++++++
 kernel/cred.c                       | 17 +++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4609e81..7c0b137 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2683,6 +2683,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Note: increases power consumption, thus should only be
 			enabled if running jitter sensitive (HPC/RT) workloads.
 
+	secureboot_enable=
+			[KNL] Enables an emulated UEFI Secure Boot mode.  This
+			locks down various aspects of the kernel guarded by the
+			CAP_COMPROMISE_KERNEL capability.  This includes things
+			like /dev/mem, IO port access, and other areas.  It can
+			be used on non-UEFI machines for testing purposes.
+
 	security=	[SECURITY] Choose a security module to enable at boot.
 			If this boot parameter is not specified, only the first
 			security module asking for security registration will be
diff --git a/kernel/cred.c b/kernel/cred.c
index e0573a4..c3f4e3e 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -565,6 +565,23 @@ void __init cred_init(void)
 				     0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
 }
 
+void __init secureboot_enable()
+{
+	pr_info("Secure boot enabled\n");
+	cap_lower((&init_cred)->cap_bset, CAP_COMPROMISE_KERNEL);
+	cap_lower((&init_cred)->cap_permitted, CAP_COMPROMISE_KERNEL);
+}
+
+/* Dummy Secure Boot enable option to fake out UEFI SB=1 */
+static int __init secureboot_enable_opt(char *str)
+{
+	int sb_enable = !!simple_strtol(str, NULL, 0);
+	if (sb_enable)
+		secureboot_enable();
+	return 1;
+}
+__setup("secureboot_enable=", secureboot_enable_opt);
+
 /**
  * prepare_kernel_cred - Prepare a set of credentials for a kernel service
  * @daemon: A userspace daemon to be used as a reference
-- 
1.8.1.2

