Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911Ab3CUIXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 04:23:08 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:39173 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab3CUIXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 04:23:04 -0400
Subject: [PATCH RFC 1/5] kconfig: implement weak reverse-dependencies
To: Michal Marek <mmarek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Richard Cochran <richardcochran@gmail.com>
Date: Thu, 21 Mar 2013 12:22:57 +0400
Message-ID: <20130321082256.21557.68351.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds new kind of dependencies between kconfig symbols,
and new kconfig keyword 'apply' for them.

'apply' works mostly like 'select', but it allows to disable target symbol.
Thus target symbol will be either disabled or reachable from current symbol.

This method allows to implement optional dependencies without introducing new
kconfig symbol for each pair of connected kconfig options.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org
---
 Documentation/kbuild/kconfig-language.txt |    6 +++++
 scripts/kconfig/expr.h                    |    2 ++
 scripts/kconfig/mconf.c                   |    2 ++
 scripts/kconfig/menu.c                    |   35 +++++++++++++++++++++++++++++
 scripts/kconfig/nconf.c                   |    3 ++
 scripts/kconfig/qconf.cc                  |    6 +++++
 scripts/kconfig/symbol.c                  |   21 ++++++++++++++++-
 scripts/kconfig/zconf.gperf               |    1 +
 scripts/kconfig/zconf.y                   |   16 ++++++++++++-
 9 files changed, 88 insertions(+), 4 deletions(-)

diff --git a/Documentation/kbuild/kconfig-language.txt b/Documentation/kbuild/kconfig-language.txt
index c858f84..0063bb2 100644
--- a/Documentation/kbuild/kconfig-language.txt
+++ b/Documentation/kbuild/kconfig-language.txt
@@ -113,6 +113,12 @@ applicable everywhere (see syntax).
 	That will limit the usefulness but on the other hand avoid
 	the illegal configurations all over.
 
+- weak reverse dependencies: "apply" <symbol> ["if" <expr>]
+  Weak dependencies restricts other symbols to be either disabled or
+  reachable from current menu symbol. For example weak dependency from FOO
+  to BAR forbids BAR=m if FOO=y, because FOO cannot reach BAR in this case.
+  Weak reverse dependencies can only be used with tristate symbols.
+
 - limiting menu display: "visible if" <expr>
   This attribute is only applicable to menu blocks, if the condition is
   false, the menu block is not displayed to the user (the symbols
diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index cdd4860..f7ac1b6 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -83,6 +83,7 @@ struct symbol {
 	struct property *prop;
 	struct expr_value dir_dep;
 	struct expr_value rev_dep;
+	struct expr_value opt_dep;
 };
 
 #define for_all_symbols(i, sym) for (i = 0; i < SYMBOL_HASHSIZE; i++) for (sym = symbol_hash[i]; sym; sym = sym->next) if (sym->type != S_OTHER)
@@ -128,6 +129,7 @@ enum prop_type {
 	P_DEFAULT,  /* default y */
 	P_CHOICE,   /* choice value */
 	P_SELECT,   /* select BAR */
+	P_APPLY,    /* apply BAR */
 	P_RANGE,    /* range 7..100 (for a symbol) */
 	P_ENV,      /* value from environment variable */
 	P_SYMBOL,   /* where a symbol is defined */
diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 566288a..72e965f 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -548,6 +548,8 @@ static void build_conf(struct menu *menu)
 				if (sym_is_changable(sym)) {
 					if (sym->rev_dep.tri == mod)
 						item_make("{%c}", ch);
+					else if (sym->opt_dep.tri == yes)
+						item_make("[%c]", ch);
 					else
 						item_make("<%c>", ch);
 				} else
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index f3bffa3..0cb96c3 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -245,6 +245,21 @@ static void sym_check_prop(struct symbol *sym)
 				    "accept arguments of boolean and "
 				    "tristate type", sym2->name);
 			break;
+		case P_APPLY:
+			sym2 = prop_get_symbol(prop);
+			if (sym->type != S_TRISTATE)
+				prop_warn(prop,
+				    "config symbol '%s' uses 'apply', but is "
+				    "not tristate", sym->name);
+			else if (sym2->type != S_UNKNOWN &&
+				 sym2->type != S_BOOLEAN &&
+				 sym2->type != S_TRISTATE)
+				prop_warn(prop,
+				    "'%s' has wrong type. 'apply' only "
+				    "accept arguments of boolaean and "
+				    "tristate type",
+				    sym2->name);
+			break;
 		case P_RANGE:
 			if (sym->type != S_INT && sym->type != S_HEX)
 				prop_warn(prop, "range is only allowed "
@@ -313,6 +328,10 @@ void menu_finalize(struct menu *parent)
 					struct symbol *es = prop_get_symbol(prop);
 					es->rev_dep.expr = expr_alloc_or(es->rev_dep.expr,
 							expr_alloc_and(expr_alloc_symbol(menu->sym), expr_copy(dep)));
+				} else if (prop->type == P_APPLY) {
+					struct symbol *es = prop_get_symbol(prop);
+					es->opt_dep.expr = expr_alloc_or(es->opt_dep.expr,
+							expr_alloc_and(expr_alloc_symbol(menu->sym), expr_copy(dep)));
 				}
 			}
 		}
