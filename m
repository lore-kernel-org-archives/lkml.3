Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbaLTMsU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 07:48:20 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:59336 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbaLTMsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 07:48:18 -0500
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] tools: perf: util: color.c:  Remove some unused functions
Date: Sat, 20 Dec 2014 13:51:05 +0100
Message-Id: <1419079865-354-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes some functions that are not used anywhere:
color_parse_mem() color_parse()

This was partially found by using a static code analysis program called cppcheck.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 tools/perf/util/color.c |   90 -----------------------------------------------
 tools/perf/util/color.h |    2 --
 2 files changed, 92 deletions(-)

diff --git a/tools/perf/util/color.c b/tools/perf/util/color.c
index f465418..b5f1579 100644
--- a/tools/perf/util/color.c
+++ b/tools/perf/util/color.c
@@ -41,96 +41,6 @@ static int parse_attr(const char *name, int len)
 	return -1;
 }
 
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
index 0a594b8..38146f9 100644
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
1.7.10.4

