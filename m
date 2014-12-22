Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353AbaLVPa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 10:30:58 -0500
Received: from mail.kernel.org ([198.145.19.201]:54104 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842AbaLVPa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 10:30:56 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/10] perf tools: Remove some unused functions from color.c
Date: Mon, 22 Dec 2014 12:30:09 -0300
Message-Id: <1419262209-9464-11-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1419262209-9464-1-git-send-email-acme@kernel.org>
References: <1419262209-9464-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Removes some functions that are not used anywhere:

 color_parse_mem()
 color_parse()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ramkumar Ramachandra <artagnon@gmail.com>
Link: http://lkml.kernel.org/r/1419079865-354-1-git-send-email-rickard_strandqvist@spectrumdigital.se
[ Remove now unused parse_{attr,color} routines too ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/color.c | 126 ------------------------------------------------
 tools/perf/util/color.h |   2 -
 2 files changed, 128 deletions(-)

diff --git a/tools/perf/util/color.c b/tools/perf/util/color.c
index f4654183d391..55355b3d4f85 100644
--- a/tools/perf/util/color.c
+++ b/tools/perf/util/color.c
@@ -5,132 +5,6 @@
 
 int perf_use_color_default = -1;
 
-static int parse_color(const char *name, int len)
-{
-	static const char * const color_names[] = {
-		"normal", "black", "red", "green", "yellow",
-		"blue", "magenta", "cyan", "white"
-	};
-	char *end;
-	int i;
-
-	for (i = 0; i < (int)ARRAY_SIZE(color_names); i++) {
-		const char *str = color_names[i];
-		if (!strncasecmp(name, str, len) && !str[len])
-			return i - 1;
-	}
-	i = strtol(name, &end, 10);
-	if (end - name == len && i >= -1 && i <= 255)
-		return i;
-	return -2;
-}
-
-static int parse_attr(const char *name, int len)
-{
-	static const int attr_values[] = { 1, 2, 4, 5, 7 };
-	static const char * const attr_names[] = {
-		"bold", "dim", "ul", "blink", "reverse"
-	};
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(attr_names); i++) {
-		const char *str = attr_names[i];
-		if (!strncasecmp(name, str, len) && !str[len])
-			return attr_values[i];
-	}
-	return -1;
-}
-
-void color_parse(const char *value, const char *var, char *dst)
-{
-	color_parse_mem(value, strlen(value), var, dst);
-}
-
-void color_parse_mem(const char *value, int value_len, const char *var,
-		char *dst)
-{
-	const char *ptr = value;
-	int len = value_len;
-	int attr = -1;
-	int fg = -2;
-	int bg = -2;
-
-	if (!strncasecmp(value, "reset", len)) {
-		strcpy(dst, PERF_COLOR_RESET);
-		return;
-	}
-
-	/* [fg [bg]] [attr] */
-	while (len > 0) {
-		const char *word = ptr;
-		int val, wordlen = 0;
-
-		while (len > 0 && !isspace(word[wordlen])) {
-			wordlen++;
-			len--;
-		}
-
-		ptr = word + wordlen;
-		while (len > 0 && isspace(*ptr)) {
-			ptr++;
-			len--;
-		}
-
-		val = parse_color(word, wordlen);
-		if (val >= -1) {
-			if (fg == -2) {
-				fg = val;
-				continue;
-			}
-			if (bg == -2) {
-				bg = val;
-				continue;
-			}
-			goto bad;
-		}
-		val = parse_attr(word, wordlen);
-		if (val < 0 || attr != -1)
-			goto bad;
-		attr = val;
-	}
-
-	if (attr >= 0 || fg >= 0 || bg >= 0) {
-		int sep = 0;
-
-		*dst++ = '\033';
-		*dst++ = '[';
-		if (attr >= 0) {
-			*dst++ = '0' + attr;
-			sep++;
-		}
-		if (fg >= 0) {
-			if (sep++)
-				*dst++ = ';';
-			if (fg < 8) {
-				*dst++ = '3';
-				*dst++ = '0' + fg;
-			} else {
-				dst += sprintf(dst, "38;5;%d", fg);
-			}
-		}
-		if (bg >= 0) {
-			if (sep++)
-				*dst++ = ';';
-			if (bg < 8) {
-				*dst++ = '4';
-				*dst++ = '0' + bg;
-			} else {
-				dst += sprintf(dst, "48;5;%d", bg);
-			}
-		}
-		*dst++ = 'm';
-	}
-	*dst = 0;
-	return;
-bad:
-	die("bad color value '%.*s' for variable '%s'", value_len, value, var);
-}
-
 int perf_config_colorbool(const char *var, const char *value, int stdout_is_tty)
 {
 	if (value) {
diff --git a/tools/perf/util/color.h b/tools/perf/util/color.h
index 0a594b8a0c26..38146f922c54 100644
--- a/tools/perf/util/color.h
+++ b/tools/perf/util/color.h
@@ -30,8 +30,6 @@ extern int perf_use_color_default;
 int perf_color_default_config(const char *var, const char *value, void *cb);
 
 int perf_config_colorbool(const char *var, const char *value, int stdout_is_tty);
-void color_parse(const char *value, const char *var, char *dst);
-void color_parse_mem(const char *value, int len, const char *var, char *dst);
 int color_vsnprintf(char *bf, size_t size, const char *color,
 		    const char *fmt, va_list args);
 int color_vfprintf(FILE *fp, const char *color, const char *fmt, va_list args);
-- 
1.9.3

