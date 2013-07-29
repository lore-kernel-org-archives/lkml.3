Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab3G2Jia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:38:30 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:60535 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab3G2Ji3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:38:29 -0400
MIME-Version: 1.0
In-Reply-To: <1374921728-9007-2-git-send-email-hanjun.guo@linaro.org>
References: <1374921728-9007-1-git-send-email-hanjun.guo@linaro.org>
	<1374921728-9007-2-git-send-email-hanjun.guo@linaro.org>
Date: Mon, 29 Jul 2013 11:38:28 +0200
Message-ID: <CAKfTPtBXi4C3ncLmsWZQEs3x80VbPhHo+gC9hG_EFwMdafJmOQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/2] ARM64: introduce cluster id and make a
 difference between socket id
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Patch Tracking <patches@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linaro-acpi@lists.linaro.org, Al Stone <al.stone@linaro.org>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Naresh Bhat <naresh.bhat@linaro.org>,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 July 2013 12:42, Hanjun Guo <hanjun.guo@linaro.org> wrote:
> In the cpu topology information, we define topology_physical_package_id()
> as cpu socket id, which means that the socket id is the idenfication for
> physical processor, not for a cluster in a cpu die.
>
> On ARM64 platform, multi cluster in a cpu die will be normal, here is a
> example with 2 cores in a cluster and 2 cluster in a socket:
>
> |--------------------------------------|
> |                socket                |
> |                                      |
> | |---------------|  |---------------| |
> | |    cluster    |  |    cluster    | |
> | |               |  |               | |
> | | |----| |----| |  | |----| |----| | |
> | | |core| |core| |  | |core| |core| | |
> | | |----| |----| |  | |----| |----| | |
> | |               |  |               | |
> | |---------------|  |---------------| |
> |                                      |
> |--------------------------------------|
>
> ARM64 extended the MPIDR into 64 bit and introduce another affinity level,
> we can use this affinity level for socket id and use the third highest level
> affinity for cluster id, which  make the socket id behavior in its original
> way.
>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  arch/arm64/include/asm/topology.h |    1 +
>  arch/arm64/kernel/topology.c      |    8 ++++++--
>  2 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm64/include/asm/topology.h b/arch/arm64/include/asm/topology.h
> index 8631808..ff68ecc 100644
> --- a/arch/arm64/include/asm/topology.h
> +++ b/arch/arm64/include/asm/topology.h
> @@ -8,6 +8,7 @@
>  struct cputopo_arm64 {
>         int thread_id;
>         int core_id;
> +       int cluster_id;
>         int socket_id;
>         cpumask_t thread_sibling;
>         cpumask_t core_sibling;
> diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
> index 1eb0435..6d1e5a6 100644
> --- a/arch/arm64/kernel/topology.c
> +++ b/arch/arm64/kernel/topology.c
> @@ -80,12 +80,14 @@ void store_cpu_topology(unsigned int cpuid)
>                         /* core performance interdependency */
>                         cpuid_topo->thread_id = MPIDR_AFFINITY_LEVEL_0(mpidr);
>                         cpuid_topo->core_id = MPIDR_AFFINITY_LEVEL_1(mpidr);
> -                       cpuid_topo->socket_id = MPIDR_AFFINITY_LEVEL_2(mpidr);
> +                       cpuid_topo->cluster_id = MPIDR_AFFINITY_LEVEL_2(mpidr);
> +                       cpuid_topo->socket_id = MPIDR_AFFINITY_LEVEL_3(mpidr);

socket_id is currently used by update_siblings_masks to update the
core_sibling mask. This mask defines which CPUs share their cache and
AFAICT, the cache are shared at the cluster level so cluster_id should
be used instead socket_id.

Have you got more information about the goal of this new level_3 ?

Vincent

>                 } else {
>                         /* largely independent cores */
>                         cpuid_topo->thread_id = -1;
>                         cpuid_topo->core_id = MPIDR_AFFINITY_LEVEL_0(mpidr);
> -                       cpuid_topo->socket_id = MPIDR_AFFINITY_LEVEL_1(mpidr);
> +                       cpuid_topo->cluster_id = MPIDR_AFFINITY_LEVEL_1(mpidr);
> +                       cpuid_topo->socket_id = MPIDR_AFFINITY_LEVEL_2(mpidr);
>                 }
>         } else {
>                 /*
> @@ -95,6 +97,7 @@ void store_cpu_topology(unsigned int cpuid)
>                  */
>                 cpuid_topo->thread_id = -1;
>                 cpuid_topo->core_id = 0;
> +               cpuid_topo->cluster_id = -1;
>                 cpuid_topo->socket_id = -1;
>         }
>
> @@ -120,6 +123,7 @@ void __init init_cpu_topology(void)
>
>                 topo->thread_id = -1;
>                 topo->core_id =  -1;
> +               topo->cluster_id = -1;
>                 topo->socket_id = -1;
>                 cpumask_clear(&topo->core_sibling);
>                 cpumask_clear(&topo->thread_sibling);
> --
> 1.7.9.5
>
