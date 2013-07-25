Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab3GYCKp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 22:10:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:33367 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753983Ab3GYCKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 22:10:39 -0400
X-IronPort-AV: E=Sophos;i="4.89,739,1367942400"; 
   d="scan'208";a="8014114"
Message-ID: <51F089C1.4010402@cn.fujitsu.com>
Date: Thu, 25 Jul 2013 10:13:21 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 14/21] x86, acpi, numa: Reserve hotpluggable memory at
 early time.
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com> <1374220774-29974-15-git-send-email-tangchen@cn.fujitsu.com> <20130723205557.GS21100@mtj.dyndns.org> <20130723213212.GA21100@mtj.dyndns.org>
In-Reply-To: <20130723213212.GA21100@mtj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/25 10:08:31,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/25 10:08:34,
	Serialize complete at 2013/07/25 10:08:34
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 05:32 AM, Tejun Heo wrote:
> On Tue, Jul 23, 2013 at 04:55:57PM -0400, Tejun Heo wrote:
>> On Fri, Jul 19, 2013 at 03:59:27PM +0800, Tang Chen wrote:
>>> +		/*
>>> +		 * In such an early time, we don't have nid. We specify pxm
>>> +		 * instead of MAX_NUMNODES to prevent memblock merging regions
>>> +		 * on different nodes. And later modify pxm to nid when nid is
>>> +		 * mapped so that we can arrange ZONE_MOVABLE on different
>>> +		 * nodes.
>>> +		 */
>>> +		memblock_reserve_hotpluggable(base_address, length, pxm);
>>
>> This is rather hacky.  Why not just introduce MEMBLOCK_NO_MERGE flag?

The original thinking is to merge regions with the same nid. So I used pxm.
And then refresh the nid field when nids are mapped.

I will try to introduce MEMBLOCK_NO_MERGE and make it less hacky.

>
> Also, if memblock is gonna know about hotplug memory, why not just let
> it control its allocation too instead of blocking it by reserving it
> from outside?  These are all pretty general memory hotplug logic which
> doesn't have much to do with acpi and I think too much is implemented
> on the acpi side.

At the very beginning, a long time ago, we just did this.
Please refer to: https://lkml.org/lkml/2012/12/10/656

In order to let memblock control the allocation, we have to store the
hotpluggable ranges somewhere, and keep the allocated range out of the
hotpluggable regions. I just think reserving the hotpluggable regions
and then memblock won't allocate them. No need to do any other limitation.

And also, the acpi side modification in this patch-set is to get SRAT
and parse it. I think most of the logic in 
acpi_reserve_hotpluggable_memory()
is necessary. I don't think letting memblock control the allocation will
make the acpi side easier.

Thanks.
