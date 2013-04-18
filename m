Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab3DRXBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 19:01:33 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:49284 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab3DRXBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 19:01:32 -0400
X-Originating-IP: 173.246.103.110
Date: Thu, 18 Apr 2013 16:01:20 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>
Cc: Matt Fleming <matt@console-pimps.org>, matthew.garrett@nebula.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Darren Hart <darren.hart@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
Message-ID: <20130418230120.GA7078@jtriplet-mobl1>
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie>
 <516EAC4A.6040202@console-pimps.org>
 <516F1B90.9040508@nexus-software.ie>
 <516FD24A.3070502@console-pimps.org>
 <51706E8A.7030909@nexus-software.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51706E8A.7030909@nexus-software.ie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 11:07:06PM +0100, Bryan O'Donoghue wrote:
> 
> >     UEFI stands for "Unified Extensible Firmware Interface", where "Firmware"
> >     is an ancient African word meaning "Why do something right when you can
> >     do it so wrong that children will weep and brave adults will cower before
> >     you", and "UEI" is Celtic for "We missed DOS so we burned it into your
> >     ROMs". The UEFI specification provides for runtime services (ie, another
> >     way for the operating system to be forced to depend on the firmware) and
> >     we rely on these for certain trivial tasks such as setting up the
> >     bootloader. But some hardware fails to work if we attempt to use these
> >     runtime services from physical mode, and so we have to switch into virtual
> >     mode. So far so dreadful.
> >
> 
> "UEI" is Celtic for "We missed DOS so we burned it into your ROMS"
> 
> I love it "maith an fear"
> 
> >There are currently only two situations where we need to map EFI Boot
> >Service regions,
> >
> >   1. To workaround the firmware bug described in 916f676f8
> >   2. To access the ACPI BGRT image
> >
> >but since we haven't seen an i386 implementation that requires either,
> >this simple fix should suffice for now. Item 2. above does still work on
> >i386 provided that the BGRT image is not in highmem.
> 
> Matt, Peter, Josh, Darren.
> 
> Given it's not possible to guarantee someone won't stuff a BGRT into
> EFI_BOOT_MEMORY >= highmem eventually (and indeed the axioms of the
> universe pretty much guarantee eventually it will be so) - I'd
> suggest version 2.
> 
> A kernel parameter - rather than a probe for BGRT - since we
> anticipate BIOS bugs on the way.
> 
> Version 2 of the submitted path introduces an early kernel parameter
> "virt_mapboot" - which is true by default (maintaining the current
> behavior of mapping EFI_BOOT_MEMORY by default) - but which can be
> set to false - if your IA32 BIOS is not buggy.
> 
> Perhaps it would be better to be optimistic.
> 
> Change the behavior of efi_enter_virtual_mode() to do the right
> thing re: the standard and require passing of a parameter to switch
> on work-arounds for non-standards conformant BIOS. Note: this
> approach would break BGRT code - requiring addition of kernel
> parameters to existing systems - which from a user-friendliness POV
> is probably verboten....

I'd much rather see the code do the right thing automatically, rather
than requiring an "unbreak me" command-line parameter.

But in any case, since BGRT is a "make my system look prettier" feature
rather than core functionality, giving up on it on 32-bit EFI seems
fairly reasonable, especially since it may still work if stored
sufficiently low in memory.

- Josh Triplett
