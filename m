Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaIAHQq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 03:16:46 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:34319 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752570AbaIAHQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 03:16:43 -0400
Subject: [PATCH v2 1/4] kconfig: save values imported from environment into
 config file
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Cc: Paul Bolle <pebolle@tiscali.nl>, Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 01 Sep 2014 11:16:29 +0400
Message-ID: <20140901071629.28909.20328.stgit@zurg>
In-Reply-To: <20140901065916.28909.35097.stgit@zurg>
References: <20140901065916.28909.35097.stgit@zurg>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After this patch option env="..." behaves more like user input.
Environment variable becomes optional, its last state is saved in config.

Impact of this change is minimal. This option is used only three times:
for ARCH, SRCARCH and KERNELVERSION. All of them are always defined by
root Makefile.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
---
 Documentation/kbuild/kconfig-language.txt |   10 ++++------
 scripts/kconfig/confdata.c                |   26 ++++++++++++++++++++++++++
 scripts/kconfig/expr.h                    |    2 +-
 scripts/kconfig/symbol.c                  |    3 ---
 4 files changed, 31 insertions(+), 10 deletions(-)

diff --git a/Documentation/kbuild/kconfig-language.txt b/Documentation/kbuild/kconfig-language.txt
index 350f733..0dad00a 100644
--- a/Documentation/kbuild/kconfig-language.txt
+++ b/Documentation/kbuild/kconfig-language.txt
@@ -149,13 +149,11 @@ applicable everywhere (see syntax).
     enables the third modular state for all config symbols.
     At most one symbol may have the "modules" option set.
 
-  - "env"=<value>
+  - "env"=<varname>
     This imports the environment variable into Kconfig. It behaves like
-    a default, except that the value comes from the environment, this
-    also means that the behaviour when mixing it with normal defaults is
-    undefined at this point. The symbol is currently not exported back
-    to the build environment (if this is desired, it can be done via
-    another symbol).
+    the user input, except that the value comes from the environment.
+    Environment variable overrides all defaults and value from the file.
+    If environment variable is not defined this option has no effect.
 
   - "allnoconfig_y"
     This declares the symbol as one that should have the value y when
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index f88d90f..5cb0034 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -404,6 +404,30 @@ setsym:
 	return 0;
 }
 
+static void conf_read_env(void)
+{
+	struct symbol *sym, *env_sym;
+	struct property *prop;
+	struct expr *expr;
+	char *value;
+
+	expr_list_for_each_sym(sym_env_list, expr, sym) {
+		prop = sym_get_env_prop(sym);
+		env_sym = prop_get_symbol(prop);
+		value = getenv(env_sym->name);
+		if (value) {
+			sym_calc_value(sym);
+			if (!sym_set_string_value(sym, value))
+				conf_warning("evironment variable %s value "
+					      "'%s' invalid for %s",
+					      env_sym->name, value, sym->name);
+		} else if (!(sym->flags & SYMBOL_DEF_USER))
+			conf_warning("neither symbol %s nor evironment "
+					"variable %s are defined",
+				       sym->name, env_sym->name);
+	}
+}
+
 int conf_read(const char *name)
 {
 	struct symbol *sym;
@@ -414,6 +438,8 @@ int conf_read(const char *name)
 	if (conf_read_simple(name, S_DEF_USER))
 		return 1;
 
+	conf_read_env();
+
 	for_all_symbols(i, sym) {
 		sym_calc_value(sym);
 		if (sym_is_choice(sym) || (sym->flags & SYMBOL_AUTO))
diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 412ea8a..8d9bbc9 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -95,7 +95,7 @@ struct symbol {
 #define SYMBOL_OPTIONAL   0x0100  /* choice is optional - values can be 'n' */
 #define SYMBOL_WRITE      0x0200  /* write symbol to file (KCONFIG_CONFIG) */
 #define SYMBOL_CHANGED    0x0400  /* ? */
-#define SYMBOL_AUTO       0x1000  /* value from environment variable */
+#define SYMBOL_AUTO       0x1000  /* calculated value - not saved into file */
 #define SYMBOL_CHECKED    0x2000  /* used during dependency checking */
 #define SYMBOL_WARNED     0x8000  /* warning has been issued */
 
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 7caabdb..9dce811 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -1350,7 +1350,6 @@ static void prop_add_env(const char *env)
 	char *p;
 
 	sym = current_entry->sym;
-	sym->flags |= SYMBOL_AUTO;
 	for_all_properties(sym, prop, P_ENV) {
 		sym2 = prop_get_symbol(prop);
 		if (strcmp(sym2->name, env))
@@ -1368,6 +1367,4 @@ static void prop_add_env(const char *env)
 	p = getenv(env);
 	if (p)
 		sym_add_default(sym, p);
-	else
-		menu_warn(current_entry, "environment variable %s undefined", env);
 }

