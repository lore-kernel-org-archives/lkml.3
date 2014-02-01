Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167AbaBAOYI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 09:24:08 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61188 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932893AbaBAOYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 09:24:06 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "PCI: Remove from bus_list and release resources in pci_release_dev()"
Date: Sat, 01 Feb 2014 15:38:29 +0100
Message-ID: <14676899.LOmsodapl3@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <CAE9FiQX_AuSPq159AwDHP+n0k6FK3pS2CNttPFAJP2K-84ho1w@mail.gmail.com>
References: <20140130131236.GW18029@intel.com> <1676758.QjUXk2223P@vostro.rjw.lan> <CAE9FiQX_AuSPq159AwDHP+n0k6FK3pS2CNttPFAJP2K-84ho1w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 31, 2014 05:56:30 PM Yinghai Lu wrote:
> On Fri, Jan 31, 2014 at 3:34 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[...]

> > diff --git a/drivers/pci/remove.c b/drivers/pci/remove.c
> > index 4ff36bfa785e..b8c93c90daf5 100644
> > --- a/drivers/pci/remove.c
> > +++ b/drivers/pci/remove.c
> > @@ -3,6 +3,20 @@
> >  #include <linux/pci-aspm.h>
> >  #include "pci.h"
> >
> > +static void pci_free_resources(struct pci_dev *dev)
> > +{
> > +       int i;
> > +
> > +       msi_remove_pci_irq_vectors(dev);
> 
> looks like you are in a rush. Why do you put back msi_remove_pci_irq_vectors?

I simply did "git revert" and that's the result.

Sorry about overlooking that, but your commit's changelog didn't mention
removing it either.

Updated revert follows.

Thanks,
Rafael


---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: Revert "PCI: Remove from bus_list and release resources in pci_release_dev()"

Revert commit ef83b0781a73 "PCI: Remove from bus_list and release
resources in pci_release_dev()" that made some nasty race conditions
become possible.  For example, if a Thunderbolt link is unplugged
and then replugged immediately, the pci_release_dev() resulting from
the hot-remove code path may be racing with the hot-add code path
which after that commit causes various kinds of breakage to happen
(up to and including a hard crash of the whole system).

Moreover, the problem that commit ef83b0781a73 attempted to address
cannot happen any more after commit 8a4c5c329de7 "PCI: Check parent
kobject in pci_destroy_dev()", because pci_destroy_dev() will now
return immediately if it has already been executed for the given
device.

Note, however, that the invocation of msi_remove_pci_irq_vectors()
removed by commit ef83b0781a73 from pci_free_resources() along with
the other changes made by it is not added back because of subsequent
code changes depending on that modification.

Fixes: ef83b0781a73 (PCI: Remove from bus_list and release resources in pci_release_dev())
Reported-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

---
To unsubscribe from this list: send the line "unsubscribe linux-pci" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

---
 drivers/pci/probe.c  |   21 ++-------------------
 drivers/pci/remove.c |   17 +++++++++++++++++
 2 files changed, 19 insertions(+), 19 deletions(-)

Index: linux-pm/drivers/pci/probe.c
===================================================================
--- linux-pm.orig/drivers/pci/probe.c
+++ linux-pm/drivers/pci/probe.c
@@ -1208,18 +1208,6 @@ static void pci_release_capabilities(str
 	pci_free_cap_save_buffers(dev);
 }
 
-static void pci_free_resources(struct pci_dev *dev)
-{
-	int i;
-
-	pci_cleanup_rom(dev);
-	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
-		struct resource *res = dev->resource + i;
-		if (res->parent)
-			release_resource(res);
-	}
-}
-
 /**
  * pci_release_dev - free a pci device structure when all users of it are finished.
  * @dev: device that's been disconnected
@@ -1229,14 +1217,9 @@ static void pci_free_resources(struct pc
  */
 static void pci_release_dev(struct device *dev)
 {
-	struct pci_dev *pci_dev = to_pci_dev(dev);
-
-	down_write(&pci_bus_sem);
-	list_del(&pci_dev->bus_list);
-	up_write(&pci_bus_sem);
-
-	pci_free_resources(pci_dev);
+	struct pci_dev *pci_dev;
 
+	pci_dev = to_pci_dev(dev);
 	pci_release_capabilities(pci_dev);
 	pci_release_of_node(pci_dev);
 	pcibios_release_device(pci_dev);
Index: linux-pm/drivers/pci/remove.c
===================================================================
--- linux-pm.orig/drivers/pci/remove.c
+++ linux-pm/drivers/pci/remove.c
@@ -3,6 +3,18 @@
 #include <linux/pci-aspm.h>
 #include "pci.h"
 
+static void pci_free_resources(struct pci_dev *dev)
+{
+	int i;
+
+	pci_cleanup_rom(dev);
+	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
+		struct resource *res = dev->resource + i;
+		if (res->parent)
+			release_resource(res);
+	}
+}
+
 static void pci_stop_dev(struct pci_dev *dev)
 {
 	pci_pme_active(dev, false);
@@ -25,6 +37,11 @@ static void pci_destroy_dev(struct pci_d
 
 	device_del(&dev->dev);
 
+	down_write(&pci_bus_sem);
+	list_del(&dev->bus_list);
+	up_write(&pci_bus_sem);
+
+	pci_free_resources(dev);
 	put_device(&dev->dev);
 }
 

