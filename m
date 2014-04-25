Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbaDYLSw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 07:18:52 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46441 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbaDYLSs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 07:18:48 -0400
Date: Fri, 25 Apr 2014 12:18:43 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Zi Shen Lim <zlim@broadcom.com>
Cc: Mark Brown <broonie@linaro.org>, Catalin Marinas <Catalin.Marinas@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 2/2] arm64: topology: add MPIDR-based detection
Message-ID: <20140425111842.GB23464@e102568-lin.cambridge.arm.com>
References: <1398395922-7482-1-git-send-email-zlim@broadcom.com>
 <1398395922-7482-3-git-send-email-zlim@broadcom.com>
MIME-Version: 1.0
In-Reply-To: <1398395922-7482-3-git-send-email-zlim@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 25 Apr 2014 11:18:58.0627 (UTC) FILETIME=[27276930:01CF6078]
X-MC-Unique: 114042512184507001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 04:18:42AM +0100, Zi Shen Lim wrote:
> Create cpu topology based on MPIDR. When hardware sets MPIDR to sane
> values, this method will always work. Therefore it should also work well
> as the fallback method. [1]

It has to be implemented as fallback, so you have to rebase this patch
on top of Mark's series.

> When we have multiple processing elements in the system, we create
> the cpu topology by mapping each affinity level (from lowest to highest)
> to threads (if they exist), cores, and clusters.
> 
> We combine data from all higher affinity levels into cluster_id
> so we don't lose any information from MPIDR. [2]
> 
> [1] http://www.spinics.net/lists/arm-kernel/msg317445.html
> [2] https://lkml.org/lkml/2014/4/23/703
> 
> Signed-off-by: Zi Shen Lim <zlim@broadcom.com>
> ---
> v1->v2: Addressed comments from Mark Brown.
>  - Reduce noise. Use pr_debug instead of pr_info.
>  - Don't ignore higher affinity levels.
> 
>  arch/arm64/include/asm/cputype.h |  2 ++
>  arch/arm64/kernel/topology.c     | 34 ++++++++++++++++++++++++++++++++++
>  2 files changed, 36 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
> index c404fb0..7639e8b 100644
> --- a/arch/arm64/include/asm/cputype.h
> +++ b/arch/arm64/include/asm/cputype.h
> @@ -18,6 +18,8 @@
>  
>  #define INVALID_HWID		ULONG_MAX
>  
> +#define MPIDR_UP_BITMASK	(0x1 << 30)
> +#define MPIDR_MT_BITMASK	(0x1 << 24)
>  #define MPIDR_HWID_BITMASK	0xff00ffffff
>  
>  #define MPIDR_LEVEL_BITS_SHIFT	3
> diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
> index 3e06b0b..7dbf981 100644
> --- a/arch/arm64/kernel/topology.c
> +++ b/arch/arm64/kernel/topology.c
> @@ -19,6 +19,8 @@
>  #include <linux/nodemask.h>
>  #include <linux/sched.h>
>  
> +#include <asm/cputype.h>
> +#include <asm/smp_plat.h>
>  #include <asm/topology.h>
>  
>  /*
> @@ -71,6 +73,38 @@ static void update_siblings_masks(unsigned int cpuid)
>  
>  void store_cpu_topology(unsigned int cpuid)
>  {
> +	struct cpu_topology *cpuid_topo = &cpu_topology[cpuid];
> +	u64 mpidr;
> +
> +	mpidr = read_cpuid_mpidr();
> +
> +	/* Create cpu topology mapping based on MPIDR. */
> +	if (mpidr & MPIDR_UP_BITMASK) {
> +		/* Uniprocessor system */
> +		cpuid_topo->thread_id  = -1;
> +		cpuid_topo->core_id    = MPIDR_AFFINITY_LEVEL(mpidr, 0);
> +		cpuid_topo->cluster_id = -1;
> +	} else if (mpidr & MPIDR_MT_BITMASK) {
> +		/* Multiprocessor system : Multi-threads per core */
> +		cpuid_topo->thread_id  = MPIDR_AFFINITY_LEVEL(mpidr, 0);
> +		cpuid_topo->core_id    = MPIDR_AFFINITY_LEVEL(mpidr, 1);
> +		cpuid_topo->cluster_id =
> +			MPIDR_AFFINITY_LEVEL(mpidr, 2) |
> +			MPIDR_AFFINITY_LEVEL(mpidr, 3) << mpidr_hash.shift_aff[3];

That's probably not what you want, even though you still end up with a
unique cluster identifier (but insanely large) if you get lucky and it
does not overflow an int. The shift is the amount of bits the level must be
shift _right_ to create the hash value.

I am wondering whether it is time for me to add those as macros.

> +	} else {
> +		/* Multiprocessor system : Single-thread per core */
> +		cpuid_topo->thread_id  = -1;
> +		cpuid_topo->core_id    = MPIDR_AFFINITY_LEVEL(mpidr, 0);
> +		cpuid_topo->cluster_id =
> +			MPIDR_AFFINITY_LEVEL(mpidr, 1) |
> +			MPIDR_AFFINITY_LEVEL(mpidr, 2) << mpidr_hash.shift_aff[2] |
> +			MPIDR_AFFINITY_LEVEL(mpidr, 3) << mpidr_hash.shift_aff[3];

Ditto.

> +	}
> +
> +	pr_debug("CPU%u: cluster %d core %d thread %d mpidr %llx\n",
> +		 cpuid, cpuid_topo->cluster_id, cpuid_topo->core_id,
> +		 cpuid_topo->thread_id, mpidr);
> +
>  	update_siblings_masks(cpuid);

That's why I object. With this implementation MPIDR_EL1 takes over DT,
and we do not want that. It has to work the other way around.

What you should do, in update_sibling_masks(), check if the topology has
been reset (ie it is not set-up), and parse the MPIDR if that's the case.

Thanks,
Lorenzo

