Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755897AbaBROZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:25:27 -0500
Received: from mga11.intel.com ([192.55.52.93]:38928 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755084AbaBROZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:25:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,502,1389772800"; 
   d="scan'208";a="483434542"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, x86@kernel.org, linux-kbuild@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/6] kbuild: Support padding in kallsyms tables v2
Date: Tue, 18 Feb 2014 15:24:28 +0100
Message-Id: <1392733470-8228-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1392733470-8228-1-git-send-email-andi@firstfloor.org>
References: <1392733470-8228-1-git-send-email-andi@firstfloor.org>
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

Add 5% slack for now in case the prediction is too small
(can happen with LTO)

v2: Fix build error, found by Markus Trippelsdorf.
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 scripts/kallsyms.c | 93 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 90 insertions(+), 3 deletions(-)

diff --git a/scripts/kallsyms.c b/scripts/kallsyms.c
index d79027e..293c9eb 100644
--- a/scripts/kallsyms.c
+++ b/scripts/kallsyms.c
@@ -23,6 +23,13 @@
 #include <string.h>
 #include <ctype.h>
 
+/*
+ * The ratio to increase the padding, by how much the final kallsyms
+ * can be larger. This is for symbols that are not visible before
+ * final linking.
+ */
+#define PAD_RATIO 20 /* 1/x = ~5% */
+
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof(arr[0]))
 #endif
@@ -41,6 +48,14 @@ struct text_range {
 	unsigned long long start, end;
 };
 
+enum pads {
+	PAD_OFF,
+	PAD_NAMES,
+	PAD_MARKERS,
+	PAD_TOKTAB,
+	NUM_PAD
+};
+
 static unsigned long long _text;
 static struct text_range text_ranges[] = {
 	{ "_stext",     "_etext"     },
@@ -69,6 +84,7 @@ static void usage(void)
 	fprintf(stderr, "Usage: kallsyms [--all-symbols] "
 			"[--symbol-prefix=<prefix char>] "
 			"[--page-offset=<CONFIG_PAGE_OFFSET>] "
+			"[--pad=A,B,C] [--pad-file=name] "
 			"< in.map > out.S\n");
 	exit(1);
 }
@@ -303,7 +319,14 @@ static int expand_symbol(unsigned char *data, int len, char *result)
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
@@ -335,6 +358,16 @@ static void write_src(void)
 	for (i = 0; i < table_cnt; i++) {
 		printf("\tPTR\t%#llx\n", table[i].addr - _text);
 	}
+	if (pad) {
+		if (i > pad[PAD_OFF])
+			bad_padding("address pointers", i - pad[PAD_OFF]);
+		for (; i < pad[PAD_OFF]; i++)
+			printf("\tPTR\t0\n");
+	} else {
+		for (i = 0; i < table_cnt / PAD_RATIO; i++)
+			printf("\tPTR\t0\n");
+		opad[PAD_OFF] = table_cnt + table_cnt/PAD_RATIO;
+	}
 	printf("\n");
 
 	output_label("kallsyms_num_syms");
@@ -363,11 +396,31 @@ static void write_src(void)
 
 		off += table[i].len + 1;
 	}
+	if (pad) {
+		if (off > pad[PAD_NAMES])
+			bad_padding("name table", off - pad[PAD_NAMES]);
+		if (off < pad[PAD_NAMES])
+			printf("\t.fill %d,1,0\n", pad[PAD_NAMES] - off);
+	} else {
+		printf("\t.fill %d,1,0\n", off/PAD_RATIO);
+		off += off/PAD_RATIO;
+		opad[PAD_NAMES] = off;
+	}
 	printf("\n");
 
 	output_label("kallsyms_markers");
 	for (i = 0; i < ((table_cnt + 255) >> 8); i++)
 		printf("\tPTR\t%d\n", markers[i]);
+	if (pad) {
+		if (i > pad[PAD_MARKERS])
+			bad_padding("markers", i - pad[PAD_MARKERS]);
+		for (; i < pad[PAD_MARKERS]; i++)
+			printf("\tPTR\t0\n");
+	} else {
+		for (k = 0; k < i/PAD_RATIO; k++)
+			printf("\tPTR\t0\n");
+		opad[PAD_MARKERS] = i + i/PAD_RATIO;
+	}
 	printf("\n");
 
 	free(markers);
@@ -380,6 +433,16 @@ static void write_src(void)
 		printf("\t.asciz\t\"%s\"\n", buf);
 		off += strlen(buf) + 1;
 	}
+	if (pad) {
+		if (off > pad[PAD_TOKTAB])
+			bad_padding("token table", off - pad[PAD_TOKTAB]);
+		if (off < pad[PAD_TOKTAB])
+			printf("\t.fill %d,1,0\n", pad[PAD_TOKTAB] - off);
+	} else {
+		printf("\t.fill %d,1,0\n", off/PAD_RATIO);
+		off += off/PAD_RATIO;
+		opad[PAD_TOKTAB] = off;
+	}
 	printf("\n");
 
 	output_label("kallsyms_token_index");
@@ -647,6 +710,10 @@ static void sort_symbols(void)
 
 int main(int argc, char **argv)
 {
+	int inpad[NUM_PAD], opad[NUM_PAD];
+	int *inpadp = NULL;
+	FILE *opadf = NULL;
+
 	if (argc >= 2) {
 		int i;
 		for (i = 1; i < argc; i++) {
@@ -661,6 +728,22 @@ int main(int argc, char **argv)
 			} else if (strncmp(argv[i], "--page-offset=", 14) == 0) {
 				const char *p = &argv[i][14];
 				kernel_start_addr = strtoull(p, NULL, 16);
+			} else if (strncmp(argv[i], "--pad=", 6) == 0) {
+				inpadp = inpad;
+				if (sscanf(argv[i] + 6, "%d,%d,%d,%d",
+					   inpad + 0,
+					   inpad + 1,
+					   inpad + 2,
+					   inpad + 3) != NUM_PAD) {
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
@@ -670,7 +753,11 @@ int main(int argc, char **argv)
 	read_map(stdin);
 	sort_symbols();
 	optimize_token_table();
-	write_src();
-
+	write_src(inpadp, opad);
+	if (opadf) {
+		fprintf(opadf, "--pad=%d,%d,%d,%d\n",
+			opad[0], opad[1], opad[2], opad[3]);
+		fclose(opadf);
+	}
 	return 0;
 }
-- 
1.8.5.2

