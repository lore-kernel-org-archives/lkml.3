Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbaHAWuz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 18:50:55 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45959 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754809AbaHAWux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 18:50:53 -0400
Date: Sat, 2 Aug 2014 00:50:49 +0200
From: Borislav Petkov <bp@alien8.de>
To: =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-pci@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, irq: Keep IRQ assignment for PCI devices during
 suspend/hibernation, bisected
Message-ID: <20140801225049.GC4553@pd.tnic>
References: <20140730175836.GC10213@pd.tnic>
 <1406766807-5745-1-git-send-email-jiang.liu@linux.intel.com>
 <20140731103941.GA4375@pd.tnic>
 <53DA70AB.9010906@linux.intel.com>
 <20140731165648.GG4375@pd.tnic>
 <20140801105618.GA3857@nazgul.tnic>
 <53DB87AB.1000900@linux.intel.com>
 <20140801143922.GB5406@pd.tnic>
 <20140801161107.GA4553@pd.tnic>
 <20140801221410.GT9809@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140801221410.GT9809@8bytes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2014 at 12:14:10AM +0200, Jörg Rödel wrote:
> My guess is that the firmware takes back the device after the OS
> released it and now the legacy emulation tries to do DMA with it. But
> since there is an IOMMU the physical addresses it tries to DMA to is
> not mapped and it generated IO page faults
> 
> In a perfect world the BIOS would define Unity Mapping regions in the
> IVRS ACPI table for the USB controler so that the IOMMU driver would
> keep these regions mapped.  But I have never seen those regions defined
> by any BIOS of an AMD machine, so this is probably the cause why you are
> seeing these IO page faults.

Ok but what changed? Apparently we didn't have that small window earlier
as I have never seen those IOMMU PFs before. So Jiang's stuff simply
opens that hole now. And I bet this whole work is aiming at physical
hotplug which is all fine and dandy but it shouldn't cause regressions.

So, IIUC, the dynamic IOAPIC stuff of freeing an irq number during
suspend opens this hole. Which leads me to the naive thinking that maybe
this new behavior should be configurable so that systems can choose.

And I bet I won't be the last one to trigger those when those changes
hit 3.17...

> But this doesn't explain the GPU faults, though.

I think this got fixed by

https://lkml.kernel.org/r/1406766807-5745-1-git-send-email-jiang.liu@linux.intel.com

which keeps the IRQ numbers across S/R.

I'll watch out for those though.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
