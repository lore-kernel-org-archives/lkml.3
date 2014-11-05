Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbaKEDTb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 22:19:31 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:36452 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127AbaKEDT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 22:19:27 -0500
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: backports@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v2 09/13] backports: define C code backport version info using CPTCFG_
Date: Tue,  4 Nov 2014 19:18:33 -0800
Message-Id: <1415157517-15442-10-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com>
References: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

In order to help unify the naming scheme for shared
backports versioning information rely on the CPTCFG_
prefix, when integration support gets added that will
translate to the respective CONFIG_BACKPORT_ prefix.
Kconfig opt env entries don't get propagated out, so
we need to define these ourselves. This leaves all
other names in place for packaging and just focuses
on sharing on the C / header code.

Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 backport/Makefile.kernel                 |  6 +++---
 backport/backport-include/linux/module.h |  6 +++---
 backport/compat/main.c                   | 32 ++++++++++++++++----------------
 3 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/backport/Makefile.kernel b/backport/Makefile.kernel
index dcb2ba7..a63184b 100644
--- a/backport/Makefile.kernel
+++ b/backport/Makefile.kernel
@@ -10,9 +10,9 @@ NOSTDINC_FLAGS := \
 	-I$(M)/include/uapi \
 	-include $(M)/backport-include/backport/backport.h \
 	$(call backport-cc-disable-warning, unused-but-set-variable) \
-	-DBACKPORTS_VERSION=\"$(BACKPORTS_VERSION)\" \
-	-DBACKPORTED_KERNEL_VERSION=\"$(BACKPORTED_KERNEL_VERSION)\" \
-	-DBACKPORTED_KERNEL_NAME=\"$(BACKPORTED_KERNEL_NAME)\" \
+	-DCPTCFG_VERSION=\"$(BACKPORTS_VERSION)\" \
+	-DCPTCFG_KERNEL_VERSION=\"$(BACKPORTED_KERNEL_VERSION)\" \
+	-DCPTCFG_KERNEL_NAME=\"$(BACKPORTED_KERNEL_NAME)\" \
 	$(BACKPORTS_GIT_TRACKER_DEF) \
 	$(CFLAGS)
 
diff --git a/backport/backport-include/linux/module.h b/backport/backport-include/linux/module.h
index e8f28b1..8870abb 100644
--- a/backport/backport-include/linux/module.h
+++ b/backport/backport-include/linux/module.h
@@ -20,9 +20,9 @@ extern void backport_dependency_symbol(void);
 #define BACKPORT_MOD_VERSIONS MODULE_VERSION(BACKPORTS_GIT_TRACKED);
 #else
 #define BACKPORT_MOD_VERSIONS						\
-	MODULE_VERSION("backported from " BACKPORTED_KERNEL_NAME	\
-		       " (" BACKPORTED_KERNEL_VERSION ")"		\
-		       " using backports " BACKPORTS_VERSION);
+	MODULE_VERSION("backported from " CPTCFG_KERNEL_NAME	\
+		       " (" CPTCFG_KERNEL_VERSION ")"		\
+		       " using backports " CPTCFG_VERSION);
 #endif
 
 #ifdef MODULE
diff --git a/backport/compat/main.c b/backport/compat/main.c
index d3f8944..04ebbfd 100644
--- a/backport/compat/main.c
+++ b/backport/compat/main.c
@@ -8,40 +8,40 @@ MODULE_AUTHOR("Luis R. Rodriguez");
 MODULE_DESCRIPTION("Kernel backport module");
 MODULE_LICENSE("GPL");
 
-#ifndef BACKPORTED_KERNEL_NAME
-#error "You need a BACKPORTED_KERNEL_NAME"
+#ifndef CPTCFG_KERNEL_NAME
+#error "You need a CPTCFG_KERNEL_NAME"
 #endif
 
-#ifndef BACKPORTED_KERNEL_VERSION
-#error "You need a BACKPORTED_KERNEL_VERSION"
+#ifndef CPTCFG_KERNEL_VERSION
+#error "You need a CPTCFG_KERNEL_VERSION"
 #endif
 
-#ifndef BACKPORTS_VERSION
-#error "You need a BACKPORTS_VERSION"
+#ifndef CPTCFG_VERSION
+#error "You need a CPTCFG_VERSION"
 #endif
 
-static char *backported_kernel_name = BACKPORTED_KERNEL_NAME;
+static char *backported_kernel_name = CPTCFG_KERNEL_NAME;
 
 module_param(backported_kernel_name, charp, 0400);
 MODULE_PARM_DESC(backported_kernel_name,
-		 "The kernel tree name that was used for this backport (" BACKPORTED_KERNEL_NAME ")");
+		 "The kernel tree name that was used for this backport (" CPTCFG_KERNEL_NAME ")");
 
-#ifdef BACKPORTS_GIT_TRACKED 
+#ifdef BACKPORTS_GIT_TRACKED
 static char *backports_tracker_id = BACKPORTS_GIT_TRACKED;
 module_param(backports_tracker_id, charp, 0400);
 MODULE_PARM_DESC(backports_tracker_id,
 		 "The version of the tree containing this backport (" BACKPORTS_GIT_TRACKED ")");
 #else
-static char *backported_kernel_version = BACKPORTED_KERNEL_VERSION;
-static char *backports_version = BACKPORTS_VERSION;
+static char *backported_kernel_version = CPTCFG_KERNEL_VERSION;
+static char *backports_version = CPTCFG_VERSION;
 
 module_param(backported_kernel_version, charp, 0400);
 MODULE_PARM_DESC(backported_kernel_version,
-		 "The kernel version that was used for this backport (" BACKPORTED_KERNEL_VERSION ")");
+		 "The kernel version that was used for this backport (" CPTCFG_KERNEL_VERSION ")");
 
 module_param(backports_version, charp, 0400);
 MODULE_PARM_DESC(backports_version,
-		 "The git version of the backports tree used to generate this backport (" BACKPORTS_VERSION ")");
+		 "The git version of the backports tree used to generate this backport (" CPTCFG_VERSION ")");
 
 #endif
 
@@ -63,15 +63,15 @@ static int __init backport_init(void)
 		return ret;
 	}
 
-	printk(KERN_INFO "Loading modules backported from " BACKPORTED_KERNEL_NAME
+	printk(KERN_INFO "Loading modules backported from " CPTCFG_KERNEL_NAME
 #ifndef BACKPORTS_GIT_TRACKED
-		" version " BACKPORTED_KERNEL_VERSION
+		" version " CPTCFG_KERNEL_VERSION
 #endif
 		"\n");
 #ifdef BACKPORTS_GIT_TRACKED
 	printk(KERN_INFO BACKPORTS_GIT_TRACKED "\n");
 #else
-	printk(KERN_INFO "Backport generated by backports.git " BACKPORTS_VERSION "\n");
+	printk(KERN_INFO "Backport generated by backports.git " CPTCFG_VERSION "\n");
 #endif
 
         return 0;
-- 
2.1.1

