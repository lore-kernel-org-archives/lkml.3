Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab3HMJ6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 05:58:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:3561 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab3HMJ6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 05:58:11 -0400
X-IronPort-AV: E=Sophos;i="4.89,868,1367942400"; 
   d="scan'208";a="8190820"
Message-ID: <520A02DE.1010908@cn.fujitsu.com>
Date: Tue, 13 Aug 2013 17:56:46 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Tang Chen <imtangchen@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        robert.moore@intel.com, lv.zheng@intel.com, rjw@sisk.pl,
        lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>
Subject: Re: [PATCH part5 0/7] Arrange hotpluggable memory as ZONE_MOVABLE.
References: <1375956979-31877-1-git-send-email-tangchen@cn.fujitsu.com> <20130812145016.GI15892@htj.dyndns.org> <5208FBBC.2080304@zytor.com> <20130812152343.GK15892@htj.dyndns.org> <52090D7F.6060600@gmail.com> <20130812164650.GN15892@htj.dyndns.org> <5209CEC1.8070908@cn.fujitsu.com>
In-Reply-To: <5209CEC1.8070908@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/13 17:56:34,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/13 17:56:36,
	Serialize complete at 2013/08/13 17:56:36
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi tj,

When doing the "near kernel memory allocation", I have something
about memblock that I need you to comfirm.

1. First of all, memblock is platform independent. Different platforms
    have different ways to store kernel image address. So I don't think
    we can obtain the kernel image address on memblock side, right ?

    If so, then we need to pass kernel image address to memblock. But...

2. There are several places calling memblock_find_in_range_node() to
    allocate memory before SRAT parsed.

    early_reserve_e820_mpc_new()
    reserve_real_mode()
    init_mem_mapping()
    setup_log_buf()
    relocate_initrd()
    acpi_initrd_override()
    reserve_crashkernel()

    Maybe more, I didn't find out.

    And in the future, maybe someone will add code to allocate memory
    before SRAT parsed. So I don't think we should pass kernel image
    addr to them one by one. It will modify a lot of things.

So I think we need a generic way to tell memblock to allocate memory
from the kernel image end address to higher memory.


My idea is:

1. Introduce a memblock.current_limit_low to limit the lowest address
    that memblock can use.

2. Make memblock be able to allocate memory from low to high.

3. Get kernel image address on x86, and set memblock.current_limit_low
    to it before SRAT is parsed. Then we achieve the goal.

4. Reset it to 0, and make memblock allocate memory form high to low.


How do you think of this, or do you have any better idea ?


Thanks for your patient and help. :)


On 08/13/2013 02:14 PM, Tang Chen wrote:
> On 08/13/2013 12:46 AM, Tejun Heo wrote:
> ......
>>
>> * Adding an option to tell the kernel to try to stay away from
>> hotpluggable nodes is fine. I have no problem with that at all.
>>
>> * The patchsets upto this point have been somehow trying to reorder
>> operations shomehow such that *no* memory allocation happens before
>> memblock is populated with hotplug information.
>>
>> * However, we already *know* that the memory the kernel image is
>> occupying won't be removeable. It's highly likely that the amount
>> of memory allocation before NUMA / hotplug information is fully
>> populated is pretty small. Also, it's highly likely that small
>> amount of memory right after the kernel image is contained in the
>> same NUMA node, so if we allocate memory close to the kernel image,
>> it's likely that we don't contaminate hotpluggable node. We're
>> talking about few megs at most right after the kernel image. I
>> can't see how that would make any noticeable difference.
>>
>> * Once hotplug information is available, allocation can happen as
>> usual and the kernel can report the nodes which are actually
>> hotpluggable - marked as hotpluggable by the firmware&& didn't get
>> contaminated during early alloc&& didn't get overflow allocations
>> afterwards. Note that we need such mechanism no matter what as the
>> kernel image can be loaded into hotpluggable nodes and reporting
>> that to userland is the only thing the kernel can do for cases like
>> that short of denying memory unplug on such nodes.
>>
>
> Hi tj, hpa, luck, yinghai,
>
> So if all of you agree on the idea above from tj, I think
> we can do it in this way. Will update the patches to allocate
> memory near kernel image before SRAT is parsed.
>
> Thanks.
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org. For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
>
