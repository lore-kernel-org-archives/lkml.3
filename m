Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbaJWV65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 17:58:57 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:44040 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615AbaJWV6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 17:58:55 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com
Subject: [PATCH v2 01/14] kbuild: add support of custom paths for "auto.conf*" files
Date: Thu, 23 Oct 2014 23:55:59 +0200
Message-Id: <1414101372-14443-2-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1414101372-14443-1-git-send-email-alexis.berlemont@gmail.com>
References: <1414101372-14443-1-git-send-email-alexis.berlemont@gmail.com>
In-Reply-To: <54216F39.9030902@suse.cz>
References: <54216F39.9030902@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the scripts/Makefile.build, use KCONFIG_AUTOCONFIG to include a
custom path for the "auto.conf" file.

The "*conf" programs were modified so as to work with the environment
variable KCONFIG_AUTOCONFIG.

Signed-off-by: Alexis Berlemont <alexis.berlemont@gmail.com>
---

Changes since v1:
 * Use PATH_MAX instead of PATH_MAXLENGTH
 * Simplify conf_get_autoconfigdep_name() according to Micheal Marek's
   advices
 * Remove a superfluous assignment

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

