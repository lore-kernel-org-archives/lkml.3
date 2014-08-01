Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbaHAOja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 10:39:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56732 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbaHAOj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 10:39:28 -0400
Date: Fri, 1 Aug 2014 16:39:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Subject: Re: [PATCH] x86, irq: Keep IRQ assignment for PCI devices during
 suspend/hibernation, bisected
Message-ID: <20140801143922.GB5406@pd.tnic>
References: <20140730175836.GC10213@pd.tnic>
 <1406766807-5745-1-git-send-email-jiang.liu@linux.intel.com>
 <20140731103941.GA4375@pd.tnic>
 <53DA70AB.9010906@linux.intel.com>
 <20140731165648.GG4375@pd.tnic>
 <20140801105618.GA3857@nazgul.tnic>
 <53DB87AB.1000900@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53DB87AB.1000900@linux.intel.com>
rom: Borislav Petkov <bp@alien8.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 08:27:23PM +0800, Jiang Liu wrote:
> 	The above commit may cause failure of suspend/hiberrnation.
> The reason is:
> 1) With recent changers, we dynamically allocate irq number for IOAPIC
>    pins.
> 2) The allocated irq will be released when suspending/hibernating.
> 	pci_disable_device()->pcibios_disable_irq()
> 3) When resuming, a different irq may be assigned to the PCI device.
> 	pci_enable_device()->pcibios_enable_irq()
> 4) Now the hardware will deliver interrupt to the new allocated irq
>    but the interrupt handler is still registered on old irq, so it
>    breaks the driver and causes failure of hibernation.
> 
> The patch sent out by me is to fix this issue by keeping the allocated
> irq when suspend/hibernate. And seems it works as expected.
> 
> But I still don't know why it causes IOMMU related warnings as:
> AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009
> address=0x0000000000000000 flags=0x0000]

Well, the devices in those change during my test runs. Once it was
00:13.0, once this, once the GPU. This box has IOMMU so it might be
related to that somehow.

I could try to disable the IOMMU and see whether it still triggers. That
could tell us something.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
