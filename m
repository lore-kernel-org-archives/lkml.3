Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820AbaFIR4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 13:56:20 -0400
Received: from service87.mimecast.com ([91.220.42.44]:39281 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbaFIR4P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 13:56:15 -0400
Message-ID: <5395F541.60604@arm.com>
Date: Mon, 09 Jun 2014 18:56:17 +0100
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Yuyang Du <yuyang.du@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [RFC PATCH 07/16 v3] Init Workload Consolidation flags in sched_domain
References: <1401431772-14320-1-git-send-email-yuyang.du@intel.com> <1401431772-14320-8-git-send-email-yuyang.du@intel.com> <20140603121416.GH30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140603121416.GH30445@twins.programming.kicks-ass.net>
X-OriginalArrivalTime: 09 Jun 2014 17:56:08.0563 (UTC) FILETIME=[177DD430:01CF840C]
X-MC-Unique: 114060918561304901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... turned out that probably the cc list was too big for lkml. Dropping
all the individual email addresses on CC.

... it seems that this message hasn't made it to the list. Apologies to
everyone on To: and Cc: receiving it again.

On 03/06/14 13:14, Peter Zijlstra wrote:
> On Fri, May 30, 2014 at 02:36:03PM +0800, Yuyang Du wrote:
>> Workload Consolidation can be enabled/disabled on the fly. This patchset
>> enables MC and CPU domain WC by default.
>>
>> To enable CPU WC (SD_WORKLOAD_CONSOLIDATION=0x8000):
>>
>> sysctl -w kernel.sched_domain.cpuX.domainY.flags += 0x8000
>>
>> To disable CPU WC:
>>
>> sysctl -w kernel.sched_domain.cpuX.domainY.flags -= 0x8000
>>
>> Signed-off-by: Yuyang Du <yuyang.du@intel.com>
>> ---
>>  include/linux/topology.h |    6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/include/linux/topology.h b/include/linux/topology.h
>> index 7062330..ebc339c3 100644
>> --- a/include/linux/topology.h
>> +++ b/include/linux/topology.h
>> @@ -102,12 +102,14 @@ int arch_update_cpu_topology(void);
>>  				| 0*SD_SERIALIZE			\
>>  				| 0*SD_PREFER_SIBLING			\
>>  				| arch_sd_sibling_asym_packing()	\
>> +				| 0*SD_WORKLOAD_CONSOLIDATION	\
>>  				,					\
>>  	.last_balance		= jiffies,				\
>>  	.balance_interval	= 1,					\
>>  	.smt_gain		= 1178,	/* 15% */			\
>>  	.max_newidle_lb_cost	= 0,					\
>>  	.next_decay_max_lb_cost	= jiffies,				\
>> +	.consolidating_coeff = 0,					\
>>  }
>>  #endif
>>  #endif /* CONFIG_SCHED_SMT */
>> @@ -134,11 +136,13 @@ int arch_update_cpu_topology(void);
>>  				| 0*SD_SHARE_CPUPOWER			\
>>  				| 1*SD_SHARE_PKG_RESOURCES		\
>>  				| 0*SD_SERIALIZE			\
>> +				| 1*SD_WORKLOAD_CONSOLIDATION	\
>>  				,					\
>>  	.last_balance		= jiffies,				\
>>  	.balance_interval	= 1,					\
>>  	.max_newidle_lb_cost	= 0,					\
>>  	.next_decay_max_lb_cost	= jiffies,				\
>> +	.consolidating_coeff = 180,					\
>>  }
>>  #endif
>>  #endif /* CONFIG_SCHED_MC */
>> @@ -167,11 +171,13 @@ int arch_update_cpu_topology(void);
>>  				| 0*SD_SHARE_PKG_RESOURCES		\
>>  				| 0*SD_SERIALIZE			\
>>  				| 1*SD_PREFER_SIBLING			\
>> +				| 1*SD_WORKLOAD_CONSOLIDATION	\
>>  				,					\
>>  	.last_balance		= jiffies,				\
>>  	.balance_interval	= 1,					\
>>  	.max_newidle_lb_cost	= 0,					\
>>  	.next_decay_max_lb_cost	= jiffies,				\
>> +	.consolidating_coeff = 180,					\
>>  }
>>  #endif
> 
> What tree are you working against, non of that exists anymore. Also, you
> cannot unconditionally set this.
> 

Hi Yuyang,

I'm running these patches on my ARM TC2 on top of
kernel/git/torvalds/linux.git (v3.15-rc7-79-gfe45736f4134). There're
considerable changes in the area of sched domain setup since Vincent's
patchset 'rework sched_domain topology description' (destined for v3.16)
which you can find on kernel/git/tip/tip.git .

Why did you make SD_WORKLOAD_CONSOLIDATION controllable via sysctl? All
the other SD flags are set during setup. Your top_flag_domain() function
takes care of figuring out what is the highest sd level this is set on
during load-balance but I can't find any good reason to do it this way
other then for testing purposes?

Setting SD_WORKLOAD_CONSOLIDATION  (which is probably a behavioural flag
rather than a topology description related one) on a certain sd level
requires you to also think about its implications in sd_init() and in sd
degenerate functionality.

-- Dietmar



