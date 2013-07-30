Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973Ab3G3Hty (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 03:49:54 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:56574 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575Ab3G3Htv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 03:49:51 -0400
Message-ID: <51F76F61.40206@linaro.org>
Date: Tue, 30 Jul 2013 15:46:41 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
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
Subject: Re: [RFC][PATCH 2/2] ARM64: introduce cluster id and make a difference
 between socket id
References: <1374921728-9007-1-git-send-email-hanjun.guo@linaro.org> <1374921728-9007-2-git-send-email-hanjun.guo@linaro.org> <CAKfTPtBXi4C3ncLmsWZQEs3x80VbPhHo+gC9hG_EFwMdafJmOQ@mail.gmail.com>
In-Reply-To: <CAKfTPtBXi4C3ncLmsWZQEs3x80VbPhHo+gC9hG_EFwMdafJmOQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-7-29 17:38, Vincent Guittot wrote:
> On 27 July 2013 12:42, Hanjun Guo <hanjun.guo@linaro.org> wrote:
>> In the cpu topology information, we define topology_physical_package_id()
>> as cpu socket id, which means that the socket id is the idenfication for
>> physical processor, not for a cluster in a cpu die.
>>
>> On ARM64 platform, multi cluster in a cpu die will be normal, here is a
>> example with 2 cores in a cluster and 2 cluster in a socket:
>>
>> |--------------------------------------|
>> |                socket                |
>> |                                      |
>> | |---------------|  |---------------| |
>> | |    cluster    |  |    cluster    | |
>> | |               |  |               | |
>> | | |----| |----| |  | |----| |----| | |
>> | | |core| |core| |  | |core| |core| | |
>> | | |----| |----| |  | |----| |----| | |
>> | |               |  |               | |
>> | |---------------|  |---------------| |
>> |                                      |
>> |--------------------------------------|
>>
>> ARM64 extended the MPIDR into 64 bit and introduce another affinity level,
>> we can use this affinity level for socket id and use the third highest level
>> affinity for cluster id, which  make the socket id behavior in its original
>> way.
>>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> ---
>>  arch/arm64/include/asm/topology.h |    1 +
>>  arch/arm64/kernel/topology.c      |    8 ++++++--
>>  2 files changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/topology.h b/arch/arm64/include/asm/topology.h
>> index 8631808..ff68ecc 100644
>> --- a/arch/arm64/include/asm/topology.h
>> +++ b/arch/arm64/include/asm/topology.h
>> @@ -8,6 +8,7 @@
>>  struct cputopo_arm64 {
>>         int thread_id;
>>         int core_id;
>> +       int cluster_id;
>>         int socket_id;
>>         cpumask_t thread_sibling;
>>         cpumask_t core_sibling;
>> diff --git a/arch/arm64/kernel/topology.c b/arch/arm64/kernel/topology.c
>> index 1eb0435..6d1e5a6 100644
>> --- a/arch/arm64/kernel/topology.c
>> +++ b/arch/arm64/kernel/topology.c
>> @@ -80,12 +80,14 @@ void store_cpu_topology(unsigned int cpuid)
>>                         /* core performance interdependency */
>>                         cpuid_topo->thread_id = MPIDR_AFFINITY_LEVEL_0(mpidr);
>>                         cpuid_topo->core_id = MPIDR_AFFINITY_LEVEL_1(mpidr);
>> -                       cpuid_topo->socket_id = MPIDR_AFFINITY_LEVEL_2(mpidr);
>> +                       cpuid_topo->cluster_id = MPIDR_AFFINITY_LEVEL_2(mpidr);
>> +                       cpuid_topo->socket_id = MPIDR_AFFINITY_LEVEL_3(mpidr);
> 
> socket_id is currently used by update_siblings_masks to update the
> core_sibling mask. This mask defines which CPUs share their cache and
> AFAICT, the cache are shared at the cluster level so cluster_id should
> be used instead socket_id.

For some architecture, cpu cores in a cluster share L2 cache, and clusters
in the cpu die share L3 cache, so I think we can make a difference between
socket id and cluster id.

> 
> Have you got more information about the goal of this new level_3 ?

Actually not, I think ARM should give some recommendations as ARMv7 did.

Thanks
Hanjun
