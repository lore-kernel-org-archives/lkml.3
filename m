Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161667AbaDPPKe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 11:10:34 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:50139 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756279AbaDPPKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 11:10:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140415203510.GA17037@node.dhcp.inet.fi>
References: <20140311235329.GA28624@quad>
	<20140415203510.GA17037@node.dhcp.inet.fi>
Date: Wed, 16 Apr 2014 08:10:31 -0700
Message-ID: <CABPqkBS92QX_xkMDPAQN3FBUc8ykdWKiMBMmNUiU15z6fCOw+Q@mail.gmail.com>
Subject: Re: [PATCH v2] perf/x86/uncore: fix compilation warning in snb_uncore_imc_init_box()
From: Stephane Eranian <eranian@google.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 1:35 PM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
> On Wed, Mar 12, 2014 at 12:53:30AM +0100, Stephane Eranian wrote:
>>
>> This patch fixes a compilation problem (unused variable) with the
>> new SNB/IVB/HSW uncore IMC code.
>>
>> In V2, we simplify the fix as suggested by Peter Zjilstra.
>>
>> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>> --
>>
>> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
>> index 3e5b240..d614f6b 100644
>> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
>> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
>> @@ -1722,15 +1722,16 @@ static struct attribute_group snb_uncore_imc_format_group = {
>>  static void snb_uncore_imc_init_box(struct intel_uncore_box *box)
>>  {
>>       struct pci_dev *pdev = box->pci_dev;
>> -     u32 addr_lo, addr_hi;
>> +     int where = SNB_UNCORE_PCI_IMC_BAR_OFFSET;
>> +     u32 pci_dword;
>>       resource_size_t addr;
>>
>> -     pci_read_config_dword(pdev, SNB_UNCORE_PCI_IMC_BAR_OFFSET, &addr_lo);
>> -     addr = addr_lo;
>> +     pci_read_config_dword(pdev, where, &pci_dword);
>> +     addr = pci_dword;
>>
>>  #ifdef CONFIG_PHYS_ADDR_T_64BIT
>> -     pci_read_config_dword(pdev, SNB_UNCORE_PCI_IMC_BAR_OFFSET+4, &addr_hi);
>> -     addr = ((resource_size_t)addr_hi << 32) | addr_lo;
>> +       pci_read_config_dword(pdev, where + 4, &pci_dword);
>> +       addr |= ((resource_size_t)pci_dword << 32);
>>  #endif
>>
>>       addr &= ~(PAGE_SIZE - 1);
>
> I see the warning on my laptop (X1 Carbon), which probably related to the commit:
>
> [    0.559204] ------------[ cut here ]------------
> [    0.559216] WARNING: CPU: 2 PID: 1 at /home/kas/git/public/linux/arch/x86/mm/ioremap.c:171 __ioremap_caller+0x2e3/0x390()
> [    0.559225] Info: mapping multiple BARs. Your kernel is fine.
> [    0.559230] Modules linked in:
>
Yes, this is the same warning.
No solution at this point. It seems to affect only Lenovo laptops.

> [    0.559238] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 3.15.0-rc1-00012-g55101e2d6ce1 #38
> [    0.559246] Hardware name: LENOVO 3460CC6/3460CC6, BIOS G6ET93WW (2.53 ) 02/04/2013
> [    0.559254]  0000000000000009 ffff8801182f3b60 ffffffff81a2274e ffff8801182f3ba8
> [    0.559264]  ffff8801182f3b98 ffffffff810db97d ffffc90000658000 00000000fed16000
> [    0.559274]  ffffc90000658000 ffffc90000658000 0000000000006000 ffff8801182f3bf8
> [    0.559284] Call Trace:
> [    0.559293]  [<ffffffff81a2274e>] dump_stack+0x4d/0x6f
> [    0.559300]  [<ffffffff810db97d>] warn_slowpath_common+0x7d/0xa0
> [    0.559307]  [<ffffffff810db9ec>] warn_slowpath_fmt+0x4c/0x50
> [    0.559316]  [<ffffffff810e39dc>] ? iomem_map_sanity_check+0xac/0xe0
> [    0.559324]  [<ffffffff810a8823>] __ioremap_caller+0x2e3/0x390
> [    0.559332]  [<ffffffff810a88e7>] ioremap_nocache+0x17/0x20
> [    0.559339]  [<ffffffff81083845>] snb_uncore_imc_init_box+0x65/0x90
> [    0.559348]  [<ffffffff810827c8>] uncore_pci_probe+0xd8/0x1b0
> [    0.559356]  [<ffffffff8140f255>] local_pci_probe+0x45/0xa0
> [    0.559364]  [<ffffffff8140e9c5>] ? pci_match_device+0xc5/0xd0
> [    0.559371]  [<ffffffff8140f389>] pci_device_probe+0xd9/0x130
> [    0.559379]  [<ffffffff81598987>] driver_probe_device+0x87/0x390
> [    0.559385]  [<ffffffff81598d63>] __driver_attach+0x93/0xa0
> [    0.559392]  [<ffffffff81598cd0>] ? __device_attach+0x40/0x40
> [    0.559401]  [<ffffffff815968bb>] bus_for_each_dev+0x6b/0xb0
> [    0.559408]  [<ffffffff815983ae>] driver_attach+0x1e/0x20
> [    0.559415]  [<ffffffff81597f88>] bus_add_driver+0x188/0x260
> [    0.559425]  [<ffffffff8237e179>] ? uncore_pmu_register+0xdb/0xdb
> [    0.559432]  [<ffffffff815993c4>] driver_register+0x64/0xf0
> [    0.559439]  [<ffffffff8237e179>] ? uncore_pmu_register+0xdb/0xdb
> [    0.559446]  [<ffffffff8140eb30>] __pci_register_driver+0x60/0x70
> [    0.559454]  [<ffffffff8237e2ee>] intel_uncore_init+0x175/0x42b
> [    0.559461]  [<ffffffff8237e179>] ? uncore_pmu_register+0xdb/0xdb
> [    0.559470]  [<ffffffff8100216a>] do_one_initcall+0xfa/0x1b0
> [    0.559479]  [<ffffffff811035e5>] ? parse_args+0x225/0x3f0
> [    0.559487]  [<ffffffff8236e17c>] kernel_init_freeable+0x1da/0x25f
> [    0.559495]  [<ffffffff8236d8e5>] ? do_early_param+0x88/0x88
> [    0.559504]  [<ffffffff81a13060>] ? rest_init+0x140/0x140
> [    0.559511]  [<ffffffff81a1306e>] kernel_init+0xe/0xf0
> [    0.559519]  [<ffffffff81a380bc>] ret_from_fork+0x7c/0xb0
> [    0.559526]  [<ffffffff81a13060>] ? rest_init+0x140/0x140
> [    0.559538] ---[ end trace 2d7d94a103087769 ]---
>
> --
>  Kirill A. Shutemov
