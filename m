Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924AbaCEXRp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 18:17:45 -0500
Received: from service87.mimecast.com ([91.220.42.44]:52131 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbaCEXRo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 18:17:44 -0500
Message-ID: <5317B092.7070805@arm.com>
Date: Wed, 05 Mar 2014 23:17:38 +0000
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC 0/6] rework sched_domain topology description
References: <1394003906-11630-1-git-send-email-vincent.guittot@linaro.org>
In-Reply-To: <1394003906-11630-1-git-send-email-vincent.guittot@linaro.org>
X-OriginalArrivalTime: 05 Mar 2014 23:17:47.0816 (UTC) FILETIME=[1F162280:01CF38C9]
X-MC-Unique: 114030523174201301
Content-Type: text/plain; charset=WINDOWS-1252; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/14 07:18, Vincent Guittot wrote:
> This patchset was previously part of the larger tasks packing patchset [1].
> I have splitted the latter in 3 different patchsets (at least) to make the
> thing easier.
> -configuration of sched_domain topology (this patchset)
> -update and consolidation of cpu_power
> -tasks packing algorithm
>
> Based on Peter Z's proposal [2][3], this patchset modifies the way to configure
> the sched_domain level in order to let architectures to add specific level like
> the current BOOK level or the proposed power gating level for ARM architecture.
>
> [1] https://lkml.org/lkml/2013/10/18/121
> [2] https://lkml.org/lkml/2013/11/5/239
> [3] https://lkml.org/lkml/2013/11/5/449
>
> Vincent Guittot (6):
>    sched: remove unused SCHED_INIT_NODE
>    sched: rework of sched_domain topology definition
>    sched: s390: create a dedicated topology table
>    sched: powerpc: create a dedicated topology table
>    sched: add a new SD_SHARE_POWERDOMAIN for sched_domain
>    sched: ARM: create a dedicated scheduler topology table
>
>   arch/arm/kernel/topology.c        |   26 ++++
>   arch/ia64/include/asm/topology.h  |   24 ----
>   arch/metag/include/asm/topology.h |   27 -----
>   arch/powerpc/kernel/smp.c         |   35 ++++--
>   arch/s390/include/asm/topology.h  |   13 +-
>   arch/s390/kernel/topology.c       |   25 ++++
>   arch/tile/include/asm/topology.h  |   33 ------
>   include/linux/sched.h             |   30 +++++
>   include/linux/topology.h          |  128 ++------------------
>   kernel/sched/core.c               |  235 ++++++++++++++++++-------------------
>   10 files changed, 237 insertions(+), 339 deletions(-)
>

Hi Vincent,

I reviewed your patch-set carefully (including test runs on TC2), 
especially due to the fact that we want to build our sd_energy stuff on 
top of it.


One thing I'm still not convinced of is the fact that specifying 
additional sd levels in the struct sched_domain_topology_level table has 
an advantage over a function pointer for sd topology flags similar to 
the one we're already using for the cpu mask in struct 
sched_domain_topology_level.

   int (*sched_domain_flags_f)(int cpu);

This function pointer would be simply another member of struct 
sched_domain_topology_level and would replace int sd_flags.  AFAICS, you 
have to create additional cpu mask functions anyway for the additional 
sd levels, like cpu_corepower_mask() for the  GMC level in the ARM case. 
  There could be a set of standard sd topology flags function for the 
default sd layer and archs which want to pass in something special 
define those function locally since they will use them only in their 
arch specific struct sched_domain_topology_level table anyway.  I know 
that you use the existing sd degenerate functionality for this and that 
the freeing of the redundant data structures (sched_domain, sched_group 
and sched_group_power) is there too but it still doesn't seem to me to 
be the right thing to do.

The problem that we now expose internal data structures (struct sd_data 
and struct sched_domain_topology_level) could be dealt with later.

-- Dietmar

