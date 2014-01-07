Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbaAGRqY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 12:46:24 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51900 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963AbaAGRqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:46:16 -0500
Message-ID: <52CC3D46.3090102@ti.com>
Date: Tue, 7 Jan 2014 12:45:42 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: =?UTF-8?B?S3J6eXN6dG9mIEhhxYJhc2E=?= <khalasa@piap.pl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: Regression (ARM) arch/arm/mm/init.c doesn't build without CONFIG_ARM_PATCH_PHYS_VIRT.
References: <m38uv1uuzr.fsf@t19.piap.pl> <m3ha9gx63v.fsf@t19.piap.pl> <20140106223906.GH27432@n2100.arm.linux.org.uk> <52CB3F55.1050404@ti.com> <20140107011121.GI27432@n2100.arm.linux.org.uk>
In-Reply-To: <20140107011121.GI27432@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 January 2014 08:11 PM, Russell King - ARM Linux wrote:
> On Mon, Jan 06, 2014 at 06:42:13PM -0500, Santosh Shilimkar wrote:
>> On Monday 06 January 2014 05:39 PM, Russell King - ARM Linux wrote:
>>> On Mon, Jan 06, 2014 at 08:28:20PM +0100, Krzysztof Hałasa wrote:
>>>> Russell, Santosh,
>>>>
>>>> the unneeded commit causing regression is still in place. Please try to
>>>> compile an ARM kernel without CONFIG_ARM_PATCH_PHYS_VIRT and with
>>>> CONFIG_ZONE_DMA and see for yourself, if you don't believe me.
>>>>
>>>> Please be aware that this commit fixes nothing, its only function is
>>>> causing the regression - so we don't lose anything by reverting it.
>>>>
>>>> If the attached wasn't clear, what the defective commit presently does
>>>> is changing a perfectly valid code into a code referencing a variable
>>>> which (without CONFIG_ARM_PATCH_PHYS_VIRT set) doesn't at all exist.
>>>>
>>>> With CONFIG_ARM_PATCH_PHYS_VIRT set, this commit does precisely nothing.
>>>
> 
> /--------------------------------------------------------------
> | > > Right, so, with Assabet, which has CONFIG_DMA_ZONE=y and
> | > > CONFIG_ARM_PATCH_PHYS_VIRT=y:
> | > > 
> | > > $ make O=../build/assabet arch/arm/mm/init.i
> | > > 
> | > > gives:
> | > >   arm_dma_limit = __pv_phys_offset + arm_dma_zone_size - 1;
> | > > 
> | > > with or without Santosh's patch.
> \--------------------------------------------------------------
> 
>> May be I missed your point but I ended up creating the patch because
>> the CMA reservation was failing on Keystone since the arm_dma_limit
>> wasn't right since it wasn't considering the actual __pv_phys_offset.
>>
>> Isn't that an issue ?
> 
> See the above.  Your patch has _no_ effect what so ever when
> CONFIG_ARM_PATCH_PHYS_VIRT=y - which you have on the Keystone, right?
> 
> If you don't believe me, ask make to produce arch/arm/mm/init.i, which
> is the output from the preprocessor, comparing the resulting generated
> file both with and without your patch applied.
> 
Looks like you are right. I did two fixes to have right arm_dma_limit in
below order.

1. 787b0d5 {ARM: 7908/1: mm: Fix the arm_dma_limit calculation}
2. 7c92732 {ARM: 7909/1: mm: Call setup_dma_zone() post early_paging_init()}

But with 2 alone the issue gets fixed since with ARM_PATCH_PHYS_VIRT and
below pre-processor, the PHYS_OFFSET also gets an updated value. I never
realised that 1 becomes redundant after second patch while creating them. 

#define PHYS_OFFSET __pv_phys_offset

So indeed, 787b0d5{ARM: 7908/1: mm: Fix the arm_dma_limit calculation}
won't be needed anymore and can be reverted. Sorry it took some time
for me to reach to your conclusion.

Regards,
Santosh



