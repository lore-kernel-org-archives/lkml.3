Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306AbaAWOta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:49:30 -0500
Received: from mail-yk0-f173.google.com ([209.85.160.173]:34414 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaAWOt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:49:28 -0500
Date: Thu, 23 Jan 2014 11:49:09 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [PATCH -tip 3/8] perf-probe: Show in what binaries/modules
 probes are set
Message-ID: <20140123144909.GC17572@ghostprotocols.net>
References: <20140123022945.7206.79944.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
 <20140123022952.7206.79515.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140123022952.7206.79515.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Jan 23, 2014 at 02:29:52AM +0000, Masami Hiramatsu escreveu:
> Show the name of binary file or modules in which the probes
> are set with --list option.
> 
> Without this change;
> 
> # ./perf probe -m drm drm_av_sync_delay
> # ./perf probe -x perf dso__load_vmlinux

Please add two spaces before lines starting with #, because 'git commit
--amend' asks you to:

# Please enter the commit message for your changes. Lines starting
# with '#' will be ignored, and an empty message aborts the commit.

:-)

- Arnaldo
 
> # ./perf probe -l
>   probe:drm_av_sync_delay (on drm_av_sync_delay)
>   probe_perf:dso__load_vmlinux (on 0x000000000006d110)
> 
> With this change;
> 
> # ./perf probe -l
>   probe:drm_av_sync_delay (on drm_av_sync_delay in drm)
>   probe_perf:dso__load_vmlinux (on 0x000000000006d110 in /kbuild/ksrc/linux-3/tools/perf/perf)
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
>  tools/perf/util/probe-event.c |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 14c649df..2fb4486 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -1742,7 +1742,8 @@ static struct strlist *get_probe_trace_command_rawlist(int fd)
>  }
>  
>  /* Show an event */
> -static int show_perf_probe_event(struct perf_probe_event *pev)
> +static int show_perf_probe_event(struct perf_probe_event *pev,
> +				 const char *module)
>  {
>  	int i, ret;
>  	char buf[128];
> @@ -1758,6 +1759,8 @@ static int show_perf_probe_event(struct perf_probe_event *pev)
>  		return ret;
>  
>  	printf("  %-20s (on %s", buf, place);
> +	if (module)
> +		printf(" in %s", module);
>  
>  	if (pev->nargs > 0) {
>  		printf(" with");
> @@ -1795,7 +1798,8 @@ static int __show_perf_probe_events(int fd, bool is_kprobe)
>  			ret = convert_to_perf_probe_event(&tev, &pev,
>  								is_kprobe);
>  			if (ret >= 0)
> -				ret = show_perf_probe_event(&pev);
> +				ret = show_perf_probe_event(&pev,
> +							    tev.point.module);
>  		}
>  		clear_perf_probe_event(&pev);
>  		clear_probe_trace_event(&tev);
> @@ -1994,7 +1998,7 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
>  		group = pev->group;
>  		pev->event = tev->event;
>  		pev->group = tev->group;
> -		show_perf_probe_event(pev);
> +		show_perf_probe_event(pev, tev->point.module);
>  		/* Trick here - restore current event/group */
>  		pev->event = (char *)event;
>  		pev->group = (char *)group;
> 
