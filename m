Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbaLVOuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 09:50:19 -0500
Received: from mail.kernel.org ([198.145.19.201]:52322 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755090AbaLVOuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 09:50:17 -0500
Date: Mon, 22 Dec 2014 11:50:13 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Ramkumar Ramachandra <artagnon@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools: perf: util: color.c:  Remove some unused functions
Message-ID: <20141222145013.GB7644@kernel.org>
References: <1419079865-354-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419079865-354-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Dec 20, 2014 at 01:51:05PM +0100, Rickard Strandqvist escreveu:
> Removes some functions that are not used anywhere:
> color_parse_mem() color_parse()
> 
> This was partially found by using a static code analysis program called cppcheck.

Thanks, applied.
 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  tools/perf/util/color.c |   90 -----------------------------------------------
>  tools/perf/util/color.h |    2 --
>  2 files changed, 92 deletions(-)
> 
> diff --git a/tools/perf/util/color.c b/tools/perf/util/color.c
> index f465418..b5f1579 100644
> --- a/tools/perf/util/color.c
> +++ b/tools/perf/util/color.c
> @@ -41,96 +41,6 @@ static int parse_attr(const char *name, int len)
>  	return -1;
>  }
>  
> -void color_parse(const char *value, const char *var, char *dst)
> -{
> -	color_parse_mem(value, strlen(value), var, dst);
> -}
> -
> -void color_parse_mem(const char *value, int value_len, const char *var,
> -		char *dst)
> -{
> -	const char *ptr = value;
> -	int len = value_len;
> -	int attr = -1;
> -	int fg = -2;
> -	int bg = -2;
> -
> -	if (!strncasecmp(value, "reset", len)) {
> -		strcpy(dst, PERF_COLOR_RESET);
> -		return;
> -	}
> -
> -	/* [fg [bg]] [attr] */
> -	while (len > 0) {
> -		const char *word = ptr;
> -		int val, wordlen = 0;
> -
> -		while (len > 0 && !isspace(word[wordlen])) {
> -			wordlen++;
> -			len--;
> -		}
> -
> -		ptr = word + wordlen;
> -		while (len > 0 && isspace(*ptr)) {
> -			ptr++;
> -			len--;
> -		}
> -
> -		val = parse_color(word, wordlen);
> -		if (val >= -1) {
> -			if (fg == -2) {
> -				fg = val;
> -				continue;
> -			}
> -			if (bg == -2) {
> -				bg = val;
> -				continue;
> -			}
> -			goto bad;
> -		}
> -		val = parse_attr(word, wordlen);
> -		if (val < 0 || attr != -1)
> -			goto bad;
> -		attr = val;
> -	}
> -
> -	if (attr >= 0 || fg >= 0 || bg >= 0) {
> -		int sep = 0;
> -
> -		*dst++ = '\033';
> -		*dst++ = '[';
> -		if (attr >= 0) {
> -			*dst++ = '0' + attr;
> -			sep++;
> -		}
> -		if (fg >= 0) {
> -			if (sep++)
> -				*dst++ = ';';
> -			if (fg < 8) {
> -				*dst++ = '3';
> -				*dst++ = '0' + fg;
> -			} else {
> -				dst += sprintf(dst, "38;5;%d", fg);
> -			}
> -		}
> -		if (bg >= 0) {
> -			if (sep++)
> -				*dst++ = ';';
> -			if (bg < 8) {
> -				*dst++ = '4';
> -				*dst++ = '0' + bg;
> -			} else {
> -				dst += sprintf(dst, "48;5;%d", bg);
> -			}
> -		}
> -		*dst++ = 'm';
> -	}
> -	*dst = 0;
> -	return;
> -bad:
> -	die("bad color value '%.*s' for variable '%s'", value_len, value, var);
> -}
> -
>  int perf_config_colorbool(const char *var, const char *value, int stdout_is_tty)
>  {
>  	if (value) {
> diff --git a/tools/perf/util/color.h b/tools/perf/util/color.h
> index 0a594b8..38146f9 100644
> --- a/tools/perf/util/color.h
> +++ b/tools/perf/util/color.h
> @@ -30,8 +30,6 @@ extern int perf_use_color_default;
>  int perf_color_default_config(const char *var, const char *value, void *cb);
>  
>  int perf_config_colorbool(const char *var, const char *value, int stdout_is_tty);
> -void color_parse(const char *value, const char *var, char *dst);
> -void color_parse_mem(const char *value, int len, const char *var, char *dst);
>  int color_vsnprintf(char *bf, size_t size, const char *color,
>  		    const char *fmt, va_list args);
>  int color_vfprintf(FILE *fp, const char *color, const char *fmt, va_list args);
> -- 
> 1.7.10.4
