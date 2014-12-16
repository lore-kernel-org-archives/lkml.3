Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332AbaLPUpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 15:45:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaLPUpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 15:45:09 -0500
Date: Tue, 16 Dec 2014 18:44:49 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, jolsa@redhat.com, dsahern@gmail.com,
        dzickus@redhat.com, namhyung@kernel.org, jmario@redhat.com,
        rfowles@redhat.com
Subject: Re: [PATCH] perf mem: enable simultaneous sampling of loads/stores
Message-ID: <20141216204449.GA9327@redhat.com>
References: <20141216165358.GA9310@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141216165358.GA9310@thinkpad>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Dec 16, 2014 at 05:53:58PM +0100, Stephane Eranian escreveu:
> 
> This patch modifies perf mem to default to sampling loads
> and stores simultaneously. It could only do one or the other
> before yet there was not hardware restriction preventing
> simultaneous collection. With this patch, one run is sufficient
> to collect both.
> 
> By default load/stores are sampled now:
> $ perf mem rec
> $ perf mem rep
> 
> It is still possible to sample only loads or stores by using the
> -t option:
>  $ perf mem -t load rec
>  $ perf mem -t load rep
> Or
>  $ perf mem -t store rec
>  $ perf mem -t store rep
> 
> The perf report TUI will show one event at a time. The store
> output will contain a Weight column which will be empty.

Can you please update the man page and resubmit?

Are those unchecked strdups really needed?

- Arnaldo
 
> Signed-off-by: Stephane Eranian <eranian@google.com>
> ---
>  tools/perf/builtin-mem.c | 107 ++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 92 insertions(+), 15 deletions(-)
> 
> diff --git a/tools/perf/builtin-mem.c b/tools/perf/builtin-mem.c
> index 24db6ff..52dbaae 100644
> --- a/tools/perf/builtin-mem.c
> +++ b/tools/perf/builtin-mem.c
> @@ -7,10 +7,13 @@
>  #include "util/session.h"
>  #include "util/data.h"
>  
> -#define MEM_OPERATION_LOAD	"load"
> -#define MEM_OPERATION_STORE	"store"
> +#define MEM_OPERATION_LOAD	0x1
> +#define MEM_OPERATION_STORE	0x2
>  
> -static const char	*mem_operation		= MEM_OPERATION_LOAD;
> +/*
> + * default to both load an store sampling
> + */
> +static int mem_operation = MEM_OPERATION_LOAD | MEM_OPERATION_STORE;
>  
>  struct perf_mem {
>  	struct perf_tool	tool;
> @@ -25,26 +28,30 @@ static int __cmd_record(int argc, const char **argv)
>  {
>  	int rec_argc, i = 0, j;
>  	const char **rec_argv;
> -	char event[64];
>  	int ret;
>  
> -	rec_argc = argc + 4;
> +	rec_argc = argc + 7; /* max number of arguments */
>  	rec_argv = calloc(rec_argc + 1, sizeof(char *));
>  	if (!rec_argv)
>  		return -1;
>  
>  	rec_argv[i++] = strdup("record");
> -	if (!strcmp(mem_operation, MEM_OPERATION_LOAD))
> +
> +	if (mem_operation & MEM_OPERATION_LOAD)
>  		rec_argv[i++] = strdup("-W");
> +
>  	rec_argv[i++] = strdup("-d");
> -	rec_argv[i++] = strdup("-e");
>  
> -	if (strcmp(mem_operation, MEM_OPERATION_LOAD))
> -		sprintf(event, "cpu/mem-stores/pp");
> -	else
> -		sprintf(event, "cpu/mem-loads/pp");
> +	if (mem_operation & MEM_OPERATION_LOAD) {
> +		rec_argv[i++] = strdup("-e");
> +		rec_argv[i++] = strdup("cpu/mem-loads/pp");
> +	}
> +
> +	if (mem_operation & MEM_OPERATION_STORE) {
> +		rec_argv[i++] = strdup("-e");
> +		rec_argv[i++] = strdup("cpu/mem-stores/pp");
> +	}
>  
> -	rec_argv[i++] = strdup(event);
>  	for (j = 1; j < argc; j++, i++)
>  		rec_argv[i] = argv[j];
>  
> @@ -170,7 +177,7 @@ static int report_events(int argc, const char **argv, struct perf_mem *mem)
>  	 * there is no weight (cost) associated with stores, so don't print
>  	 * the column
>  	 */
> -	if (strcmp(mem_operation, MEM_OPERATION_LOAD))
> +	if (!(mem_operation & MEM_OPERATION_LOAD))
>  		rep_argv[i++] = strdup("--sort=mem,sym,dso,symbol_daddr,"
>  				       "dso_daddr,tlb,locked");
>  
> @@ -182,6 +189,75 @@ static int report_events(int argc, const char **argv, struct perf_mem *mem)
>  	return ret;
>  }
>  
> +struct mem_mode {
> +	const char *name;
> +	int mode;
> +};
> +
> +#define MEM_OPT(n, m) \
> +	{ .name = n, .mode = (m) }
> +
> +#define MEM_END { .name = NULL }
> +
> +static const struct mem_mode mem_modes[]={
> +	MEM_OPT("load", MEM_OPERATION_LOAD),
> +	MEM_OPT("store", MEM_OPERATION_STORE),
> +	MEM_END
> +};
> +
> +static int
> +parse_mem_ops(const struct option *opt, const char *str, int unset)
> +{
> +	int *mode = (int *)opt->value;
> +	const struct mem_mode *m;
> +	char *s, *os = NULL, *p;
> +	int ret = -1;
> +
> +	if (unset)
> +		return 0;
> +
> +	/* str may be NULL in case no arg is passed to -t */
> +	if (str) {
> +		/* because str is read-only */
> +		s = os = strdup(str);
> +		if (!s)
> +			return -1;
> +
> +		/* reset mode */
> +		*mode = 0;
> +
> +		for (;;) {
> +			p = strchr(s, ',');
> +			if (p)
> +				*p = '\0';
> +
> +			for (m = mem_modes; m->name; m++) {
> +				if (!strcasecmp(s, m->name))
> +					break;
> +			}
> +			if (!m->name) {
> +				fprintf(stderr, "unknown sampling op %s,"
> +					    " check man page\n", s);
> +				goto error;
> +			}
> +
> +			*mode |= m->mode;
> +
> +			if (!p)
> +				break;
> +
> +			s = p + 1;
> +		}
> +	}
> +	ret = 0;
> +
> +	if (*mode == 0)
> +		*mode = MEM_OPERATION_LOAD;
> +error:
> +	free(os);
> +	return ret;
> +}
> +
>  int cmd_mem(int argc, const char **argv, const char *prefix __maybe_unused)
>  {
>  	struct stat st;
> @@ -199,8 +275,9 @@ int cmd_mem(int argc, const char **argv, const char *prefix __maybe_unused)
>  		.input_name		 = "perf.data",
>  	};
>  	const struct option mem_options[] = {
> -	OPT_STRING('t', "type", &mem_operation,
> -		   "type", "memory operations(load/store)"),
> +	OPT_CALLBACK('t', "type", &mem_operation,
> +		   "type", "memory operations(load,store) Default load,store",
> +		    parse_mem_ops),
>  	OPT_BOOLEAN('D', "dump-raw-samples", &mem.dump_raw,
>  		    "dump raw samples in ASCII"),
>  	OPT_BOOLEAN('U', "hide-unresolved", &mem.hide_unresolved,
> -- 
> 1.9.1
