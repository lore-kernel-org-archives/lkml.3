Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759267Ab3EFVPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 17:15:45 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:62504 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759224Ab3EFVPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 17:15:43 -0400
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Yann E. MORIN" <yann.morin.1998@free.fr>,
        Jean Delvare <jdelvare@suse.de>, Michal Marek <mmarek@suse.cz>,
        Roland Eggner <edvx1@systemanalysen.net>,
        Wang YanQing <udknight@gmail.com>
Subject: [PATCH v3] kconfig: sort found symbols by relevance
Date: Mon,  6 May 2013 23:15:31 +0200
Message-Id: <1367874931-6251-1-git-send-email-yann.morin.1998@free.fr>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1367826629.4494.30.camel@chaos.site>
References: <1367826629.4494.30.camel@chaos.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yann E. MORIN" <yann.morin.1998@free.fr>

When searching for symbols, return the symbols sorted by relevance.

Sorting is done as thus:
  - first, symbols with a prompt,   [1]
  - then, smallest offset,          [2]
  - then, shortest match,           [3]
  - then, highest relative match,   [4]
  - finally, alphabetical sort      [5]

So, searching (eg.) for 'P.*CI' :

[1] Symbols of interest are probably those with a prompt, as they can be
    changed, while symbols with no prompt are only for info. Thus:
        PCIEASPM comes before PCI_ATS

[2] Symbols that match earlier in the name are to be preferred over
    symbols which match later. Thus:
        PCI_MSI comes before WDTPCI

[3] The shortest match is (IMHO) more interesting than a longer one.
    Thus:
        PCI comes before PCMCIA

[4] The relative match is the ratio of the length of the match against
    the length of the symbol. The more of a symbol name we match, the
    more instersting that symbol is. Thus:
        PCIEAER comes before PCIEASPM

[5] As fallback, sort symbols alphabetically

This heuristic tries hard to get interesting symbols first in the list.

In any case, exact match can (as previously) be requested by using
start-of-line and end-of-line in the searc regexp: ^PCI$

Reported-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: Jean Delvare <jdelvare@suse.de>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Roland Eggner <edvx1@systemanalysen.net>
Cc: Wang YanQing <udknight@gmail.com>
---
 scripts/kconfig/symbol.c | 96 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 87 insertions(+), 9 deletions(-)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index ecc5aa5..20f8107 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -943,38 +943,116 @@ const char *sym_escape_string_value(const char *in)
 	return res;
 }
 
+struct sym_match {
+	struct symbol	*sym;
+	off_t		so, eo;
+};
+
+/* Compare matched symbols as thus:
+ * - first, symbols with a prompt,
+ * - then, smallest offset,
+ * - then, shortest match,
+ * - then, highest relative match,
+ * - finally, alphabetical sort
+ */
+static int sym_rel_comp( const void *sym1, const void *sym2 )
+{
+	struct sym_match *s1 = *(struct sym_match **)sym1;
+	struct sym_match *s2 = *(struct sym_match **)sym2;
+	struct property *p;
+	bool p1 = false, p2 = false;
+	int l1, l2, r1, r2;
+
+	for_all_prompts(s1->sym, p) {
+		p1 = true;
+	}
+	for_all_prompts(s2->sym, p) {
+		p2 = true;
+	}
+	if (p1 && !p2)
+		return -1;
+	if (!p1 && p2)
+		return 1;
+
+	if ( s1->so < s2->so )
+		return -1;
+	if ( s1->so > s2->so )
+		return 1;
+
+	l1 = s1->eo - s1->so;
+	l2 = s2->eo - s2->so;
+	if ( l1 > l2 )
+		return 1;
+	if ( l1 < l2 )
+		return -1;
+
+	r1 = 100*l1 / strlen(s1->sym->name);
+	r2 = 100*l2 / strlen(s2->sym->name);
+	if ( r1 > r2 )
+		return -1;
+	if ( r1 < r2 )
+		return 1;
+
+	return strcmp( s1->sym->name, s2->sym->name );
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
+		tmp_sym_match->so = match[0].rm_so;
+		tmp_sym_match->eo = match[0].rm_eo;
+		sym_match_arr[cnt++] = tmp_sym_match;
 	}
-	if (sym_arr)
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

