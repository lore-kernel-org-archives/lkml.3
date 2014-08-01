Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbaHAM12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 08:27:28 -0400
Received: from mga01.intel.com ([192.55.52.88]:17386 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbaHAM11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 08:27:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,780,1400050800"; 
   d="scan'208";a="578721121"
Message-ID: <53DB87AB.1000900@linux.intel.com>
Date: Fri, 01 Aug 2014 20:27:23 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, irq: Keep IRQ assignment for PCI devices during
 suspend/hibernation, bisected
References: <20140730175836.GC10213@pd.tnic> <1406766807-5745-1-git-send-email-jiang.liu@linux.intel.com> <20140731103941.GA4375@pd.tnic> <53DA70AB.9010906@linux.intel.com> <20140731165648.GG4375@pd.tnic> <20140801105618.GA3857@nazgul.tnic>
In-Reply-To: <20140801105618.GA3857@nazgul.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014/8/1 18:56, Borislav Petkov wrote:
> Ok,
> 
> so I went and looked at tip and which branches could be the usual
> suspects. And whaddya know, tip/x86/apic was the first to pick and it
> contained the culprit:
> 
> 6a38fa0e3c94 ("x86, irq, ACPI: Release IOAPIC pin when PCI device is disabled")
Hi Borislav,
	The above commit may cause failure of suspend/hiberrnation.
The reason is:
1) With recent changers, we dynamically allocate irq number for IOAPIC
   pins.
2) The allocated irq will be released when suspending/hibernating.
	pci_disable_device()->pcibios_disable_irq()
3) When resuming, a different irq may be assigned to the PCI device.
	pci_enable_device()->pcibios_enable_irq()
4) Now the hardware will deliver interrupt to the new allocated irq
   but the interrupt handler is still registered on old irq, so it
   breaks the driver and causes failure of hibernation.

The patch sent out by me is to fix this issue by keeping the allocated
irq when suspend/hibernate. And seems it works as expected.

But I still don't know why it causes IOMMU related warnings as:
AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009
address=0x0000000000000000 flags=0x0000]

Regards!
Gerry
> 
> It seems like my machine doesn't like releasing the IOAPIC pin. Or,
> maybe it is IOMMU-related and the IOMMU doesn't like this releasing of
> the pin *after* the device gets suspended and *before* the IOMMU.
> 
> Strange.
> 
> Oh well, a well deserved lunch now :)
> 
