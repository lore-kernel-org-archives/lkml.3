Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbaK1Cbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 21:31:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:39256 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbaK1Cbv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 21:31:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,473,1413270000"; 
   d="scan'208";a="644797490"
Message-ID: <5477DE90.5090500@linux.intel.com>
Date: Fri, 28 Nov 2014 10:31:44 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, tip-bot for Jiang Liu <tipbot@zytor.com>
CC: linux-tip-commits@vger.kernel.org, mingo@kernel.org, rdunlap@infradead.org,
        bhelgaas@google.com, hpa@zytor.com, tony.luck@intel.com,
        rjw@rjwysocki.net, grant.likely@linaro.org, konrad.wilk@oracle.com,
        gregkh@linuxfoundation.org, tglx@linutronix.de, yinghai@kernel.org,
        joro@8bytes.org, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, jroedel@suse.de
Subject: Re: [tip:x86/apic] x86, irq: Use cached IOAPIC entry instead of reading
 from hardware
References: <1416901802-24211-30-git-send-email-jiang.liu@linux.intel.com> <tip-fda7c08b1349cc4c65f8a5240b10f7e9938604b8@git.kernel.org> <20141127193213.GB4190@pd.tnic>
In-Reply-To: <20141127193213.GB4190@pd.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/11/28 3:32, Borislav Petkov wrote:
> On Wed, Nov 26, 2014 at 03:20:08PM -0800, tip-bot for Jiang Liu wrote:
>> Commit-ID:  fda7c08b1349cc4c65f8a5240b10f7e9938604b8
>> Gitweb:     http://git.kernel.org/tip/fda7c08b1349cc4c65f8a5240b10f7e9938604b8
>> Author:     Jiang Liu <jiang.liu@linux.intel.com>
>> AuthorDate: Tue, 25 Nov 2014 15:49:53 +0800
>> Committer:  Thomas Gleixner <tglx@linutronix.de>
>> CommitDate: Wed, 26 Nov 2014 23:52:49 +0100
>>
>> x86, irq: Use cached IOAPIC entry instead of reading from hardware
>>
>> Use cached IOAPIC entry instead of reading data from IOAPIC hardware
>> registers to improve performance.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
<snit>
>> @@ -1729,28 +1712,6 @@ static unsigned int startup_ioapic_irq(struct irq_data *data)
>>  	return was_pending;
>>  }
>>  
>> -static void __target_IO_APIC_irq(unsigned int irq, struct irq_cfg *cfg,
>> -				 struct mp_chip_data *data)
>> -{
>> -	int apic, pin;
>> -	struct irq_pin_list *entry;
>> -	u8 vector = cfg->vector;
>> -	unsigned int dest = SET_APIC_LOGICAL_ID(cfg->dest_apicid);
>> -
>> -	for_each_irq_pin(entry, data->irq_2_pin) {
>> -		unsigned int reg;
>> -
>> -		apic = entry->apic;
>> -		pin = entry->pin;
>> -
>> -		io_apic_write(apic, 0x11 + pin*2, dest);
>> -		reg = io_apic_read(apic, 0x10 + pin*2);
>> -		reg &= ~IO_APIC_REDIR_VECTOR_MASK;
>> -		reg |= vector;
>> -		io_apic_modify(apic, 0x10 + pin*2, reg);
>> -	}
>> -}
>> -
>>  atomic_t irq_mis_count;
>>  
>>  #ifdef CONFIG_GENERIC_PENDING_IRQ
>> @@ -1916,6 +1877,7 @@ static int ioapic_set_affinity(struct irq_data *irq_data,
>>  {
>>  	struct irq_data *parent = irq_data->parent_data;
>>  	struct mp_chip_data *data = irq_data->chip_data;
>> +	struct irq_pin_list *entry;
>>  	struct irq_cfg *cfg;
>>  	unsigned long flags;
>>  	int ret;
>> @@ -1926,7 +1888,9 @@ static int ioapic_set_affinity(struct irq_data *irq_data,
>>  		cfg = irqd_cfg(irq_data);
>>  		data->entry.dest = SET_APIC_LOGICAL_ID(cfg->dest_apicid);
>>  		data->entry.vector = cfg->vector;
>> -		__target_IO_APIC_irq(irq_data->irq, cfg, irq_data->chip_data);
>> +		for_each_irq_pin(entry, data->irq_2_pin)
>> +			__ioapic_write_entry(entry->apic, entry->pin,
>> +					     data->entry);
>>  	}
> 
> So let me hold down what tglx and I have been staring at a whole day
> today. This commit breaks booting my AMD laptop with the error messages
> below. The machine ends up in the emergency shell, completely unusable.
> 
> When I revert the commit, x86/apic boots fine again. Btw, I was able to
> reproduce the same issue in a kvm guest so something's definitely wrong.
> 
> If I revert only the last hunk and do
> 
> 	__target_IO_APIC_irq(irq_data->irq, cfg, irq_data->chip_data);
> 
> instead and leave the loop over the irq pins in that function as the old
> icode did t, the problem disappears.
Hi Borislav,
	Thanks for tracking down to this line of change. I have no
platform to reproduce this bug, so could you please help to revert this
commit and apply following patch to get some data about IOAPIC entry?
Thanks!
Gerry
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index a915ee005148..cfada57140bd 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1736,7 +1736,9 @@ static void __target_IO_APIC_irq(unsigned int irq,
struct irq_cfg *cfg,
        struct irq_pin_list *entry;
        u8 vector = cfg->vector;
        unsigned int dest = SET_APIC_LOGICAL_ID(cfg->dest_apicid);
+       union entry_union eu;

+       eu.entry = data->entry;
        for_each_irq_pin(entry, data->irq_2_pin) {
                unsigned int reg;

@@ -1748,6 +1750,7 @@ static void __target_IO_APIC_irq(unsigned int irq,
struct irq_cfg *cfg,
                reg &= ~IO_APIC_REDIR_VECTOR_MASK;
                reg |= vector;
                io_apic_modify(apic, 0x10 + pin*2, reg);
+               pr_warn("ioapic%d pin%d, hardware reg %x, cached data
%x\n", apic, pin, reg, eu.w1);
        }
 }


> 
> I've been trying different things but nothing helped so far as to
> pinpoint where the problem lies. Thus this mail to hold down the current
> situation. More staring later, on a clear head.
> 
> [    3.465391] PM: Checking hibernation image partition /dev/sda2
> [    3.497559] PM: Hibernation image partition 8:2 present
> [    3.501859] PM: Looking for hibernation image.
> [    6.600378] usb 1-1: New USB device found, idVendor=0627, idProduct=0001
> [    6.608098] usb 1-1: New USB device strings: Mfr=1, Product=3, SerialNumber=5
> [    6.614747] usb 1-1: Product: QEMU USB Tablet
> [    6.617966] usb 1-1: Manufacturer: QEMU
> [    6.632779] usb 1-1: SerialNumber: 42
> [    7.648783] ata2.00: qc timeout (cmd 0xa0)
> [    7.655222] ata2.00: TEST_UNIT_READY failed (err_mask=0x5)
> [    7.818934] ata2.01: NODEV after polling detection
> [    7.849882] ata2.00: configured for MWDMA2
> [    8.585096] input: QEMU QEMU USB Tablet as /devices/pci0000:00/0000:00:01.2/usb1/1-1/1-1:1.0/0003:0627:0001.0001/input/input1
> [    8.598044] hid-generic 0003:0627:0001.0001: input,hidraw0: USB HID v0.01 Pointer [QEMU QEMU USB Tablet] on usb-0000:00:01.2-1/input0
> [   12.852654] ata2.00: qc timeout (cmd 0xa0)
> [   12.855798] ata2.00: TEST_UNIT_READY failed (err_mask=0x5)
> [   12.859555] ata2.00: limiting speed to MWDMA2:PIO3
> [   13.017632] ata2.01: NODEV after polling detection
> [   13.024501] ata2.00: configured for MWDMA2
> [   18.028681] ata2.00: qc timeout (cmd 0xa0)
> [   18.035697] ata2.00: TEST_UNIT_READY failed (err_mask=0x5)
> [   18.042919] ata2.00: disabled
> [   18.045671] ata2: soft resetting link
> [   18.206824] ata2.01: NODEV after polling detection
> [   18.211174] ata2: EH complete
> [   32.873120] ata1: lost interrupt (Status 0x50)
> [   32.881800] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
> [   32.886772] ata1.00: failed command: READ DMA
> 
