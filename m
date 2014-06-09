Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbaFIF4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 01:56:44 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:59788 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaFIF4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 01:56:36 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: jolsa@redhat.com, linux-kernel@vger.kernel.org, acme@infradead.org
Subject: Re: perf: Add support for full Intel event lists v5
References: <1401486615-21374-1-git-send-email-andi@firstfloor.org>
Date: Mon, 09 Jun 2014 14:56:34 +0900
In-Reply-To: <1401486615-21374-1-git-send-email-andi@firstfloor.org> (Andi
	Kleen's message of "Fri, 30 May 2014 14:50:06 -0700")
Message-ID: <878up6d3sd.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 May 2014 14:50:06 -0700, Andi Kleen wrote:
> [v2: Review feedback addressed and some minor improvements]
> [v3: More review feedback addressed and handle test failures better.
> Ported to latest tip/core.]
> [v4: Addressed Namhyung's feedback]
> [v5: Rebase to latest tree. Minor description update.]
>
> perf has high level events which are useful in many cases. However
> there are some tuning situations where low level events in the CPU
> are needed. Traditionally this required specifying the event in 
> raw form (very awkward) or using non standard frontends
> like ocperf or patching in libpfm.
>
> Intel CPUs can have very large event files (Haswell has ~336 core events,
> much more if you add uncore or all the offcore combinations), which is too
> large to describe through the kernel interface. It would require tying up
> significant amounts of unswappable memory for this.
>
> oprofile always had separate event list files that were maintained by 
> the CPU vendors. The oprofile events were shipped with the tool.
> The Intel events get updated regularly, for example to add references
> to the specification updates or add new events.
>
> Unfortunately oprofile usually did not keep up with these updates,
> so the events in oprofile were often out of date. In addition
> it ties up quite a bit of disk space, mostly for CPUs you don't have.
>
> This patch kit implements another mechanism that avoids these problems.
> Intel releases the event lists for CPUs in a standardized JSON format
> on a download server.
>
> I implemented an automatic downloader to get the event file for the
> current CPU.  The events are stored in ~/.cache/pmu-events.
> Then perf adds a parser that converts the JSON format into perf event
> aliases, which then can be used directly as any other perf event.
>
> The parsing is done using a simple existing JSON library.
>
> The events are still abstracted for perf, but the abstraction mechanism is
> through the downloaded file instead of through the kernel.
>
> The JSON format and perf parser has some minor Intelisms, but they
> are simple and small and optional. It's easy to extend, so it would be
> possible to use it for other CPUs too, add different pmu attributes, and
> add new download sites to the downloader tool.
>
> Currently only core events are supported, uncore may come at a later
> point. No kernel changes, all code in perf user tools only.
>
> Some of the parser files are partially shared with separate event parser
> library and are thus 2-clause BSD licensed.

So I played with this patchset for a little while, and it's mostly good
and I left comments for each patch I have concerns.  With that change,

Acked-by: Namhyung Kim <namhyung@kernel.org>


Hopefully other vendors will add support for their cpus too.

Thanks,
Namhyung


>
> Patches also available from
> git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc perf/json
>
> Example output:
>
> % perf download 
> Downloading models file
> Downloading readme.txt
> 2014-03-05 10:39:33 URL:https://download.01.org/perfmon/readme.txt [10320/10320] -> "readme.txt" [1]
> 2014-03-05 10:39:34 URL:https://download.01.org/perfmon/mapfile.csv [1207/1207] -> "mapfile.csv" [1]
> Downloading events file
> % perf list
> ...
>   br_inst_exec.all_branches                          [Speculative and retired
>                                                       branches]
>   br_inst_exec.all_conditional                       [Speculative and retired
>                                                       macro-conditional
>                                                       branches]
>   br_inst_exec.all_direct_jmp                        [Speculative and retired
>                                                       macro-unconditional
>                                                       branches excluding
>                                                       calls and indirects]
> ... 333 more new events ...
>
> % perf stat -e br_inst_exec.all_direct_jmp true
>
>  Performance counter stats for 'true':
>
>              6,817      cpu/br_inst_exec.all_direct_jmp/                                   
>
>        0.003503212 seconds time elapsed
>
> One nice feature is that a pointer to the specification update is now
> included in the description, which will hopefully clear up many problems:
>
> % perf list
> ...
>   mem_load_uops_l3_hit_retired.xsnp_hit              [Retired load uops which
>                                                       data sources were L3
>                                                       and cross-core snoop
>                                                       hits in on-pkg core
>                                                       cache. Supports address
>                                                       when precise. Spec
>                                                       update: HSM26, HSM30
>                                                       (Precise event)]
> ...
>
>
> -Andi
