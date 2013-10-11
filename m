Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab3JKXot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 19:44:49 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49584 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753931Ab3JKXor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 19:44:47 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [BUG] WARN_ON(!context) in drivers/pci/hotplug/acpiphp_glue.c
Date: Sat, 12 Oct 2013 01:56:31 +0200
Message-ID: <4515770.NUXBX1NCHS@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <4905498.aEGIofg2fM@vostro.rjw.lan>
References: <20131010165905.7815defa@gandalf.local.home> <CA+55aFyJL5gLGtg8-z1t1xSY1ih9MAzsDzMZaxrEYZOFZ7rRBw@mail.gmail.com> <4905498.aEGIofg2fM@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 11, 2013 11:58:48 PM Rafael J. Wysocki wrote:
> On Friday, October 11, 2013 10:21:35 AM Linus Torvalds wrote:
> > On Fri, Oct 11, 2013 at 4:13 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:

[...]

> > Or am I misreading the code? It's more readable, and no longer makes
> > me homicidal, but I don't actually know the code itself.
> 
> I think you're reading it correctly, it really makes acpiphp see all slots
> even if pciehp sees them too.  So the change is somewhat risky.
> 
> That said the risk doesn't seem to be huge and there seem to be cases in
> which it actually would be useful to have both acpiphp and pciehp signaling
> available for the same device.  For example, even if the BIOS told us that
> we could use the native mechanism (pciehp), it may not actually work.  That is,
> we may not get any hotplug interrupts from PCIe ports due to platform bugs of
> some sort and we may get ACPI notifications instead (because the platform
> designer knew about those bugs and thought it would be smart to use ACPI to
> work around them).
> 
> There are bug reports indicating thinks like that, so we were going to allow
> acpiphp and pciehp to handle the same devices anyway at one point.  I thought
> we might as well try to do it now and see how it goes.  Still, if you think
> it's too risky for this stage of the cycle, I'll just send a patch removing
> the WARN_ON() and we'll revisit that thing in 3.13.

Having reconsidered this I think it's best to just drop the WARN_ON() for now
after all and sort out the coexistence between acpiphp and pciehp later, so
that we don't run into a weird corner case late in the cycle.

So the one below is what I'm going to do for 3.12.

Rafael

---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / hotplug / PCI: Drop WARN_ON() from acpiphp_enumerate_slots()

The WARN_ON() in acpiphp_enumerate_slots() triggers unnecessarily for
devices whose bridges are going to be handled by native PCIe hotplug
(pciehp) and the simplest way to prevent that from happening is to
drop the WARN_ON().

References: https://bugzilla.kernel.org/show_bug.cgi?id=62831
Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -999,12 +999,13 @@ void acpiphp_enumerate_slots(struct pci_
 
 		/*
 		 * This bridge should have been registered as a hotplug function
-		 * under its parent, so the context has to be there.  If not, we
-		 * are in deep goo.
+		 * under its parent, so the context should be there, unless the
+		 * parent is going to be handled by pciehp, in which case this
+		 * bridge is not interesting to us either.
 		 */
 		mutex_lock(&acpiphp_context_lock);
 		context = acpiphp_get_context(handle);
-		if (WARN_ON(!context)) {
+		if (!context) {
 			mutex_unlock(&acpiphp_context_lock);
 			put_device(&bus->dev);
 			kfree(bridge);

