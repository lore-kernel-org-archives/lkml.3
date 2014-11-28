Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaK1Pkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 10:40:43 -0500
Received: from mga03.intel.com ([134.134.136.65]:16341 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbaK1Pkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 10:40:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,477,1413270000"; 
   d="scan'208";a="645086427"
Message-ID: <54789774.7030704@linux.intel.com>
Date: Fri, 28 Nov 2014 23:40:36 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: tip-bot for Jiang Liu <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org, mingo@kernel.org,
        rdunlap@infradead.org, bhelgaas@google.com, hpa@zytor.com,
        tony.luck@intel.com, rjw@rjwysocki.net, grant.likely@linaro.org,
        konrad.wilk@oracle.com, gregkh@linuxfoundation.org, tglx@linutronix.de,
        yinghai@kernel.org, joro@8bytes.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, jroedel@suse.de
Subject: Re: [tip:x86/apic] x86, irq: Use cached IOAPIC entry instead of reading
 from hardware
References: <1416901802-24211-30-git-send-email-jiang.liu@linux.intel.com> <tip-fda7c08b1349cc4c65f8a5240b10f7e9938604b8@git.kernel.org> <20141127193213.GB4190@pd.tnic> <5477DE90.5090500@linux.intel.com> <20141128113358.GB30997@pd.tnic> <20141128115306.GC30997@pd.tnic>
In-Reply-To: <20141128115306.GC30997@pd.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/28 19:53, Borislav Petkov wrote:
> On Fri, Nov 28, 2014 at 12:33:58PM +0100, Borislav Petkov wrote:
>> On Fri, Nov 28, 2014 at 10:31:44AM +0800, Jiang Liu wrote:
>>> 	Thanks for tracking down to this line of change. I have no
>>> platform to reproduce this bug, so could you please help to revert this
>>> commit and apply following patch to get some data about IOAPIC entry?
>>
>> Yep, the cached data differs from what's in the hw reg sometimes:
>>
>> dmesg | grep -i ioapic
>> [    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
>> [    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
>> [    0.429355] ioapic0 pin9, hardware reg a939, cached data 1a939
>> [    0.506249] ioapic0 pin9, hardware reg 1a939, cached data 1a939
>> [    0.521547] ACPI: Using IOAPIC for interrupt routing
>> [    1.313959] ioapic0 pin19, hardware reg a9c1, cached data 1a9c1
>> [    1.357875] ioapic0 pin12, hardware reg 93c, cached data 93c
>> [    1.359204] ioapic0 pin1, hardware reg 931, cached data 931
>> [    1.367423] ioapic0 pin8, hardware reg 938, cached data 938
>> [    7.560846] ioapic0 pin17, hardware reg a981, cached data 1a981
>> [    7.866814] ioapic0 pin18, hardware reg a9a1, cached data 1a9a1
>> [   10.141662] ioapic0 pin16, hardware reg a942, cached data 1a942
>>
>> This would explain the failure because the ahci ioapic pin19 has that
>> discrepancy:
>>
>> [    1.311476] ahci 0000:00:11.0: version 3.0
>> [    1.313374] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 1 ports 3 Gbps 0x1 impl SATA mode
>> [    1.313556] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part ccc 
>> [    1.313959] ioapic0 pin19, hardware reg a9c1, cached data 1a9c1
> 
> Ok, so this is interesting: the cached data has bit 16 set which,
> AFAICT, is in one of those io redirection table registers. That bit
> masks out interrupts and if set, those get ignored. Which would explain
> the timeoutting of the ATA commands because the IRQ is masked.
> 
> I don't know, though, why your cached data has bit 16 set....
Hi Borislav,
	Sorry, my previous test patch has some issue, but I think I
should have found the root cause now. Could you please try following
patch directly on top of tip/master without reverting any patch?
Thanks!
Gerry

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 5307320c08e6..ec193bc6712e 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1885,7 +1885,7 @@ static int ioapic_set_affinity(struct irq_data
*irq_data,
        raw_spin_lock_irqsave(&ioapic_lock, flags);
        if (ret >= 0 && ret != IRQ_SET_MASK_OK_DONE) {
                cfg = irqd_cfg(irq_data);
-               data->entry.dest = SET_APIC_LOGICAL_ID(cfg->dest_apicid);
+               data->entry.dest = cfg->dest_apicid;
                data->entry.vector = cfg->vector;
                for_each_irq_pin(entry, data->irq_2_pin)
                        __ioapic_write_entry(entry->apic, entry->pin,

> 
> This is all a big IMHO of course...
> 
