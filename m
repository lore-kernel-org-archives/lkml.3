Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab3EJMj4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 08:39:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9182 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498Ab3EJMjw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 08:39:52 -0400
Date: Fri, 10 May 2013 14:39:21 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: David Ahern <dsahern@gmail.com>
Cc: linux-kernel@vger.kernel.org, acme@ghostprotocols.net, mingo@kernel.org,
        fweisbec@gmail.com, peterz@infradead.org, namhyung@kernel.org,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH 07/13] perf kvm: split out tracepoints from record args
Message-ID: <20130510123921.GI1040@krava.brq.redhat.com>
References: <1368073909-8825-1-git-send-email-dsahern@gmail.com>
 <1368073909-8825-8-git-send-email-dsahern@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368073909-8825-8-git-send-email-dsahern@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 10:31:43PM -0600, David Ahern wrote:
> Needed by kvm live command. Make record_args a local while we are
> messing with the args.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> ---
>  tools/perf/builtin-kvm.c |   30 +++++++++++++++++++-----------
>  1 file changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
> index 24b78ae..7d14a3a 100644
> --- a/tools/perf/builtin-kvm.c
> +++ b/tools/perf/builtin-kvm.c
> @@ -801,16 +801,11 @@ exit:
>  	return ret;
>  }
>  
> -static const char * const record_args[] = {
> -	"record",
> -	"-R",
> -	"-f",
> -	"-m", "1024",
> -	"-c", "1",
> -	"-e", "kvm:kvm_entry",
> -	"-e", "kvm:kvm_exit",
> -	"-e", "kvm:kvm_mmio",
> -	"-e", "kvm:kvm_pio",
> +static const char * const kvm_events_tp[] = {
> +	"kvm:kvm_entry",
> +	"kvm:kvm_exit",
> +	"kvm:kvm_mmio",
> +	"kvm:kvm_pio",
>  };
>  
>  #define STRDUP_FAIL_EXIT(s)		\
> @@ -826,8 +821,16 @@ kvm_events_record(struct perf_kvm_stat *kvm, int argc, const char **argv)
>  {
>  	unsigned int rec_argc, i, j;
>  	const char **rec_argv;
> +	const char * const record_args[] = {
> +		"record",
> +		"-R",
> +		"-f",
> +		"-m", "1024",
> +		"-c", "1",
> +	};
>  
> -	rec_argc = ARRAY_SIZE(record_args) + argc + 2;
> +	rec_argc = ARRAY_SIZE(record_args) + argc + 2 +
> +		   2 * ARRAY_SIZE(kvm_events_tp);
>  	rec_argv = calloc(rec_argc + 1, sizeof(char *));
>  
>  	if (rec_argv == NULL)
> @@ -836,6 +839,11 @@ kvm_events_record(struct perf_kvm_stat *kvm, int argc, const char **argv)
>  	for (i = 0; i < ARRAY_SIZE(record_args); i++)
>  		rec_argv[i] = STRDUP_FAIL_EXIT(record_args[i]);
>  
> +	for (j = 0; j < ARRAY_SIZE(kvm_events_tp); j++) {
> +		rec_argv[i++] = "-e";
> +		rec_argv[i++] = STRDUP_FAIL_EXIT(kvm_events_tp[j]);
> +	}
> +

just curious.. I dont understand why it needs to be dynamic?

jirka
