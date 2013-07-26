Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757361Ab3GZDmz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 23:42:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:17153 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756302Ab3GZDmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 23:42:52 -0400
X-IronPort-AV: E=Sophos;i="4.89,748,1367942400"; 
   d="scan'208";a="8029852"
Message-ID: <51F1F0E0.7040800@cn.fujitsu.com>
Date: Fri, 26 Jul 2013 11:45:36 +0800
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
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com> <1374220774-29974-15-git-send-email-tangchen@cn.fujitsu.com> <20130723205557.GS21100@mtj.dyndns.org> <20130723213212.GA21100@mtj.dyndns.org> <51F089C1.4010402@cn.fujitsu.com> <20130725151719.GE26107@mtj.dyndns.org>
In-Reply-To: <20130725151719.GE26107@mtj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/26 11:40:44,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/26 11:40:46,
	Serialize complete at 2013/07/26 11:40:46
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 11:17 PM, Tejun Heo wrote:
> Hello,
>
> On Thu, Jul 25, 2013 at 10:13:21AM +0800, Tang Chen wrote:
>>>> This is rather hacky.  Why not just introduce MEMBLOCK_NO_MERGE flag?
>>
>> The original thinking is to merge regions with the same nid. So I used pxm.
>> And then refresh the nid field when nids are mapped.
>>
>> I will try to introduce MEMBLOCK_NO_MERGE and make it less hacky.
>
> I kinda don't follow why it's necessary to disallow merging BTW.  Can
> you plesae elaborate?  Shouldn't it be enough to mark the regions
> hotpluggable?  Why does it matter whether they get merged or not?  If
> they belong to different nodes, they'll be separated during the
> isolation phase while setting nids, which is the modus operandi of
> memblock anyway.

Sorry, I didn't make it clear enough.

The reason why disallowing merging is that in [Patch 20/21], I wanted to
use the nid in each reserved region to set the start address of ZONE_MOVABLE
in each node. And this is only my idea. It is OK without doing this.

But as you said, the isolation phase in memblock_set_node() will split the
specified region and set the nid, I think it is OK to merge the regions 
here.

I'll just let it merged here, and not store the pxm.

>
>> In order to let memblock control the allocation, we have to store the
>> hotpluggable ranges somewhere, and keep the allocated range out of the
>> hotpluggable regions. I just think reserving the hotpluggable regions
>> and then memblock won't allocate them. No need to do any other limitation.
>
> It isn't different from what you're doing right now.  Just tell
> memblock that the areas are hotpluggable and the default memblock
> allocation functions stay away from the areas.  That way you can later
> add functions which may allocate from hotpluggable areas for
> node-local data without resorting to tricks like unreserving part of
> it and trying allocation or what not.

I just don't want to any new variables to store the hotpluggable regions.
But without a new shared variable, it seems difficult to achieve the goal
you said below.

>As it currently stands, you're
> scattering hotpluggable memory handling across memblock and acpi which
> is kinda nasty.  Please make acpi feed information into memblock and
> make memblock handle hotpluggable regions appropriately.

Now, when SRAT is found in acpi side, I reserve the region directly in 
memblock.
I think this is the one you don't like.

So how about this.
1. Introduce a new global list used to store hotpluggable regions.
2. On acpi side, find and fulfill the list.
3. On memblock side, make the default allocation function stay away from
    these regions.

>
>> And also, the acpi side modification in this patch-set is to get SRAT
>> and parse it. I think most of the logic in
>> acpi_reserve_hotpluggable_memory()
>> is necessary. I don't think letting memblock control the allocation will
>> make the acpi side easier.
>
> It's about proper layering.  The code change involved in either case
> aren't big but splitting it right would give us less headache when we
> later try to support a different firmware or add more features, and
> more importantly, it makes things logical and lowers the all important
> WTH factor and makes things easier to follow.

OK, followed.

Thanks.
