Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736AbaIVFQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 01:16:37 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:58757 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbaIVFQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 01:16:35 -0400
Date: Mon, 22 Sep 2014 07:16:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, stable@vger.kernel.org
Subject: Re: [PATCH v3] perf tools: Fix build-id matching on vmlinux
Message-ID: <20140922051630.GA18588@gmail.com>
References: <1411353945-16576-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411353945-16576-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Namhyung Kim <namhyung@kernel.org> wrote:

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
> version (in case of a recent version) or a running kernel silently.
> 
> Even with the recent tools, this still has a possibility of breaking
> the result.  As the build directory is a symbolic link, if one built a
> new kernel in the same directory with different source/config, the old
> link to vmlinux will point the new file.  So it's absolutely needed to
> use build-id when finding a kernel image.
> 
> In this patch, it's now changed to try to search a kernel dso using
> "vmlinux" shortname (which always has a build-id) and, if not found,
> search "[kernel.kallsyms]".
> 
> Before:
> 
>   $ perf report
>   # Children      Self  Command  Shared Object      Symbol
>   # ........  ........  .......  .................  ...............................
>   #
>       72.15%     0.00%  swapper  [kernel.kallsyms]  [k] set_curr_task_rt
>       72.15%     0.00%  swapper  [kernel.kallsyms]  [k] native_calibrate_tsc
>       72.15%     0.00%  swapper  [kernel.kallsyms]  [k] tsc_refine_calibration_work
>       71.87%    71.87%  swapper  [kernel.kallsyms]  [k] module_finalize
>    ...
> 
> After (for the same perf.data):
> 
>       72.15%     0.00%  swapper  vmlinux  [k] cpu_startup_entry
>       72.15%     0.00%  swapper  vmlinux  [k] arch_cpu_idle
>       72.15%     0.00%  swapper  vmlinux  [k] default_idle
>       71.87%    71.87%  swapper  vmlinux  [k] native_safe_halt
>    ...
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/machine.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index b2ec38bf211e..14880b81e98c 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -1062,8 +1062,22 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
>  		 * Should be there already, from the build-id table in
>  		 * the header.
>  		 */
> -		struct dso *kernel = __dsos__findnew(&machine->kernel_dsos,
> -						     kmmap_prefix);
> +		struct dso *kernel = NULL;
> +		struct dso *dso;
> +
> +		list_for_each_entry(dso, &machine->kernel_dsos, node) {
> +			const char *suffix;
> +
> +			suffix = dso->long_name + strlen(dso->long_name) - 3;
> +			if (strcmp(suffix, ".ko")) {
> +				kernel = dso;
> +				break;
> +			}

Is strlen(dso->long_name) guaranteed to be >= 3? If not then you 
should probably check for it, otherwise we might strcmp into 
invalid memory.

Thanks,

	Ingo
