Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210AbaIVVzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:55:55 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:52231 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbaIVVzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:55:52 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        dsahern@gmail.com, mingo@kernel.org, sam@ravnborg.org, mmarek@suse.cz,
        namhyung@kernel.org
Subject: [PATCH 01/15] kbuild: add support of custom paths for "auto.conf*" files
Date: Mon, 22 Sep 2014 23:53:02 +0200
Message-Id: <1411422796-27049-2-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1411422796-27049-1-git-send-email-alexis.berlemont@gmail.com>
References: <1411422796-27049-1-git-send-email-alexis.berlemont@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the scripts/Makefile.build, use KCONFIG_AUTOCONFIG to include a
custom path for the "auto.conf" file.

The "*conf" programs were modified so as to work with the environment
variable KCONFIG_AUTOCONFIG.
---
 scripts/Makefile.build     |  3 ++-
 scripts/kconfig/confdata.c | 27 ++++++++++++++++++++++++++-
 scripts/kconfig/lkc.h      |  1 +
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index bf3e677..ef60769 100644
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
index f88d90f..d4d8920 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -75,6 +75,27 @@ const char *conf_get_autoconfig_name(void)
 	return name ? name : "include/config/auto.conf";
 }
 
+#define PATH_MAXLENGTH 4096
+const char *conf_get_autoconfigdep_name(void)
+{
+	static char res_value[PATH_MAXLENGTH];
+
+	char *name = getenv("KCONFIG_AUTOCONFIG");
+
+	if (name == NULL)
+		name = "include/config/auto.conf.cmd";
+	if (strlen(name) > PATH_MAXLENGTH - 5)
+		name = NULL;
+	else {
+		res_value[0] = 0;
+		strncpy(res_value, name, PATH_MAXLENGTH);
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
@@ -953,7 +974,11 @@ int conf_write_autoconf(void)
 
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
2.1.0

