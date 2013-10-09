Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab3JILD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 07:03:59 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:49868 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab3JILD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 07:03:57 -0400
Date: Wed, 9 Oct 2013 13:03:54 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/63] Basic scheduler support for automatic NUMA
 balancing V9
Message-ID: <20131009110353.GA19370@gmail.com>
References: <1381141781-10992-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381141781-10992-1-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mel Gorman <mgorman@suse.de> wrote:

> This series has roughly the same goals as previous versions despite the
> size. It reduces overhead of automatic balancing through scan rate reduction
> and the avoidance of TLB flushes. It selects a preferred node and moves tasks
> towards their memory as well as moving memory toward their task. It handles
> shared pages and groups related tasks together. Some problems such as shared
> page interleaving and properly dealing with processes that are larger than
> a node are being deferred. This version should be ready for wider testing
> in -tip.

Thanks Mel - the series looks really nice. I've applied the patches to 
tip:sched/core and will push them out later today if they pass testing 
here.

> Note that with kernel 3.12-rc3 that numa balancing will fail to boot if 
> CONFIG_JUMP_LABEL is configured. This is a separate bug that is 
> currently being dealt with.

Okay, this is about:

  https://lkml.org/lkml/2013/9/30/308

Note that Peter and me saw no crashes so far, and we boot with 
CONFIG_JUMP_LABEL=y and CONFIG_NUMA_BALANCING=y. It seems like an 
unrelated bug in any case, perhaps related to specific details in your 
kernel image?

2)

I also noticed a small Kconfig annoyance:

config NUMA_BALANCING_DEFAULT_ENABLED
        bool "Automatically enable NUMA aware memory/task placement"
        default y
        depends on NUMA_BALANCING
        help
          If set, autonumic NUMA balancing will be enabled if running on a NUMA
          machine.

config NUMA_BALANCING
        bool "Memory placement aware NUMA scheduler"
        depends on ARCH_SUPPORTS_NUMA_BALANCING
        depends on !ARCH_WANT_NUMA_VARIABLE_LOCALITY
        depends on SMP && NUMA && MIGRATION
        help
          This option adds support for automatic NUM

the NUMA_BALANCING_DEFAULT_ENABLED option should come after the 
NUMA_BALANCING entries - things like 'make oldconfig' produce weird output 
otherwise.

3)

Plus in addition to PeterZ's build fix I noticed this new build warning on 
i386 UP kernels:

 kernel/sched/fair.c:819:22: warning: 'task_h_load' declared 'static' but never defined [-Wunused-function]

Introduced here I think:

    sched/numa: Use a system-wide search to find swap/migration candidates

Thanks,

	Ingo
