Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaBCHts (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 02:49:48 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:51969 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbaBCHtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 02:49:46 -0500
X-AuditID: 9c93016f-b7b7aae0000036de-62-52ef4a19ad4b
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        "Steven Rostedt \(Red Hat\)" <rostedt@goodmis.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        "David A. Long" <dave.long@linaro.org>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH -tip v2 4/8] perf-probe: Use _stext based address instead of the symbol name
In-Reply-To: <20140129091459.22141.29467.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
	(Masami Hiramatsu's message of "Wed, 29 Jan 2014 09:14:59 +0000")
References: <20140129091450.22141.86662.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
	<20140129091459.22141.29467.stgit@kbuild-fedora.yrl.intra.hitachi.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
Date: Mon, 03 Feb 2014 16:49:44 +0900
Message-ID: <87d2j43aav.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jan 2014 09:14:59 +0000, Masami Hiramatsu wrote:
> diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
> index 4a9f43b..120954b 100644
> --- a/tools/perf/util/probe-event.c
> +++ b/tools/perf/util/probe-event.c
> @@ -387,6 +387,44 @@ static int add_module_to_probe_trace_events(struct probe_trace_event *tevs,
>  	return ret;
>  }
>  
> +/* Post processing the probe events */
> +static int post_process_probe_trace_events(struct probe_trace_event *tevs,
> +					   int ntevs, const char *module,
> +					   bool uprobe)
> +{
> +	struct symbol *sym;
> +	struct map *map;
> +	unsigned long stext = 0;
> +	char *tmp;
> +	int i;
> +
> +	if (uprobe)
> +		return add_exec_to_probe_trace_events(tevs, ntevs, module);
> +
> +	/* Note that currently _stext based probe is not for drivers */
> +	if (module)
> +		return add_module_to_probe_trace_events(tevs, ntevs, module);
> +
> +	sym = __find_kernel_function_by_name("_stext", &map);

Couldn't we just use kmap->ref_reloc_sym instead of the hard-coded
"_stext"?  You might want to check the Adrian's recent kaslr fixes (now
in tip/perf/urgent).

Thanks,
Namhyung


> +	if (!sym) {
> +		pr_debug("Failed to find _stext. Use original symbol name.\n");
> +		return 0;
> +	}
> +	stext = map->unmap_ip(map, sym->start);
> +
> +	for (i = 0; i < ntevs; i++) {
> +		if (tevs[i].point.address) {
> +			tmp = strdup("_stext");
> +			if (!tmp)
> +				return -ENOMEM;
> +			free(tevs[i].point.symbol);
> +			tevs[i].point.symbol = tmp;
> +			tevs[i].point.offset = tevs[i].point.address - stext;
> +		}
> +	}
> +	return 0;
> +}
> +
