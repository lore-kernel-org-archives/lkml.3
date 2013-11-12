Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab3KLLqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 06:46:18 -0500
Received: from mail-gg0-f175.google.com ([209.85.161.175]:42966 "EHLO
	mail-gg0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab3KLLqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 06:46:16 -0500
Date: Tue, 12 Nov 2013 08:46:09 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 2/2] perf trace: Fix segfault on perf trace -i perf.data
Message-ID: <20131112114609.GB4053@ghostprotocols.net>
References: <1384237500-22991-1-git-send-email-namhyung@kernel.org>
 <1384237500-22991-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384237500-22991-2-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Nov 12, 2013 at 03:25:00PM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> When replaying a previous record session, it'll get a segfault since
> it doesn't initialize evsel->priv for finding syscall id.  So fix it
> by initialize sys_enter/exit evsel manually.
> 
> While at it, factor out perf_evsel__init_syscall_tp() to init a
> syscall evsel and remove unused perf_session__has_tp().

Try to avoid these "while at it" to combine multiple patches into one
:-)

I'll try to do it for you this time as it fixes a real problem, thanks
for fixing it!

More comments below:

- Arnaldo
 
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Pekka Enberg <penberg@kernel.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/builtin-trace.c | 63 ++++++++++++++++++++++++++++------------------
>  1 file changed, 38 insertions(+), 25 deletions(-)
> 
> diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
> -static struct perf_evsel *perf_evsel__syscall_newtp(const char *direction, void *handler)
> +static int perf_evsel__init_syscall_tp(struct perf_evsel *evsel, void *handler)
>  {
> -	struct perf_evsel *evsel = perf_evsel__newtp("raw_syscalls", direction);
> +	evsel->priv = malloc(sizeof(struct syscall_tp));
>  
> -	if (evsel) {
> -		evsel->priv = malloc(sizeof(struct syscall_tp));
> +	if (evsel->priv == NULL)
> +		return -ENOMEM;
>  
> -		if (evsel->priv == NULL)
> -			goto out_delete;
> +	if (perf_evsel__init_sc_tp_uint_field(evsel, id))
> +		return -1;

Try to be consistent here, if when allocating memory you return minus
ernno code, try to use that error reporting convention here as well.

Otherwise if perf_evsel__init_syscall_tp checks the error it will try to
figure out why it is returning -EPERM (-1) when
perf_evsel__init_sc_tp_uint_field fails :)

I think the right error to return here is -ENOENT, i.e. the field was
not found in this tracepoint.

>  
> -		if (perf_evsel__init_sc_tp_uint_field(evsel, id))
> -			goto out_delete;
> +	evsel->handler = handler;
> +	return 0;
> +}
> +
> +static struct perf_evsel *perf_evsel__syscall_newtp(const char *direction,
> +						    void *handler)
> +{
> +	struct perf_evsel *evsel = perf_evsel__newtp("raw_syscalls", direction);
>  
> -		evsel->handler = handler;
> +	if (evsel) {
> +		if (perf_evsel__init_syscall_tp(evsel, handler) < 0)
> +			goto out_delete;
>  	}
>  
>  	return evsel;
> @@ -1754,16 +1762,6 @@ static int trace__process_sample(struct perf_tool *tool,
>  	return err;
>  }
>  
> -static bool
> -perf_session__has_tp(struct perf_session *session, const char *name)
> -{
> -	struct perf_evsel *evsel;
> -
> -	evsel = perf_evlist__find_tracepoint_by_name(session->evlist, name);
> -
> -	return evsel != NULL;
> -}
> -
>  static int parse_target_str(struct trace *trace)
>  {
>  	if (trace->opts.target.pid) {
> @@ -2000,8 +1998,6 @@ out_error:
>  static int trace__replay(struct trace *trace)
>  {
>  	const struct perf_evsel_str_handler handlers[] = {
> -		{ "raw_syscalls:sys_enter",  trace__sys_enter, },
> -		{ "raw_syscalls:sys_exit",   trace__sys_exit, },
>  		{ "probe:vfs_getname",	     trace__vfs_getname, },
>  	};
>  	struct perf_data_file file = {
> @@ -2009,6 +2005,7 @@ static int trace__replay(struct trace *trace)
>  		.mode  = PERF_DATA_MODE_READ,
>  	};
>  	struct perf_session *session;
> +	struct perf_evsel *evsel;
>  	int err = -1;
>  
>  	trace->tool.sample	  = trace__process_sample;
> @@ -2040,13 +2037,29 @@ static int trace__replay(struct trace *trace)
>  	if (err)
>  		goto out;
>  
> -	if (!perf_session__has_tp(session, "raw_syscalls:sys_enter")) {
> -		pr_err("Data file does not have raw_syscalls:sys_enter events\n");
> +	evsel = perf_evlist__find_tracepoint_by_name(session->evlist,
> +						     "raw_syscalls:sys_enter");
> +	if (evsel == NULL) {
> +		pr_err("Data file does not have raw_syscalls:sys_enter event\n");
> +		goto out;
> +	}
> +
> +	if (perf_evsel__init_syscall_tp(evsel, trace__sys_enter) < 0 ||
> +	    perf_evsel__init_sc_tp_ptr_field(evsel, args)) {
> +		pr_err("Error during initialize raw_syscalls:sys_enter event\n");
> +		goto out;
> +	}
> +
> +	evsel = perf_evlist__find_tracepoint_by_name(session->evlist,
> +						     "raw_syscalls:sys_exit");
> +	if (evsel == NULL) {
> +		pr_err("Data file does not have raw_syscalls:sys_exit event\n");
>  		goto out;
>  	}
>  
> -	if (!perf_session__has_tp(session, "raw_syscalls:sys_exit")) {
> -		pr_err("Data file does not have raw_syscalls:sys_exit events\n");
> +	if (perf_evsel__init_syscall_tp(evsel, trace__sys_exit) < 0 ||
> +	    perf_evsel__init_sc_tp_uint_field(evsel, ret)) {
> +		pr_err("Error during initialize raw_syscalls:sys_exit event\n");
>  		goto out;
>  	}
>  
> -- 
> 1.7.11.7
