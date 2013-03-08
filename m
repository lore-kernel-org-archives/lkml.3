Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab3CHHoU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 02:44:20 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:58008 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091Ab3CHHoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 02:44:19 -0500
MIME-Version: 1.0
In-Reply-To: <20130308070130.GM14556@mtj.dyndns.org>
References: <1362718720-27048-1-git-send-email-yinghai@kernel.org>
	<1362718720-27048-15-git-send-email-yinghai@kernel.org>
	<20130308070130.GM14556@mtj.dyndns.org>
Date: Thu, 7 Mar 2013 23:44:18 -0800
X-Google-Sender-Auth: S0RNDLa0sdK0uvpLX9AwB_AF7iQ
Message-ID: <CAE9FiQWe_QbsmuJfqT+Wc77v7M0y1+ho-3ZpxV8b0er6tSTFKQ@mail.gmail.com>
Subject: Re: [PATCH 14/14] x86, mm: Put pagetable on local node ram
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, Pekka Enberg <penberg@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 11:01 PM, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Mar 07, 2013 at 08:58:40PM -0800, Yinghai Lu wrote:
>> If node with ram is hotplugable, local node mem for page table and vmemmap
>> should be on that node ram.
>>
>> This patch is some kind of refreshment of
>> | commit 1411e0ec3123ae4c4ead6bfc9fe3ee5a3ae5c327
>> | Date:   Mon Dec 27 16:48:17 2010 -0800
>> |
>> |    x86-64, numa: Put pgtable to local node memory
>> That was reverted before.
>>
>> We have reason to reintroduce it to make memory hotplug work.
>>
>> Split calling of init_mem_mapping into early_initmem_info
>> for nodes after we get numa info there.
>>
>> First node will be low range.
>> Need to rework alloc_low_pages to alloc page table in following order:
>>       BRK, local node, low range
>>
>> Still only load_cr3 one time, otherwise we would break xen 64bit again.
>
> Hmmm... can you please split this patch further?  init_mem_mapping()
> change can be separated, no?

will try to split it out.

> Also, comments are disturbingly missing.
> How are other people reading the code supposed to know what it's
> trying to achieve why and how?  Hmmm... we're also likely to end up
> with smaller mapping for misaligned NUMA configurations (I think my
> test machine is like that).  Is it guaranteed that the top level ends
> up in the first node?  It really needs documentation.

Yes. To really memory hotplug working, will need to trim the node
alignment to be
1G in memblock and numa_meminfo.

also need to put pgd page in low range (first node) if 512G block is
crossing node.
for example: if node2 is [256g, 1024g), pgd for 256g-512g, must be stay on node0
and 512g-1024g could stay on node2.
or just put all PGD pages on low range (first node).

Thanks

Yinghai
