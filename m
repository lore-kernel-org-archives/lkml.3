Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752869AbaC1N5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 09:57:34 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35724 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaC1N53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 09:57:29 -0400
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Ingo Molnar <mingo@redhat.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>
Subject: [PATCH 23/28] ktap: add userspace/kp_util.c
Date: Fri, 28 Mar 2014 09:47:44 -0400
Message-Id: <1396014469-5937-24-git-send-email-jovi.zhangwei@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jovi Zhangwei <jovi.zhangwei@gmail.com>
---
 tools/ktap/userspace/kp_util.c | 646 +++++++++++++++++++++++++++++++++++++++++
 tools/ktap/userspace/kp_util.h | 120 ++++++++
 2 files changed, 766 insertions(+)
 create mode 100644 tools/ktap/userspace/kp_util.c
 create mode 100644 tools/ktap/userspace/kp_util.h

diff --git a/tools/ktap/userspace/kp_util.c b/tools/ktap/userspace/kp_util.c
new file mode 100644
index 0000000..f7ca335
--- /dev/null
+++ b/tools/ktap/userspace/kp_util.c
@@ -0,0 +1,646 @@
+/*
+ * util.c
+ *
+ * This file is part of ktap by Jovi Zhangwei.
+ *
+ * Copyright (C) 2012-2014 Jovi Zhangwei <jovi.zhangwei@gmail.com>.
+ *
+ * Adapted from luajit and lua interpreter.
+ * Copyright (C) 2005-2014 Mike Pall.
+ * Copyright (C) 1994-2008 Lua.org, PUC-Rio.
+ *
+ * ktap is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * ktap is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ */
+
+#include <stdarg.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <math.h>
+#include <ctype.h>
+#include "../include/ktap_types.h"
+#include "../include/ktap_bc.h"
+#include "kp_util.h"
+
+/* Error message strings. */
+const char *kp_err_allmsg =
+#define ERRDEF(name, msg)       msg "\0"
+#include "../include/ktap_errmsg.h"
+;
+
+const uint8_t kp_char_bits[257] = {
+    0,
+    1,  1,  1,  1,  1,  1,  1,  1,  1,  3,  3,  3,  3,  3,  1,  1,
+    1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,  1,
+    2,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,  4,
+  152,152,152,152,152,152,152,152,152,152,  4,  4,  4,  4,  4,  4,
+    4,176,176,176,176,176,176,160,160,160,160,160,160,160,160,160,
+  160,160,160,160,160,160,160,160,160,160,160,  4,  4,  4,  4,132,
+    4,208,208,208,208,208,208,192,192,192,192,192,192,192,192,192,
+  192,192,192,192,192,192,192,192,192,192,192,  4,  4,  4,  4,  1,
+  128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,
+  128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,
+  128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,
+  128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,
+  128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,
+  128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,
+  128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,
+  128,128,128,128,128,128,128,128,128,128,128,128,128,128,128,128
+};
+
+void kp_buf_init(SBuf *sb)
+{
+	sb->b = (char *)malloc(200);
+	sb->p = NULL;
+	sb->e = sb->b + 200;
+}
+
+void kp_buf_reset(SBuf *sb)
+{
+	sb->p = sb->b;
+}
+
+void kp_buf_free(SBuf *sb)
+{
+	free(sbufB(sb));
+}
+
+char *kp_buf_more(SBuf *sb, int sz)
+{
+	char *b;
+	int old_len = sbuflen(sb);
+
+	if (sz > sbufleft(sb)) {
+		b = realloc(sbufB(sb), sbuflen(sb) * 2);
+		sb->b = b;
+		sb->p = b + old_len;
+		sb->e = b + old_len * 2;
+	}
+
+	return sbufP(sb);
+}
+
+char *kp_buf_need(SBuf *sb, int sz)
+{
+	char *b;
+	int old_len = sbuflen(sb);
+
+	if (sz > sbufsz(sb)) {
+		b = realloc(sbufB(sb), sz);
+		sb->b = b;
+		sb->p = b + old_len;
+		sb->e = b + sz;
+	}
+
+	return sbufB(sb);
+}
+
+char *kp_buf_wmem(char *p, const void *q, int len)
+{
+	return (char *)memcpy(p, q, len) + len;
+}
+
+void kp_buf_putb(SBuf *sb, int c)
+{
+	char *p = kp_buf_more(sb, 1);
+	*p++ = (char)c;
+	setsbufP(sb, p);
+}
+
+ktap_str_t *kp_buf_str(SBuf *sb)
+{
+	return kp_str_new(sbufB(sb), sbuflen(sb));
+}
+
+/* Write ULEB128 to buffer. */
+char *strfmt_wuleb128(char *p, uint32_t v)
+{
+  for (; v >= 0x80; v >>= 7)
+    *p++ = (char)((v & 0x7f) | 0x80);
+  *p++ = (char)v;
+  return p;
+}
+
+void kp_err_lex(ktap_str_t *src, const char *tok, BCLine line,
+		ErrMsg em, va_list argp)
+{
+	const char *msg;
+
+	msg = kp_sprintfv(err2msg(em), argp);
+	msg = kp_sprintf("%s:%d: %s", getstr(src), line, msg);
+	if (tok)
+		msg = kp_sprintf(err2msg(KP_ERR_XNEAR), msg, tok);
+	fprintf(stderr, "%s: %s\n", err2msg(KP_ERR_XSYNTAX), msg);
+	exit(-1);
+}
+
+void *kp_reallocv(void *block, size_t osize, size_t nsize)
+{
+	return realloc(block, nsize);
+}
+
+static const ktap_val_t kp_niltv = { {NULL}, {KTAP_TNIL} } ;
+#define niltv  (&kp_niltv)
+
+#define gnode(t,i)	(&(t)->node[i])
+#define gkey(n)		(&(n)->key)
+#define gval(n)		(&(n)->val)
+
+const ktap_val_t *kp_tab_get(ktap_tab_t *t, const ktap_val_t *key)
+{
+	int i;
+
+	switch (itype(key)) {
+	case KTAP_TNIL:
+		return niltv;
+	case KTAP_TNUM:
+		for (i = 0; i <= t->hmask; i++) {
+			ktap_val_t *v = gkey(gnode(t, i));
+			if (is_number(v) && nvalue(key) == nvalue(v))
+				return gval(gnode(t, i));
+		}
+		break;
+	case KTAP_TSTR:
+		for (i = 0; i <= t->hmask; i++) {
+			ktap_val_t *v = gkey(gnode(t, i));
+			if (is_string(v) && (rawtsvalue(key) == rawtsvalue(v)))
+				return gval(gnode(t, i));
+		}
+		break;
+	default:
+		for (i = 0; i <= t->hmask; i++) {
+			if (kp_obj_equal(key, gkey(gnode(t, i))))
+				return gval(gnode(t, i));
+		}
+		break;
+	}
+
+	return niltv;
+}
+
+const ktap_val_t *kp_tab_getstr(ktap_tab_t *t, const ktap_str_t *ts)
+{
+	int i;
+
+	for (i = 0; i <= t->hmask; i++) {
+		ktap_val_t *v = gkey(gnode(t, i));
+		if (is_string(v) && (ts == rawtsvalue(v)))
+			return gval(gnode(t, i));
+	}
+
+	return niltv;
+}
+
+void kp_tab_setvalue(ktap_tab_t *t, const ktap_val_t *key, ktap_val_t *val)
+{
+	const ktap_val_t *v = kp_tab_get(t, key);
+
+	if (v != niltv) {
+		set_obj((ktap_val_t *)v, val);
+	} else {
+		if (t->freetop == t->node) {
+			int size = (t->hmask + 1) * sizeof(ktap_node_t);
+			t->node = realloc(t->node, size * 2);
+			memset(t->node + t->hmask + 1, 0, size);
+			t->freetop = t->node + (t->hmask + 1) * 2;
+			t->hmask = (t->hmask + 1) * 2 - 1;
+		}
+
+		ktap_node_t *n = --t->freetop;
+		set_obj(gkey(n), key);
+		set_obj(gval(n), val);
+	}
+}
+
+ktap_val_t *kp_tab_set(ktap_tab_t *t, const ktap_val_t *key)
+{
+	const ktap_val_t *v = kp_tab_get(t, key);
+
+	if (v != niltv) {
+		return (ktap_val_t *)v;
+	} else {
+		if (t->freetop == t->node) {
+			int size = (t->hmask + 1) * sizeof(ktap_node_t);
+			t->node = realloc(t->node, size * 2);
+			memset(t->node + t->hmask + 1, 0, size);
+			t->freetop = t->node + (t->hmask + 1) * 2;
+			t->hmask = (t->hmask + 1) * 2 - 1;
+		}
+
+		ktap_node_t *n = --t->freetop;
+		set_obj(gkey(n), key);
+		set_nil(gval(n));
+		return gval(n);
+	}
+}
+
+
+ktap_tab_t *kp_tab_new(void)
+{
+	int hsize, i;
+
+	ktap_tab_t *t = malloc(sizeof(ktap_tab_t));
+	t->gct = ~KTAP_TTAB;
+	hsize = 1024;
+	t->hmask = hsize - 1;
+	t->node = (ktap_node_t *)malloc(hsize * sizeof(ktap_node_t));
+	t->freetop = &t->node[hsize];
+	t->asize = 0;
+
+	for (i = 0; i <= t->hmask; i++) {
+		set_nil(&t->node[i].val);
+		set_nil(&t->node[i].key);
+	}
+	return t;
+}
+
+/* simple interned string array, use hash table in future  */
+static ktap_str_t **strtab;
+static int strtab_size = 1000; /* initial size */
+static int strtab_nr;
+
+void kp_str_resize(void)
+{
+	int size = strtab_size * sizeof(ktap_str_t *);
+
+	strtab = malloc(size);
+	if (!strtab) {
+		fprintf(stderr, "cannot allocate stringtable\n");
+		exit(-1);
+	}
+
+	memset(strtab, 0, size);
+	strtab_nr = 0;
+}
+
+static ktap_str_t *stringtable_search(const char *str, int len)
+{
+	int i;
+
+	for (i = 0; i < strtab_nr; i++) {
+		ktap_str_t *s = strtab[i];
+		if ((len == s->len) && !memcmp(str, getstr(s), len))
+			return s;
+	}
+
+	return NULL;
+}
+
+static void stringtable_insert(ktap_str_t *ts)
+{
+	strtab[strtab_nr++] = ts;
+
+	if (strtab_nr == strtab_size) {
+		int size = strtab_size * sizeof(ktap_str_t *);
+		strtab = realloc(strtab, size * 2);
+		memset(strtab + strtab_size, 0, size);
+		strtab_size *= 2;
+	}
+}
+
+static ktap_str_t *createstrobj(const char *str, size_t l)
+{
+	ktap_str_t *ts;
+	size_t totalsize;  /* total size of TString object */
+
+	totalsize = sizeof(ktap_str_t) + ((l + 1) * sizeof(char));
+	ts = (ktap_str_t *)malloc(totalsize);
+	ts->gct = ~KTAP_TSTR;
+	ts->len = l;
+	ts->reserved = 0;
+	ts->extra = 0;
+	memcpy(ts + 1, str, l * sizeof(char));
+	((char *)(ts + 1))[l] = '\0';  /* ending 0 */
+	return ts;
+}
+
+ktap_str_t *kp_str_new(const char *str, size_t l)
+{
+	ktap_str_t *ts = stringtable_search(str, l);
+
+	if (ts)
+		return ts;
+
+	ts = createstrobj(str, l);
+	stringtable_insert(ts);
+	return ts;
+}
+
+ktap_str_t *kp_str_newz(const char *str)
+{
+	return kp_str_new(str, strlen(str));
+}
+
+/*
+ * todo: memory leak here
+ */
+char *kp_sprintf(const char *fmt, ...)
+{
+	char *msg = malloc(128);
+
+	va_list argp;
+	va_start(argp, fmt);
+	vsprintf(msg, fmt, argp);
+	va_end(argp);
+	return msg;
+}
+
+const char *kp_sprintfv(const char *fmt, va_list argp)
+{
+	char *msg = malloc(128);
+
+	vsprintf(msg, fmt, argp);
+	return msg;
+}
+
+int kp_obj_equal(const ktap_val_t *t1, const ktap_val_t *t2)
+{
+	switch (itype(t1)) {
+	case KTAP_TNIL:
+		return 1;
+	case KTAP_TNUM:
+		return nvalue(t1) == nvalue(t2);
+	case KTAP_TTRUE:
+	case KTAP_TFALSE:
+		return itype(t1) == itype(t2);
+	case KTAP_TLIGHTUD:
+		return pvalue(t1) == pvalue(t2);
+	case KTAP_TFUNC:
+		return fvalue(t1) == fvalue(t2);
+	case KTAP_TSTR:
+		return rawtsvalue(t1) == rawtsvalue(t2);
+	default:
+		return gcvalue(t1) == gcvalue(t2);
+	}
+
+	return 0;
+}
+
+/*
+ * strglobmatch is copyed from perf(linux/tools/perf/util/string.c)
+ */
+
+/* Character class matching */
+static bool __match_charclass(const char *pat, char c, const char **npat)
+{
+	bool complement = false, ret = true;
+
+	if (*pat == '!') {
+		complement = true;
+		pat++;
+	}
+	if (*pat++ == c)	/* First character is special */
+		goto end;
+
+	while (*pat && *pat != ']') {	/* Matching */
+		if (*pat == '-' && *(pat + 1) != ']') {	/* Range */
+			if (*(pat - 1) <= c && c <= *(pat + 1))
+				goto end;
+			if (*(pat - 1) > *(pat + 1))
+				goto error;
+			pat += 2;
+		} else if (*pat++ == c)
+			goto end;
+	}
+	if (!*pat)
+		goto error;
+	ret = false;
+
+end:
+	while (*pat && *pat != ']')	/* Searching closing */
+		pat++;
+	if (!*pat)
+		goto error;
+	*npat = pat + 1;
+	return complement ? !ret : ret;
+
+error:
+	return false;
+}
+
+/* Glob/lazy pattern matching */
+static bool __match_glob(const char *str, const char *pat, bool ignore_space)
+{
+	while (*str && *pat && *pat != '*') {
+		if (ignore_space) {
+			/* Ignore spaces for lazy matching */
+			if (isspace(*str)) {
+				str++;
+				continue;
+			}
+			if (isspace(*pat)) {
+				pat++;
+				continue;
+			}
+		}
+		if (*pat == '?') {	/* Matches any single character */
+			str++;
+			pat++;
+			continue;
+		} else if (*pat == '[')	/* Character classes/Ranges */
+			if (__match_charclass(pat + 1, *str, &pat)) {
+				str++;
+				continue;
+			} else
+				return false;
+		else if (*pat == '\\') /* Escaped char match as normal char */
+			pat++;
+		if (*str++ != *pat++)
+			return false;
+	}
+	/* Check wild card */
+	if (*pat == '*') {
+		while (*pat == '*')
+			pat++;
+		if (!*pat)	/* Tail wild card matches all */
+			return true;
+		while (*str)
+			if (__match_glob(str++, pat, ignore_space))
+				return true;
+	}
+	return !*str && !*pat;
+}
+
+/**
+ * strglobmatch - glob expression pattern matching
+ * @str: the target string to match
+ * @pat: the pattern string to match
+ *
+ * This returns true if the @str matches @pat. @pat can includes wildcards
+ * ('*','?') and character classes ([CHARS], complementation and ranges are
+ * also supported). Also, this supports escape character ('\') to use special
+ * characters as normal character.
+ *
+ * Note: if @pat syntax is broken, this always returns false.
+ */
+bool strglobmatch(const char *str, const char *pat)
+{
+	return __match_glob(str, pat, false);
+}
+
+#define handle_error(str) do { perror(str); exit(-1); } while(0)
+
+#define KALLSYMS_PATH "/proc/kallsyms"
+/*
+ * read kernel symbol from /proc/kallsyms
+ */
+int kallsyms_parse(void *arg,
+		   int(*process_symbol)(void *arg, const char *name,
+		   char type, unsigned long start))
+{
+	FILE *file;
+	char *line = NULL;
+	int ret = 0;
+	int found = 0;
+
+	file = fopen(KALLSYMS_PATH, "r");
+	if (file == NULL)
+		handle_error("open " KALLSYMS_PATH " failed");
+
+	while (!feof(file)) {
+		char *symbol_addr, *symbol_name;
+		char symbol_type;
+		unsigned long start;
+		int line_len;
+		size_t n;
+
+		line_len = getline(&line, &n, file);
+		if (line_len < 0 || !line)
+			break;
+
+		line[--line_len] = '\0'; /* \n */
+
+		symbol_addr = strtok(line, " \t");
+		start = strtoul(symbol_addr, NULL, 16);
+
+		symbol_type = *strtok(NULL, " \t");
+		symbol_name = strtok(NULL, " \t");
+
+		ret = process_symbol(arg, symbol_name, symbol_type, start);
+		if (!ret)
+			found = 1;
+	}
+
+	free(line);
+	fclose(file);
+
+	return found;
+}
+
+struct ksym_addr_t {
+	const char *name;
+	unsigned long addr;
+};
+
+static int symbol_cmp(void *arg, const char *name, char type,
+		      unsigned long start)
+{
+	struct ksym_addr_t *base = arg;
+
+	if (strcmp(base->name, name) == 0) {
+		base->addr = start;
+		return 1;
+	}
+
+	return 0;
+}
+
+unsigned long find_kernel_symbol(const char *symbol)
+{
+	int ret;
+	struct ksym_addr_t arg = {
+		.name = symbol,
+		.addr = 0
+	};
+
+	ret = kallsyms_parse(&arg, symbol_cmp);
+	if (ret < 0 || arg.addr == 0) {
+		fprintf(stderr, "cannot read kernel symbol \"%s\" in %s\n",
+			symbol, KALLSYMS_PATH);
+		exit(EXIT_FAILURE);
+	}
+
+	return arg.addr;
+}
+
+
+#define AVAILABLE_EVENTS_PATH "/sys/kernel/debug/tracing/available_events"
+
+void list_available_events(const char *match)
+{
+	FILE *file;
+	char *line = NULL;
+
+	file = fopen(AVAILABLE_EVENTS_PATH, "r");
+	if (file == NULL)
+		handle_error("open " AVAILABLE_EVENTS_PATH " failed");
+
+	while (!feof(file)) {
+		int line_len;
+		size_t n;
+
+		line_len = getline(&line, &n, file);
+		if (line_len < 0 || !line)
+			break;
+
+		if (!match || strglobmatch(line, match))
+			printf("%s", line);
+	}
+
+	free(line);
+	fclose(file);
+}
+
+void process_available_tracepoints(const char *sys, const char *event,
+				   int (*process)(const char *sys,
+						  const char *event))
+{
+	char *line = NULL;
+	FILE *file;
+	char str[128] = {0};
+
+	/* add '\n' into tail */
+	snprintf(str, 64, "%s:%s\n", sys, event);
+
+	file = fopen(AVAILABLE_EVENTS_PATH, "r");
+	if (file == NULL)
+		handle_error("open " AVAILABLE_EVENTS_PATH " failed");
+
+	while (!feof(file)) {
+		int line_len;
+		size_t n;
+
+		line_len = getline(&line, &n, file);
+		if (line_len < 0 || !line)
+			break;
+
+		if (strglobmatch(line, str)) {
+			char match_sys[64] = {0};
+			char match_event[64] = {0};
+			char *sep;
+
+			sep = strchr(line, ':');
+			memcpy(match_sys, line, sep - line);
+			memcpy(match_event, sep + 1,
+					    line_len - (sep - line) - 2);
+
+			if (process(match_sys, match_event))
+				break;
+		}
+	}
+
+	free(line);
+	fclose(file);
+}
+
diff --git a/tools/ktap/userspace/kp_util.h b/tools/ktap/userspace/kp_util.h
new file mode 100644
index 0000000..e15f89e
--- /dev/null
+++ b/tools/ktap/userspace/kp_util.h
@@ -0,0 +1,120 @@
+#ifndef __KTAP_UTIL_H__
+#define __KTAP_UTIL_H__
+
+#include "../include/ktap_bc.h"
+#include "../include/ktap_err.h"
+
+typedef int bool;
+#define false 0
+#define true 1
+
+/* Resizable string buffer. */
+typedef struct SBuf {
+	char *p; /* String buffer pointer. */
+	char *e; /* String buffer end pointer. */
+	char *b; /* String buffer base. */
+} SBuf;
+
+/* Resizable string buffers. Struct definition in kp_obj.h. */
+#define sbufB(sb)	((char *)(sb)->b)
+#define sbufP(sb)	((char *)(sb)->p)
+#define sbufE(sb)	((char *)(sb)->e)
+#define sbufsz(sb)	((int)(sbufE((sb)) - sbufB((sb))))
+#define sbuflen(sb)	((int)(sbufP((sb)) - sbufB((sb))))
+#define sbufleft(sb)	((int)(sbufE((sb)) - sbufP((sb))))
+#define setsbufP(sb, q) ((sb)->p = (q))
+
+void kp_buf_init(SBuf *sb);
+void kp_buf_reset(SBuf *sb);
+void kp_buf_free(SBuf *sb);
+char *kp_buf_more(SBuf *sb, int sz);
+char *kp_buf_need(SBuf *sb, int sz);
+char *kp_buf_wmem(char *p, const void *q, int len);
+void kp_buf_putb(SBuf *sb, int c);
+ktap_str_t *kp_buf_str(SBuf *sb);
+
+
+#define KP_CHAR_CNTRL	0x01
+#define KP_CHAR_SPACE	0x02
+#define KP_CHAR_PUNCT	0x04
+#define KP_CHAR_DIGIT	0x08
+#define KP_CHAR_XDIGIT	0x10
+#define KP_CHAR_UPPER	0x20
+#define KP_CHAR_LOWER	0x40
+#define KP_CHAR_IDENT	0x80
+#define KP_CHAR_ALPHA	(KP_CHAR_LOWER|KP_CHAR_UPPER)
+#define KP_CHAR_ALNUM	(KP_CHAR_ALPHA|KP_CHAR_DIGIT)
+#define KP_CHAR_GRAPH	(KP_CHAR_ALNUM|KP_CHAR_PUNCT)
+
+/* Only pass -1 or 0..255 to these macros. Never pass a signed char! */
+#define kp_char_isa(c, t)	((kp_char_bits+1)[(c)] & t)
+#define kp_char_iscntrl(c)	kp_char_isa((c), KP_CHAR_CNTRL)
+#define kp_char_isspace(c)	kp_char_isa((c), KP_CHAR_SPACE)
+#define kp_char_ispunct(c)	kp_char_isa((c), KP_CHAR_PUNCT)
+#define kp_char_isdigit(c)	kp_char_isa((c), KP_CHAR_DIGIT)
+#define kp_char_isxdigit(c)	kp_char_isa((c), KP_CHAR_XDIGIT)
+#define kp_char_isupper(c)	kp_char_isa((c), KP_CHAR_UPPER)
+#define kp_char_islower(c)	kp_char_isa((c), KP_CHAR_LOWER)
+#define kp_char_isident(c)	kp_char_isa((c), KP_CHAR_IDENT)
+#define kp_char_isalpha(c)	kp_char_isa((c), KP_CHAR_ALPHA)
+#define kp_char_isalnum(c)	kp_char_isa((c), KP_CHAR_ALNUM)
+#define kp_char_isgraph(c)	kp_char_isa((c), KP_CHAR_GRAPH)
+
+#define kp_char_toupper(c)	((c) - (kp_char_islower(c) >> 1))
+#define kp_char_tolower(c)	((c) + kp_char_isupper(c))
+
+extern const char *kp_err_allmsg;
+#define err2msg(em)     (kp_err_allmsg+(int)(em))
+
+extern const uint8_t kp_char_bits[257];
+
+
+char *strfmt_wuleb128(char *p, uint32_t v);
+void kp_err_lex(ktap_str_t *src, const char *tok, BCLine line,
+		ErrMsg em, va_list argp);
+char *kp_sprintf(const char *fmt, ...);
+const char *kp_sprintfv(const char *fmt, va_list argp);
+
+void *kp_reallocv(void *block, size_t osize, size_t nsize);
+
+void kp_str_resize(void);
+ktap_str_t *kp_str_newz(const char *str);
+ktap_str_t *kp_str_new(const char *str, size_t l);
+
+ktap_tab_t *kp_tab_new();
+const ktap_val_t *kp_tab_get(ktap_tab_t *t, const ktap_val_t *key);
+const ktap_val_t *kp_tab_getstr(ktap_tab_t *t, const ktap_str_t *ts);
+void kp_tab_setvalue(ktap_tab_t *t, const ktap_val_t *key, ktap_val_t *val);
+ktap_val_t *kp_tab_set(ktap_tab_t *t, const ktap_val_t *key);
+
+int kp_obj_equal(const ktap_val_t *t1, const ktap_val_t *t2);
+
+bool strglobmatch(const char *str, const char *pat);
+int kallsyms_parse(void *arg,
+		   int(*process_symbol)(void *arg, const char *name,
+		   char type, unsigned long start));
+
+unsigned long find_kernel_symbol(const char *symbol);
+void list_available_events(const char *match);
+void process_available_tracepoints(const char *sys, const char *event,
+				   int (*process)(const char *sys,
+						  const char *event));
+int kallsyms_parse(void *arg,
+                   int(*process_symbol)(void *arg, const char *name,
+                   char type, unsigned long start));
+
+ktap_eventdesc_t *kp_parse_events(const char *eventdef);
+void cleanup_event_resources(void);
+
+extern int verbose;
+#define verbose_printf(...) \
+	if (verbose)	\
+		printf("[verbose] " __VA_ARGS__);
+
+
+void kp_dump_proto(ktap_proto_t *pt);
+typedef int (*ktap_writer)(const void* p, size_t sz, void* ud);
+int kp_bcwrite(ktap_proto_t *pt, ktap_writer writer, void *data, int strip);
+
+int kp_create_reader(const char *output);
+#endif
-- 
1.8.1.4