@@ -606,11 +625,27 @@ void get_symbol_str(struct gstr *r, struct symbol *sym,
 	}
 	if (hit)
 		str_append(r, "\n");
+	hit = false;
+	for_all_properties(sym, prop, P_APPLY) {
+		if (!hit) {
+			str_append(r, "  Apply: ");
+			hit = true;
+		} else
+			str_printf(r, " && ");
+		expr_gstr_print(prop->expr, r);
+	}
+	if (hit)
+		str_append(r, "\n");
 	if (sym->rev_dep.expr) {
 		str_append(r, _("  Selected by: "));
 		expr_gstr_print(sym->rev_dep.expr, r);
 		str_append(r, "\n");
 	}
+	if (sym->opt_dep.expr) {
+		str_append(r, _("  Applied by: "));
+		expr_gstr_print(sym->opt_dep.expr, r);
+		str_append(r, "\n");
+	}
 	str_append(r, "\n\n");
 }
 
diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index dbf31ed..d959e28 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -877,6 +877,9 @@ static void build_conf(struct menu *menu)
 					if (sym->rev_dep.tri == mod)
 						item_make(menu,
 							't', "{%c}", ch);
+					else if (sym->opt_dep.tri == yes)
+						item_make(menu,
+							't', "[%c]", ch);
 					else
 						item_make(menu,
 							't', "<%c>", ch);
diff --git a/scripts/kconfig/qconf.cc b/scripts/kconfig/qconf.cc
index 1500c38..c9982f7 100644
--- a/scripts/kconfig/qconf.cc
+++ b/scripts/kconfig/qconf.cc
@@ -1078,6 +1078,11 @@ QString ConfigInfoView::debug_info(struct symbol *sym)
 		expr_print(sym->rev_dep.expr, expr_print_help, &debug, E_NONE);
 		debug += "<br>";
 	}
+	if (sym->opt_dep.expr) {
+		debug += "optional dep: ";
+		expr_print(sym->opt_dep.expr, expr_print_help, &debug, E_NONE);
+		debug += "<br>";
+	}
 	for (struct property *prop = sym->prop; prop; prop = prop->next) {
 		switch (prop->type) {
 		case P_PROMPT:
@@ -1088,6 +1093,7 @@ QString ConfigInfoView::debug_info(struct symbol *sym)
 			break;
 		case P_DEFAULT:
 		case P_SELECT:
+		case P_APPLY:
 		case P_RANGE:
 		case P_ENV:
 			debug += prop_get_type_name(prop->type);
diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index ecc5aa5..67e327b 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -223,6 +223,13 @@ static void sym_calc_visibility(struct symbol *sym)
 		sym->rev_dep.tri = tri;
 		sym_set_changed(sym);
 	}
+	tri = no;
+	if (sym->opt_dep.expr)
+		tri = expr_calc_value(sym->opt_dep.expr);
+	if (sym->opt_dep.tri != tri) {
+		sym->opt_dep.tri = tri;
+		sym_set_changed(sym);
+	}
 }
 
 /*
@@ -370,6 +377,9 @@ void sym_calc_value(struct symbol *sym)
 			}
 			newval.tri = EXPR_OR(newval.tri, sym->rev_dep.tri);
 		}
+		/* disallow 'mod' if symbol applied by some 'yes' symbol */
+		if (newval.tri == mod && sym->opt_dep.tri == yes)
+			newval.tri = yes;
 		if (newval.tri == mod && sym_get_type(sym) == S_BOOLEAN)
 			newval.tri = yes;
 		break;
@@ -473,6 +483,8 @@ bool sym_tristate_within_range(struct symbol *sym, tristate val)
 		return false;
 	if (sym->visible <= sym->rev_dep.tri)
 		return false;
