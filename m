Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab3EFJqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 05:46:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53719 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752629Ab3EFJqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 05:46:44 -0400
X-IronPort-AV: E=Sophos;i="4.87,621,1363104000"; 
   d="scan'208";a="7196403"
Message-ID: <51877CAD.4070909@cn.fujitsu.com>
Date: Mon, 06 May 2013 17:49:33 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, linux-kernel@vger.kernel.org,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [PATCH v4 00/22] x86, ACPI, numa: Parse numa info early
References: <1365728168-32067-1-git-send-email-yinghai@kernel.org> <517F7110.6000705@cn.fujitsu.com>
In-Reply-To: <517F7110.6000705@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/06 17:45:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/06 17:45:49,
	Serialize complete at 2013/05/06 17:45:49
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Could anyone give some suggestions to this patch-set ?

Thanks.

On 04/30/2013 03:21 PM, Tang Chen wrote:
> Hi Yinghai, all,
>
> I've tested this patch-set with my following patch-set:
> [PATCH v1 00/12] Arrange hotpluggable memory in SRAT as ZONE_MOVABLE.
> https://lkml.org/lkml/2013/4/19/94
>
> Using ACPI table override, I overrided SRAT on my box like this:
>
> [ 0.000000] SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]
> [ 0.000000] SRAT: Node 0 PXM 0 [mem 0x100000000-0x307ffffff]
> [ 0.000000] SRAT: Node 1 PXM 2 [mem 0x308000000-0x583ffffff] Hot Pluggable
> [ 0.000000] SRAT: Node 2 PXM 3 [mem 0x584000000-0x7ffffffff] Hot Pluggable
>
> We had 3 nodes, node0 was not hotpluggable, and node1 and node2 were
> hotpluggable.
>
>
> And memblock reserved pagetable pages (with flag 0x1) in local nodes.
> ......
> [ 0.000000] reserved[0xb] [0x00000307ff0000-0x00000307ff1fff], 0x2000
> bytes flags: 0x0
> [ 0.000000] reserved[0xc] [0x00000307ff2000-0x00000307ffffff], 0xe000
> bytes on node 0 flags: 0x1
> [ 0.000000] reserved[0xd] [0x00000583ff7000-0x00000583ffffff], 0x9000
> bytes on node 1 flags: 0x1
> [ 0.000000] reserved[0xe] [0x000007ffff9000-0x000007ffffffff], 0x7000
> bytes on node 2 flags: 0x1
>
> And after some bug fix, memblock can also reserve hotpluggable memory
> with flag 0x2.
> ......
> [ 0.000000] reserved[0xb] [0x00000307ff0000-0x00000307ff1fff], 0x2000
> bytes flags: 0x0
> [ 0.000000] reserved[0xc] [0x00000307ff2000-0x00000307ffffff], 0xe000
> bytes on node 0 flags: 0x1
> [ 0.000000] reserved[0xd] [0x00000308000000-0x00000583ff6fff],
> 0x27bff7000 bytes on node 1 flags: 0x2
> [ 0.000000] reserved[0xe] [0x00000583ff7000-0x00000583ffffff], 0x9000
> bytes on node 1 flags: 0x1
> [ 0.000000] reserved[0xf] [0x00000584000000-0x000007ffff7fff],
> 0x27bff8000 bytes on node 2 flags: 0x2
> [ 0.000000] reserved[0x10] [0x000007ffff8000-0x000007ffffffff], 0x8000
> bytes on node 2 flags: 0x1
>
> And free it to buddy system when memory initialization finished.
>
>
> So the results:
> 1. We can parse SRAT earlier correctly.
> 2. We can override tables correctly.
> 3. We can put pagetable pages in local node.
> 4. We can prevent memblock from allocating hotpluggable memory.
> 5. We can arrange ZONE_MOVABLE using SRAT info.
>
>
> Known problems:
>
> When we put pagetable pages in local node, memory hot-remove logic won't
> work.
> I'm fixing it now. We need to fix the following:
> 1. Improve hot-remove to support freeing local node pagetable pages.
> 2. Improve hot-add to support putting hot-added pagetable pages in local
> node.
> 3. Do the same to vmemmap and page_cgrop pages.
>
> So I suggest to separate the job into 2 parts:
> 1. Push Yinghai's patch1 ~ patch20, without putting pagetable in local
> node.
> And push my work to use SRAT to arrange ZONE_MOVABLE.
> In this case, we can enable memory hotplug in the kernel first.
> 2. Merge patch21 and patch22 into the fixing work I am doing now, and
> push them
> together when finished.
>
> How do you think ?
>
> Reviewed-by: Tang Chen <tangchen@cn.fujitsu.com>
> Tested-by: Tang Chen <tangchen@cn.fujitsu.com>
>
> Thanks. :)
>
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at http://www.tux.org/lkml/
>
