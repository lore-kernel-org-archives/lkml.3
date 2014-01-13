Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751239AbaAMAtY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 19:49:24 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57012 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750899AbaAMAtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 19:49:21 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Guo Chao <yan@linux.vnet.ibm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Myron Stowe <myron.stowe@gmail.com>
Subject: [PATCH] PCI / remove: Check parent kobject in pci_destroy_dev() (was: Re: [PATCH v2 04/10] PCI: Destroy pci dev only once)
Date: Mon, 13 Jan 2014 02:03:16 +0100
Message-ID: <3407940.L2vvqCPqy4@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc8+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1519414.GDlGZFCTSR@vostro.rjw.lan>
References: <1385429290-25397-1-git-send-email-yinghai@kernel.org> <CAE9FiQV1KvpzfTmzbERS8heAE1z5zf=CjXnnjS9ZMBqmhY7rkw@mail.gmail.com> <1519414.GDlGZFCTSR@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, December 07, 2013 02:27:51 AM Rafael J. Wysocki wrote:
> On Thursday, December 05, 2013 10:52:36 PM Yinghai Lu wrote:
> > On Mon, Dec 2, 2013 at 6:49 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > >
> > > Scenario 5: pci_stop_and_remove_bus_device() is run concurrently
> > >   for a device and its parent bridge via remove_callback().
> > >
> > >   In that case both code paths attempt to acquire
> > >   pci_remove_rescan_mutex.  If the child device removal acquires
> > >   it first, there will be no problems.  However, if the parent
> > >   bridge removal acquires it first, it will eventually execute
> > >   pci_destroy_dev() for the child device, but that device will
> > >   not be freed yet due to the reference held by the concurrent
> > >   child removal.  Consequently, both pci_stop_bus_device() and
> > >   pci_remove_bus_device() will be executed for that device
> > >   unnecessarily and pci_destroy_dev() will see a corrupted list
> > >   head in that object.  Moreover, an excess put_device() will
> > >   be executed for that device in that case which may lead to a
> > >   use-after-free in the final kobject_put() done by
> > >   sysfs_schedule_callback_work().
> > >
> > > Index: linux-pm/include/linux/pci.h
> > > ===================================================================
> > > --- linux-pm.orig/include/linux/pci.h
> > > +++ linux-pm/include/linux/pci.h
> > > @@ -321,6 +321,7 @@ struct pci_dev {
> > >         unsigned int    multifunction:1;/* Part of multi-function device */
> > >         /* keep track of device state */
> > >         unsigned int    is_added:1;
> > > +       unsigned int    is_gone:1;
> > >         unsigned int    is_busmaster:1; /* device is busmaster */
> > >         unsigned int    no_msi:1;       /* device may not use msi */
> > >         unsigned int    block_cfg_access:1;     /* config space access is blocked */
> > > Index: linux-pm/drivers/pci/remove.c
> > > ===================================================================
> > > --- linux-pm.orig/drivers/pci/remove.c
> > > +++ linux-pm/drivers/pci/remove.c
> > > @@ -34,6 +34,7 @@ static void pci_stop_dev(struct pci_dev
> > >
> > >  static void pci_destroy_dev(struct pci_dev *dev)
> > >  {
> > > +       dev->is_gone = 1;
> > >         device_del(&dev->dev);
> > >
> > >         down_write(&pci_bus_sem);
> > > @@ -109,8 +110,10 @@ static void pci_remove_bus_device(struct
> > >   */
> > >  void pci_stop_and_remove_bus_device(struct pci_dev *dev)
> > >  {
> > > -       pci_stop_bus_device(dev);
> > > -       pci_remove_bus_device(dev);
> > > +       if (!dev->is_gone) {
> > > +               pci_stop_bus_device(dev);
> > > +               pci_remove_bus_device(dev);
> > > +       }
> > >  }
> > >  EXPORT_SYMBOL(pci_stop_and_remove_bus_device);
> > >
> > 
> > Yes, above change should address sys double remove problem.
> 
> I've just realized that we don't need a new flag for that, though.
> 
> It looks like we only need to check dev->dev.kobj.parent and return if that is
> NULL, because that means pci_destroy_dev() has run for that device already
> (I'm wondering why device_del() doesn't clear dev->parent, BTW, it looks like
> it should do that?).
> 
> Of course, that still is going to be racy if we don't hold
> pci_remove_rescan_mutex around pci_stop_and_remove_bus_device() in every code
> path using it (or use another similar synchronization mechanism).

Before I forget about this, on top of the series I sent out on Friday.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: PCI / remove: Check parent kobject in pci_destroy_dev()

If pci_stop_and_remove_bus_device() is run concurrently for a device
and its parent bridge via remove_callback(), both code paths attempt
to acquire pci_rescan_remove_lock.  If the child device removal
acquires it first, there will be no problems.  However, if the parent
bridge removal acquires it first, it will eventually execute
pci_destroy_dev() for the child device, but that device object will
not be freed yet due to the reference held by the concurrent child
removal.  Consequently, both pci_stop_bus_device() and
pci_remove_bus_device() will be executed for that device unnecessarily
and pci_destroy_dev() will see a corrupted list head in that object.
Moreover, an excess put_device() will be executed for that device in
that case which may lead to a use-after-free in the final
kobject_put() done by sysfs_schedule_callback_work().

To avoid that problem, make pci_destroy_dev() check if the device's
parent kobject is NULL, which only happens after device_del() has
already run for it.  Make pci_destroy_dev() return immediately
whithout doing anything in that case.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/remove.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-pm/drivers/pci/remove.c
===================================================================
--- linux-pm.orig/drivers/pci/remove.c
+++ linux-pm/drivers/pci/remove.c
@@ -34,6 +34,9 @@ static void pci_stop_dev(struct pci_dev
 
 static void pci_destroy_dev(struct pci_dev *dev)
 {
+	if (!dev->dev.kobj.parent)
+		return;
+
 	device_del(&dev->dev);
 
 	down_write(&pci_bus_sem);

