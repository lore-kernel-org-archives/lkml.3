Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3LZOvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 09:51:06 -0500
Received: from mail-qe0-f44.google.com ([209.85.128.44]:55156 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145Ab3LZOu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 09:50:59 -0500
Date: Thu, 26 Dec 2013 11:50:51 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 4/8] perf tools: Introduce struct perf_log
Message-ID: <20131226145051.GG30980@ghostprotocols.net>
References: <1388036284-32342-1-git-send-email-namhyung@kernel.org>
 <1388036284-32342-5-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388036284-32342-5-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 26, 2013 at 02:38:00PM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Add new functions to save error messages in a temp file.  It'll be
> used by some UI front-ends to see the messages.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/Makefile.perf |   1 +
>  tools/perf/perf.c        |   3 ++
>  tools/perf/util/debug.h  |  15 +++++++
>  tools/perf/util/log.c    | 105 +++++++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 124 insertions(+)
>  create mode 100644 tools/perf/util/log.c
> 
> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> index 3638b0bd20dc..49c5c998009e 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -372,6 +372,7 @@ LIB_OBJS += $(OUTPUT)util/stat.o
>  LIB_OBJS += $(OUTPUT)util/record.o
>  LIB_OBJS += $(OUTPUT)util/srcline.o
>  LIB_OBJS += $(OUTPUT)util/data.o
> +LIB_OBJS += $(OUTPUT)util/log.o
>  
>  LIB_OBJS += $(OUTPUT)ui/setup.o
>  LIB_OBJS += $(OUTPUT)ui/helpline.o
> diff --git a/tools/perf/perf.c b/tools/perf/perf.c
> index 431798a4110d..bdf7bd8e4394 100644
> --- a/tools/perf/perf.c
> +++ b/tools/perf/perf.c
> @@ -10,6 +10,7 @@
>  
>  #include "util/exec_cmd.h"
>  #include "util/cache.h"
> +#include "util/debug.h"
>  #include "util/quote.h"
>  #include "util/run-command.h"
>  #include "util/parse-events.h"
> @@ -524,6 +525,7 @@ int main(int argc, const char **argv)
>  	 */
>  	pthread__block_sigwinch();
>  
> +	perf_log_init();
>  	while (1) {
>  		static int done_help;
>  		int was_alias = run_argv(&argc, &argv);
> @@ -543,6 +545,7 @@ int main(int argc, const char **argv)
>  		} else
>  			break;
>  	}
> +	perf_log_exit();
>  
>  	fprintf(stderr, "Failed to run command '%s': %s\n",
>  		cmd, strerror(errno));
> diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
> index 443694c36b03..ea160abc2ae0 100644
> --- a/tools/perf/util/debug.h
> +++ b/tools/perf/util/debug.h
> @@ -19,4 +19,19 @@ int ui__warning(const char *format, ...) __attribute__((format(printf, 1, 2)));
>  
>  void pr_stat(const char *fmt, ...);
>  
> +struct perf_log {
> +	FILE *fp;
> +	off_t *linemap;
> +	u32 lines;
> +	u32 nr_alloc;
> +	bool seen_newline;
> +};
> +
> +extern struct perf_log perf_log;
> +
> +int perf_log_init(void);
> +int perf_log_exit(void);
> +void perf_log_add(const char *msg);
> +void perf_log_addv(const char *fmt, va_list ap);

The convention in tools/perf/ has been to use class__method, i.e. in the
above case we would have:

int perf_log__init(void);
int perf_log__exit(void);
void perf_log__add(const char *msg);
void perf_log__addv(const char *fmt, va_list ap);


But I have some questions about the implementation, will we go on
allocating memory for each and every line?

Can't we just come out with a simple ui_file_browser class that would
then be usable for any file, including this one?

The ui_file_browser__seek() method would have to go on reading lines and
seeking newlines, with the ui_file_browser__seek(browser, 0, SEEK_SET)
would map directly to fseek(log_fp, 0, SEEK_SET), etc.

It should handle "live" files, like the one we're feeding log lines,
etc.

The way you implemented it will grow memory consumption without limits, no?

- Arnaldo

>  #endif	/* __PERF_DEBUG_H */
> diff --git a/tools/perf/util/log.c b/tools/perf/util/log.c
> new file mode 100644
> index 000000000000..3838d49f82de
> --- /dev/null
> +++ b/tools/perf/util/log.c
> @@ -0,0 +1,105 @@
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include "util/debug.h"
> +
> +#define LINEMAP_GROW  128
> +
> +struct perf_log perf_log = {
> +	.seen_newline = true,
> +};
> +
> +int perf_log_init(void)
> +{
> +	FILE *fp;
> +	char name[] = "/tmp/perf-log-XXXXXX";
> +	int fd = mkstemp(name);
> +
> +	if (fd < 0)
> +		return -1;
> +
> +	fp = fdopen(fd, "r+");
> +	if (fp == NULL) {
> +		close(fd);
> +		return -1;
> +	}
> +
> +	perf_log.fp = fp;
> +
> +	return 0;
> +}
> +
> +int perf_log_exit(void)
> +{
> +	FILE *fp = perf_log.fp;
> +	if (fp)
> +		fclose(fp);
> +
> +	free(perf_log.linemap);
> +
> +	perf_log.fp = NULL;
> +	perf_log.linemap = NULL;
> +	return 0;
> +}
> +
> +static int grow_linemap(struct perf_log *log)
> +{
> +	off_t *newmap;
> +	int newsize = log->nr_alloc + LINEMAP_GROW;
> +
> +	newmap = realloc(log->linemap, newsize * sizeof(*log->linemap));
> +	if (newmap == NULL)
> +		return -1;
> +
> +	log->nr_alloc = newsize;
> +	log->linemap = newmap;
> +	return 0;
> +}
> +
> +static int __add_to_linemap(struct perf_log *log, off_t idx)
> +{
> +	if (log->lines == log->nr_alloc)
> +		if (grow_linemap(log) < 0)
> +			return -1;
> +
> +	log->linemap[log->lines++] = idx;
> +	return 0;
> +}
> +
> +static void add_to_linemap(struct perf_log *log, const char *msg, off_t base)
> +{
> +	const char *pos;
> +
> +	if (strlen(msg) == 0)
> +		return;
> +
> +	if (log->seen_newline) {
> +		if (__add_to_linemap(log, base) < 0)
> +			return;
> +	}
> +
> +	if ((pos = strchr(msg, '\n')) != NULL) {
> +		log->seen_newline = true;
> +		pos++;
> +		add_to_linemap(log, pos, base + (pos - msg));
> +	} else {
> +		log->seen_newline = false;
> +	}
> +}
> +
> +void perf_log_add(const char *msg)
> +{
> +	FILE *fp = perf_log.fp;
> +	off_t offset = ftello(fp);
> +
> +	add_to_linemap(&perf_log, msg, offset);
> +
> +	fwrite(msg, 1, strlen(msg), fp);
> +}
> +
> +void perf_log_addv(const char *fmt, va_list ap)
> +{
> +	char buf[4096];
> +
> +	vsnprintf(buf, sizeof(buf), fmt, ap);
> +	perf_log_add(buf);
> +}
> -- 
> 1.7.11.7
