Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab3A3TdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 14:33:12 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:62690 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070Ab3A3TdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 14:33:08 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-sparse@vger.kernel.org
Cc: Christopher Li <sparse@chrisli.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2 sparse] Support the force attribute for function parameters
Date: Wed, 30 Jan 2013 20:32:56 +0100
Message-Id: <1359574377-3402-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.2
X-Provags-ID: V02:K0:991gYbH0mH/YMorFMyDtNtHTn/BezRRcWSQ+DrbnoId
 ywDgyCjWcgdZkHyuDTEbWAN0ihcUujGa3npbW1/FzovzdIUvkd
 Wp/Gj25rtouGMg2qD6uQ/COaTceg+e/gc3iUCfzOgoJ4H0LYmE
 fHSEmrptzN6nxi9mxrW85h/6M7B60F8PwR632S/R97S/59zaM8
 jTjG9qrxn7vMiWbd1p8a3EnWyCMKurhODdJ8B5H3Pl4a1jpOY9
 Dc125IX5Rbac4yshFLh6kYc2DbNE3Veq2J9bH7IbQORQ+Yt9Rv
 XYmHn0m4reGLNy0yuvHloOFt0r5nPMX3PHsFrc8aZVL6ciRPn0
 njcXi91AyfH2hN3SrraRnjAXlICDmOHm72KL5fGzDEW0j0bZPa
 FU05WAtzy8D4p2rB+r1HWbsREJNX3NomjLnvFbXEATTIfjrNkE
 F5zg2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions such as IS_ERR() in the Linux kernel extract an error value
encoded in a pointer. sparse warns when a pointer with an address space
other than the default (i.e. annotated with __user, __iomem, __percpu or
__rcu) is passed to these functions. However, checking whether the
pointer represents an encoded error and extracting the value are purely
arithmetic operations on the pointer and therefore not concerned with
the pointer's address space at all.

This patch allows function parameters to be annotated with the force
attribute which will cause any differences in the address space and the
noderef attribute to be ignored.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
---
 evaluate.c | 22 +++++++++++++---------
 expand.c   |  4 ++--
 parse.c    |  2 ++
 symbol.h   |  5 ++++-
 4 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/evaluate.c b/evaluate.c
index bebe968..d5a00e1 100644
--- a/evaluate.c
+++ b/evaluate.c
@@ -609,8 +609,9 @@ static void examine_fn_arguments(struct symbol *fn);
 #define MOD_IGN (MOD_VOLATILE | MOD_CONST)
 
 const char *type_difference(struct ctype *c1, struct ctype *c2,
-	unsigned long mod1, unsigned long mod2)
+	unsigned long mod1, unsigned long mod2, unsigned long flags)
 {
+	unsigned long mask = MOD_IGNORE | MOD_SIGNEDNESS;
 	unsigned long as1 = c1->as, as2 = c2->as;
 	struct symbol *t1 = c1->base_type;
 	struct symbol *t2 = c2->base_type;
@@ -727,7 +728,7 @@ const char *type_difference(struct ctype *c1, struct ctype *c2,
 					return "different argument counts";
 				diffstr = type_difference(&arg1->ctype,
 							  &arg2->ctype,
-							  MOD_IGN, MOD_IGN);
+							  MOD_IGN, MOD_IGN, 0);
 				if (diffstr) {
 					static char argdiff[80];
 					sprintf(argdiff, "incompatible argument %d (%s)", i, diffstr);
@@ -759,9 +760,11 @@ const char *type_difference(struct ctype *c1, struct ctype *c2,
 		t1 = base1;
 		t2 = base2;
 	}
-	if (as1 != as2)
+	if (as1 != as2 && (flags & FLAG_FORCE) == 0)
 		return "different address spaces";
-	if ((mod1 ^ mod2) & ~MOD_IGNORE & ~MOD_SIGNEDNESS)
+	if (flags & FLAG_FORCE)
+		mask |= MOD_NODEREF;
+	if ((mod1 ^ mod2) & ~mask)
 		return "different modifiers";
 	return NULL;
 }
@@ -795,7 +798,7 @@ static struct symbol *evaluate_ptr_sub(struct expression *expr)
 	examine_pointer_target(rtype);
 	typediff = type_difference(&ltype->ctype, &rtype->ctype,
 				   target_qualifiers(rtype),
-				   target_qualifiers(ltype));
+				   target_qualifiers(ltype), 0);
 	if (typediff)
 		expression_error(expr, "subtraction of different types can't work (%s)", typediff);
 
