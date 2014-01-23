Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270AbaAWOwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:52:22 -0500
Received: from mail-gg0-f181.google.com ([209.85.161.181]:45673 "EHLO
	mail-gg0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932237AbaAWOwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:52:19 -0500
Date: Thu, 23 Jan 2014 11:52:11 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH -tip 4/8] perf-probe: Use the actual address instead of
 the symbol name
Message-ID: <20140123145211.GB25714@ghostprotocols.net>
References: <20140123022945.7206.79944.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
 <20140123022954.7206.77940.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123022954.7206.77940.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 23, 2014 at 02:29:55AM +0000, Masami Hiramatsu escreveu:
> Since several local symbols can have same name (e.g. t_show),
> we need to use the actual address instead of symbol name for
> those points. Note that this works only with debuginfo.
> 
> E.g. without this change;
> ----

Please use spaces after dashed lines, this is even as (or more)
important as prefixing # lines, as this makes everything after the ---
line and the patch itself to be ignored.

I'm fixing this up this time, please add the spaces next time,

- Arnaldo

> # ./perf probe -a t_show \$vars
> Added new events:
>   probe:t_show         (on t_show with $vars)
>   probe:t_show_1       (on t_show with $vars)
>   probe:t_show_2       (on t_show with $vars)
>   probe:t_show_3       (on t_show with $vars)
> 
> You can now use it in all perf tools, such as:
> 
>         perf record -e probe:t_show_3 -aR sleep 1
> ----
> OK, we have 4 different t_show()s. All functions have
> different arguments as below;
> ----
> # cat /sys/kernel/debug/tracing/kprobe_events
> p:probe/t_show t_show m=%di:u64 v=%si:u64
> p:probe/t_show_1 t_show m=%di:u64 v=%si:u64 t=%si:u64
> p:probe/t_show_2 t_show m=%di:u64 v=%si:u64 fmt=%si:u64
> p:probe/t_show_3 t_show m=%di:u64 v=%si:u64 file=%si:u64
> ----
> However, all of them have been put on the *same* address.
> ----
> # cat /sys/kernel/debug/kprobes/list
> ffffffff810d9720  k  t_show+0x0    [DISABLED]
> ffffffff810d9720  k  t_show+0x0    [DISABLED]
> ffffffff810d9720  k  t_show+0x0    [DISABLED]
> ffffffff810d9720  k  t_show+0x0    [DISABLED]
> ----
> 
> With this change;
> ----
> # ./perf probe -a t_show \$vars
> Added new events:
>   probe:t_show         (on t_show with $vars)
>   probe:t_show_1       (on t_show with $vars)
>   probe:t_show_2       (on t_show with $vars)
>   probe:t_show_3       (on t_show with $vars)
> 
> You can now use it in all perf tools, such as:
> 
>         perf record -e probe:t_show_3 -aR sleep 1
> 
> # cat /sys/kernel/debug/tracing/kprobe_events
> p:probe/t_show 0xffffffff810d9720 m=%di:u64 v=%si:u64
> p:probe/t_show_1 0xffffffff810e2e40 m=%di:u64 v=%si:u64 t=%si:u64
> p:probe/t_show_2 0xffffffff810ece30 m=%di:u64 v=%si:u64 fmt=%si:u64
> p:probe/t_show_3 0xffffffff810f4ad0 m=%di:u64 v=%si:u64 file=%si:u64
> 
> # cat /sys/kernel/debug/kprobes/list
> ffffffff810e2e40  k  t_show+0x0    [DISABLED]
> ffffffff810ece30  k  t_show+0x0    [DISABLED]
> ffffffff810f4ad0  k  t_show+0x0    [DISABLED]
> ffffffff810d9720  k  t_show+0x0    [DISABLED]
> ----
> This time, each event is put in different address
> correctly.
> 
> Note that currently this doesn't support address-based
> probe on modules (thus the probes on modules are symbol
> based), since it requires relative address probe syntax
> for kprobe-tracer, and it doesn't implemented yet.
> 
> One more note, this allows us to put events on correct
> address, but --list option should be updated to show
> correct corresponding source code.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
>  tools/perf/util/probe-event.c |   23 +++++++++++++++--------
>  1 file changed, 15 insertions(+), 8 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 2fb4486..92ab688 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -1529,20 +1529,27 @@ char *synthesize_probe_trace_command(struct probe_trace_event *tev)
>  	if (buf == NULL)
>  		return NULL;
>  
> -	if (tev->uprobes)
> -		len = e_snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s:%s",
> -				 tp->retprobe ? 'r' : 'p',
> -				 tev->group, tev->event,
> +	len = e_snprintf(buf, MAX_CMDLEN, "%c:%s/%s ", tp->retprobe ? 'r' : 'p',
> +			 tev->group, tev->event);
> +	if (len <= 0)
> +		goto error;
> +
> +	/* Use the real address, except for kernel modules */
> +	if (tp->address && !(tp->module && !tev->uprobes))
> +		ret = e_snprintf(buf + len, MAX_CMDLEN, "%s%s0x%lx",
> +				 tp->module ?: "", tp->module ? ":" : "",
> +				 tp->address);
> +	else if (tev->uprobes)
> +		ret = e_snprintf(buf + len, MAX_CMDLEN, "%s:%s",
>  				 tp->module, tp->symbol);
>  	else
> -		len = e_snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s%s%s+%lu",
> -				 tp->retprobe ? 'r' : 'p',
> -				 tev->group, tev->event,
> +		ret = e_snprintf(buf + len, MAX_CMDLEN, "%s%s%s+%lu",
>  				 tp->module ?: "", tp->module ? ":" : "",
>  				 tp->symbol, tp->offset);
>  
> -	if (len <= 0)
> +	if (ret <= 0)
>  		goto error;
> +	len += ret;
>  
>  	for (i = 0; i < tev->nargs; i++) {
>  		ret = synthesize_probe_trace_arg(&tev->args[i], buf + len,
> 
