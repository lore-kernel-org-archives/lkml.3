Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaDYPz7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:55:59 -0400
Received: from service87.mimecast.com ([91.220.42.44]:38128 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaDYPzy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:55:54 -0400
Message-ID: <535A8585.6030103@arm.com>
Date: Fri, 25 Apr 2014 16:55:49 +0100
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>
CC: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v4 5/5] sched: ARM: create a dedicated scheduler topology
 table
References: <1397209481-28542-1-git-send-email-vincent.guittot@linaro.org> <1397209481-28542-6-git-send-email-vincent.guittot@linaro.org> <5357A802.1030804@arm.com> <CAKfTPtDnw-OZZekdE3oNGS11m6dfpS4veMNZ_Bezs-Lm7zn6QQ@mail.gmail.com> <5357DBA5.1010106@arm.com> <CAKfTPtAOZqnP=sWeJuqFAqrGT8vLQZKj+tpqiwOTG37paXoGjg@mail.gmail.com> <53590835.9090803@arm.com> <CAKfTPtAq8PXS-n7A0W6ESe08m-6O3u84BcY3==+-0+63+uca9g@mail.gmail.com>
In-Reply-To: <CAKfTPtAq8PXS-n7A0W6ESe08m-6O3u84BcY3==+-0+63+uca9g@mail.gmail.com>
X-OriginalArrivalTime: 25 Apr 2014 15:56:05.0164 (UTC) FILETIME=[DD579EC0:01CF609E]
X-MC-Unique: 114042516555112701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/04/14 08:45, Vincent Guittot wrote:

[...]

>>
>> Back than I had
>>   CPU0: cpu_corepower_mask=0-1
>>   CPU2: cpu_corepower_mask=2
>> so for GMC level the cpumasks are inconsistent across CPUs and it worked.
> 
> The example above is consistent because CPU2 mask and CPU0 mask are
> fully exclusive

OK, got it now. The cpu mask functions on an sd level can return
different (but then exclusive) cpu masks or they all return the same cpu
mask (DIE level in example). Like you said we still have to respect the
topology of the system.

This essentially excludes the DIE level (i.e. the sd level which spawns
all CPUs) from playing this 'sd level folding via sd degenerate' game
for a system which specifies FORCE_SD_OVERLAP to false or don't use this
SDTL_OVERLAP tl flag.

> 
> so
> CPU0: cpu_corepower_mask=0-1
> CPU2: cpu_corepower_mask=2
> are consistent
> 
> CPU0: cpu_corepower_mask=0-2
> CPU2: cpu_corepower_mask=0-2
> are also consistent
> 
> but
> 
> CPU0: cpu_corepower_mask=0-1
> CPU2: cpu_corepower_mask=0-2
> are not consistent
> 
> and your example uses the last configuration
> 
> To be more precise, the rule above applies on default SDT definition
> but the flag SD_OVERLAP enables such kind of overlap between group.
> Have you tried it ?

Setting FORCE_SD_OVERLAP indeed changes the scenario a bit (we're now
using build_overlap_sched_groups() instead of build_sched_groups()). It
looks better, but the groups for CPU0/1 in DIE level are wrong (to get
so far I still have to comment out the check that 'if cpu_map is equal
to sd span of sd then break' in build_sched_domains() though).

dmesg snippet:

 CPU0 attaching sched-domain:
  domain 0: span 0-1 level MC
   groups: 0 1
   domain 1: span 0-4 level DIE
    groups: 0-4 (cpu_power = 5120) 0-1 (cpu_power = 2048) <-- error !!!
 CPU1 attaching sched-domain:
  domain 0: span 0-1 level MC
   groups: 1 0
   domain 1: span 0-4 level DIE
    groups: 0-1 (cpu_power = 2048) 0-4 (cpu_power = 5120) <-- error !!!
 CPU2 attaching sched-domain:
  domain 0: span 2-4 level GMC
   groups: 2 3 4
   domain 1: span 0-4 level GDIE
    groups: 2-4 (cpu_power = 3072) 0-1 (cpu_power = 2048)
 ...

The feature I'm currently working on is to add sd energy information to
sd levels of the sd topology level table. I essentially added another
column of sd energy related func ptr's (next to the flags related one)
and wanted to use 'sd level folding via sd degenerate' in MC and DIE
level to have different sd energy information per CPU.

In any case, this dependency to FORCE_SD_OVERLAP would be less then nice
for this feature though :-( A way out would be a 'int cpu' parameter but
we already discussed this back then for the flag function.

Thanks,

-- Dietmar

> 
> Vincent
> 

[...]

