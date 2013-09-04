Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934253Ab3IDCHJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 22:07:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:45084 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755910Ab3IDCHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 22:07:07 -0400
X-IronPort-AV: E=Sophos;i="4.89,1017,1367942400"; 
   d="scan'208";a="8400449"
Message-ID: <5226957F.2060704@cn.fujitsu.com>
Date: Wed, 04 Sep 2013 10:05:51 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 07/11] x86, memblock: Set lowest limit for memblock_alloc_base_nid().
References: <1377596268-31552-1-git-send-email-tangchen@cn.fujitsu.com>  <1377596268-31552-8-git-send-email-tangchen@cn.fujitsu.com> <1378255041.10300.931.camel@misato.fc.hp.com>
In-Reply-To: <1378255041.10300.931.camel@misato.fc.hp.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/04 10:04:55,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/09/04 10:04:58,
	Serialize complete at 2013/09/04 10:04:58
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2013 08:37 AM, Toshi Kani wrote:
> On Tue, 2013-08-27 at 17:37 +0800, Tang Chen wrote:
>> memblock_alloc_base_nid() is a common API of memblock. And it calls
>> memblock_find_in_range_node() with %start = 0, which means it has no
>> limit for the lowest address by default.
>>
>> 	memblock_find_in_range_node(0, max_addr, size, align, nid);
>>
>> Since we introduced current_limit_low to memblock, if we have no limit
>> for the lowest address or we are not sure, we should pass
>> MEMBLOCK_ALLOC_ACCESSIBLE to %start so that it will be limited by the
>> default low limit.
>>
>> dma_contiguous_reserve() and setup_log_buf() will eventually call
>> memblock_alloc_base_nid() to allocate memory. So if the allocation order
>> is from low to high, they will allocate memory from the lowest limit
>> to higher memory.
>
> This requires the callers to use MEMBLOCK_ALLOC_ACCESSIBLE instead of 0.
> Is there a good way to make sure that all callers will follow this rule
> going forward?  Perhaps, memblock_find_in_range_node() should emit some
> message if 0 is passed when current_order is low to high and the boot
> option is specified?

How about set this as the default rule:

	When using from low to high order, always allocate memory from
	current_limit_low.

So far, I think only movablenode boot option will use this order.

>
> Similarly, I wonder if we should have a check to the allocation size to
> make sure that all allocations will stay small in this case.
>

We can check the size. But what is the stragety after we found that the 
size
is too large ?  Do we refuse to allocate memory ?  I don't think so.

I think only relocate_initrd() and reserve_crachkernel() could allocate 
large
memory. reserve_crachkernel() is easy to reorder, but reordering 
relocate_initrd()
is difficult because acpi_initrd_override() need to access to it with va.

I think on most servers, we don't need to do relocate_initrd(). initrd 
will be
loaded to mapped memory in normal situation. Can we just leave it there ?

Thanks.
