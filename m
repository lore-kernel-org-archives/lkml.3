Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942AbbAMVYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 16:24:39 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:61562 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbbAMVYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 16:24:37 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: dhowells@redhat.com
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, mmarek@suse.cz
Subject: [PATCH] X.509: silence asn1 compiler debug output
Date: Tue, 13 Jan 2015 22:24:31 +0100
Message-ID: <2620021.MFTRTXyQbt@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2124221.xG51kBCe6s@wuerfel>
References: <2124221.xG51kBCe6s@wuerfel>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:3wz8a1KewLFLcTbV/SeJGU4XsMO+NPY8syFOgfs6ZnCvZdHYSM+
 LGjtzZGS7UhphiHe/QwhHF2PL3DNp9OAMxO21IGp8E04BlZ1IFElRZlNBPD+API7BMndBau
 5XdKD11DQs4gflERXV8DUDb6/zZgpEgScl+R/RsuQKWYyfBxbxuVuwGduhFoWiDYcUv7Yht
 2Qy1D8TmNshXAEii95E0w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The asn1_compiler process is particularly chatty and produces
about the only stdout output for an allmodconfig kernel.

In order to follow the general concept of 'no news is good
news' for building kernels, this hides all the existing output
unless the KBUILD_VERBOSE environment variable is set.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/scripts/asn1_compiler.c b/scripts/asn1_compiler.c
index 91c4117637ae..048f4e2aeca9 100644
--- a/scripts/asn1_compiler.c
+++ b/scripts/asn1_compiler.c
@@ -311,6 +311,9 @@ struct token {
 
 static struct token *token_list;
 static unsigned nr_tokens;
+static _Bool verbose;
+
+#define debug(args ...) ({ if (verbose) printf(args); })
 
 static int directive_compare(const void *_key, const void *_pdir)
 {
@@ -322,21 +325,21 @@ static int directive_compare(const void *_key, const void *_pdir)
 	dlen = strlen(dir);
 	clen = (dlen < token->size) ? dlen : token->size;
 
-	//printf("cmp(%*.*s,%s) = ",
+	//debug("cmp(%*.*s,%s) = ",
 	//       (int)token->size, (int)token->size, token->value,
 	//       dir);
 
 	val = memcmp(token->value, dir, clen);
 	if (val != 0) {
-		//printf("%d [cmp]\n", val);
+		//debug("%d [cmp]\n", val);
 		return val;
 	}
 
 	if (dlen == token->size) {
-		//printf("0\n");
+		//debug("0\n");
 		return 0;
 	}
-	//printf("%d\n", (int)dlen - (int)token->size);
+	//debug("%d\n", (int)dlen - (int)token->size);
 	return dlen - token->size; /* shorter -> negative */
 }
 
@@ -515,13 +518,13 @@ static void tokenise(char *buffer, char *end)
 	}
 
 	nr_tokens = tix;
-	printf("Extracted %u tokens\n", nr_tokens);
+	debug("Extracted %u tokens\n", nr_tokens);
 
 #if 0
 	{
 		int n;
 		for (n = 0; n < nr_tokens; n++)
-			printf("Token %3u: '%*.*s'\n",
+			debug("Token %3u: '%*.*s'\n",
 			       n,
 			       (int)token_list[n].size, (int)token_list[n].size,
 			       token_list[n].value);
@@ -542,6 +545,7 @@ int main(int argc, char **argv)
 	ssize_t readlen;
 	FILE *out, *hdr;
 	char *buffer, *p;
+	char *kbuild_verbose;
 	int fd;
 
 	if (argc != 4) {
@@ -550,6 +554,10 @@ int main(int argc, char **argv)
 		exit(2);
 	}
 
+	kbuild_verbose = getenv("KBUILD_VERBOSE");
+	if (kbuild_verbose)
+		verbose = atoi(kbuild_verbose);
+
 	filename = argv[1];
 	outputname = argv[2];
 	headername = argv[3];
@@ -748,11 +756,11 @@ static void build_type_list(void)
 
 	qsort(type_index, nr, sizeof(type_index[0]), type_index_compare);
 
-	printf("Extracted %u types\n", nr_types);
+	debug("Extracted %u types\n", nr_types);
 #if 0
 	for (n = 0; n < nr_types; n++) {
 		struct type *type = type_index[n];
-		printf("- %*.*s\n",
+		debug("- %*.*s\n",
 		       (int)type->name->size,
 		       (int)type->name->size,
 		       type->name->value);
@@ -793,7 +801,7 @@ static void parse(void)
 
 	} while (type++, !(type->flags & TYPE_STOP_MARKER));
 
-	printf("Extracted %u actions\n", nr_actions);
+	debug("Extracted %u actions\n", nr_actions);
 }
 
 static struct element *element_list;
@@ -1284,7 +1292,7 @@ static void render(FILE *out, FILE *hdr)
 	}
 
 	/* We do two passes - the first one calculates all the offsets */
-	printf("Pass 1\n");
+	debug("Pass 1\n");
 	nr_entries = 0;
 	root = &type_list[0];
 	render_element(NULL, root->element, NULL);
@@ -1295,7 +1303,7 @@ static void render(FILE *out, FILE *hdr)
 		e->flags &= ~ELEMENT_RENDERED;
 
 	/* And then we actually render */
-	printf("Pass 2\n");
+	debug("Pass 2\n");
 	fprintf(out, "\n");
 	fprintf(out, "static const unsigned char %s_machine[] = {\n",
 		grammar_name);

