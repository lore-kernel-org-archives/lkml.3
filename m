Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbaKZFPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 00:15:31 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38178 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbaKZFP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 00:15:29 -0500
Message-ID: <547561D7.1050605@linux.vnet.ibm.com>
Date: Wed, 26 Nov 2014 10:45:03 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Shreyas B. Prabhu" <shreyas@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-pm@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 0/4] powernv: cpuidle: Redesign idle states management
References: <1416914279-30384-1-git-send-email-shreyas@linux.vnet.ibm.com>
In-Reply-To: <1416914279-30384-1-git-send-email-shreyas@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112605-0033-0000-0000-00000126AE7F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I ran hackbench to evaluate this patchset and found good improvements in
the results.

I modified hackbench to take in a 'loops' parameter along with
num_groups which ensures that the test runs long enough to observe and
debug issues. The idea was to find out how latency sensitive workloads
can get affected by modification in cpuidle heuristics since it is easy
to measure the impact on these workloads.

The experiment was conducted on a Power8 system with 1 socket and 6
cores on it.

The first experiment was carried out by pinning hackbench to the first
thread in each core while the rest of the smt threads were idle and
below are the results. This would ensure the core entered deep idle
states more often.

num_grps     %improvement with patchset
3                    3.6
6                   10.6
12                   5.0
24                   5.0

The second experiment was carried out by allowing hackbench to run on
the smt threads of two cores and % improvement with the patchset was in
range of 4-7%.

I ran the experiments on the vanilla kernel. This means the performance
improvements is primarily due to avoiding having to do a timebase sync
by every thread in the core. The power numbers have very little
variation between the runs with and without the patchset.

Thanks

Regards
Preeti U Murthy

On 11/25/2014 04:47 PM, Shreyas B. Prabhu wrote:
> Deep idle states like sleep and winkle are per core idle states. A core
> enters these states only when all the threads enter either the particular
> idle state or a deeper one. There are tasks like fastsleep hardware bug
> workaround and hypervisor core state save which have to be done only by
> the last thread of the core entering deep idle state and similarly tasks
> like timebase resync, hypervisor core register restore that have to be
> done only by the first thread waking up from these states. 
> 
> The current idle state management does not have a way to distinguish the
> first/last thread of the core waking/entering idle states. Tasks like
> timebase resync are done for all the threads. This is not only is suboptimal,
> but can cause functionality issues when subcores are involved.
> 
> Winkle is deeper idle state compared to fastsleep. In this state the power
> supply to the chiplet, i.e core, private L2 and private L3 is turned off.
> This results in a total hypervisor state loss. This patch set adds support
> for winkle and provides a way to track the idle states of the threads of the
> core and use it for idle state management of idle states sleep and winkle.
> 
> 
> Changes in v2:
> --------------
> -Using PNV_THREAD_NAP/SLEEP defines while calling power7_powersave_common
> -Comment changes based on review
> -Rebased on top of 3.18-rc6
> 
> 
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> Cc: linux-pm@vger.kernel.org
> Cc: linuxppc-dev@lists.ozlabs.org
> Cc: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
> Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>
> 
> Paul Mackerras (1):
>   powerpc: powernv: Switch off MMU before entering nap/sleep/rvwinkle
>     mode
> 
> Preeti U. Murthy (1):
>   powerpc/powernv: Enable Offline CPUs to enter deep idle states
> 
> Shreyas B. Prabhu (2):
>   powernv: cpuidle: Redesign idle states management
>   powernv: powerpc: Add winkle support for offline cpus
> 
>  arch/powerpc/include/asm/cpuidle.h             |  14 ++
>  arch/powerpc/include/asm/opal.h                |  13 +
>  arch/powerpc/include/asm/paca.h                |   6 +
>  arch/powerpc/include/asm/ppc-opcode.h          |   2 +
>  arch/powerpc/include/asm/processor.h           |   1 +
>  arch/powerpc/include/asm/reg.h                 |   4 +
>  arch/powerpc/kernel/asm-offsets.c              |   6 +
>  arch/powerpc/kernel/cpu_setup_power.S          |   4 +
>  arch/powerpc/kernel/exceptions-64s.S           |  30 ++-
>  arch/powerpc/kernel/idle_power7.S              | 332 +++++++++++++++++++++----
>  arch/powerpc/platforms/powernv/opal-wrappers.S |  39 +++
>  arch/powerpc/platforms/powernv/powernv.h       |   2 +
>  arch/powerpc/platforms/powernv/setup.c         | 160 ++++++++++++
>  arch/powerpc/platforms/powernv/smp.c           |  10 +-
>  arch/powerpc/platforms/powernv/subcore.c       |  34 +++
>  arch/powerpc/platforms/powernv/subcore.h       |   1 +
>  drivers/cpuidle/cpuidle-powernv.c              |  10 +-
>  17 files changed, 608 insertions(+), 60 deletions(-)
>  create mode 100644 arch/powerpc/include/asm/cpuidle.h
> 

