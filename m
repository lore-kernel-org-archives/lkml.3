Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbbASObj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 09:31:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:27608 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446AbbASObh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 09:31:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,427,1418112000"; 
   d="scan'208";a="514305281"
Message-ID: <54BD1544.5010001@linux.intel.com>
Date: Mon, 19 Jan 2015 22:31:32 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>
CC: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [Bugfix 3/3] x86/PCI: Refine the way to release PCI IRQ resources
References: <1421643344-17092-1-git-send-email-jiang.liu@linux.intel.com> <1421643344-17092-4-git-send-email-jiang.liu@linux.intel.com> <54BD138D.3090403@citrix.com>
In-Reply-To: <54BD138D.3090403@citrix.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2015/1/19 22:24, David Vrabel wrote:
> On 19/01/15 04:55, Jiang Liu wrote:
>> Some PCI device drivers assume that pci_dev->irq won't change after
>> calling pci_disable_device() and pci_enable_device() during suspend and
>> resume.
>>
>> Commit c03b3b0738a56cf283b0d05256988d5e3c8bd719 ("x86, irq, mpparse:
>> Release IOAPIC pin when PCI device is disabled") frees PCI IRQ
>> resources when pci_disable_device() is called and reallocate IRQ
>> resources when pci_enable_device() is called again. This breaks
>> above assumption. So commit 3eec595235c1 ("x86, irq, PCI: Keep IRQ
>> assignment for PCI devices during suspend/hibernation") and
>> 9eabc99a635a ("x86, irq, PCI: Keep IRQ assignment for runtime power
>> management") fix the issue by avoiding freeing/reallocating IRQ
>> resources during PCI device suspend/resume. They achieve this by
>> checking dev.power.is_prepared and dev.power.runtime_status.
>> PM maintainer, Rafael, then pointed out that it's really an ugly fix
>> which leaking PM internal state information to IRQ subsystem.
> 
> If this only affects pciback, perhaps it would be best to just fix it there?
Currently we already found it causes regressions to power management
subsystem and pciback driver, but other drivers may have the same
assumption. So it's safer to refine the irq resource management.
And it doesn't really provide much benefit to reclaim irq resource
when there's still a driver bound to the device.

> 
>> Recently David Vrabel <david.vrabel@citrix.com> also reports an
>> regression in pciback driver caused by commit cffe0a2b5a34 ("x86, irq:
>> Keep balance of IOAPIC pin reference count"). Please refer to:
> 
> Sander reported this regression.
Sorry, I copied the wrong email address. Will fix it in next version.
Regards!
Gerry

> 
>> So this patch refine the way to release PCI IRQ resources. Instead of
>> releasing PCI IRQ resources in pci_disable_device()/
>> pcibios_disable_device(), we now release it at driver unbinding
>> notification BUS_NOTIFY_UNBOUND_DRIVER. In other word, we only release
>> PCI IRQ resources when there's no driver bound to the PCI device, and
>> it keeps the assumption that pci_dev->irq won't through multiple
>> invocation of pci_enable_device()/pci_disable_device().
> 
> David
> 
