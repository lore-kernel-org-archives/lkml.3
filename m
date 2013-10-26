Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357Ab3JZJPJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Oct 2013 05:15:09 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:41174 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab3JZJPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Oct 2013 05:15:06 -0400
Date: Sat, 26 Oct 2013 11:15:01 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Adam Williamson <awilliam@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <David.Woodhouse@intel.com>
Cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lan Tianyu <tianyu.lan@intel.com>, Matthew Garrett <mjg@redhat.com>,
        Peter Anvin <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>,
        Robin Holt <holt@sgi.com>, davej@fedoraproject.org,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86/ACPI: Make Sony Vaio Z1 series to use "reboot=pci"
 default
Message-ID: <20131026091501.GE14237@gmail.com>
References: <1382597377-26797-1-git-send-email-tianyu.lan@intel.com>
 <20131025105352.GA5419@gmail.com>
 <1382719652.2445.1.camel@adam.happyassassin.net>
 <CA+55aFyZEZp3CSFEcxzKt0c_7Q9_juGWiqb7VH214Fjcs3wUkQ@mail.gmail.com>
 <1382750841.19471.72.camel@adam.happyassassin.net>
 <1382754015.19471.80.camel@adam.happyassassin.net>
 <20131026031759.GA8513@redhat.com>
 <1382772154.3604.1.camel@adam.happyassassin.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382772154.3604.1.camel@adam.happyassassin.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Adam Williamson <awilliam@redhat.com> wrote:

> On Fri, 2013-10-25 at 23:17 -0400, Dave Jones wrote:
> > On Fri, Oct 25, 2013 at 07:20:15PM -0700, Adam Williamson wrote:
> >  > OK, so, findings: F16 and F17 live images reboot quickly. F18 is the
> >  > first that reboots slowly.
> > 
> > wait, stop. what does "reboots slowly" mean ? 
> > In every one of the failure I've seen, without a quirk it means reboot
> > doesn't happen at all.
> 
> If you read the original report - on Z1s, if you leave the system alone,
> it sits at the 'Restarting system.' message for about two minutes, then
> finally reboots. If you pass 'reboot=pci', reboot is as fast as you'd
> expect.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=61721

So, the best range for the breakage we have is v3.3..v3.5.

As a blind shot into the dark, that turns out to be a range when a 
number of irq-remapping, vt-d changes went upstream:

comet:~/tip> gll v3.3..v3.6 arch/x86 | grep -i remap
399988eea194 irq_remap: Fix compiler warning with CONFIG_IRQ_REMAP=y
79fec2c557cf Merge tag 'intr-remapping-ops-for-ingo' of git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu into core/iommu
8a8f422d3b4f iommu: rename intr_remapping.[ch] to irq_remapping.[ch]
95a02e976c39 iommu: rename intr_remapping references to irq_remapping
263b5e8629c9 x86, iommu/vt-d: Clean up interfaces for interrupt remapping
5e2b930b0784 iommu/vt-d: Convert MSI remapping setup to remap_ops
9d619f657222 iommu/vt-d: Convert free_irte into a remap_ops callback
4c1bad6a0af1 iommu/vt-d: Convert IR set_affinity function to remap_ops
0c3f173a88c4 iommu/vt-d: Convert IR ioapic-setup to use remap_ops
4f3d8b67ad30 iommu/vt-d: Convert missing apic.c intr-remapping call to remap_ops
736baef4472d iommu/vt-d: Make intr-remapping initialization generic
f7219a5300ba x86: Introduce CONFIG_X86_DMA_REMAP

So if you are able to test current kernels, it might be an 
additional data point to see whether the reboot delay (which appears 
to be a reboot hang on other systems) is related to the following 
kernel option:

  CONFIG_IRQ_REMAP=y

(CONFIG_X86_DMA_REMAP is off on Fedora.)

IRQ_REMAP is somewhat of a dual personality feature, living half in 
arch/x86/, half in drivers/iommu/. It should normally matter for 
servers more than for laptops.

Btw., regarding your encrypted partitions boot problem, do you have 
any non-encrypted filesystem? If yes then you could copy /[s]bin and 
/lib to it and boot via init=/bin/bash, you ought to get a minimal 
shell and be able to run /sbin/reboot.

Thanks,

	Ingo