@@ -1056,7 +1059,7 @@ static struct symbol *evaluate_compare(struct expression *expr)
 
 	typediff = type_difference(&ltype->ctype, &rtype->ctype,
 				   target_qualifiers(rtype),
-				   target_qualifiers(ltype));
+				   target_qualifiers(ltype), 0);
 	if (!typediff)
 		goto OK;
 
@@ -1170,7 +1173,7 @@ static struct symbol *evaluate_conditional_expression(struct expression *expr)
 		/* XXX: that should be pointer to composite */
 		ctype = ltype;
 		typediff = type_difference(&ltype->ctype, &rtype->ctype,
-					   qual, qual);
+					   qual, qual, 0);
 		if (!typediff)
 			goto Qual;
 		goto Err;
@@ -1347,7 +1350,8 @@ static int compatible_assignment_types(struct expression *expr, struct symbol *t
 			goto Cast;
 		}
 		/* It's OK if the target is more volatile or const than the source */
-		typediff = type_difference(&t->ctype, &s->ctype, 0, mod1);
+		typediff = type_difference(&t->ctype, &s->ctype, 0, mod1,
+					   target->ctype.flags);
 		if (typediff)
 			goto Err;
 		return 1;
@@ -3016,7 +3020,7 @@ static void check_duplicates(struct symbol *sym)
 		const char *typediff;
 		evaluate_symbol(next);
 		declared++;
-		typediff = type_difference(&sym->ctype, &next->ctype, 0, 0);
+		typediff = type_difference(&sym->ctype, &next->ctype, 0, 0, 0);
 		if (typediff) {
 			sparse_error(sym->pos, "symbol '%s' redeclared with different type (originally declared at %s:%d) - %s",
 				show_ident(sym->ident),
diff --git a/expand.c b/expand.c
index 63a9075..b76d951 100644
--- a/expand.c
+++ b/expand.c
@@ -465,9 +465,9 @@ static int compare_types(int op, struct symbol *left, struct symbol *right)
 	struct ctype c2 = {.base_type = right};
 	switch (op) {
 	case SPECIAL_EQUAL:
-		return !type_difference(&c1, &c2, MOD_IGN, MOD_IGN);
+		return !type_difference(&c1, &c2, MOD_IGN, MOD_IGN, 0);
 	case SPECIAL_NOTEQUAL:
-		return type_difference(&c1, &c2, MOD_IGN, MOD_IGN) != NULL;
+		return type_difference(&c1, &c2, MOD_IGN, MOD_IGN, 0) != NULL;
 	case '<':
 		return left->bit_size < right->bit_size;
 	case '>':
diff --git a/parse.c b/parse.c
index bd42180..a553570 100644
--- a/parse.c
+++ b/parse.c
@@ -1832,6 +1832,8 @@ static struct token *parameter_declaration(struct token *token, struct symbol *s
 	apply_modifiers(token->pos, &ctx);
 	sym->ctype = ctx.ctype;
 	sym->ctype.modifiers |= storage_modifiers(&ctx);
+	if (ctx.storage_class == SForced)
+		sym->ctype.flags |= FLAG_FORCE;
 	sym->endpos = token->pos;
 	return token;
 }
diff --git a/symbol.h b/symbol.h
index 1e74579..2417496 100644
--- a/symbol.h
+++ b/symbol.h
@@ -81,12 +81,15 @@ extern struct context *alloc_context(void);
 
 DECLARE_PTR_LIST(context_list, struct context);
 
+#define FLAG_FORCE 1
+
 struct ctype {
 	unsigned long modifiers;
 	unsigned long alignment;
 	struct context_list *contexts;
 	unsigned int as;
 	struct symbol *base_type;
+	unsigned long flags;
 };
 
 struct decl_state {
@@ -266,7 +269,7 @@ extern struct symbol_list *translation_unit_used_list;
 extern void access_symbol(struct symbol *);
 
 extern const char * type_difference(struct ctype *c1, struct ctype *c2,
-	unsigned long mod1, unsigned long mod2);
+	unsigned long mod1, unsigned long mod2, unsigned long flags);
 
 extern struct symbol *lookup_symbol(struct ident *, enum namespace);
 extern struct symbol *create_symbol(int stream, const char *name, int type, int namespace);
-- 
1.8.1.1

