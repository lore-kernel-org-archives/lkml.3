Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab3HOVRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 17:17:43 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:35389 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab3HOVRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 17:17:41 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 1/4] kconfig: switch to "long long" for sanity
Date: Thu, 15 Aug 2013 23:17:30 +0200
Message-Id: <129784abc982ccac43322c2f175f3ca735c2ca73.1376600922.git.yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <cover.1376600922.git.yann.morin.1998@free.fr>
References: <cover.1376600922.git.yann.morin.1998@free.fr>
In-Reply-To: <cover.1376600922.git.yann.morin.1998@free.fr>
References: <cover.1376600922.git.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

Instead of using "long" for kconfig "hex" and "range" values, which may
change in size depending on the host architecture, use "long long". This
will allow values greater than INT_MAX on 32-bit hosts when cross
compiling.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Tested-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
---
 scripts/kconfig/symbol.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index a76b8fd..c9a6775 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -136,7 +136,7 @@ static struct property *sym_get_range_prop(struct symbol *sym)
 	return NULL;
 }
 
-static long sym_get_range_val(struct symbol *sym, int base)
+static long long sym_get_range_val(struct symbol *sym, int base)
 {
 	sym_calc_value(sym);
 	switch (sym->type) {
@@ -149,13 +149,14 @@ static long sym_get_range_val(struct symbol *sym, int base)
 	default:
 		break;
 	}
-	return strtol(sym->curr.val, NULL, base);
+	return strtoll(sym->curr.val, NULL, base);
 }
 
 static void sym_validate_range(struct symbol *sym)
 {
 	struct property *prop;
-	long base, val, val2;
+	int base;
+	long long val, val2;
 	char str[64];
 
 	switch (sym->type) {
@@ -171,7 +172,7 @@ static void sym_validate_range(struct symbol *sym)
 	prop = sym_get_range_prop(sym);
 	if (!prop)
 		return;
-	val = strtol(sym->curr.val, NULL, base);
+	val = strtoll(sym->curr.val, NULL, base);
 	val2 = sym_get_range_val(prop->expr->left.sym, base);
 	if (val >= val2) {
 		val2 = sym_get_range_val(prop->expr->right.sym, base);
@@ -179,9 +180,9 @@ static void sym_validate_range(struct symbol *sym)
 			return;
 	}
 	if (sym->type == S_INT)
-		sprintf(str, "%ld", val2);
+		sprintf(str, "%lld", val2);
 	else
-		sprintf(str, "0x%lx", val2);
+		sprintf(str, "0x%llx", val2);
 	sym->curr.val = strdup(str);
 }
 
@@ -594,7 +595,7 @@ bool sym_string_valid(struct symbol *sym, const char *str)
 bool sym_string_within_range(struct symbol *sym, const char *str)
 {
 	struct property *prop;
-	long val;
+	long long val;
 
 	switch (sym->type) {
 	case S_STRING:
@@ -605,7 +606,7 @@ bool sym_string_within_range(struct symbol *sym, const char *str)
 		prop = sym_get_range_prop(sym);
 		if (!prop)
 			return true;
-		val = strtol(str, NULL, 10);
+		val = strtoll(str, NULL, 10);
 		return val >= sym_get_range_val(prop->expr->left.sym, 10) &&
 		       val <= sym_get_range_val(prop->expr->right.sym, 10);
 	case S_HEX:
@@ -614,7 +615,7 @@ bool sym_string_within_range(struct symbol *sym, const char *str)
 		prop = sym_get_range_prop(sym);
 		if (!prop)
 			return true;
-		val = strtol(str, NULL, 16);
+		val = strtoll(str, NULL, 16);
 		return val >= sym_get_range_val(prop->expr->left.sym, 16) &&
 		       val <= sym_get_range_val(prop->expr->right.sym, 16);
 	case S_BOOLEAN:
-- 
1.8.1.2

