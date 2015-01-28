Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761140AbbA1UuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:50:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964984AbbA1UuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:50:13 -0500
Date: Wed, 28 Jan 2015 07:05:01 -0800
From: tip-bot for Rickard Strandqvist <tipbot@zytor.com>
Message-ID: <tip-c8defe249460b6fa3103797273f590372cc62efc@git.kernel.org>
Cc: a.p.zijlstra@chello.nl, namhyung@kernel.org, acme@redhat.com,
        mingo@redhat.com, artagnon@gmail.com, jolsa@redhat.com,
        linux-kernel@vger.kernel.org, paulus@samba.org, tglx@linutronix.de,
        rickard_strandqvist@spectrumdigital.se, mingo@kernel.org,
        hpa@zytor.com
Reply-To: mingo@kernel.org, hpa@zytor.com,
        rickard_strandqvist@spectrumdigital.se, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, paulus@samba.org, jolsa@redhat.com,
        artagnon@gmail.com, acme@redhat.com, mingo@redhat.com,
        namhyung@kernel.org, a.p.zijlstra@chello.nl
In-Reply-To: <1419079865-354-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1419079865-354-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Remove some unused functions from color.c
Git-Commit-ID: c8defe249460b6fa3103797273f590372cc62efc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c8defe249460b6fa3103797273f590372cc62efc
Gitweb:     http://git.kernel.org/tip/c8defe249460b6fa3103797273f590372cc62efc
Author:     Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
AuthorDate: Sat, 20 Dec 2014 13:51:05 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 21 Jan 2015 13:24:32 -0300

perf tools: Remove some unused functions from color.c

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
index f465418..55355b3 100644
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
