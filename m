Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaLOBT5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 20:19:57 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:7002 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750702AbaLOBTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 20:19:49 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="45139974"
Message-ID: <548E3825.9020204@cn.fujitsu.com>
Date: Mon, 15 Dec 2014 09:23:49 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 3/5] workqueue: fixup existing pool->node
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com> <1418379595-6281-4-git-send-email-laijs@cn.fujitsu.com> <20141212172546.GC20020@htj.dyndns.org>
In-Reply-To: <20141212172546.GC20020@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2014 01:25 AM, Tejun Heo wrote:
> On Fri, Dec 12, 2014 at 06:19:53PM +0800, Lai Jiangshan wrote:
>> Yasuaki Ishimatsu hit a bug when the numa mapping between CPU and node
>> is changed.  And the previous path fixup wq_numa_possible_cpumask.
>> (See more information form the changelog of that patch)
>>
>> After wq_numa_possible_cpumask was updated, the new pool->node will be
>> correct, but the existing pools (and workers) are still running, some of
>> them are running with the wrong pool->node, or even worse, with pool->node
>> which is quitted node, they create_worker() on wrong pool->node.
>> These create_worker() may create workers on wrong node or failed without
>> any progress (when with pool->node which is quitted node).
>>
>> So we need to update the pool->node when the numa mapping is changed.
>>
>> We simply re-calc the pool->node when the numa mapping changed. It reuses
>> the code from get_unbound_pool() for unbound pool.
> 
> I don't get this patch.  If a node is gone, all its cpus would be gone
> and the pool should be discarded.  If a new node comes online with
> different mappings, new sets of pools should serve them instead of
> recycling the old ones.  Wouldn't it make a lot more sense to make
> sure we don't reuse the pools w/ old mappings for new pwqs?
> 


The pwqs of the old node's cpumask do be discarded. But the pools of the old
node's cpumask maybe recycle. For example, a new workqueue's affinity is set to
the old node's cpumask before the pool is dead. Any old pool can long live.


> Thanks.
> 

