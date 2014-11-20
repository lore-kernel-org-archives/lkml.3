Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbaKTIih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 03:38:37 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:57445 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756733AbaKTIig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 03:38:36 -0500
Message-ID: <546DA795.9080209@huawei.com>
Date: Thu, 20 Nov 2014 16:34:29 +0800
From: Ding Tianhong <dingtianhong@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: For the problem when using swiotlb
References: <5469E26B.2010905@huawei.com> <1535751.CcvIi3DN4F@wuerfel> <546D58B1.60108@huawei.com> <2522857.bNQToYpBNt@wuerfel>
In-Reply-To: <2522857.bNQToYpBNt@wuerfel>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.246]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020209.546DA881.00E3,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 66a215c03747970b51084b178798d672
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/20 15:40, Arnd Bergmann wrote:
> On Thursday 20 November 2014 10:57:53 Ding Tianhong wrote:
>> On 2014/11/19 16:45, Arnd Bergmann wrote:
>>> On Wednesday 19 November 2014 11:17:15 Ding Tianhong wrote:
>>>> On 2014/11/18 2:09, Catalin Marinas wrote:
>>>>> On Mon, Nov 17, 2014 at 12:18:42PM +0000, Arnd Bergmann wrote:
>>>> Thanks everyone, I think I found the way to fix it, need to enable DMA_CMA, to reserve a big memory
>>>> for CMA and set coherent mask for dev, then dma_alloc and dma_mapping will not use the swiotlb until
>>>> the memory out of mask or swiotlb_force is enabled.
>>>>
>>>> If I still understand uncorrectly, please inform me.
>>>>
>>>
>>> Please do not use CMA to work around the problem, but fix the underlying bug
>>> instead.
>>>
>>> The driver should call 'dma_set_mask_and_coherent()' with the appropriate
>>> dma mask, and check whether that succeeded. However, the code implementing
>>> dma_set_mask_and_coherent on arm64 also needs to be changed to look up
>>> the dma-ranges property (see of_dma_configure()), and check if the mask
>>> is possible.
>>>
>> The dma_pfn_offset looks only support arm32, but my platform is aarch64 and I check the latest kernel version, 
>> I think the dma-rangs still could not work for aarch64, so maybe we should add dma_pfn_offset for aarch64 first.
>>
> 
> I didn't mean the dma_pfn_offset. The problem is that the of_dma_configure
> code currently doesn't look at the mask. As I explained in my reply to
> Catalin, it should set the mask to the size of the dma-ranges if that is
> 32-bit or smaller, and dma_set_mask should look at the same dma-ranges
> property to decide what to set the mask to when a driver asks for a
> mask larger than 64-bit.
> 
> 	Arnd
> 
ok, I think the your reply to catalin is clear, I got it, add a appropriate mask for the dev is
reasonable, I think it should be fixed later.

But in my case, if I don't use the DMA_CMA, the dma_alloc_coherent should use the swiotlb directly which maximum is 16M,
so unless I use the kmalloc otherwise I have no better idea for that.

Regards
Ding 

> .
> 


