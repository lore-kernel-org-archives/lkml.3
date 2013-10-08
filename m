Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab3JHMRV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:17:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755150Ab3JHMRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:17:20 -0400
Date: Tue, 8 Oct 2013 09:17:09 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Mike Galbraith <bitbucket@online.de>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf: perf sched lat segfault - bisected
Message-ID: <20131008121709.GA3955@infradead.org>
References: <1381221715.15686.3.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381221715.15686.3.camel@marge.simpson.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Oct 08, 2013 at 10:41:55AM +0200, Mike Galbraith escreveu:
> Box: Q6600
> 
> Reproducer:
> perf sched record -- sleep 1
> perf sched lat (boom)
> 
> The bisect winner:

Can you try with today's tip/perf/urgent branch?

- Arnaldo
 
> marge:/usr/local/src/kernel/linux-3.x.git # git bisect good
> 5c5e854bc760a2e2c878df3cfcf2afa4febcd511 is the first bad commit
> commit 5c5e854bc760a2e2c878df3cfcf2afa4febcd511
> Author: Stephane Eranian <eranian@google.com>
> Date:   Wed Aug 21 12:10:25 2013 +0200
> 
>     perf tools: Add attr->mmap2 support
>     
>     This patch adds support for the new PERF_RECORD_MMAP2 record type
>     exposed by the kernel. This is an extended PERF_RECORD_MMAP record.
>     
>     It adds for each file-backed mapping the device major, minor number and
>     the inode number and generation.
>     
>     This triplet uniquely identifies the source of a file-backed mapping. It
>     can be used to detect identical virtual mappings between processes, for
>     instance.
>     
>     The patch will prefer MMAP2 over MMAP.
>     
>     Signed-off-by: Stephane Eranian <eranian@google.com>
>     Cc: Andi Kleen <ak@linux.intel.com>
>     Cc: David Ahern <dsahern@gmail.com>
>     Cc: Ingo Molnar <mingo@elte.hu>
>     Cc: Jiri Olsa <jolsa@redhat.com>
>     Cc: Namhyung Kim <namhyung.kim@lge.com>
>     Cc: Peter Zijlstra <peterz@infradead.org>
>     Link: http://lkml.kernel.org/r/1377079825-19057-3-git-send-email-eranian@google.com
>     [ Cope with 314add6 "Change machine__findnew_thread() to set thread pid",
>       fix 'perf test' regression test entry affected,
>       use perf_missing_features.mmap2 to fallback to not using .mmap2 in older kernels,
>       so that new tools can work with kernels where this feature is not present ]
>     Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> :040000 040000 2d600afbdd11b323bbcd00a4c6b50ee82a604acc d2a81503d08aeea994e203245358ae939eb5e787 M      tools
> 
> 
> git bisect start
> # bad: [8b5ede69d24db939f52b47effff2f6fe1e83e08b] powerpc/irq: Don't switch to irq stack from softirq stack
> git bisect bad 8b5ede69d24db939f52b47effff2f6fe1e83e08b
> # good: [6e4664525b1db28f8c4e1130957f70a94c19213e] Linux 3.11
> git bisect good 6e4664525b1db28f8c4e1130957f70a94c19213e
> # good: [57d730924d5cc2c3e280af16a9306587c3a511db] Merge branch 'timers-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good 57d730924d5cc2c3e280af16a9306587c3a511db
> # good: [d8cacd3a259bf522ea5e6c4c60eba67ba22f599c] Merge tag 'virtio-next-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux
> git bisect good d8cacd3a259bf522ea5e6c4c60eba67ba22f599c
> # good: [b55ee2816ed6d8f8a00d4badab0e3642ffbac19f] Merge branch 'sched-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
> git bisect good b55ee2816ed6d8f8a00d4badab0e3642ffbac19f
> # bad: [d45004f9947e521fc9e812bc7937ed6e0328793b] Merge tag 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost
> git bisect bad d45004f9947e521fc9e812bc7937ed6e0328793b
> # bad: [9bf12df31f282e845b3dfaac1e5d5376a041da22] Merge git://git.kvack.org/~bcrl/aio-next
> git bisect bad 9bf12df31f282e845b3dfaac1e5d5376a041da22
> # bad: [26935fb06ee88f1188789807687c03041f3c70d9] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
> git bisect bad 26935fb06ee88f1188789807687c03041f3c70d9
> # bad: [5223161dc0f5e44fbf3d5e42d23697b6796cdf4e] Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds
> git bisect bad 5223161dc0f5e44fbf3d5e42d23697b6796cdf4e
> # bad: [02b9735c12892e04d3e101b06e4c6d64a814f566] Merge tag 'pm+acpi-fixes-3.12-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
> git bisect bad 02b9735c12892e04d3e101b06e4c6d64a814f566
> # good: [0df03a30c333d67ee9b4c37f32d423624f48fe05] Merge branch 'pm-cpufreq'
> git bisect good 0df03a30c333d67ee9b4c37f32d423624f48fe05
> # bad: [5c5e854bc760a2e2c878df3cfcf2afa4febcd511] perf tools: Add attr->mmap2 support
> git bisect bad 5c5e854bc760a2e2c878df3cfcf2afa4febcd511
> # good: [41817815666e4a6f302dad1fea47cbe64cc45e40] perf trace: Check if MAP_32BIT is defined
> git bisect good 41817815666e4a6f302dad1fea47cbe64cc45e40
> # good: [ccf53eac2097fb47bc40875ffb22c2d10fa8c46c] perf trace: Handle perf.data files with no tracepoints
> git bisect good ccf53eac2097fb47bc40875ffb22c2d10fa8c46c
> # good: [e71aa28312b208a14cd87fa61e941ac8c85072f4] perf kvm: Fix sample_type manipulation
> git bisect good e71aa28312b208a14cd87fa61e941ac8c85072f4
> # first bad commit: [5c5e854bc760a2e2c878df3cfcf2afa4febcd511] perf tools: Add attr->mmap2 support
> 
