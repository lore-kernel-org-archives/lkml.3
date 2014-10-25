Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751795AbaJYWXR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 18:23:17 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:65062 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaJYWXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 18:23:15 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        paulus@samba.org, acme@kernel.org, namhyung@kernel.org, mmarek@suse.cz
Subject: [PATCH v4 01/14] kbuild: add support of custom paths for "auto.conf*" files
Date: Sun, 26 Oct 2014 00:20:26 +0200
Message-Id: <1414275639-1053-2-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414275639-1053-1-git-send-email-alexis.berlemont@gmail.com>
References: <1414275639-1053-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <20141024124601.GX14687@kernel.org>
References: <20141024124601.GX14687@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the scripts/Makefile.build, use KCONFIG_AUTOCONFIG to include a
custom path for the "auto.conf" file.

The "*conf" programs were modified so as to work with the environment
variable KCONFIG_AUTOCONFIG.

Signed-off-by: Alexis Berlemont <alexis.berlemont@gmail.com>
---
 scripts/Makefile.build     |  3 ++-
 scripts/kconfig/confdata.c | 23 ++++++++++++++++++++++-
 scripts/kconfig/lkc.h      |  1 +
 3 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 649ce68..2abb82f 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -31,7 +31,8 @@ subdir-asflags-y :=
 subdir-ccflags-y :=
 
 # Read auto.conf if it exists, otherwise ignore
--include include/config/auto.conf
+kconfig-autoconfig := $(if $(KCONFIG_AUTOCONFIG),$(KCONFIG_AUTOCONFIG),include/config/auto.conf)
+-include $(kconfig-autoconfig)
 
 include scripts/Kbuild.include
 
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index f88d90f..75cf6bf 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -75,6 +75,23 @@ const char *conf_get_autoconfig_name(void)
 	return name ? name : "include/config/auto.conf";
 }
 
+const char *conf_get_autoconfigdep_name(void)
+{
+	static char res_value[PATH_MAX+1];
+
+	const char *name = conf_get_autoconfig_name();
+
+	if (strlen(name) > PATH_MAX - 4)
+		name = NULL;
+	else {
+		strcpy(res_value, name);
+		strcat(res_value, ".cmd");
+		name = res_value;
+	}
+
+	return name;
+}
+
 static char *conf_expand_value(const char *in)
 {
 	struct symbol *sym;
@@ -953,7 +970,11 @@ int conf_write_autoconf(void)
 
 	sym_clear_all_valid();
 
-	file_write_dep("include/config/auto.conf.cmd");
+	name = conf_get_autoconfigdep_name();
+	if (name == NULL)
+		return 1;
+
+	file_write_dep(name);
 
 	if (conf_split_config())
 		return 1;
diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index d5daa7a..ac99004 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -84,6 +84,7 @@ const char *zconf_curname(void);
 /* confdata.c */
 const char *conf_get_configname(void);
 const char *conf_get_autoconfig_name(void);
+const char *conf_get_autoconfigdep_name(void);
 char *conf_get_default_confname(void);
 void sym_set_change_count(int count);
 void sym_add_change_count(int count);
-- 
2.1.1

