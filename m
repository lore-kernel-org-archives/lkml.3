Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933964Ab3BMNWg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 08:22:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:19422 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756892Ab3BMNWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 08:22:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,657,1355126400"; 
   d="scan'208";a="286695925"
Message-ID: <511B9392.1080003@intel.com>
Date: Wed, 13 Feb 2013 21:22:26 +0800
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
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>  <1358996820-23036-2-git-send-email-alex.shi@intel.com> <1360663879.4485.2.camel@laptop>
In-Reply-To: <1360663879.4485.2.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 06:11 PM, Peter Zijlstra wrote:
> On Thu, 2013-01-24 at 11:06 +0800, Alex Shi wrote:
>> The domain flag SD_PREFER_SIBLING was set both on MC and CPU domain at
>> frist commit b5d978e0c7e79a, and was removed uncarefully when clear up
>> obsolete power scheduler. Then commit 6956dc568 recover the flag on CPU
>> domain only. It works, but it introduces a extra domain level since this
>> cause MC/CPU different.
>>
>> So, recover the the flag in MC domain too to remove a domain level in
>> x86 platform.

Peter, I am very very happy to see you again! :)
> 
> This fails to clearly state why its desirable.. I'm guessing its because
> we should use sibling cache domains before sibling threads, right?

No, the flags set on MC/CPU domain, but is checked in their parents
balancing, like in NUMA domain.
Without the flag, will cause NUMA domain imbalance. like on my 2 sockets
NHM EP: 3 of 4 tasks were assigned on socket 0(lcpu, 10, 12, 14)

In this case, update_sd_pick_busiest() need a reduced group_capacity to
return true:
	if (sgs->sum_nr_running > sgs->group_capacity)
		return true;
then numa domain balancing get chance to start.

---------
05:00:28 AM  CPU    %usr   %nice      %idle
05:00:29 AM  all   25.00    0.00      74.94
05:00:29 AM    0    0.00    0.00      99.00
05:00:29 AM    1    0.00    0.00     100.00
05:00:29 AM    2    0.00    0.00     100.00
05:00:29 AM    3    0.00    0.00     100.00
05:00:29 AM    4    0.00    0.00     100.00
05:00:29 AM    5    0.00    0.00     100.00
05:00:29 AM    6    0.00    0.00     100.00
05:00:29 AM    7    0.00    0.00     100.00
05:00:29 AM    8    0.00    0.00     100.00
05:00:29 AM    9    0.00    0.00     100.00
05:00:29 AM   10  100.00    0.00       0.00
05:00:29 AM   11    0.00    0.00     100.00
05:00:29 AM   12  100.00    0.00       0.00
05:00:29 AM   13    0.00    0.00     100.00
05:00:29 AM   14  100.00    0.00       0.00
05:00:29 AM   15  100.00    0.00       0.00



-- 
Thanks
    Alex
