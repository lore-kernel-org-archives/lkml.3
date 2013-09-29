Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab3I2A25 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 20:28:57 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:52065 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755214Ab3I2A24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 20:28:56 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Please revert 928bea964827d7824b548c1f8e06eccbbc4d0d7d
Date: Sun, 29 Sep 2013 02:40:21 +0200
Message-ID: <3570038.ZGVWFnHvMQ@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CAE9FiQV8ipnQ_vV68S-QHMrUrQTWQT_XObxyBeR=dOuw6fG1eg@mail.gmail.com>
References: <1380270519.27811.10.camel@pasglop> <1380323960.27811.67.camel@pasglop> <CAE9FiQV8ipnQ_vV68S-QHMrUrQTWQT_XObxyBeR=dOuw6fG1eg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, September 27, 2013 04:44:20 PM Yinghai Lu wrote:
> [+ Rafael]
> 
> On Fri, Sep 27, 2013 at 4:19 PM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> > On Fri, 2013-09-27 at 15:56 -0700, Yinghai Lu wrote:
> >
> >> ok, please if you are ok attached one instead. It will print some warning about
> >> driver skipping pci_set_master, so we can catch more problem with drivers.
> >
> > Except that the message is pretty cryptic :-) Especially since the
> > driver causing the message to be printed is not the one that did
> > the mistake in the first place, it's the next one coming up that
> > trips the warning.
> >
> > In any case, the root cause is indeed the PCIe port driver:
> >
> > We don't have ACPI, so pcie_port_platform_notify() isn't implemented,
> > and pcie_ports_auto is true, so we end up with capabilities set to 0.
> 
> in
> | commit fe31e69740eddc7316071ed5165fed6703c8cd12
> | Author: Rafael J. Wysocki <rjw@sisk.pl>
> | Date:   Sun Dec 19 15:57:16 2010 +0100
> |
> |    PCI/PCIe: Clear Root PME Status bits early during system resume
> |
> |    I noticed that PCI Express PMEs don't work on my Toshiba Portege R500
> |    after the system has been woken up from a sleep state by a PME
> |    (through Wake-on-LAN).  After some investigation it turned out that
> |    the BIOS didn't clear the Root PME Status bit in the root port that
> |    received the wakeup PME and since the Requester ID was also set in
> |    the port's Root Status register, any subsequent PMEs didn't trigger
> |    interrupts.
> |
> |    This problem can be avoided by clearing the Root PME Status bits in
> |    all PCI Express root ports during early resume.  For this purpose,
> |    add an early resume routine to the PCIe port driver and make this
> |    driver be always registered, even if pci_ports_disable is set (in
> |    which case the driver's only function is to provide the early
> |    resume callback).
> |
> |
> |@@ -349,15 +349,18 @@ int pcie_port_device_register(struct pci_dev *dev)
> |        int status, capabilities, i, nr_service;
> |        int irqs[PCIE_PORT_DEVICE_MAXSERVICES];
> |
> |-       /* Get and check PCI Express port services */
> |-       capabilities = get_port_device_capability(dev);
> |-       if (!capabilities)
> |-               return -ENODEV;
> |-
> |        /* Enable PCI Express port device */
> |        status = pci_enable_device(dev);
> |        if (status)
> |                return status;
> |+
> |+       /* Get and check PCI Express port services */
> |+       capabilities = get_port_device_capability(dev);
> |+       if (!capabilities) {
> |+               pcie_no_aspm();
> |+               return 0;
> |+       }
> |+
> |        pci_set_master(dev);
> |        /*
> |         * Initialize service irqs. Don't use service devices that
> 
> >
> > Thus the port driver bails out before calling pci_set_master(). The fix
> > is to call pci_set_master() unconditionally. However that lead me to
> > find to a few interesting oddities in that port driver code:
> 
> can we revert that partially change ? aka we should check get_port....
> at first...
> 
> like attached.

It looks like we can do something like this (just pasting your patch):

diff --git a/drivers/pci/pcie/portdrv_core.c b/drivers/pci/pcie/portdrv_core.c
index 31063ac..1ee6f16 100644
--- a/drivers/pci/pcie/portdrv_core.c
+++ b/drivers/pci/pcie/portdrv_core.c
@@ -362,16 +362,16 @@ int pcie_port_device_register(struct pci_dev *dev)
 	int status, capabilities, i, nr_service;
 	int irqs[PCIE_PORT_DEVICE_MAXSERVICES];
 
-	/* Enable PCI Express port device */
-	status = pci_enable_device(dev);
-	if (status)
-		return status;
-
 	/* Get and check PCI Express port services */
 	capabilities = get_port_device_capability(dev);
 	if (!capabilities)
 		return 0;
 
+	/* Enable PCI Express port device */
+	status = pci_enable_device(dev);
+	if (status)
+		return status;
+
 	pci_set_master(dev);
 	/*
 	 * Initialize service irqs. Don't use service devices that

but I don't have that box with me to test whether or not it still works
correctly after this change.  I'll be back home on the next Saturday if
all goes well.

Thanks,
Rafael

