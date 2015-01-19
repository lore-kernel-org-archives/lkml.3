Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626AbbASOUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:20:39 -0500
Received: from mga14.intel.com ([192.55.52.115]:10151 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbbASOUi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:20:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,427,1418112000"; 
   d="scan'208";a="514301294"
Message-ID: <54BD12B1.8010006@linux.intel.com>
Date: Mon, 19 Jan 2015 22:20:33 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Sander Eikelenboom <linux@eikelenboom.it>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Xen-devel List <xen-devel@lists.xen.org>
Subject: Re: [Bugfix 0/3] Fix regressions in Xen IRQ management
References: <1421643344-17092-1-git-send-email-jiang.liu@linux.intel.com> <444634093.20150119133447@eikelenboom.it>
In-Reply-To: <444634093.20150119133447@eikelenboom.it>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/19 20:34, Sander Eikelenboom wrote:
> 
> Monday, January 19, 2015, 5:55:41 AM, you wrote:
> 
>> Hi all,
>>         Sander reports an Xen pci-passthrough regression caused by
>> commit cffe0a2b5a34c95a4dadc9ec7132690a5b0f6687 ("x86, irq: Keep
>> balance of IOAPIC pin reference count"). This patch set tries to
>> fix it.
> 
>> Patch 1 is a fix for another issue found during fixing the regression.
>> Patch 2 is a hotfix for the regression and should be targeted for v3.19.
>> Patch 3 is the foundamental fix for the regression and should be targeted
>> at v3.20.
> 
>> Hi Sander,
>>         Could you please help to test by:
>> 1) only apply patch 1 and patch 2
>> 2) and then apply patch 3 ontop of patch 1/2.
>> Thanks!
>> Gerry
> 
> Hi Gerry / David / Konrad,
> 
> My test results:
> 
> - On intel:
>     - With apic v4 series and only patch 1 + 2 of this series:
>         - powerbutton is still working as expected due to apic v4 series
>         - irq's are delivered to the passed through wifi device,
>           the wifi device is working now, so that's good !
>         - However now i get this splat in dom0,
>           (haven't seen this one before,
>            but unfortunately i don't seem to be able to trigger it reliably (only hit this once in 10 boots),
>            and i also don't know for sure if it's even due to this patch set or not):
>              [ 2361.607881] irq 18: nobody cared (try booting with the "irqpoll" option)
>              [ 2361.650103] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.19.0-rc5-creanuc-20150119-doflr-apicv4-apicpcipt12+ #1
>              [ 2361.670344] Hardware name:                  /D53427RKE, BIOS RKPPT10H.86A.0017.2013.0425.1251 04/25/2013
>              [ 2361.690787]  0000000000000000 ffff8800596aee8c ffffffff818af9e7 ffff8800596aee00
>              [ 2361.711547]  ffffffff8108151c ffff8800596aee00 0000000000000000 0000000000000000
>              [ 2361.732474]  ffffffff81081929 0000000000000000 0000000000000000 0000000000000012
>              [ 2361.753265] Call Trace:
>              [ 2361.773907]  <IRQ>  [<ffffffff818af9e7>] ? dump_stack+0x40/0x50
>              [ 2361.795077]  [<ffffffff8108151c>] ? __report_bad_irq+0x1e/0xbb
>              [ 2361.815844]  [<ffffffff81081929>] ? note_interrupt+0x1a9/0x234
>              [ 2361.835965]  [<ffffffff8107fa8f>] ? handle_irq_event_percpu+0xd7/0xf1
>              [ 2361.856384]  [<ffffffff8107fae0>] ? handle_irq_event+0x37/0x57
>              [ 2361.876775]  [<ffffffff81082212>] ? handle_fasteoi_irq+0x74/0xcb
>              [ 2361.896812]  [<ffffffff8107f47a>] ? generic_handle_irq+0x15/0x20
>              [ 2361.916476]  [<ffffffff813bf5e7>] ? evtchn_fifo_handle_events+0x138/0x16f
>              [ 2361.936105]  [<ffffffff813bd3a5>] ? __xen_evtchn_do_upcall+0x39/0x69
>              [ 2361.955986]  [<ffffffff813be71d>] ? xen_evtchn_do_upcall+0x27/0x36
>              [ 2361.975998]  [<ffffffff818b881e>] ? xen_do_hypervisor_callback+0x1e/0x30
>              [ 2361.996017]  <EOI>  [<ffffffff810013aa>] ? xen_hypercall_sched_op+0xa/0x20
>              [ 2362.016394]  [<ffffffff810013aa>] ? xen_hypercall_sched_op+0xa/0x20
>              [ 2362.036886]  [<ffffffff81007138>] ? xen_safe_halt+0xc/0x13
>              [ 2362.057118]  [<ffffffff81013add>] ? default_idle+0x5/0x8
>              [ 2362.077309]  [<ffffffff81078b52>] ? cpu_startup_entry+0x114/0x25e
>              [ 2362.097612]  [<ffffffff81effe9d>] ? start_kernel+0x422/0x42d
>              [ 2362.118041]  [<ffffffff81eff880>] ? set_init_arg+0x50/0x50
>              [ 2362.138141]  [<ffffffff81f029a0>] ? xen_start_kernel+0x4d3/0x4db
>              [ 2362.157862] handlers:
>              [ 2362.177280] [<ffffffff8157567e>] ata_bmdma_interrupt
>              [ 2362.196805] Disabling IRQ #18
>         - attached complete proc-interrupts, lspci, dmesg and xl-dmesg attached as proc-interrupts12.txt, lspci12.txt, dmesg12.txt and xl-dmesg12.txt
> 
> 
>     - With apic v4 series and patch 1 + 2 + 3 of this series:
>         - powerbutton is still working as expected due to apic v4 series
>         - irq's are delivered to the passed through wifi device,
>           the wifi device is working now, so that's good !
>         - I haven't seen the splat above so far,
>           (but since i can't trigger it reliably that doesn't give any guarantees unfortunately).
> 
> On AMD:
>     - With apic v4 series and only patch 1 + 2 of this series:
>         - powerbutton is still working as expected due to apic v4 series
>         - videostream from passed through device is stable again, so that's good !
> 
>     - With apic v4 series and patch 1 + 2 + 3 of this series:
>         - powerbutton is still working as expected due to apic v4 series
>         - videostream from passed through device is stable again, so that's good !
> 
> 
> So to summarize:
>     The reported problems are fixed, everything looks good.
>     Apart from a splat which occurs infrequently and from which i don't know
>     if it is due to this patch set anyway.
> 
> So i'm very much inclined to say: 
> Tested-by: Sander Eikelenboom <linux@eikelenboom.it>
Thanks for your great efforts to tests those patches, Sander.
I will send out formal patch set for 3.19 tomorrow.
Thanks!
Gerry

> 
> 
> Thanks Gerry !
> 
> --
> Sander
> 
>> Jiang Liu (3):
>>   xen/irq, ACPI: Fix regression in xen PCI passthrough caused by
>>     cffe0a2b5a34
>>   xen/irq: Override ACPI IRQ management callback __acpi_unregister_gsi
>>   x86/PCI: Refine the way to release PCI IRQ resources
> 
>>  arch/x86/include/asm/acpi.h    |    1 +
>>  arch/x86/include/asm/pci_x86.h |    2 --
>>  arch/x86/pci/common.c          |   30 ++++++++++++++++++++++++++++--
>>  arch/x86/pci/intel_mid_pci.c   |    4 ++--
>>  arch/x86/pci/irq.c             |   15 +--------------
>>  arch/x86/pci/xen.c             |    2 ++
>>  drivers/acpi/pci_irq.c         |   10 +---------
>>  7 files changed, 35 insertions(+), 29 deletions(-)
