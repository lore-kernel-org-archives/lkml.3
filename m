Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968029Ab3HIQEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 12:04:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:39773 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934345Ab3HIQDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 12:03:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,846,1367996400"; 
   d="scan'208";a="384498931"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, linux-kbuild@vger.kernel.org,
        david.daney@cavium.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/3] Kbuild, kallsyms: Support padding in kallsyms tables
Date: Fri,  9 Aug 2013 09:03:18 -0700
Message-Id: <1376064199-8296-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1376064199-8296-1-git-send-email-andi@firstfloor.org>
References: <1376064199-8296-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add support for padding the variable length tables in kallsyms.
This adds a new --pad=XXX option to kallsyms to specify the table lengths,
and another option --pad-file=X to write the table lengths to a file.
Then when a table is shorter than the padding add the necessary padding
at the end.

This allows to replace an existing symbol table later with a different
one that may differ slightly.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 scripts/kallsyms.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 61 insertions(+), 4 deletions(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index 38c8ede..6940f00 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -41,6 +41,13 @@ struct text_range {
 	unsigned long long start, end;
 };
 
+enum pads {
+	PAD_OFF,
+	PAD_NAMES,
+	PAD_MARKERS,
+	NUM_PAD
+};
+
 static unsigned long long _text;
 static struct text_range text_ranges[] = {
 	{ "_stext",     "_etext"     },
@@ -65,7 +72,7 @@ unsigned char best_table_len[256];
 
 static void usage(void)
 {
-	fprintf(stderr, "Usage: kallsyms [--all-symbols] [--symbol-prefix=<prefix char>] < in.map > out.S\n");
+	fprintf(stderr, "Usage: kallsyms [--all-symbols] [--symbol-prefix=<prefix char>] [--pad=A,B,C] [--padfile=name] < in.map > out.S\n");
 	exit(1);
 }
 
@@ -285,7 +292,14 @@ static int expand_symbol(unsigned char *data, int len, char *result)
 	return total;
 }
 
-static void write_src(void)
+static void bad_padding(char *msg, int diff)
+{
+	fprintf(stderr, "kallsyms: %s padding too short: %d missing\n",
+			msg, diff);
+	exit(EXIT_FAILURE);
+}
+
+static void write_src(int *pad, int *opad)
 {
 	unsigned int i, k, off;
 	unsigned int best_idx[256];
@@ -317,6 +331,13 @@ static void write_src(void)
 	for (i = 0; i < table_cnt; i++) {
 		printf("\tPTR\t%#llx\n", table[i].addr - _text);
 	}
+	if (pad) {
+		if (i > pad[PAD_OFF])
+			bad_padding("address pointers", i - pad[PAD_OFF]);
+		for (; i < pad[PAD_OFF]; i++)
+			printf("\tPTR\t0\n");
+	} else
+		opad[PAD_OFF] = table_cnt;
 	printf("\n");
 
 	output_label("kallsyms_num_syms");
@@ -345,11 +366,25 @@ static void write_src(void)
 
 		off += table[i].len + 1;
 	}
+	if (pad) {
+		if (off > pad[PAD_NAMES])
+			bad_padding("name table", off - pad[PAD_NAMES]);
+		if (off < pad[PAD_NAMES])
+			printf("\t.fill %d,1,0\n", pad[PAD_NAMES] - off);
+	} else
+		opad[PAD_NAMES] = off;
 	printf("\n");
 
 	output_label("kallsyms_markers");
 	for (i = 0; i < ((table_cnt + 255) >> 8); i++)
 		printf("\tPTR\t%d\n", markers[i]);
+	if (pad) {
+		if (i > pad[PAD_MARKERS])
+			bad_padding("markers", i - pad[PAD_MARKERS]);
+		for (; i < pad[PAD_MARKERS]; i++)
+			printf("\tPTR\t0\n");
+	} else
+		opad[PAD_MARKERS] = i;
 	printf("\n");
 
 	free(markers);
@@ -629,6 +664,10 @@ static void sort_symbols(void)
 
 int main(int argc, char **argv)
 {
+	int inpad[NUM_PAD], opad[NUM_PAD];
+	int *inpadp = NULL;
+	FILE *opadf = NULL;
+
 	if (argc >= 2) {
 		int i;
 		for (i = 1; i < argc; i++) {
@@ -640,6 +679,21 @@ int main(int argc, char **argv)
 				if ((*p == '"' && *(p+2) == '"') || (*p == '\'' && *(p+2) == '\''))
 					p++;
 				symbol_prefix_char = *p;
+			} else if (strncmp(argv[i], "--pad=", 6) == 0) {
+				inpadp = inpad;
+				if (sscanf(argv[i] + 6, "%d,%d,%d",
+					   inpad + 0,
+					   inpad + 1,
+					   inpad + 2) != NUM_PAD) {
+					fprintf(stderr, "Bad pad list\n");
+					exit(EXIT_FAILURE);
+				}
+			} else if (strncmp(argv[i], "--pad-file=", 11) == 0) {
+				opadf = fopen(argv[i] + 11, "w");
+				if (!opadf) {
+					fprintf(stderr, "Cannot open %s", argv[i]+11);
+					exit(EXIT_FAILURE);
+				}
 			} else
 				usage();
 		}
@@ -649,7 +703,10 @@ int main(int argc, char **argv)
 	read_map(stdin);
 	sort_symbols();
 	optimize_token_table();
-	write_src();
-
+	write_src(inpadp, opad);
+	if (opadf) {
+		fprintf(opadf, "--pad=%d,%d,%d\n", opad[0], opad[1], opad[2]);
+		fclose(opadf);
+	}
 	return 0;
 }
-- 
1.8.3.1

