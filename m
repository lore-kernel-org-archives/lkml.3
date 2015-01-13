Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167AbbAMHHX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 02:07:23 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:11617 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750921AbbAMHHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 02:07:21 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="55969450"
Message-ID: <54B4C46C.1000404@cn.fujitsu.com>
Date: Tue, 13 Jan 2015 15:08:28 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 3/5] workqueue: fixup existing pool->node
References: <1418379595-6281-1-git-send-email-laijs@cn.fujitsu.com> <1418379595-6281-4-git-send-email-laijs@cn.fujitsu.com> <20141212172546.GC20020@htj.dyndns.org> <548E3825.9020204@cn.fujitsu.com> <20141225201406.GB22951@htj.dyndns.org>
In-Reply-To: <20141225201406.GB22951@htj.dyndns.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2014 04:14 AM, Tejun Heo wrote:
> On Mon, Dec 15, 2014 at 09:23:49AM +0800, Lai Jiangshan wrote:
>> The pwqs of the old node's cpumask do be discarded. But the pools of the old
>> node's cpumask maybe recycle. For example, a new workqueue's affinity is set to
>> the old node's cpumask before the pool is dead. Any old pool can long live.
> 
> Hah?  Why can't it just be unhashed so that it can't be looked up for
> new pwqs anymore?
> 

unhashing doesn't reduce the complexity in my code.

	for_each_pool(pool, pi) {
		node = calc_pool_node(pool);
		if (pool->node != node)
-			pool->node = node;
+			unhash_pool(pool);
	}

And any old pool can long live due to:
	some works queues themself back and back
	the old pool has extremely long pending works

So I prefer to fixup existing pool->node.
