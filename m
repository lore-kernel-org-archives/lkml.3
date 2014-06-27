Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbaF0XQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 19:16:16 -0400
Received: from mga03.intel.com ([143.182.124.21]:57621 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754279AbaF0XQN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 19:16:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,564,1400050800"; 
   d="scan'208";a="450941286"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 1/9] perf, tools: Add jsmn `jasmine' JSON parser v3
Date: Fri, 27 Jun 2014 16:15:56 -0700
Message-Id: <1403910964-11017-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403910964-11017-1-git-send-email-andi@firstfloor.org>
References: <1403910964-11017-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

I need a JSON parser. This adds the simplest JSON
parser I could find -- Serge Zaitsev's jsmn `jasmine' --
to the perf library. I merely converted it to (mostly)
Linux style and added support for non 0 terminated input.

The parser is quite straight forward and does not
copy any data, just returns tokens with offsets
into the input buffer. So it's relatively efficient
and simple to use.

The code is not fully checkpatch clean, but I didn't
want to completely fork the upstream code.

Original source: http://zserge.bitbucket.org/jsmn.html

In addition I added a simple wrapper that mmaps a json
file and provides some straight forward access functions.

Used in follow-on patches to parse event files.

v2: Address review feedback.
v3: Minor checkpatch fixes.
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/Makefile.perf |   4 +
 tools/perf/util/jsmn.c   | 313 +++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/jsmn.h   |  67 ++++++++++
 tools/perf/util/json.c   | 155 +++++++++++++++++++++++
 tools/perf/util/json.h   |  13 ++
 5 files changed, 552 insertions(+)
 create mode 100644 tools/perf/util/jsmn.c
 create mode 100644 tools/perf/util/jsmn.h
 create mode 100644 tools/perf/util/json.c
 create mode 100644 tools/perf/util/json.h

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 9670a16..1cd32c5 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -300,6 +300,8 @@ LIB_H += ui/progress.h
 LIB_H += ui/util.h
 LIB_H += ui/ui.h
 LIB_H += util/data.h
+LIB_H += util/jsmn.h
+LIB_H += util/json.h
 
 LIB_OBJS += $(OUTPUT)util/abspath.o
 LIB_OBJS += $(OUTPUT)util/alias.o
@@ -373,6 +375,8 @@ LIB_OBJS += $(OUTPUT)util/stat.o
 LIB_OBJS += $(OUTPUT)util/record.o
 LIB_OBJS += $(OUTPUT)util/srcline.o
 LIB_OBJS += $(OUTPUT)util/data.o
+LIB_OBJS += $(OUTPUT)util/jsmn.o
+LIB_OBJS += $(OUTPUT)util/json.o
 
 LIB_OBJS += $(OUTPUT)ui/setup.o
 LIB_OBJS += $(OUTPUT)ui/helpline.o
