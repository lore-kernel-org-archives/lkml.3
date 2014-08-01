Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756536AbaHAWOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 18:14:15 -0400
Received: from 8bytes.org ([81.169.241.247]:49922 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514AbaHAWON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 18:14:13 -0400
Date: Sat, 2 Aug 2014 00:14:10 +0200
From: =?iso-8859-1?Q?J=F6rg_R=F6del?= <joro@8bytes.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, irq: Keep IRQ assignment for PCI devices during
 suspend/hibernation, bisected
Message-ID: <20140801221410.GT9809@8bytes.org>
References: <20140730175836.GC10213@pd.tnic>
 <1406766807-5745-1-git-send-email-jiang.liu@linux.intel.com>
 <20140731103941.GA4375@pd.tnic>
 <53DA70AB.9010906@linux.intel.com>
 <20140731165648.GG4375@pd.tnic>
 <20140801105618.GA3857@nazgul.tnic>
 <53DB87AB.1000900@linux.intel.com>
 <20140801143922.GB5406@pd.tnic>
 <20140801161107.GA4553@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140801161107.GA4553@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2014 at 06:11:08PM +0200, Borislav Petkov wrote:
> [   89.040795] pcieport 0000:00:04.0: System wakeup enabled by ACPI
> [   89.061697] AMD-Vi: Event logged [IO_PAGE_FAULT device=01:00.0 domain=0x0014 address=0x0000000020001000 flags=0x0000]
> [   89.071871] ACPI: Preparing to enter system sleep state S5
> [   89.072117] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query honored via cmdline
> [   89.089832] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x0000000000000080 flags=0x0020]
> [   89.102239] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x0000000000000000 flags=0x0000]
> [   89.114684] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
> [   89.127162] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
> [   89.139576] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
> [   89.152017] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
> [   89.164481] AMD-Vi: Event logged [IO_PAGE_FAULT device=00:12.0 domain=0x0009 address=0x00000000ffffffc0 flags=0x0010]
> [   89.176994] AMD-Vi: Event logged [[   89.177657] reboot: Power down
> [   89.185286] acpi_power_off called
> 
> Now this device 00:12.0 is that OHCI thing for which we have the
> hcd-pci.c hunk applied above, AFAICT:
> 
> 00:12.0 USB controller: Advanced Micro Devices, Inc. [AMD/ATI] SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
> 
> so it must be still some timing issue there after disabling the device
> and *before* disabling the IOMMU.

My guess is that the firmware takes back the device after the OS
released it and now the legacy emulation tries to do DMA with it. But
since there is an IOMMU the physical addresses it tries to DMA to is
not mapped and it generated IO page faults

In a perfect world the BIOS would define Unity Mapping regions in the
IVRS ACPI table for the USB controler so that the IOMMU driver would
keep these regions mapped.  But I have never seen those regions defined
by any BIOS of an AMD machine, so this is probably the cause why you are
seeing these IO page faults.

But this doesn't explain the GPU faults, though.


	Joerg

