Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab3AYBNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 20:13:09 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52380 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab3AYBNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 20:13:05 -0500
X-AuditID: 9c93016f-b7b70ae000000e36-7a-5101dc1dfc05
Date: Fri, 25 Jan 2013 10:13:03 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] x86, reboot: skip reboot_fixups in early boot phase
Message-ID: <20130125011303.GA3401@lge.com>
References: <1356702623-9430-1-git-send-email-js1304@gmail.com>
 <CAErSpo5_dgH1Au3QChVrhqBY_Fm54+Aw_ZiwGf2JSsgQaR1dug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo5_dgH1Au3QChVrhqBY_Fm54+Aw_ZiwGf2JSsgQaR1dug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Bjorn.

On Thu, Jan 24, 2013 at 10:45:13AM -0700, Bjorn Helgaas wrote:
> On Fri, Dec 28, 2012 at 6:50 AM, Joonsoo Kim <js1304@gmail.com> wrote:
> > During early boot phase, PCI bus subsystem is not yet initialized.
> > If panic is occured in early boot phase and panic_timeout is set,
> > code flow go into emergency_restart() and hit mach_reboot_fixups(), then
> > encounter another panic. When second panic, we can't hold a panic_lock, so
> > code flow go into panic_smp_self_stop() which prevent system to restart.
> >
> > For avoid second panic, skip reboot_fixups in early boot phase.
> > It makes panic_timeout works in early boot phase.
> >
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: Ingo Molnar <mingo@redhat.com>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Signed-off-by: Joonsoo Kim <js1304@gmail.com>
> >
> > diff --git a/arch/x86/kernel/reboot_fixups_32.c b/arch/x86/kernel/reboot_fixups_32.c
> > index c8e41e9..b9b8ec9 100644
> > --- a/arch/x86/kernel/reboot_fixups_32.c
> > +++ b/arch/x86/kernel/reboot_fixups_32.c
> > @@ -89,6 +89,10 @@ void mach_reboot_fixups(void)
> >         if (in_interrupt())
> >                 return;
> >
> > +       /* During early boot phase, PCI is not yet initialized */
> > +       if (system_state == SYSTEM_BOOTING)
> > +               return;
> > +
> >         for (i=0; i < ARRAY_SIZE(fixups_table); i++) {
> >                 cur = &(fixups_table[i]);
> >                 dev = pci_get_device(cur->vendor, cur->device, NULL);
> 
> I guess you're saying that if we call pci_get_device() too early, it
> panics?  Did you figure out why that happens?
> 
> If we call pci_get_device() before PCI has been initialized, it would
> be good if it just returned NULL, indicating that we didn't find any
> matching device.  I looked briefly, and I thought that's what would
> happen, but apparently I'm missing something.

In bus_find_device(), klist_iter_init_node() is called with 
@bus->p->klist_device. Before initialization, bus->p is NULL,
so panic is occured.

> Bjorn
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
