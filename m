Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753587AbaD3E0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 00:26:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:37041 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978AbaD3E0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 00:26:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,956,1389772800"; 
   d="scan'208";a="532185376"
Message-ID: <53607B7D.6050205@linux.intel.com>
Date: Wed, 30 Apr 2014 12:26:37 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [Bugfix v2] sched: fix possible invalid memory access caused
 by CPU hot-addition
References: <1398653293-12483-1-git-send-email-jiang.liu@linux.intel.com> <20140428070954.GM11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140428070954.GM11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Peter, I will try to find other solutions.

On 2014/4/28 15:09, Peter Zijlstra wrote:
> On Mon, Apr 28, 2014 at 10:48:13AM +0800, Jiang Liu wrote:
>> Intel platforms with Nehalem/Westmere/IvyBridge CPUs may support socket
>> hotplug/online at runtime. The CPU hot-addition flow is:
>> 1) handle CPU hot-addition event
>> 	1.a) gather platform specific information
>> 	1.b) associate hot-added CPU with NUMA node
>> 	1.c) create CPU device
>> 2) online hot-added CPU through sysfs:
>> 	2.a)	cpu_up()
>> 	2.b)		->try_online_node()
>> 	2.c)			->hotadd_new_pgdat()
>> 	2.d)			->node_set_online()
>>
>> Between 1.b and 2.c, hot-added CPUs are associated with NUMA nodes
>> but those NUMA nodes may still be in offlined state. So we should
>> check node_online(nid) before calling kmalloc_node(nid) and friends,
>> otherwise it may cause invalid memory access as below.
> 
> So complete and full NAK on this. This is a workaround for a fucked in
> the head BIOS. If you're going to do a work around for that they should
> live in arch/ space, not in core code.
> 
> The code in question is nearly 7 years old (2.6.24), which leads me to
> believe it works just fine for (regular) memory less nodes as I've not
> had complaints about it before.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
