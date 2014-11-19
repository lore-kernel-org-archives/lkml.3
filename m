Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbaKSDTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 22:19:34 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:9952 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754178AbaKSDTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 22:19:33 -0500
Message-ID: <546C0BBB.9070000@huawei.com>
Date: Wed, 19 Nov 2014 11:17:15 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>, Arnd Bergmann <arnd@arndb.de>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: For the problem when using swiotlb
References: <5469E26B.2010905@huawei.com> <1650523.IrjSXzxF5O@wuerfel> <20141117180947.GI29595@e104818-lin.cambridge.arm.com>
In-Reply-To: <20141117180947.GI29595@e104818-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.246]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020203.546C0BC3.0168,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 66a215c03747970b51084b178798d672
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/18 2:09, Catalin Marinas wrote:
> On Mon, Nov 17, 2014 at 12:18:42PM +0000, Arnd Bergmann wrote:
>> On Monday 17 November 2014 19:56:27 Ding Tianhong wrote:
>>>         The commit 3690951fc6d42f3a0903987677d0e592c49dd8db(arm64: Use swiotlb late initialisation)
>>> switches the DMA mapping code to swiotlb_tlb_late_init_with_default_size(), this will occur a problem
>>> when I run the scsi stress tests, the message as below:
>>>
>>>         sas_controller b1000000.sas: swiotlb buffer is full (sz: 65536 bytes)..
>>>         DMA: Out of SW-IOMMU space for 65536 bytes at device b1000000.sas
>>>
>>> The reason is that the swiotlb_tlb_late_init_with_default_size() could only alloc 16M memory for DMA-mapping,
>>> and the param in cmdline "swiotlb=xxx" is useless because the get_free_pages() only use the buddy to assigned a
>>> maximum memory of 16M(The MAX_ORDER is 13 for 4k pages), obviously 16M is too small in many scenes, but
>>> the swiotlb_init() which could reserved a bigger memory as wished could work well for most drivers.
>>>
>>> I could not get a better way to fix this problem except to revert this patch, so could you please give me some
>>> advise and help me, thanks very much.
>>
>> In general, you should not need to use swiotlb for most devices, in
>> particular for high-performance devices like network or block.
>>
>> Please make sure that you have set up the dma-ranges properties in
>> your DT properly to allow 64-bit DMA if the device supports it.
> 
> That's the problem indeed, the DMA API ends up using swiotlb bounce
> buffers because the physical address of the pages passed to (or
> allocated by) the driver are beyond 32-bit limit (which is the default
> dma mask).
> 

Thanks everyone, I think I found the way to fix it, need to enable DMA_CMA, to reserve a big memory
for CMA and set coherent mask for dev, then dma_alloc and dma_mapping will not use the swiotlb until
the memory out of mask or swiotlb_force is enabled.

If I still understand uncorrectly, please inform me.

Regards
Ding

