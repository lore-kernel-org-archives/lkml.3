Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751067Ab3BPFQq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 00:16:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:30350 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741Ab3BPFQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 00:16:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,676,1355126400"; 
   d="scan'208";a="263458739"
Message-ID: <511F1637.5000308@intel.com>
Date: Sat, 16 Feb 2013 13:16:39 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch v4 01/18] sched: set SD_PREFER_SIBLING on MC domain to
 reduce a domain level
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>   <1358996820-23036-2-git-send-email-alex.shi@intel.com>  <1360663879.4485.2.camel@laptop> <511B9392.1080003@intel.com> <1360931899.2739.8.camel@laptop>
In-Reply-To: <1360931899.2739.8.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2013 08:38 PM, Peter Zijlstra wrote:
> On Wed, 2013-02-13 at 21:22 +0800, Alex Shi wrote:
>> No, the flags set on MC/CPU domain, but is checked in their parents
>> balancing, like in NUMA domain.
>> Without the flag, will cause NUMA domain imbalance. like on my 2
>> sockets
>> NHM EP: 3 of 4 tasks were assigned on socket 0(lcpu, 10, 12, 14)
>>
>> In this case, update_sd_pick_busiest() need a reduced group_capacity
>> to
>> return true:
>>         if (sgs->sum_nr_running > sgs->group_capacity)
>>                 return true;
>> then numa domain balancing get chance to start.
> 
> Ah, indeed. Its always better to include such 'obvious' problems in the
> changelog :-)
> 

got it. :)
how about the following commit log and patch:

---

>From c97fceceaf9d68e73eaf015d5915474a9a94a2d1 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Fri, 28 Dec 2012 13:53:00 +0800
Subject: [PATCH] sched: set SD_PREFER_SIBLING on MC domain to reduce a domain
 level

The domain flag SD_PREFER_SIBLING was set both on MC and CPU domain at
frist commit b5d978e0c7e79a, and was removed in-carefully when clear up
obsolete power scheduler. Then commit 6956dc568 recover the flag on CPU
domain only. It works, but it introduces a extra domain level since this
cause MC/CPU different.

So, recover the the flag in MC domain too to remove a domain level in
x86 platform.

This flag can not be removed since it is used to keep parent domain
balancing, like in NUMA domain, update_sd_pick_busiest() need a reduced
group_capacity to return 'true' then re-balance tasks from groups.

Reported-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/topology.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/topology.h b/include/linux/topology.h
index d3cf0d6..386bcf4 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -132,6 +132,7 @@ int arch_update_cpu_topology(void);
 				| 0*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
+				| 1*SD_PREFER_SIBLING			\
 				,					\
 	.last_balance		= jiffies,				\
 	.balance_interval	= 1,					\
-- 
1.7.5.4


