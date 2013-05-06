Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab3EFNCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 09:02:55 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:54483 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab3EFNCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 09:02:53 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Jean Delvare <jdelvare@suse.de>, Michal Marek <mmarek@suse.cz>,
        Roland Eggner <edvx1@systemanalysen.net>,
        Wang YanQing <udknight@gmail.com>
Subject: [PATCH] kconfig: sort found symbols by relevance
Date: Mon,  6 May 2013 15:02:45 +0200
Message-Id: <1367845365-13316-1-git-send-email-yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367826629.4494.30.camel@chaos.site>
References: <1367826629.4494.30.camel@chaos.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

When searching for symbols, return the symbols sorted by relevance.

Relevance is the ratio of the length of the matched string and the
length of the symbol name. Symbols of equal relevance are sorted
alphabetically.

Reported-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Jean Delvare <jdelvare@suse.de>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Roland Eggner <edvx1@systemanalysen.net>
Cc: Wang YanQing <udknight@gmail.com>
---
 scripts/kconfig/symbol.c | 66 +++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 57 insertions(+), 9 deletions(-)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index ecc5aa5..baba030 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -943,38 +943,86 @@ const char *sym_escape_string_value(const char *in)
 	return res;
 }
 
+struct sym_match {
+	struct symbol	*sym;
+	int 		rel;
+};
+
+/* Compare matched symbols as thus:
+ * - highest relevance first
+ * - equal relevance sorted alphabetically
+ */
+static int sym_rel_comp( const void *sym1, const void *sym2 )
+{
+	struct sym_match **s1 = (struct sym_match **)sym1;
+	struct sym_match **s2 = (struct sym_match **)sym2;
+
+	if ( (*s1)->rel > (*s2)->rel )
+		return -1;
+	else if ( (*s1)->rel < (*s2)->rel )
+		return 1;
+	else
+		return strcmp( (*s1)->sym->name, (*s2)->sym->name );
+}
+
 struct symbol **sym_re_search(const char *pattern)
 {
 	struct symbol *sym, **sym_arr = NULL;
+	struct sym_match **sym_match_arr = NULL;
 	int i, cnt, size;
 	regex_t re;
+	regmatch_t match[1];
 
 	cnt = size = 0;
 	/* Skip if empty */
 	if (strlen(pattern) == 0)
 		return NULL;
-	if (regcomp(&re, pattern, REG_EXTENDED|REG_NOSUB|REG_ICASE))
+	if (regcomp(&re, pattern, REG_EXTENDED|REG_ICASE))
 		return NULL;
 
 	for_all_symbols(i, sym) {
+		struct sym_match *tmp_sym_match;
 		if (sym->flags & SYMBOL_CONST || !sym->name)
 			continue;
-		if (regexec(&re, sym->name, 0, NULL, 0))
+		if (regexec(&re, sym->name, 1, match, 0))
 			continue;
 		if (cnt + 1 >= size) {
-			void *tmp = sym_arr;
+			void *tmp;
 			size += 16;
-			sym_arr = realloc(sym_arr, size * sizeof(struct symbol *));
-			if (!sym_arr) {
-				free(tmp);
-				return NULL;
+			tmp = realloc(sym_match_arr, size * sizeof(struct sym_match *));
+			if (!tmp) {
+				goto sym_re_search_free;
 			}
+			sym_match_arr = tmp;
 		}
 		sym_calc_value(sym);
-		sym_arr[cnt++] = sym;
+		tmp_sym_match = (struct sym_match*)malloc(sizeof(struct sym_match));
+		if (!tmp_sym_match)
+			goto sym_re_search_free;
+		tmp_sym_match->sym = sym;
+		/* As regexec return 0, we know we have a match, so
+		 * we can use match[0].rm_[se]o without further checks
+		 */
+		tmp_sym_match->rel = (100*(match[0].rm_eo-match[0].rm_so))
+				     /strlen(sym->name);
+		sym_match_arr[cnt++] = tmp_sym_match;
 	}
-	if (sym_arr)
+
+	if( sym_match_arr ) {
+		qsort( sym_match_arr, cnt, sizeof(struct sym_match*), sym_rel_comp );
+		sym_arr = malloc( (cnt+1) * sizeof(struct symbol) );
+		if (!sym_arr)
+			goto sym_re_search_free;
+		for ( i=0; i<cnt; i++ )
+			sym_arr[i] = sym_match_arr[i]->sym;
 		sym_arr[cnt] = NULL;
+	}
+sym_re_search_free:
+	if (sym_match_arr) {
+		for ( i=0; i<cnt; i++ )
+			free( sym_match_arr[i] );
+		free( sym_match_arr );
+	}
 	regfree(&re);
 
 	return sym_arr;
-- 
1.8.1.2

