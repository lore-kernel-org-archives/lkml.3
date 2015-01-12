Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbbALMWW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 07:22:22 -0500
Received: from mail4.hitachi.co.jp ([133.145.228.5]:43510 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbbALMWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:22:20 -0500
Message-ID: <54B3BC75.2060500@hitachi.com>
Date: Mon, 12 Jan 2015 21:22:13 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH 3/4] perf probe: Fix probing kretprobes
References: <1420886028-15135-1-git-send-email-namhyung@kernel.org> <1420886028-15135-3-git-send-email-namhyung@kernel.org>
In-Reply-To: <1420886028-15135-3-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2015/01/10 19:33), Namhyung Kim wrote:
> The commit dfef99cd0b2c ("perf probe: Use ref_reloc_sym based address
> instead of the symbol name") converts kprobes to use ref_reloc_sym
> (i.e. _stext) and offset instead of using symbol's name directly.  So
> on my system, adding do_fork ends up with like below:
> 
>   $ sudo perf probe -v --add do_fork%return
>   probe-definition(0): do_fork%return
>   symbol:do_fork file:(null) line:0 offset:0 return:1 lazy:(null)
>   0 arguments
>   Looking at the vmlinux_path (7 entries long)
>   Using /lib/modules/3.17.6-1-ARCH/build/vmlinux for symbols
>   Could not open debuginfo. Try to use symbols.
>   Opening /sys/kernel/debug/tracing/kprobe_events write=1
>   Added new event:
>   Writing event: r:probe/do_fork _stext+456136
>   Failed to write event: Invalid argument
>   Error: Failed to add events. Reason: Operation not permitted (Code: -1)
> 
> As you can see, the do_fork was translated to _stext+456136.  This was
> because to support (local) symbols that have same name.  But the
> problem is that kretprobe requires to be inserted at function start
> point so it simply checks whether it's called with offset 0.  And if
> not, it'll return with -EINVAL.  You can see it with dmesg.
> 
>   $ dmesg | tail -1
>     [125621.764103] Return probe must be used without offset.
> 
> So we need to use the symbol name instead of ref_reloc_sym in case of
> return probes.

Thanks, but as I pointed in previous mail, this patch fixes just one
code path which doesn't use debuginfo. With debuginfo, perf-probe
executes try_to_find_probe_trace_events() to analyze debuginfo.
We can just skip calling it for retprobes, but I prefer to keep
it works. So just skipping conversion in post_process_probe_trace_events()
is better.

Thank you,

> 
> Reported-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/probe-event.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index e5af16988791..6fe5aa357efc 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -2321,7 +2321,7 @@ static int find_probe_trace_events_from_map(struct perf_probe_event *pev,
>  		goto out;
>  	}
>  
> -	if (!pev->uprobes) {
> +	if (!pev->uprobes && !pp->retprobe) {
>  		kmap = map__kmap(map);
>  		reloc_sym = kmap->ref_reloc_sym;
>  		if (!reloc_sym) {
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


