Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbaE1KIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 06:08:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:33833 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbaE1KIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 06:08:10 -0400
Date: Wed, 28 May 2014 12:07:50 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        linux-pm@vger.kernel.org
Subject: Re: [Patch V3 19/37] x86, irq: introduce mechanisms to support
 dynamically allocate IRQ for IOAPIC
In-Reply-To: <538597F0.1040003@linutronix.de>
Message-ID: <alpine.DEB.2.02.1405281159030.21720@ionos.tec.linutronix.de>
References: <1401178092-1228-1-git-send-email-jiang.liu@linux.intel.com> <1401178092-1228-20-git-send-email-jiang.liu@linux.intel.com> <alpine.DEB.2.02.1405271445050.21720@ionos.tec.linutronix.de> <538597F0.1040003@linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 May 2014, Sebastian Andrzej Siewior wrote:
> On 05/27/2014 09:58 PM, Thomas Gleixner wrote:
> > ce4100 is an oddball though. The ioapic is registered way before the
> > interrupt subsystem is initialized and I have a hard time to
> > understand that comment:
> > 
> >         /* We can't set this earlier, because we need to calibrate the timer */
> >         legacy_pic = &null_legacy_pic;
> > 
> > The timer calibration happens after the interrupts are set up. I
> > assume it's check_timer() which wants that, but we know exactly how
> > the ce4100 works, so we might be able to avoid that whole "testing"
> > stuff. Sebastian, any input on this?
> 
> According to my memory there was some PIC init we need but I don't
> recall the details. However, booting the system with "legacy_pic =
> &null_legacy_pic;" in x86_ce4100_early_setup() gives me this:
> 
> [    0.001000] Enabling APIC mode:  Flat.  Using 2 I/O APICs
> [    0.001000] leaving PIC mode, enabling APIC mode.
> [    0.001000] enabled ExtINT on CPU#0
> [    0.001000] ENABLING IO-APIC IRQs
> [    0.001000] Setting 1 in the phys_id_present_map
> [    0.001000] ...changing IO-APIC physical APIC ID to 1 ... ok.
> [    0.001000] Setting 2 in the phys_id_present_map
> [    0.001000] ...changing IO-APIC physical APIC ID to 2 ... ok.
> [    0.001000] smpboot: CPU0: Intel(R) Atom(TM) CPU CE4150   @ 1.20GHz
> (fam: 06, model: 1c, stepping: 0a)
> [    0.001000] Using local APIC timer interrupts.
> [    0.001000] calibrating APIC timer ...
> 
> and we stand still. With the assignment as it is now:
> 
> [    0.001000] Enabling APIC mode:  Flat.  Using 2 I/O APICs
> [    0.001000] leaving PIC mode, enabling APIC mode.
> [    0.001000] enabled ExtINT on CPU#0
> [    0.002312] ENABLING IO-APIC IRQs
> [    0.003009] Setting 1 in the phys_id_present_map
> [    0.004007] ...changing IO-APIC physical APIC ID to 1 ... ok.
> [    0.005533] Setting 2 in the phys_id_present_map
> [    0.006006] ...changing IO-APIC physical APIC ID to 2 ... ok.
> [    0.008373] ..TIMER: vector=0x30 apic1=-1 pin1=-1 apic2=-1 pin2=-1
> [    0.009000] ...trying to set up timer as Virtual Wire IRQ...
> [    0.019490] ..... works.

Right, so it needs the setup of irq 0 and that only happens when the
legacy_pic->nr_legacy_irqs > 0.

Do you remember, why we switch to the null_pic later on?

Thanks,

	tglx


