Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933876AbaFJCzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 22:55:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:28478 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754382AbaFJCzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 22:55:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,1006,1392192000"; 
   d="scan'208";a="552982482"
Message-ID: <53967383.1000908@linux.intel.com>
Date: Tue, 10 Jun 2014 10:54:59 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [Patch V4 01/42] x86, irq: update high address field when updating
 affinity for MSI IRQ
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>	<1402302011-23642-2-git-send-email-jiang.liu@linux.intel.com> <CAE9FiQXiZZG=FdafLVEBM_ENO50xxOZ19M3k5KwzsR7M0b2P=w@mail.gmail.com>
In-Reply-To: <CAE9FiQXiZZG=FdafLVEBM_ENO50xxOZ19M3k5KwzsR7M0b2P=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/6/10 7:46, Yinghai Lu wrote:
> On Mon, Jun 9, 2014 at 1:19 AM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
>> If x2apic is enabled, the MSI high address field should also be aslo
>> updated when setting affinity for MSI IRQ, otherwise the MSI IRQ may
>> target wrong APIC IDs.
> 
> Do you have any test case to reveal the problem?
Just by code inspection.

> 
>>
>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>> Cc: stable@vger.kernel.org
>> ---
>>  arch/x86/kernel/apic/io_apic.c |    4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
>> index 9d0a9795a0f8..2de992501a1b 100644
>> --- a/arch/x86/kernel/apic/io_apic.c
>> +++ b/arch/x86/kernel/apic/io_apic.c
>> @@ -3007,6 +3007,10 @@ msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
>>
>>         __get_cached_msi_msg(data->msi_desc, &msg);
>>
>> +       msg.address_hi = MSI_ADDR_BASE_HI;
>> +       if (x2apic_enabled())
>> +               msg.address_hi |= MSI_ADDR_EXT_DEST_ID(dest);
>> +
>>         msg.data &= ~MSI_DATA_VECTOR_MASK;
>>         msg.data |= MSI_DATA_VECTOR(cfg->vector);
>>         msg.address_lo &= ~MSI_ADDR_DEST_ID_MASK;
> 
> No. This change is not needed.
> 
> When x2apic is used, and apicid > 255, irq remapping is used.
> 
> msi_chip.irq_set_affinity will be changed from msi_set_affinity to
> x86_io_apic_ops.set_affinity (aka intel_setup_ioapic_entry),  via
> irq_remap_modify_chip_defaults().
Thanks for explanation, will drop this patch.
Gerry
> 
> Thanks
> 
> Yinghai
> 
