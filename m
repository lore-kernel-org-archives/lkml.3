Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbaDRVlM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 17:41:12 -0400
Received: from mout.web.de ([212.227.17.11]:49822 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684AbaDRVlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 17:41:05 -0400
From: Martin Walch <walch.martin@web.de>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH v2 1/2] kconfig: completely remove expr_eliminate_dups2() and related code
Date: Fri, 18 Apr 2014 23:41:03 +0200
Message-ID: <1934101.2gULjgL2Er@tacticalops>
User-Agent: KMail/4.12.3 (Linux/3.12.13-gentoo-gnu; KDE/4.12.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V03:K0:FXzmva83rlgrhf12La1WBU7KUdF3ExGjH5oiOAREsEZuonzz4Do
 u0g1HQ7MP4t7TjR/S/MXhm5RGeqgluCB0nBpgQ+kD2twyxg31yNsc7xGeUKL/E3qE4JjXwz
 1ffhxNxLxIJmKfcsAaLs+mMtRW3W3yMny4rjjLad7kVafjo8qoYAfG9v/5gY6tuS9IUAPeX
 q7QAYu74nkc20jakia1Sw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Walch <walch.martin@web.de>
Date: Fri, 18 Apr 2014 22:10:14 +0200
Subject: [PATCH v2 1/2] kconfig: completely remove expr_eliminate_dups2() and related code

remove expr_eliminate_dups2(), expr_extract_eq_and(), expr_extract_eq_or(),
and expr_extract_eq() from scripts/kconfig/expr.[ch]

As the comments in the code state, expr_eliminate_dups2 applies these
two transformations:
(FOO || BAR) && (!FOO && !BAR) -> n
(FOO && BAR) || (!FOO || !BAR) -> y
At first glance, this may look like a good idea. On second thought, one
should verify all possible values for FOO and BAR, finally leading to the
assignment

FOO << 1
BAR << 1

which yields for both expressions the interpretation 1 (syntactically this
corresponds to an m) when applying the evaluation rules from
Documentation/kbuild/kconfig-language.txt:

(FOO || BAR) && (!FOO && !BAR)
-> min(max(1, 1), min(2-1, 2-1)) = min(1, 1) = 1

(FOO && BAR) || (!FOO || !BAR)
-> max(min(1, 1), max(2-1, 2-1)) = max(1, 1) = 1

As n always evaluates to 0 and y to 2, this means that the transformation
does not preserve semantics, which I guess is not intended here.
In particular, the expression m && !m expands to
(m && MODULES) && !(m && MODULES), then to (m && MODULES) && (!m || !MODULES),
and finally in expr_eliminate_dups2 to n. I therefore think it is a bug
which should be fixed.

This patch should fix the problem by just removing the corresponding code.
Nothing should break: a quick check did not yield any expression in the
mainline kernel that the (bad) transformation currently applies to. Also,
as far as I understand the code, expr_eliminate_dups2 does not do anything
except those two transformations that are to be removed.

As a positive side effect, this reduces code size in expr.c by roughly 10%
and slightly improves startup time for all configuration frontends.

Signed-off-by: Martin Walch <walch.martin@web.de>
---
 scripts/kconfig/expr.c | 108 -------------------------------------------------
 scripts/kconfig/expr.h |   3 --
 2 files changed, 111 deletions(-)

diff --git a/scripts/kconfig/expr.c b/scripts/kconfig/expr.c
index d662652..4aa171b 100644
--- a/scripts/kconfig/expr.c
+++ b/scripts/kconfig/expr.c
@@ -553,62 +553,6 @@ static void expr_eliminate_dups1(enum expr_type type, struct expr **ep1, struct
 #undef e2
 }
 
-static void expr_eliminate_dups2(enum expr_type type, struct expr **ep1, struct expr **ep2)
-{
-#define e1 (*ep1)
-#define e2 (*ep2)
-	struct expr *tmp, *tmp1, *tmp2;
-
-	if (e1->type == type) {
-		expr_eliminate_dups2(type, &e1->left.expr, &e2);
-		expr_eliminate_dups2(type, &e1->right.expr, &e2);
-		return;
-	}
-	if (e2->type == type) {
-		expr_eliminate_dups2(type, &e1, &e2->left.expr);
-		expr_eliminate_dups2(type, &e1, &e2->right.expr);
-	}
-	if (e1 == e2)
-		return;
-
-	switch (e1->type) {
-	case E_OR:
-		expr_eliminate_dups2(e1->type, &e1, &e1);
-		// (FOO || BAR) && (!FOO && !BAR) -> n
-		tmp1 = expr_transform(expr_alloc_one(E_NOT, expr_copy(e1)));
-		tmp2 = expr_copy(e2);
-		tmp = expr_extract_eq_and(&tmp1, &tmp2);
-		if (expr_is_yes(tmp1)) {
-			expr_free(e1);
-			e1 = expr_alloc_symbol(&symbol_no);
-			trans_count++;
-		}
-		expr_free(tmp2);
-		expr_free(tmp1);
-		expr_free(tmp);
-		break;
-	case E_AND:
-		expr_eliminate_dups2(e1->type, &e1, &e1);
-		// (FOO && BAR) || (!FOO || !BAR) -> y
-		tmp1 = expr_transform(expr_alloc_one(E_NOT, expr_copy(e1)));
-		tmp2 = expr_copy(e2);
-		tmp = expr_extract_eq_or(&tmp1, &tmp2);
-		if (expr_is_no(tmp1)) {
-			expr_free(e1);
-			e1 = expr_alloc_symbol(&symbol_yes);
-			trans_count++;
-		}
-		expr_free(tmp2);
-		expr_free(tmp1);
-		expr_free(tmp);
-		break;
-	default:
-		;
-	}
-#undef e1
-#undef e2
-}
-
 struct expr *expr_eliminate_dups(struct expr *e)
 {
 	int oldcount;
@@ -621,7 +565,6 @@ struct expr *expr_eliminate_dups(struct expr *e)
 		switch (e->type) {
 		case E_OR: case E_AND:
 			expr_eliminate_dups1(e->type, &e, &e);
-			expr_eliminate_dups2(e->type, &e, &e);
 		default:
 			;
 		}
@@ -823,57 +766,6 @@ bool expr_depends_symbol(struct expr *dep, struct symbol *sym)
  	return false;
 }
 
-struct expr *expr_extract_eq_and(struct expr **ep1, struct expr **ep2)
-{
-	struct expr *tmp = NULL;
-	expr_extract_eq(E_AND, &tmp, ep1, ep2);
-	if (tmp) {
-		*ep1 = expr_eliminate_yn(*ep1);
-		*ep2 = expr_eliminate_yn(*ep2);
-	}
-	return tmp;
-}
-
-struct expr *expr_extract_eq_or(struct expr **ep1, struct expr **ep2)
-{
-	struct expr *tmp = NULL;
-	expr_extract_eq(E_OR, &tmp, ep1, ep2);
-	if (tmp) {
-		*ep1 = expr_eliminate_yn(*ep1);
-		*ep2 = expr_eliminate_yn(*ep2);
-	}
-	return tmp;
-}
-
-void expr_extract_eq(enum expr_type type, struct expr **ep, struct expr **ep1, struct expr **ep2)
-{
-#define e1 (*ep1)
-#define e2 (*ep2)
-	if (e1->type == type) {
-		expr_extract_eq(type, ep, &e1->left.expr, &e2);
-		expr_extract_eq(type, ep, &e1->right.expr, &e2);
-		return;
-	}
-	if (e2->type == type) {
-		expr_extract_eq(type, ep, ep1, &e2->left.expr);
-		expr_extract_eq(type, ep, ep1, &e2->right.expr);
-		return;
-	}
-	if (expr_eq(e1, e2)) {
-		*ep = *ep ? expr_alloc_two(type, *ep, e1) : e1;
-		expr_free(e2);
-		if (type == E_AND) {
-			e1 = expr_alloc_symbol(&symbol_yes);
-			e2 = expr_alloc_symbol(&symbol_yes);
-		} else if (type == E_OR) {
-			e1 = expr_alloc_symbol(&symbol_no);
-			e2 = expr_alloc_symbol(&symbol_no);
-		}
-	}
-#undef e1
-#undef e2
-}
-
 struct expr *expr_trans_compare(struct expr *e, enum expr_type type, struct symbol *sym)
 {
 	struct expr *e1, *e2;
diff --git a/scripts/kconfig/expr.h b/scripts/kconfig/expr.h
index 412ea8a..9c9fb57 100644
--- a/scripts/kconfig/expr.h
+++ b/scripts/kconfig/expr.h
@@ -214,9 +214,6 @@ struct expr *expr_eliminate_dups(struct expr *e);
 struct expr *expr_transform(struct expr *e);
 int expr_contains_symbol(struct expr *dep, struct symbol *sym);
 bool expr_depends_symbol(struct expr *dep, struct symbol *sym);
-struct expr *expr_extract_eq_and(struct expr **ep1, struct expr **ep2);
-struct expr *expr_extract_eq_or(struct expr **ep1, struct expr **ep2);
-void expr_extract_eq(enum expr_type type, struct expr **ep, struct expr **ep1, struct expr **ep2);
 struct expr *expr_trans_compare(struct expr *e, enum expr_type type, struct symbol *sym);
 struct expr *expr_simplify_unmet_dep(struct expr *e1, struct expr *e2);
 
-- 
1.8.3.2
