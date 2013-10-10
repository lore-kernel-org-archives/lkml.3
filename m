Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab3JJW5w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 18:57:52 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62982 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754273Ab3JJW5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 18:57:50 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [BUG] WARN_ON(!context) in drivers/pci/hotplug/acpiphp_glue.c
Date: Fri, 11 Oct 2013 01:09:33 +0200
Message-ID: <2679976.SxBsymIdoJ@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CA+55aFwA8WZ+ARtNFFY+z4d8kS5AUBLg32iu7Jkk3rsz_i1OZw@mail.gmail.com>
References: <20131010165905.7815defa@gandalf.local.home> <81272921.7ZJW2CaxNE@vostro.rjw.lan> <CA+55aFwA8WZ+ARtNFFY+z4d8kS5AUBLg32iu7Jkk3rsz_i1OZw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 10, 2013 02:37:15 PM Linus Torvalds wrote:
> On Thu, Oct 10, 2013 at 2:35 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> >
> > Well, I must have overlooked the original report.  Is it available anywhere
> > I can find it?
> 
> I think Steven has some buggered email system, he has other emails
> being eaten by lkml too, and apparently other mail gateways (because
> you were direct-cc'd on the original).

Mailer issues aside, I've just seen the original (Bjorn forwarded it to me,
thanks!) and I'm wondering if the message added by the debug patch below is
triggered along with the WARN_ON().  If it is, I think it's better to drop
the WARN_ON(), at least for now (until we sort out the acpiphp/pciehp
coexistence).

Rafael


---
 drivers/pci/hotplug/acpiphp_glue.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -991,6 +991,11 @@ void acpiphp_enumerate_slots(struct pci_
 
 	if (!pci_is_root_bus(bridge->pci_bus)) {
 		struct acpiphp_context *context;
+		struct pci_dev *parent = bridge->pci_bus->parent->self;
+
+		if (parent && device_is_managed_by_native_pciehp(parent))
+			dev_warn(&bridge->pci_dev->dev,
+				 "Parent is managed by pciehp!\n");
 
 		/*
 		 * This bridge should have been registered as a hotplug function



