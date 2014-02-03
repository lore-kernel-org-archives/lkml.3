Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaBCHlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 02:41:46 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:45207 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbaBCHlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 02:41:45 -0500
X-AuditID: 9c93017e-b7b63ae000000e6a-d2-52ef48388a4f
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt \(Red Hat\)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH -tip v2 1/8] [BUGFIX] perf-probe: Fix to do exit call for symbol maps
References: <20140129091450.22141.86662.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
	<20140129091452.22141.36766.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
Date: Mon, 03 Feb 2014 16:41:43 +0900
In-Reply-To: <20140129091452.22141.36766.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
	(Masami Hiramatsu's message of "Wed, 29 Jan 2014 09:14:52 +0000")
Message-ID: <87iosw3ao8.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Wed, 29 Jan 2014 09:14:52 +0000, Masami Hiramatsu wrote:
> Some perf-probe commands do symbol_init() but doesn't
> do exit call. This fixes that to call symbol_exit()
> and relase machine if needed.
> This also merges init_vmlinux() and init_user_exec()
> because both of them are doing similar things.
> (init_user_exec() just skips init vmlinux related
>  symbol maps)
>
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
>  tools/perf/util/probe-event.c |  110 +++++++++++++++++++++++------------------
>  1 file changed, 61 insertions(+), 49 deletions(-)
>
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index a8a9b6c..14c649df 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -73,31 +73,35 @@ static char *synthesize_perf_probe_point(struct perf_probe_point *pp);
>  static int convert_name_to_addr(struct perf_probe_event *pev,
>  				const char *exec);
>  static void clear_probe_trace_event(struct probe_trace_event *tev);
> -static struct machine machine;
> +static struct machine *host_machine;
>  
>  /* Initialize symbol maps and path of vmlinux/modules */
> -static int init_vmlinux(void)
> +static int init_symbol_maps(bool user_only)
>  {
>  	int ret;
>  
>  	symbol_conf.sort_by_name = true;
> -	if (symbol_conf.vmlinux_name == NULL)
> -		symbol_conf.try_vmlinux_path = true;
> -	else
> -		pr_debug("Use vmlinux: %s\n", symbol_conf.vmlinux_name);
> +	if (user_only)
> +		symbol_conf.try_vmlinux_path = false;
> +	else {
> +		if (symbol_conf.vmlinux_name == NULL)
> +			symbol_conf.try_vmlinux_path = true;

This looks unnecessary and duplicate since we already have following
code in __cmd_probe().

	/*
	 * Only consider the user's kernel image path if given.
	 */
	symbol_conf.try_vmlinux_path = (symbol_conf.vmlinux_name == NULL);

Thanks,
Namhyung


> +		else
> +			pr_debug("Use vmlinux: %s\n", symbol_conf.vmlinux_name);
> +	}
