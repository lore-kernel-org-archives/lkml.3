Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbaIVROM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 13:14:12 -0400
Received: from mout.web.de ([212.227.17.11]:51296 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622AbaIVROG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 13:14:06 -0400
From: Martin Walch <walch.martin@web.de>
To: yann.morin.1998@free.fr
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Walch <walch.martin@web.de>
Subject: [PATCH v2 1/2] kconfig: fix bad syntactic transformation in expr.c
Date: Mon, 22 Sep 2014 19:13:18 +0200
Message-Id: <1411405999-20212-2-git-send-email-walch.martin@web.de>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1411405999-20212-1-git-send-email-walch.martin@web.de>
References: <3491939.FtiyjGE4Of@tacticalops>
 <1411405999-20212-1-git-send-email-walch.martin@web.de>
X-Provags-ID: V03:K0:bE3L2Hhi1ktPY2nIjWn45Ro/CuVPFvKFRDuKbOTnoH3WuMgtldD
 aRHxp1cGJwqs67UcpVLOrodKb3nbz1CdKbmemNsaoer5hlVJh7KEXtbQCIHuH0ON/hZBSRJ
 QEzTJOC1c4Nmlmi7ddOZgd7+ONVgqD3iOv1p7FayTKK1Lq5Uk05er8ARcIoL1GE7hROvO/o
 RDaF1x3k8VgAHcbrITyEQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

expr_eliminate_dups2() in scripts/kconfig/expr.c applies two bad
inference rules:

(FOO || BAR) && (!FOO && !BAR) -> n
(FOO && BAR) || (!FOO || !BAR) -> y

They would be correct in propositional logic, but this is a three-valued
logic, and here it is wrong in that it changes semantics. It becomes
immediately visible when substituting FOO and BAR with m.

Fix it by removing expr_eliminate_dups2() and the functions that have no use
anywhere else: expr_extract_eq_and(), expr_extract_eq_or(),
and expr_extract_eq() from scripts/kconfig/expr.[ch]

Currently the bug is not triggered in mainline, so this patch does not modify
the configuration space there.

As a side effect, this reduces code size in expr.c by roughly 10% and slightly
improves startup time for all configuration frontends.

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
1.8.5.5

