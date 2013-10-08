Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab3JHImK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 04:42:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:63555 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab3JHImG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:42:06 -0400
Message-ID: <1381221715.15686.3.camel@marge.simpson.net>
Subject: perf: perf sched lat segfault - bisected
From: Mike Galbraith <bitbucket@online.de>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Tue, 08 Oct 2013 10:41:55 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:FpZpi7qF9hZdPIFWpyfubzbJj9Y+wD4f5YYRcHKWzcD
 JOci0DZr7CbeRbuAWRJvMOJ5cpppOrFuB5WKktq8+nSOalCuTO
 pCXmbAIKLAV6NTuWbootBdQ0m6TCSB2hwSpHeU/j9asEjUcyfS
 yPDwfn+Z0pfD2j/kq5uYdJ2be89ZsqzzlNi6V/1AD3GyLPJDTH
 V+uK91XJKUoiYR0JeXCIKfhxUT1gX4cfkyIEefmb2NtlMC9uHB
 Njt3fCs5ffLlSPbv4b3Ou7MtlaYRMTINNdGqysOwUhg/pCRIRv
 krdYzyfaflbC9cUa3de35v2lVlvd+34vjDRxWC1AvhOnqH0p50
 mvM+VgDYSgMaxty33znnZi3F5ZXINrIw9aQ2ne1j1jsqyLvDuF
 aARr5yGT2n2AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Box: Q6600

Reproducer:
perf sched record -- sleep 1
perf sched lat (boom)

The bisect winner:

marge:/usr/local/src/kernel/linux-3.x.git # git bisect good
5c5e854bc760a2e2c878df3cfcf2afa4febcd511 is the first bad commit
commit 5c5e854bc760a2e2c878df3cfcf2afa4febcd511
Author: Stephane Eranian <eranian@google.com>
Date:   Wed Aug 21 12:10:25 2013 +0200

    perf tools: Add attr->mmap2 support
    
    This patch adds support for the new PERF_RECORD_MMAP2 record type
    exposed by the kernel. This is an extended PERF_RECORD_MMAP record.
    
    It adds for each file-backed mapping the device major, minor number and
    the inode number and generation.
    
    This triplet uniquely identifies the source of a file-backed mapping. It
    can be used to detect identical virtual mappings between processes, for
    instance.
    
    The patch will prefer MMAP2 over MMAP.
    
    Signed-off-by: Stephane Eranian <eranian@google.com>
    Cc: Andi Kleen <ak@linux.intel.com>
    Cc: David Ahern <dsahern@gmail.com>
    Cc: Ingo Molnar <mingo@elte.hu>
    Cc: Jiri Olsa <jolsa@redhat.com>
    Cc: Namhyung Kim <namhyung.kim@lge.com>
    Cc: Peter Zijlstra <peterz@infradead.org>
    Link: http://lkml.kernel.org/r/1377079825-19057-3-git-send-email-eranian@google.com
    [ Cope with 314add6 "Change machine__findnew_thread() to set thread pid",
      fix 'perf test' regression test entry affected,
      use perf_missing_features.mmap2 to fallback to not using .mmap2 in older kernels,
      so that new tools can work with kernels where this feature is not present ]
    Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>

:040000 040000 2d600afbdd11b323bbcd00a4c6b50ee82a604acc d2a81503d08aeea994e203245358ae939eb5e787 M      tools


git bisect start
# bad: [8b5ede69d24db939f52b47effff2f6fe1e83e08b] powerpc/irq: Don't switch to irq stack from softirq stack
git bisect bad 8b5ede69d24db939f52b47effff2f6fe1e83e08b
# good: [6e4664525b1db28f8c4e1130957f70a94c19213e] Linux 3.11
git bisect good 6e4664525b1db28f8c4e1130957f70a94c19213e
# good: [57d730924d5cc2c3e280af16a9306587c3a511db] Merge branch 'timers-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good 57d730924d5cc2c3e280af16a9306587c3a511db
# good: [d8cacd3a259bf522ea5e6c4c60eba67ba22f599c] Merge tag 'virtio-next-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/rusty/linux
git bisect good d8cacd3a259bf522ea5e6c4c60eba67ba22f599c
# good: [b55ee2816ed6d8f8a00d4badab0e3642ffbac19f] Merge branch 'sched-urgent-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip
git bisect good b55ee2816ed6d8f8a00d4badab0e3642ffbac19f
# bad: [d45004f9947e521fc9e812bc7937ed6e0328793b] Merge tag 'for_linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost
git bisect bad d45004f9947e521fc9e812bc7937ed6e0328793b
# bad: [9bf12df31f282e845b3dfaac1e5d5376a041da22] Merge git://git.kvack.org/~bcrl/aio-next
git bisect bad 9bf12df31f282e845b3dfaac1e5d5376a041da22
# bad: [26935fb06ee88f1188789807687c03041f3c70d9] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
git bisect bad 26935fb06ee88f1188789807687c03041f3c70d9
# bad: [5223161dc0f5e44fbf3d5e42d23697b6796cdf4e] Merge branch 'for-next' of git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds
git bisect bad 5223161dc0f5e44fbf3d5e42d23697b6796cdf4e
# bad: [02b9735c12892e04d3e101b06e4c6d64a814f566] Merge tag 'pm+acpi-fixes-3.12-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
git bisect bad 02b9735c12892e04d3e101b06e4c6d64a814f566
# good: [0df03a30c333d67ee9b4c37f32d423624f48fe05] Merge branch 'pm-cpufreq'
git bisect good 0df03a30c333d67ee9b4c37f32d423624f48fe05
# bad: [5c5e854bc760a2e2c878df3cfcf2afa4febcd511] perf tools: Add attr->mmap2 support
git bisect bad 5c5e854bc760a2e2c878df3cfcf2afa4febcd511
# good: [41817815666e4a6f302dad1fea47cbe64cc45e40] perf trace: Check if MAP_32BIT is defined
git bisect good 41817815666e4a6f302dad1fea47cbe64cc45e40
# good: [ccf53eac2097fb47bc40875ffb22c2d10fa8c46c] perf trace: Handle perf.data files with no tracepoints
git bisect good ccf53eac2097fb47bc40875ffb22c2d10fa8c46c
# good: [e71aa28312b208a14cd87fa61e941ac8c85072f4] perf kvm: Fix sample_type manipulation
git bisect good e71aa28312b208a14cd87fa61e941ac8c85072f4
# first bad commit: [5c5e854bc760a2e2c878df3cfcf2afa4febcd511] perf tools: Add attr->mmap2 support


