Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbaHAQLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 12:11:14 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35876 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbaHAQLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 12:11:12 -0400
Date: Fri, 1 Aug 2014 18:11:08 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jiang Liu <jiang.liu@linux.intel.com>,
        =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, irq: Keep IRQ assignment for PCI devices during
 suspend/hibernation, bisected
Message-ID: <20140801161107.GA4553@pd.tnic>
References: <20140730175836.GC10213@pd.tnic>
 <1406766807-5745-1-git-send-email-jiang.liu@linux.intel.com>
 <20140731103941.GA4375@pd.tnic>
 <53DA70AB.9010906@linux.intel.com>
 <20140731165648.GG4375@pd.tnic>
 <20140801105618.GA3857@nazgul.tnic>
 <53DB87AB.1000900@linux.intel.com>
 <20140801143922.GB5406@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140801143922.GB5406@pd.tnic>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 04:39:22PM +0200, Borislav Petkov wrote:
> I could try to disable the IOMMU and see whether it still triggers.
> That could tell us something.

Ok, let me summarize what I've been able to observe so far:

* https://lkml.kernel.org/r/1406766807-5745-1-git-send-email-jiang.liu@linux.intel.com

this is definitely needed for suspend/resume so for that patch

Acked-and-tested-by: Borislav Petkov <bp@suse.de>

(I need to somehow justify a whole day of bisecting today :-P)

* Then, this
---
diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
index 82044b5d6113..efc953119ce2 100644
--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -380,6 +380,8 @@ void usb_hcd_pci_shutdown(struct pci_dev *dev)
 	if (test_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags) &&
 			hcd->driver->shutdown) {
 		hcd->driver->shutdown(hcd);
+		if (usb_hcd_is_primary_hcd(hcd) && hcd->irq > 0)
+			free_irq(hcd->irq, hcd);
 		pci_disable_device(dev);
 	}
 }
--

is needed for not triggering the remove_proc_entry() WARN_ON.

Finally, even with this hunk above, suspend works fine but I see IOMMU
PFs sometimes(!). Yes, sometimes as in it suspends fine without even
screaming at all and sometimes I get a few of those right before the
machine goes down:

[   89.040795] pcieport 0000:00:04.0: System wakeup enabled by ACPI
[   89.061697] AMD-Vi: Event logged [IO_PAGE_FAULT device=01:00.0 domain=0x0014 address=0x0000000020001000 flags=0x0000]
[   89.071871] ACPI: Preparing to enter system sleep state S5
[   89.072117] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query honored via cmdline
[   89.089832] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x0000000000000080 flags=0x0020]
[   89.102239] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x0000000000000000 flags=0x0000]
[   89.114684] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
[   89.127162] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
[   89.139576] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
[   89.152017] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
[   89.164481] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
[   89.176994] AMD-Vi: Event logged [[   89.177657] reboot: Power down
[   89.185286] acpi_power_off called

Now this device 00:12.0 is that OHCI thing for which we have the
hcd-pci.c hunk applied above, AFAICT:

00:12.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller

so it must be still some timing issue there after disabling the device
and *before* disabling the IOMMU.

I don't have a clue how to further debug that. Joerg is on CC.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
