Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277Ab3GMSJI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 14:09:08 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35161 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758234Ab3GMSIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 14:08:40 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Jean Delvare <jdelvare@suse.de>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
Subject: [PATCH 3/3] kconfig: cleanup symbol-search code
Date: Sat, 13 Jul 2013 20:08:25 +0200
Message-Id: <1373738905-23396-4-git-send-email-yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1373738905-23396-1-git-send-email-yann.morin.1998@free.fr>
References: <1373738905-23396-1-git-send-email-yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

- no need for a double-indirection for the temporary sym_match_arr array
- the temporary sym_match_arr array is not NULL terminated, so no need
  to allocate n+1 elements
- two minor style fixes
- grammar fix in comment

Reported-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Jean Delvare <jdelvare@suse.de>
---
 scripts/kconfig/symbol.c | 39 +++++++++++++++------------------------
 1 file changed, 15 insertions(+), 24 deletions(-)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index 020a0ac..a76b8fd 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -963,10 +963,10 @@ struct sym_match {
  * - first, symbols that match exactly
  * - then, alphabetical sort
  */
-static int sym_rel_comp( const void *sym1, const void *sym2 )
+static int sym_rel_comp(const void *sym1, const void *sym2)
 {
-	struct sym_match *s1 = *(struct sym_match **)sym1;
-	struct sym_match *s2 = *(struct sym_match **)sym2;
+	const struct sym_match *s1 = sym1;
+	const struct sym_match *s2 = sym2;
 	int exact1, exact2;
 
 	/* Exact match:
@@ -992,7 +992,7 @@ static int sym_rel_comp( const void *sym1, const void *sym2 )
 struct symbol **sym_re_search(const char *pattern)
 {
 	struct symbol *sym, **sym_arr = NULL;
-	struct sym_match **sym_match_arr = NULL;
+	struct sym_match *sym_match_arr = NULL;
 	int i, cnt, size;
 	regex_t re;
 	regmatch_t match[1];
@@ -1005,47 +1005,38 @@ struct symbol **sym_re_search(const char *pattern)
 		return NULL;
 
 	for_all_symbols(i, sym) {
-		struct sym_match *tmp_sym_match;
 		if (sym->flags & SYMBOL_CONST || !sym->name)
 			continue;
 		if (regexec(&re, sym->name, 1, match, 0))
 			continue;
-		if (cnt + 1 >= size) {
+		if (cnt >= size) {
 			void *tmp;
 			size += 16;
-			tmp = realloc(sym_match_arr, size * sizeof(struct sym_match *));
-			if (!tmp) {
+			tmp = realloc(sym_match_arr, size * sizeof(struct sym_match));
+			if (!tmp)
 				goto sym_re_search_free;
-			}
 			sym_match_arr = tmp;
 		}
 		sym_calc_value(sym);
-		tmp_sym_match = (struct sym_match*)malloc(sizeof(struct sym_match));
-		if (!tmp_sym_match)
-			goto sym_re_search_free;
-		tmp_sym_match->sym = sym;
-		/* As regexec return 0, we know we have a match, so
+		/* As regexec returned 0, we know we have a match, so
 		 * we can use match[0].rm_[se]o without further checks
 		 */
-		tmp_sym_match->so = match[0].rm_so;
-		tmp_sym_match->eo = match[0].rm_eo;
-		sym_match_arr[cnt++] = tmp_sym_match;
+		sym_match_arr[cnt].so = match[0].rm_so;
+		sym_match_arr[cnt].eo = match[0].rm_eo;
+		sym_match_arr[cnt++].sym = sym;
 	}
 	if (sym_match_arr) {
-		qsort(sym_match_arr, cnt, sizeof(struct sym_match*), sym_rel_comp);
+		qsort(sym_match_arr, cnt, sizeof(struct sym_match), sym_rel_comp);
 		sym_arr = malloc((cnt+1) * sizeof(struct symbol));
 		if (!sym_arr)
 			goto sym_re_search_free;
 		for (i = 0; i < cnt; i++)
-			sym_arr[i] = sym_match_arr[i]->sym;
+			sym_arr[i] = sym_match_arr[i].sym;
 		sym_arr[cnt] = NULL;
 	}
 sym_re_search_free:
-	if (sym_match_arr) {
-		for (i = 0; i < cnt; i++)
-			free(sym_match_arr[i]);
-		free(sym_match_arr);
-	}
+	/* sym_match_arr can be NULL if no match, but free(NULL) is OK */
+	free(sym_match_arr);
 	regfree(&re);
 
 	return sym_arr;
-- 
1.8.1.2

