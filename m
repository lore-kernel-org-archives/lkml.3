Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759044Ab3GRQGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:06:54 -0400
Received: from smtp.outflux.net ([198.145.64.163]:58777 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758647Ab3GRQGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:06:52 -0400
Date: Thu, 18 Jul 2013 09:06:33 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Michal Marek <mmarek@suse.cz>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH] kconfig: switch to "long long" for sanity
Message-ID: <20130718160633.GA16208@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using "long" for kconfig "hex" and "range" values, which may
change in size depending on the host architecture, use "long long". This
will allow values greater than INT_MAX on 32-bit hosts when cross
compiling.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 scripts/kconfig/symbol.c |   18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index d550300..5280c55 100644
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
@@ -149,13 +149,13 @@ static long sym_get_range_val(struct symbol *sym, int base)
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
+	long long base, val, val2;
 	char str[64];
 
 	switch (sym->type) {
@@ -171,7 +171,7 @@ static void sym_validate_range(struct symbol *sym)
 	prop = sym_get_range_prop(sym);
 	if (!prop)
 		return;
-	val = strtol(sym->curr.val, NULL, base);
+	val = strtoll(sym->curr.val, NULL, base);
 	val2 = sym_get_range_val(prop->expr->left.sym, base);
 	if (val >= val2) {
 		val2 = sym_get_range_val(prop->expr->right.sym, base);
@@ -179,9 +179,9 @@ static void sym_validate_range(struct symbol *sym)
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
 
@@ -594,7 +594,7 @@ bool sym_string_valid(struct symbol *sym, const char *str)
 bool sym_string_within_range(struct symbol *sym, const char *str)
 {
 	struct property *prop;
-	long val;
+	long long val;
 
 	switch (sym->type) {
 	case S_STRING:
@@ -605,7 +605,7 @@ bool sym_string_within_range(struct symbol *sym, const char *str)
 		prop = sym_get_range_prop(sym);
 		if (!prop)
 			return true;
-		val = strtol(str, NULL, 10);
+		val = strtoll(str, NULL, 10);
 		return val >= sym_get_range_val(prop->expr->left.sym, 10) &&
 		       val <= sym_get_range_val(prop->expr->right.sym, 10);
 	case S_HEX:
@@ -614,7 +614,7 @@ bool sym_string_within_range(struct symbol *sym, const char *str)
 		prop = sym_get_range_prop(sym);
 		if (!prop)
 			return true;
-		val = strtol(str, NULL, 16);
+		val = strtoll(str, NULL, 16);
 		return val >= sym_get_range_val(prop->expr->left.sym, 16) &&
 		       val <= sym_get_range_val(prop->expr->right.sym, 16);
 	case S_BOOLEAN:
-- 
1.7.9.5


-- 
Kees Cook
Chrome OS Security
