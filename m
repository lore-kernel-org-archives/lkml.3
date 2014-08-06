Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbaHFKXB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 06:23:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:3711 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbaHFKW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 06:22:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,811,1400050800"; 
   d="scan'208";a="580774051"
Message-ID: <53E201FC.6010102@linux.intel.com>
Date: Wed, 06 Aug 2014 18:22:52 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@linaro.org>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [Bugfix 1/2] x86, irq, PCI: Keep IRQ assignment for PCI devices
 during suspend/hibernation
References: <1407209178-18644-1-git-send-email-jiang.liu@linux.intel.com> <1407209178-18644-2-git-send-email-jiang.liu@linux.intel.com> <20140805183729.GA23068@pd.tnic>
In-Reply-To: <20140805183729.GA23068@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/8/6 2:37, Borislav Petkov wrote:
> On Tue, Aug 05, 2014 at 11:26:17AM +0800, Jiang Liu wrote:
>> Now IOAPIC driver dynamically allocates IRQ numbers for IOAPIC pins.
>> We need to keep IRQ assignment for PCI devices during suspend/hibernation,
>> otherwise it may cause failure of suspend/hibernation due to:
>> 1) Device driver calls pci_enable_device() to allocate an IRQ number
>>    and register interrupt handler on the returned IRQ.
>> 2) Device driver's suspend callback calls pci_disable_device() and
>>    release assigned IRQ in turn.
>> 3) Device driver's resume callback calls pci_enable_device() to
>>    allocate IRQ number again. A different IRQ number may be assigned
>>    by IOAPIC driver this time.
>> 4) Now the hardware delivers interrupt to the new IRQ but interrupt
>>    handler is still registered against the old IRQ, so it breaks
>>    suspend/hibernation.
>>
>> To fix this issue, we keep IRQ assignment during suspend/hibernation.
>> Flag pci_dev.dev.power.is_prepared is used to detect that
>> pci_disable_device() is called during suspend/hibernation.
>>
>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>> ---
>> Hi Borislav,
>> 	Could you please help to review the patch again since I have
>> made changes against the previous version?
> 
> I think you're asking me to test that patch, correct?
> 
> If so, what is the exact tree I need to apply? tip/x86/apic + those two
> patches here? What else? What about the USB chunk which removes the proc
> splat, is that somewhere too? Maybe Linus did pull it already?
> 
> Please specify what exactly I should test.
Hi Borislav,
	I have prepared a tree for you at
https://github.com/jiangliu/linux.git suspend2

It's based on tip/master and includes:
1) the patch to fix warning caused  by USB controller
2) these two patches to fix failure of suspend/hibernation

Could you please help to check whether suspend/hibernation works as
expect on your platforms?
Thanks!
Gerry

> 
> Thanks.
> 
