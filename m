Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab3FNNIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 09:08:48 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:44166 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab3FNNIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 09:08:47 -0400
Message-ID: <51BB15DA.8020302@gmail.com>
Date: Fri, 14 Jun 2013 08:08:42 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] ARM: mmu: Add debug_ll_io_init() mappings to early mappings
References: <1371000607-1787-1-git-send-email-sboyd@codeaurora.org> <CAL_JsqLJ7ZD9-VR+vgOZZ_q-RD6FCDvKPSNSCjAADxy94SU1Xg@mail.gmail.com> <20130612172146.GB10823@codeaurora.org>
In-Reply-To: <20130612172146.GB10823@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2013 12:21 PM, Stephen Boyd wrote:
> On 06/11, Rob Herring wrote:
>> On Tue, Jun 11, 2013 at 8:30 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>>
>>> diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
>>> index e0d8565..04fe160 100644
>>> --- a/arch/arm/mm/mmu.c
>>> +++ b/arch/arm/mm/mmu.c
>>> @@ -938,8 +938,12 @@ static void __init pci_reserve_io(void)
>>>  #ifdef CONFIG_DEBUG_LL
>>>  void __init debug_ll_io_init(void)
>>>  {
>>> +       struct vm_struct *vm;
>>> +       struct static_vm *svm;
>>>         struct map_desc map;
>>>
>>> +       svm = early_alloc_aligned(sizeof(*svm), __alignof__(*svm));
>>> +
>>>         debug_ll_addr(&map.pfn, &map.virtual);
>>>         if (!map.pfn || !map.virtual)
>>>                 return;
>>> @@ -948,6 +952,15 @@ void __init debug_ll_io_init(void)
>>>         map.length = PAGE_SIZE;
>>>         map.type = MT_DEVICE;
>>>         create_mapping(&map);
>>> +
>>> +       vm = &svm->vm;
>>> +       vm->addr = (void *)map.virtual;
>>> +       vm->size = map.length;
>>> +       vm->phys_addr = __pfn_to_phys(map.pfn);
>>> +       vm->flags = VM_IOREMAP | VM_ARM_STATIC_MAPPING;
>>> +       vm->flags |= VM_ARM_MTYPE(map.type);
>>> +       vm->caller = debug_ll_io_init;
>>> +       add_static_vm_early(svm);
>>
>> Can you use vm_reserve_area_early here or perhaps just call
>> iotable_init instead of create_mapping directly? I don't recall if
>> there was some reason I didn't do that.
>>
> 
> I had iotable_init() before but I thought it was better to have
> the ->caller argument say debug_ll_io_init() instead of
> iotable_init(). Shall I extract out the similar code?

Well, that's always welcome...

Another option would be use __builtin_return_address. That would change
vmallocinfo from showing iotable_init to the caller of iotable_init.
Arguably, knowing the caller would be better.

Rob

