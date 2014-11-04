Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbaKDDOR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 22:14:17 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:37433 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162AbaKDDON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 22:14:13 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, srikar@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Brendan Gregg <brendan.gregg@gmail.com>, yrl.pp-manager.tt@hitachi.com,
        Hemant Kumar <hemant@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH perf/core 0/6] perf-probe: Bugfix and add new options for cache
References: <20141031185128.27889.32747.stgit@localhost.localdomain>
Date: Tue, 04 Nov 2014 12:14:10 +0900
In-Reply-To: <20141031185128.27889.32747.stgit@localhost.localdomain> (Masami
	Hiramatsu's message of "Fri, 31 Oct 2014 14:51:29 -0400")
Message-ID: <87389z7j3x.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Fri, 31 Oct 2014 14:51:29 -0400, Masami Hiramatsu wrote:
> Hi,
>
> Here is a sereis of patches for enabling "event cache" feature
> to perf probe. Brendan gives me this cool idea, thanks! :)
>
> In this series, I added following options/features;
>  - --output option
>    We can save the probe definition command for given probe-event
>    instead of setting up the local tracing/kprobe_events.
>
>  - --no-inlines option
>    We can avoid searching the inline functions in debuginfo. Usually
>    useful with wildcards since the wildcards will hit a huge amount
>    of probe-points.
>
>  - $params special probe argument
>    $params is expanded to function parameters only, no locally defined
>    variables. This is useful for function-call tracing.
>
>  - wildcard support for function name
>    Wildcard support is the key feature for this idea. Now we can use
>    '*foo*' for function name to define the probe-point.
>
> So by using all of them, we can make an "event cache" file on all
> functions (except for inlined functions) as below.
>
>   # perf probe --max-probes=100000 --no-inlines -a '* $params' -o event.cache
>
> builds "event.cache" file in which event settings for
> all function entries, like below;
>
>   p:probe/reset_early_page_tables _text+12980741
>   p:probe/copy_bootdata _text+12980830 real_mode_data=%di:u64
>   p:probe/exit_amd_microcode _text+14692680
>   p:probe/early_make_pgtable _text+12981274 address=%di:u64
>   p:probe/x86_64_start_reservations _text+12981700 real_mode_data=%di:u64
>   p:probe/x86_64_start_kernel _text+12981744 real_mode_data=%di:u64
>   p:probe/reserve_ebda_region _text+12982117

Does this event cache support kernel modules too?  AFAIK it can have a
different address whenever loaded even on a same kernel.


>
> This event.cache file will be big (but much smaller than native
> debuginfo :) ) if your kernel have many option embedded.
> Anyway, you can compress it too.
>
>   # wc -l event.cache
>   33813 event.cache
>   # ls -sh event.cache
>   2.3M event.cache
>   # ls -sh event.cache.gz
>   464K event.cache.gz
>
> For setting up a probe event, you can grep the function name
> and write it to tracing/kprobe_events, as below;
>
>   # zcat event.cache.gz | \
>     grep probe/vfs_symlink > /sys/kernel/debug/tracing/kprobe_events
>
> This can be applied for the remote machine only if the machine
> runs on completely same kernel binary. Perhaps, we need some
> helper tool to check it.

While it's useful for "agent-less" systems, I think we also need to have
a simple way to apply it with perf tools.

Thanks,
Namhyung


>
> Thank you,
>
>
> ---
>
> Masami Hiramatsu (6):
>       [BUGFIX] perf-probe: Fix to handle optimized not-inlined but has no instance
>       [DOC] perf-probe: Update perf-probe document
>       perf-probe: Add --output option to write commands in a standard file
>       perf-probe: Add --no-inlines option to avoid searching inline functions
>       perf-probe: Support $params special probe argument
>       perf-probe: Support glob wildcards for function name
>
>
>  tools/perf/Documentation/perf-probe.txt |   25 ++++++++++
>  tools/perf/builtin-probe.c              |   32 +++++++++++++
>  tools/perf/util/dwarf-aux.c             |   31 +++++++++++++
>  tools/perf/util/dwarf-aux.h             |    6 +++
>  tools/perf/util/probe-event.c           |   73 +++++++++++++++++++++++--------
>  tools/perf/util/probe-event.h           |    4 +-
>  tools/perf/util/probe-finder.c          |   74 +++++++++++++++++++------------
>  tools/perf/util/probe-finder.h          |    6 ++-
>  tools/perf/util/util.h                  |    4 ++
>  9 files changed, 202 insertions(+), 53 deletions(-)
>
> --
> Masami HIRAMATSU
> Software Platform Research Dpt. Linux Technology Center
> Hitachi, Ltd., Yokohama Research Laboratory
> E-mail: masami.hiramatsu.pt@hitachi.com
