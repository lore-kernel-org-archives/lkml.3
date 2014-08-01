Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbaHABhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 21:37:45 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:31475 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750907AbaHABho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 21:37:44 -0400
X-IronPort-AV: E=Sophos;i="5.04,240,1406563200"; 
   d="scan'208";a="34043618"
Message-ID: <53DAEFB5.7060501@cn.fujitsu.com>
Date: Fri, 1 Aug 2014 09:39:01 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>
CC: Michal Hocko <mhocko@suse.cz>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Jianyu Zhan <nasa4836@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Khalid Aziz <khalid.aziz@oracle.com>, <linux-mm@kvack.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH] swap: remove the struct cpumask has_work
References: <1406777421-12830-3-git-send-email-laijs@cn.fujitsu.com> <20140731115137.GA20244@dhcp22.suse.cz> <53DA6A2F.100@tilera.com>
In-Reply-To: <53DA6A2F.100@tilera.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2014 12:09 AM, Chris Metcalf wrote:
> On 7/31/2014 7:51 AM, Michal Hocko wrote:
>> On Thu 31-07-14 11:30:19, Lai Jiangshan wrote:
>>> It is suggested that cpumask_var_t and alloc_cpumask_var() should be used
>>> instead of struct cpumask.  But I don't want to add this complicity nor
>>> leave this unwelcome "static struct cpumask has_work;", so I just remove
>>> it and use flush_work() to perform on all online drain_work.  flush_work()
>>> performs very quickly on initialized but unused work item, thus we don't
>>> need the struct cpumask has_work for performance.
>> Why? Just because there is general recommendation for using
>> cpumask_var_t rather than cpumask?
>>
>> In this particular case cpumask shouldn't matter much as it is static.
>> Your code will work as well, but I do not see any strong reason to
>> change it just to get rid of cpumask which is not on stack.
> 
> The code uses for_each_cpu with a cpumask to avoid waking cpus that don't
> need to do work.  This is important for the nohz_full type functionality,
> power efficiency, etc.  So, nack for this change.
> 

flush_work() on initialized but unused work item just disables irq and
fetches work->data to test and restores irq and return.

the struct cpumask has_work is just premature optimization.
