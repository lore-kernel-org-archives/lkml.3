Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbaCKLYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 07:24:39 -0400
Received: from mail-oa0-f42.google.com ([209.85.219.42]:41742 "EHLO
	mail-oa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbaCKLYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 07:24:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140311111350.GU27965@twins.programming.kicks-ass.net>
References: <20140311104433.GA16207@quad>
	<20140311111350.GU27965@twins.programming.kicks-ass.net>
Date: Tue, 11 Mar 2014 12:24:36 +0100
Message-ID: <CABPqkBT8tyS7ZZA_0nVzfeYZhQRSqdTpa2UTONYPkLs8B8LyOQ@mail.gmail.com>
Subject: Re: [PATCH] perf/x86/uncore: fix compilation warning in snb_uncore_imc_init_box()
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "H. Peter Anvin" <hpa@zytor.com>, tglx <tglx@linuxtronic.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 11, 2014 at 12:13 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Mar 11, 2014 at 11:44:33AM +0100, Stephane Eranian wrote:
>>
>>
>> This patches fixes a compilation problem (unused variable) with the
>> new SNB/IVB/HSW uncore IMC code.
>>
>> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
>> index b262c61..3846a37 100644
>> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
>> @@ -1722,15 +1722,19 @@ static struct attribute_group snb_uncore_imc_format_group = {
>>  static void snb_uncore_imc_init_box(struct intel_uncore_box *box)
>>  {
>>       struct pci_dev *pdev = box->pci_dev;
>> -     u32 addr_lo, addr_hi;
>> +     u32 addr_lo;
>>       resource_size_t addr;
>>
>>       pci_read_config_dword(pdev, SNB_UNCORE_PCI_IMC_BAR_OFFSET, &addr_lo);
>>       addr = addr_lo;
>>
>>  #ifdef CONFIG_PHYS_ADDR_T_64BIT
>> -     pci_read_config_dword(pdev, SNB_UNCORE_PCI_IMC_BAR_OFFSET+4, &addr_hi);
>> -     addr = ((resource_size_t)addr_hi << 32) | addr_lo;
>> +     { u32 addr_hi;
>> +       int where = SNB_UNCORE_PCI_IMC_BAR_OFFSET + 4;
>> +
>> +       pci_read_config_dword(pdev, where, &addr_hi);
>> +       addr = ((resource_size_t)addr_hi << 32) | addr_lo;
>> +     }
>>  #endif
>
> How about something like:
>
> - u32 addr_lo, addr_hi;
> + u32 pci_dword;
>
>         pci_read_config_dword(pdev, SNB_UNCORE_PCI_IMC_BAR_OFFSET, &pci_dword);
>         addr = pci_dword;
>
> #ifdef ..
>         pci_read_config_dword(pdev, SNB_UNCORE_PCI_IMC_BAR_OFFSET + 4, &pci_dword);
>         addr |= ((u64)pci_dword) << 32;
> #endif
>
> That avoids the need for the ugly {} thing.
Okay, that's better.
I will repost then.
Thanks.
