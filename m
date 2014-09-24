Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbaIXHeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 03:34:05 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:52029 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaIXHeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 03:34:01 -0400
Date: Wed, 24 Sep 2014 09:33:56 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, stable@vger.kernel.org
Subject: Re: [PATCH v4] perf tools: Fix build-id matching on vmlinux
Message-ID: <20140924073356.GB1962@gmail.com>
References: <1411373053-24250-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411373053-24250-1-git-send-email-namhyung@kernel.org>
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
> In this patch, it's now changed to try to search a kernel dso in the
> existing dso list which was constructed during build-id table parsing
> so it'll always have a build-id.  If not found, search "[kernel.kallsyms]".
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
>  tools/perf/util/machine.c | 23 +++++++++++++++++++++--
>  1 file changed, 21 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index b2ec38bf211e..5661195a8cf6 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -12,6 +12,7 @@
>  #include <stdbool.h>
>  #include <symbol/kallsyms.h>
>  #include "unwind.h"
> +#include "asm/bug.h"
>  
>  int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
>  {
> @@ -1062,8 +1063,26 @@ static int machine__process_kernel_mmap_event(struct machine *machine,
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
> +			size_t len = strlen(dso->long_name);
> +
> +			if (WARN_ONCE(len <= 3, "Too short dso name"))
> +				continue;
> +
> +			suffix = dso->long_name + len - 3;
> +			if (strcmp(suffix, ".ko")) {
> +				kernel = dso;
> +				break;
> +			}
> +		}
> +
> +		if (kernel == NULL)
> +			kernel = __dsos__findnew(&machine->kernel_dsos,
> +						 kmmap_prefix);

Please don't break the line just to pacify checkpatch.pl. Other 
than that:

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ing