+	if (val != no && val < sym->opt_dep.tri)
+		return false;
 	if (sym_is_choice_value(sym) && sym->visible == yes)
 		return val == yes;
 	return val >= sym->rev_dep.tri && val <= sym->visible;
@@ -771,7 +783,8 @@ const char *sym_get_string_value(struct symbol *sym)
 
 bool sym_is_changable(struct symbol *sym)
 {
-	return sym->visible > sym->rev_dep.tri;
+	return (sym->visible > sym->rev_dep.tri) &&
+	       (sym->rev_dep.tri == no || sym->opt_dep.tri < yes);
 }
 
 static unsigned strhash(const char *s)
@@ -1131,7 +1144,9 @@ static struct symbol *sym_check_sym_deps(struct symbol *sym)
 		goto out;
 
 	for (prop = sym->prop; prop; prop = prop->next) {
-		if (prop->type == P_CHOICE || prop->type == P_SELECT)
+		if (prop->type == P_CHOICE ||
+		    prop->type == P_SELECT ||
+		    prop->type == P_APPLY)
 			continue;
 		stack.prop = prop;
 		sym2 = sym_check_expr_deps(prop->visible.expr);
@@ -1270,6 +1285,8 @@ const char *prop_get_type_name(enum prop_type type)
 		return "choice";
 	case P_SELECT:
 		return "select";
+	case P_APPLY:
+		return "apply";
 	case P_RANGE:
 		return "range";
 	case P_SYMBOL:
diff --git a/scripts/kconfig/zconf.gperf b/scripts/kconfig/zconf.gperf
index f14ab41..c3405b0 100644
--- a/scripts/kconfig/zconf.gperf
+++ b/scripts/kconfig/zconf.gperf
@@ -37,6 +37,7 @@ int,		T_TYPE,		TF_COMMAND, S_INT
 hex,		T_TYPE,		TF_COMMAND, S_HEX
 string,		T_TYPE,		TF_COMMAND, S_STRING
 select,		T_SELECT,	TF_COMMAND
+apply,		T_APPLY,	TF_COMMAND
 range,		T_RANGE,	TF_COMMAND
 visible,	T_VISIBLE,	TF_COMMAND
 option,		T_OPTION,	TF_COMMAND
diff --git a/scripts/kconfig/zconf.y b/scripts/kconfig/zconf.y
index 864da07..fd6b727 100644
--- a/scripts/kconfig/zconf.y
+++ b/scripts/kconfig/zconf.y
@@ -31,7 +31,7 @@ struct symbol *symbol_hash[SYMBOL_HASHSIZE];
 static struct menu *current_menu, *current_entry;
 
 %}
-%expect 30
+%expect 32
 
 %union
 {
@@ -62,6 +62,7 @@ static struct menu *current_menu, *current_entry;
 %token <id>T_TYPE
 %token <id>T_DEFAULT
 %token <id>T_SELECT
+%token <id>T_APPLY
 %token <id>T_RANGE
 %token <id>T_VISIBLE
 %token <id>T_OPTION
@@ -119,7 +120,7 @@ stmt_list:
 ;
 
 option_name:
-	T_DEPENDS | T_PROMPT | T_TYPE | T_SELECT | T_OPTIONAL | T_RANGE | T_DEFAULT | T_VISIBLE
+	T_DEPENDS | T_PROMPT | T_TYPE | T_SELECT | T_APPLY | T_OPTIONAL | T_RANGE | T_DEFAULT | T_VISIBLE
 ;
 
 common_stmt:
@@ -211,6 +212,12 @@ config_option: T_SELECT T_WORD if_expr T_EOL
 	printd(DEBUG_PARSE, "%s:%d:select\n", zconf_curname(), zconf_lineno());
 };
 
+config_option: T_APPLY T_WORD if_expr T_EOL
+{
+	menu_add_symbol(P_APPLY, sym_lookup($2, 0), $3);
+	printd(DEBUG_PARSE, "%s:%d:utilize\n", zconf_curname(), zconf_lineno());
+};
+
 config_option: T_RANGE symbol symbol if_expr T_EOL
 {
 	menu_add_expr(P_RANGE, expr_alloc_comp(E_RANGE,$2, $3), $4);
@@ -662,6 +669,11 @@ static void print_symbol(FILE *out, struct menu *menu)
 			expr_fprint(prop->expr, out);
 			fputc('\n', out);
 			break;
+		case P_APPLY:
+			fputs( "  apply ", out);
+			expr_fprint(prop->expr, out);
+			fputc('\n', out);
+			break;
 		case P_RANGE:
 			fputs( "  range ", out);
 			expr_fprint(prop->expr, out);