diff --git a/tools/perf/util/jsmn.c b/tools/perf/util/jsmn.c
new file mode 100644
index 0000000..11d1fa1
--- /dev/null
+++ b/tools/perf/util/jsmn.c
@@ -0,0 +1,313 @@
+/*
+ * Copyright (c) 2010 Serge A. Zaitsev
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to deal
+ * in the Software without restriction, including without limitation the rights
+ * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
+ * copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
+ * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
+ * THE SOFTWARE.
+ *
+ * Slightly modified by AK to not assume 0 terminated input.
+ */
+
+#include <stdlib.h>
+#include "jsmn.h"
+
+/*
+ * Allocates a fresh unused token from the token pool.
+ */
+static jsmntok_t *jsmn_alloc_token(jsmn_parser *parser,
+				   jsmntok_t *tokens, size_t num_tokens)
+{
+	jsmntok_t *tok;
+
+	if ((unsigned)parser->toknext >= num_tokens)
+		return NULL;
+	tok = &tokens[parser->toknext++];
+	tok->start = tok->end = -1;
+	tok->size = 0;
+	return tok;
+}
+
+/*
+ * Fills token type and boundaries.
+ */
+static void jsmn_fill_token(jsmntok_t *token, jsmntype_t type,
+			    int start, int end)
+{
+	token->type = type;
+	token->start = start;
+	token->end = end;
+	token->size = 0;
+}
+
+/*
+ * Fills next available token with JSON primitive.
+ */
+static jsmnerr_t jsmn_parse_primitive(jsmn_parser *parser, const char *js,
+				      size_t len,
+				      jsmntok_t *tokens, size_t num_tokens)
+{
+	jsmntok_t *token;
+	int start;
+
+	start = parser->pos;
+
+	for (; parser->pos < len; parser->pos++) {
+		switch (js[parser->pos]) {
+#ifndef JSMN_STRICT
+		/*
+		 * In strict mode primitive must be followed by ","
+		 * or "}" or "]"
+		 */
+		case ':':
+#endif
+		case '\t':
+		case '\r':
+		case '\n':
+		case ' ':
+		case ',':
+		case ']':
+		case '}':
+			goto found;
+		default:
+			break;
+		}
+		if (js[parser->pos] < 32 || js[parser->pos] >= 127) {
+			parser->pos = start;
+			return JSMN_ERROR_INVAL;
+		}
+	}
+#ifdef JSMN_STRICT
+	/*
+	 * In strict mode primitive must be followed by a
+	 * comma/object/array.
+	 */
+	parser->pos = start;
+	return JSMN_ERROR_PART;
+#endif
+
+found:
+	token = jsmn_alloc_token(parser, tokens, num_tokens);
+	if (token == NULL) {
+		parser->pos = start;
+		return JSMN_ERROR_NOMEM;
+	}
+	jsmn_fill_token(token, JSMN_PRIMITIVE, start, parser->pos);
+	parser->pos--; /* parent sees closing brackets */
+	return JSMN_SUCCESS;
+}
+
+/*
+ * Fills next token with JSON string.
+ */
+static jsmnerr_t jsmn_parse_string(jsmn_parser *parser, const char *js,
+				   size_t len,
+				   jsmntok_t *tokens, size_t num_tokens)
+{
+	jsmntok_t *token;
+	int start = parser->pos;
+
+	/* Skip starting quote */
+	parser->pos++;
+
+	for (; parser->pos < len; parser->pos++) {
+		char c = js[parser->pos];
+
+		/* Quote: end of string */
+		if (c == '\"') {
+			token = jsmn_alloc_token(parser, tokens, num_tokens);
+			if (token == NULL) {
+				parser->pos = start;
+				return JSMN_ERROR_NOMEM;
+			}
+			jsmn_fill_token(token, JSMN_STRING, start+1,
+					parser->pos);
+			return JSMN_SUCCESS;
+		}
+
+		/* Backslash: Quoted symbol expected */
+		if (c == '\\') {
+			parser->pos++;
+			switch (js[parser->pos]) {
+				/* Allowed escaped symbols */
+			case '\"':
+			case '/':
+			case '\\':
+			case 'b':
+			case 'f':
+			case 'r':
+			case 'n':
+			case 't':
+				break;
+				/* Allows escaped symbol \uXXXX */
+			case 'u':
+				/* TODO */
+				break;
+				/* Unexpected symbol */
+			default:
+				parser->pos = start;
+				return JSMN_ERROR_INVAL;
+			}
+		}
+	}
+	parser->pos = start;
+	return JSMN_ERROR_PART;
+}
+
+/*
+ * Parse JSON string and fill tokens.
+ */
+jsmnerr_t jsmn_parse(jsmn_parser *parser, const char *js, size_t len,
+		     jsmntok_t *tokens, unsigned int num_tokens)
+{
+	jsmnerr_t r;
+	int i;
+	jsmntok_t *token;
+
+	for (; parser->pos < len; parser->pos++) {
+		char c;
+		jsmntype_t type;
+
+		c = js[parser->pos];
+		switch (c) {
+		case '{':
+		case '[':
+			token = jsmn_alloc_token(parser, tokens, num_tokens);
+			if (token == NULL)
+				return JSMN_ERROR_NOMEM;
+			if (parser->toksuper != -1)
+				tokens[parser->toksuper].size++;
+			token->type = (c == '{' ? JSMN_OBJECT : JSMN_ARRAY);
+			token->start = parser->pos;
+			parser->toksuper = parser->toknext - 1;
+			break;
+		case '}':
+		case ']':
+			type = (c == '}' ? JSMN_OBJECT : JSMN_ARRAY);
+			for (i = parser->toknext - 1; i >= 0; i--) {
+				token = &tokens[i];
+				if (token->start != -1 && token->end == -1) {
+					if (token->type != type)
+						return JSMN_ERROR_INVAL;
+					parser->toksuper = -1;
+					token->end = parser->pos + 1;
+					break;
+				}
+			}
+			/* Error if unmatched closing bracket */
+			if (i == -1)
+				return JSMN_ERROR_INVAL;
+			for (; i >= 0; i--) {
+				token = &tokens[i];
+				if (token->start != -1 && token->end == -1) {
+					parser->toksuper = i;
+					break;
+				}
+			}
+			break;
+		case '\"':
+			r = jsmn_parse_string(parser, js, len, tokens,
+					      num_tokens);
+			if (r < 0)
+				return r;
+			if (parser->toksuper != -1)
+				tokens[parser->toksuper].size++;
+			break;
+		case '\t':
+		case '\r':
+		case '\n':
+		case ':':
+		case ',':
+		case ' ':
+			break;
+#ifdef JSMN_STRICT
+			/*
+			 * In strict mode primitives are:
+			 * numbers and booleans.
+			 */
+		case '-':
+		case '0':
+		case '1':
+		case '2':
+		case '3':
+		case '4':
+		case '5':
+		case '6':
+		case '7':
+		case '8':
+		case '9':
+		case 't':
+		case 'f':
+		case 'n':
+#else
+			/*
+			 * In non-strict mode every unquoted value
+			 * is a primitive.
+			 */
+			/*FALL THROUGH */
+		default:
+#endif
+			r = jsmn_parse_primitive(parser, js, len, tokens,
+						 num_tokens);
+			if (r < 0)
+				return r;
+			if (parser->toksuper != -1)
+				tokens[parser->toksuper].size++;
+			break;
+
+#ifdef JSMN_STRICT
+			/* Unexpected char in strict mode */
+		default:
+			return JSMN_ERROR_INVAL;
+#endif
+		}
+	}
+
+	for (i = parser->toknext - 1; i >= 0; i--) {
+		/* Unmatched opened object or array */
+		if (tokens[i].start != -1 && tokens[i].end == -1)
+			return JSMN_ERROR_PART;
+	}
+
+	return JSMN_SUCCESS;
+}
+
+/*
+ * Creates a new parser based over a given  buffer with an array of tokens
+ * available.
+ */
+void jsmn_init(jsmn_parser *parser)
+{
+	parser->pos = 0;
+	parser->toknext = 0;
+	parser->toksuper = -1;
+}
+
+const char *jsmn_strerror(jsmnerr_t err)
+{
+	switch (err) {
+	case JSMN_ERROR_NOMEM:
+		return "No enough tokens";
+	case JSMN_ERROR_INVAL:
+		return "Invalid character inside JSON string";
+	case JSMN_ERROR_PART:
+		return "The string is not a full JSON packet, more bytes expected";
+	case JSMN_SUCCESS:
+		return "Success";
+	default:
+		return "Unknown json error";
+	}
+}
diff --git a/tools/perf/util/jsmn.h b/tools/perf/util/jsmn.h
new file mode 100644
index 0000000..d666b10
--- /dev/null
+++ b/tools/perf/util/jsmn.h
@@ -0,0 +1,67 @@
+#ifndef __JSMN_H_
+#define __JSMN_H_
+
+/*
+ * JSON type identifier. Basic types are:
+ *	o Object
+ *	o Array
+ *	o String
+ *	o Other primitive: number, boolean (true/false) or null
+ */
+typedef enum {
+	JSMN_PRIMITIVE = 0,
+	JSMN_OBJECT = 1,
+	JSMN_ARRAY = 2,
+	JSMN_STRING = 3
+} jsmntype_t;
+
+typedef enum {
+	/* Not enough tokens were provided */
+	JSMN_ERROR_NOMEM = -1,
+	/* Invalid character inside JSON string */
+	JSMN_ERROR_INVAL = -2,
+	/* The string is not a full JSON packet, more bytes expected */
+	JSMN_ERROR_PART = -3,
+	/* Everything was fine */
+	JSMN_SUCCESS = 0
+} jsmnerr_t;
+
+/*
+ * JSON token description.
+ * @param		type	type (object, array, string etc.)
+ * @param		start	start position in JSON data string
+ * @param		end		end position in JSON data string
+ */
+typedef struct {
+	jsmntype_t type;
+	int start;
+	int end;
+	int size;
+} jsmntok_t;
+
+/*
+ * JSON parser. Contains an array of token blocks available. Also stores
+ * the string being parsed now and current position in that string
+ */
+typedef struct {
+	unsigned int pos; /* offset in the JSON string */
+	int toknext; /* next token to allocate */
+	int toksuper; /* superior token node, e.g parent object or array */
+} jsmn_parser;
+
+/*
+ * Create JSON parser over an array of tokens
+ */
+void jsmn_init(jsmn_parser *parser);
+
+/*
+ * Run JSON parser. It parses a JSON data string into and array of tokens,
+ * each describing a single JSON object.
+ */
+jsmnerr_t jsmn_parse(jsmn_parser *parser, const char *js,
+		     size_t len,
+		     jsmntok_t *tokens, unsigned int num_tokens);
+
+const char *jsmn_strerror(jsmnerr_t err);
+
+#endif /* __JSMN_H_ */
diff --git a/tools/perf/util/json.c b/tools/perf/util/json.c
new file mode 100644
index 0000000..cac1b83
--- /dev/null
+++ b/tools/perf/util/json.c
@@ -0,0 +1,155 @@
+/* Parse JSON files using the JSMN parser. */
+
+/*
+ * Copyright (c) 2014, Intel Corporation
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions are met:
+ *
+ * 1. Redistributions of source code must retain the above copyright notice,
+ * this list of conditions and the following disclaimer.
+ *
+ * 2. Redistributions in binary form must reproduce the above copyright
+ * notice, this list of conditions and the following disclaimer in the
+ * documentation and/or other materials provided with the distribution.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
+ * FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
+ * COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
+ * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
+ * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
+ * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
+ * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
+ * OF THE POSSIBILITY OF SUCH DAMAGE.
+*/
+
+#include <stdlib.h>
+#include <string.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/fcntl.h>
+#include <stdio.h>
+#include <unistd.h>
+#include "jsmn.h"
+#include "json.h"
+#include <linux/kernel.h>
+
+static char *mapfile(const char *fn, size_t *size)
+{
+	unsigned ps = sysconf(_SC_PAGESIZE);
+	struct stat st;
+	char *map = NULL;
+	int err;
+	int fd = open(fn, O_RDONLY);
+
+	if (fd < 0)
+		return NULL;
+	err = fstat(fd, &st);
+	if (err < 0)
+		goto out;
+	*size = st.st_size;
+	map = mmap(NULL,
+		   (st.st_size + ps - 1) & ~(ps - 1),
+		   PROT_READ|PROT_WRITE, MAP_PRIVATE, fd, 0);
+	if (map == MAP_FAILED)
+		map = NULL;
+out:
+	close(fd);
+	return map;
+}
+
+static void unmapfile(char *map, size_t size)
+{
+	unsigned ps = sysconf(_SC_PAGESIZE);
+	munmap(map, roundup(size, ps));
+}
+
+/*
+ * Parse json file using jsmn. Return array of tokens,
+ * and mapped file. Caller needs to free array.
+ */
+jsmntok_t *parse_json(const char *fn, char **map, size_t *size, int *len)
+{
+	jsmn_parser parser;
+	jsmntok_t *tokens;
+	jsmnerr_t res;
+	unsigned sz;
+
+	*map = mapfile(fn, size);
+	if (!*map)
+		return NULL;
+	/* Heuristic */
+	sz = *size * 16;
+	tokens = malloc(sz);
+	if (!tokens)
+		goto error;
+	jsmn_init(&parser);
+	res = jsmn_parse(&parser, *map, *size, tokens,
+			 sz / sizeof(jsmntok_t));
+	if (res != JSMN_SUCCESS) {
+		pr_err("%s: json error %s\n", fn, jsmn_strerror(res));
+		goto error_free;
+	}
+	if (len)
+		*len = parser.toknext;
+	return tokens;
+error_free:
+	free(tokens);
+error:
+	unmapfile(*map, *size);
+	return NULL;
+}
+
+void free_json(char *map, size_t size, jsmntok_t *tokens)
+{
+	free(tokens);
+	unmapfile(map, size);
+}
+
+static int countchar(char *map, char c, int end)
+{
+	int i;
+	int count = 0;
+	for (i = 0; i < end; i++)
+		if (map[i] == c)
+			count++;
+	return count;
+}
+
+/* Return line number of a jsmn token */
+int json_line(char *map, jsmntok_t *t)
+{
+	return countchar(map, '\n', t->start) + 1;
+}
+
+static const char * const jsmn_types[] = {
+	[JSMN_PRIMITIVE] = "primitive",
+	[JSMN_ARRAY] = "array",
+	[JSMN_OBJECT] = "object",
+	[JSMN_STRING] = "string"
+};
+
+#define LOOKUP(a, i) ((i) < (sizeof(a)/sizeof(*(a))) ? ((a)[i]) : "?")
+
+/* Return type name of a jsmn token */
+const char *json_name(jsmntok_t *t)
+{
+	return LOOKUP(jsmn_types, t->type);
+}
+
+int json_len(jsmntok_t *t)
+{
+	return t->end - t->start;
+}
+
+/* Is string t equal to s? */
+int json_streq(char *map, jsmntok_t *t, const char *s)
+{
+	unsigned len = json_len(t);
+	return len == strlen(s) && !strncasecmp(map + t->start, s, len);
+}
diff --git a/tools/perf/util/json.h b/tools/perf/util/json.h
new file mode 100644
index 0000000..37dd9e9
--- /dev/null
+++ b/tools/perf/util/json.h
@@ -0,0 +1,13 @@
+#ifndef JSON_H
+#define JSON_H 1
+
+#include "jsmn.h"
+
+jsmntok_t *parse_json(const char *fn, char **map, size_t *size, int *len);
+void free_json(char *map, size_t size, jsmntok_t *tokens);
+int json_line(char *map, jsmntok_t *t);
+const char *json_name(jsmntok_t *t);
+int json_streq(char *map, jsmntok_t *t, const char *s);
+int json_len(jsmntok_t *t);
+
+#endif
-- 
1.9.3

