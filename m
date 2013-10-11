Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab3JKVrH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 17:47:07 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63009 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754599Ab3JKVrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 17:47:04 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [BUG] WARN_ON(!context) in drivers/pci/hotplug/acpiphp_glue.c
Date: Fri, 11 Oct 2013 23:58:48 +0200
Message-ID: <4905498.aEGIofg2fM@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CA+55aFyJL5gLGtg8-z1t1xSY1ih9MAzsDzMZaxrEYZOFZ7rRBw@mail.gmail.com>
References: <20131010165905.7815defa@gandalf.local.home> <2096980.ZtIelfoX39@vostro.rjw.lan> <CA+55aFyJL5gLGtg8-z1t1xSY1ih9MAzsDzMZaxrEYZOFZ7rRBw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 11, 2013 10:21:35 AM Linus Torvalds wrote:
> On Fri, Oct 11, 2013 at 4:13 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > +/**
> > + * slot_should_be_exposed - Check whether or not to expose a slot to userland.
> > + * @bridge: ACPIPHP bridge the slot belongs to.
> > + * @handle: ACPI handle of a device in the slot.
> > + */
> > +static inline bool slot_should_be_exposed(struct acpiphp_bridge *bridge,
> > +                                         acpi_handle handle)
> 
> Thanks, that looks much better.
> 
> I do worry that we now seem to add the slot to all the acpiphp lists
> even if it is managed by pciehp. That gets rid of the warning Steven
> saw (because now it always has that context), but I'm left wondering
> how much pcihp and aciphp will fight over the slot.
>
> Yes, the acpiphp_register_hotplug_slot() doesn't get called, but we
> still do register_hotplug_dock_device(), for example. How does that
> interact with pcihp that thinks it owns the slot?

Well, owning the slot doesn't really mean much here, because the "rescan"
and "remove" things may always be triggered by user space via sysfs from
under the PCI device in question (regardless of whether or not pciehp
thinks that it "owns" that device).  So if they are triggered by an ACPI
notify instead, that should still be fine.

Ejects are more of a gray area, but they do the "remove" first and only
then they go for an actual "eject".  Question is if we should execute
_EJ0 provided that it's actually present for the pciehp slots (which we will
do with the patch applied).  It might be safer to trigger the native eject
then, but again I'd be surprised if _EJ0 didn't work anyway (if there is a
system in which _EJ0 is available for a device handled by pciehp in the first
place).

As far as docking stations go, the undock is done by ACPI anyway and it will
carry out "remove" for all devices under the dock, so the patch doesn't change
this particular case as far as I can say.

> Or am I misreading the code? It's more readable, and no longer makes
> me homicidal, but I don't actually know the code itself.

I think you're reading it correctly, it really makes acpiphp see all slots
even if pciehp sees them too.  So the change is somewhat risky.

That said the risk doesn't seem to be huge and there seem to be cases in
which it actually would be useful to have both acpiphp and pciehp signaling
available for the same device.  For example, even if the BIOS told us that
we could use the native mechanism (pciehp), it may not actually work.  That is,
we may not get any hotplug interrupts from PCIe ports due to platform bugs of
some sort and we may get ACPI notifications instead (because the platform
designer knew about those bugs and thought it would be smart to use ACPI to
work around them).

There are bug reports indicating thinks like that, so we were going to allow
acpiphp and pciehp to handle the same devices anyway at one point.  I thought
we might as well try to do it now and see how it goes.  Still, if you think
it's too risky for this stage of the cycle, I'll just send a patch removing
the WARN_ON() and we'll revisit that thing in 3.13.

Rafael

