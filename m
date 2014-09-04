Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbaIDOS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 10:18:57 -0400
Received: from mail.kernel.org ([198.145.19.201]:44599 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbaIDOSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 10:18:55 -0400
Date: Thu, 4 Sep 2014 11:18:45 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] perf tools: Fix build-id matching on vmlinux
Message-ID: <20140904141845.GD2997@kernel.org>
References: <1409035119-24357-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409035119-24357-1-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Aug 26, 2014 at 03:38:39PM +0900, Namhyung Kim escreveu:
> There's a problem on finding correct kernel symbols when perf report
> runs on a different kernel.  Although a part of the problem was solved
> by the prior commit 0a7e6d1b6844 ("perf tools: Check recorded kernel
> version when finding vmlinux"), there's a remaining problem still.
> 
> When perf records samples, it synthesizes the kernel map using
> machine__mmap_name() and ref_reloc_sym like "[kernel.kallsyms]_text".
> You can easily see it using 'perf report -D' command.
> 
> After finishing record, it goes through the recorded events to find
> maps/dsos actually used.  And then record build-id info of them.
> 
> During this process, it needs to load symbols in a dso and it'd call
> dso__load_vmlinux() since the default value of the symbol_conf.try_
> vmlinux_path is true.  However it changes dso->long_name to a real
> path of the vmlinux file (e.g. /lib/modules/3.16.0-rc2+/build/vmlinux)
> if one is running on a custom kernel.
> 
> It resulted in that perf report reads the build-id of the vmlinux, but
> cannot use it since it only knows about the [kernel.kallsyms] map.  It
> then falls back to possible vmlinux paths by using the recorded kernel
> version (in case of a recent version) or a running kernel silently
> (which might break the result).  I think it's worth going to the
> stable tree.
> 
> I can think of a couple of ways to fix it.  In this patch, I changed
> to use the name of "[kernel.kallsyms]" for the kernel build-id event
> instead of not trying vmlinux paths.  This way we can provide maximum
> info (like annotation) with minimum change IMHO.
> 
> Before:
> 
>   $ perf record -a usleep 1
> 
>   $ perf buildid-list
>   00d5ff078efe1d30b8492854f259215fd877ce30 /lib/modules/3.16.0-rc2+/build/vmlinux
>   78186287bba77069a056a5ccbeb14b7fd2ca3a4b /usr/lib64/libc-2.17.so
>   4eadca6cb82e0a85edb87c15b5e3980742514501 /usr/lib64/ld-2.17.so
>   1e272ca30081e81ef41935a630eb2f4c636798b4 /usr/lib64/dri/swrast_dri.so
> 
>   $ perf buildid-list -H
>   0000000000000000000000000000000000000000 [kernel.kallsyms]
>   78186287bba77069a056a5ccbeb14b7fd2ca3a4b /usr/lib64/libc-2.17.so
>   4eadca6cb82e0a85edb87c15b5e3980742514501 /usr/lib64/ld-2.17.so
>   1e272ca30081e81ef41935a630eb2f4c636798b4 /usr/lib64/dri/swrast_dri.so
>   0000000000000000000000000000000000000000 /tmp/perf-2523.map
> 
> After:
> 
>   $ perf record -a usleep 1
> 
>   $ perf buildid-list
>   00d5ff078efe1d30b8492854f259215fd877ce30 [kernel.kallsyms]

We are losing information, namely the pathname for the kernel used, that
may be useful in analysis.

Why not make sure that if there is a build-id in the perf.data header,
then we completely refusing anything that doesn't match the build-id?
I.e. the name is irrelevant for this purpose, the contents, as keyed by
the build-id, is what matters.

- Arnaldo

>   78186287bba77069a056a5ccbeb14b7fd2ca3a4b /usr/lib64/libc-2.17.so
>   4eadca6cb82e0a85edb87c15b5e3980742514501 /usr/lib64/ld-2.17.so
>   1e272ca30081e81ef41935a630eb2f4c636798b4 /usr/lib64/dri/swrast_dri.so
> 
>   $ perf buildid-list -H
>   00d5ff078efe1d30b8492854f259215fd877ce30 [kernel.kallsyms]
>   78186287bba77069a056a5ccbeb14b7fd2ca3a4b /usr/lib64/libc-2.17.so
>   4eadca6cb82e0a85edb87c15b5e3980742514501 /usr/lib64/ld-2.17.so
>   1e272ca30081e81ef41935a630eb2f4c636798b4 /usr/lib64/dri/swrast_dri.so
>   0000000000000000000000000000000000000000 /tmp/perf-2523.map
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/header.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index 158c787ce0c4..5c4093dee467 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -263,6 +263,9 @@ static int __dsos__write_buildid_table(struct list_head *head,
>  			machine__mmap_name(machine, nm, sizeof(nm));
>  			name = nm;
>  			name_len = strlen(nm) + 1;
> +		} else if (dso__is_vmlinux(pos)) {
> +			name = pos->name;
> +			name_len = strlen(pos->name) + 1;
>  		} else {
>  			name = pos->long_name;
>  			name_len = pos->long_name_len + 1;
> -- 
> 2.0.0
