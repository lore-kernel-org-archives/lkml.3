Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894Ab3CUIKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 04:10:55 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:40981 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858Ab3CUIKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 04:10:49 -0400
Subject: [PATCH] kconfig: print each first level disjunction block from a new
 line
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Michal Marek <mmarek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild@vger.kernel.org
Date: Thu, 21 Mar 2013 12:10:44 +0400
Message-ID: <20130321081043.21073.38947.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch improves readability of complicated expressions.

before:
   Selected by: A && AA && AAA || B && BB && (BBB || BBBB) || C && CC && CCC

after:
   Selected by: A && AA && AAA
 || B && BB && (BBB || BBBB)
 || C && CC && CCC

Modules' config options usually comes first in these blocks.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org
---
 scripts/kconfig/expr.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/scripts/kconfig/expr.c b/scripts/kconfig/expr.c
index d662652..e47eb28 100644
--- a/scripts/kconfig/expr.c
+++ b/scripts/kconfig/expr.c
@@ -1087,9 +1087,15 @@ void expr_print(struct expr *e, void (*fn)(void *, struct symbol *, const char *
 		fn(data, e->right.sym, e->right.sym->name);
 		break;
 	case E_OR:
-		expr_print(e->left.expr, fn, data, E_OR);
-		fn(data, NULL, " || ");
-		expr_print(e->right.expr, fn, data, E_OR);
+		if (prevtoken == E_NONE) {
+			expr_print(e->left.expr, fn, data, E_NONE);
+			fn(data, NULL, "\n|| ");
+			expr_print(e->right.expr, fn, data, E_NONE);
+		} else {
+			expr_print(e->left.expr, fn, data, E_OR);
+			fn(data, NULL, " || ");
+			expr_print(e->right.expr, fn, data, E_OR);
+		}
 		break;
 	case E_AND:
 		expr_print(e->left.expr, fn, data, E_AND);

