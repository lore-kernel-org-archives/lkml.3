Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbaGHT3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:29:09 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:24536 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506AbaGHT3G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:29:06 -0400
Date: Tue, 8 Jul 2014 15:28:54 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: konrad@kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/7] xen/pciback: Implement PCI reset slot or bus with
 'do_flr' SysFS attribute
Message-ID: <20140708192854.GA12446@laptop.dumpdata.com>
References: <1404845909-13563-1-git-send-email-konrad@kernel.org>
 <1404845909-13563-5-git-send-email-konrad@kernel.org>
 <53BC324B.5090600@citrix.com>
 <20140708184626.GA15548@laptop.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140708184626.GA15548@laptop.dumpdata.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 02:46:26PM -0400, Konrad Rzeszutek Wilk wrote:
> On Tue, Jul 08, 2014 at 07:02:51PM +0100, David Vrabel wrote:
> > On 08/07/14 19:58, konrad@kernel.org wrote:
> > > --- a/Documentation/ABI/testing/sysfs-driver-pciback
> > > +++ b/Documentation/ABI/testing/sysfs-driver-pciback
> > > @@ -82,3 +82,14 @@ Description:
> > >                  device is shared, enabled, or on a level interrupt line.
> > >                  Writing a string of DDDD:BB:DD.F will toggle the state.
> > >                  This is Domain:Bus:Device.Function where domain is optional.
> > > +
> > > +What:           /sys/bus/pci/drivers/pciback/do_flr
> > > +Date:           July 2014
> > > +KernelVersion:  3.16
> > > +Contact:        xen-devel@lists.xenproject.org
> > > +Description:
> > > +                An option to slot or bus reset an PCI device owned by
> > > +                Xen PCI backend. Writing a string of DDDD:BB:DD.F will cause
> > > +                the driver to perform an slot or bus reset if the device
> > > +                supports. It also checks to make sure that all of the devices
> > > +                under the bridge are owned by Xen PCI backend.
> > 
> > Not sure I like this new interface.  I solved this by adding a new reset
> > file that looked like the regular one the pci would have if it supported
> > FLR.  I'm fairly sure I posted a series for this.  Was there a reason
> > you didn't do this?
> 
> It did not work.
> 
> During bootup kobject would complain about a secondary 'reset' SysFS
> on the PCI device.

Here is what I saw:
   20.441332] Key type dns_resolver registered
[   20.446548] registered taskstats version 1
[   20.452843] ------------[ cut here ]------------
[   20.457731] WARNING: CPU: 0 PID: 1 at /home/konrad/ssd/konrad/linux/fs/sysfs/dir.c:31 sysfs_warn_dup+0x6a/0x80()
[   20.468594] sysfs: cannot create duplicate filename '/devices/pci0000:00/0000:00:1c.0/0000:02:00.0/0000:03:01.0/0000:04:00.0/reset'
[   20.481207] Modules linked in:
[   20.484508] CPU: 0 PID: 1 Comm: swapper/0 Tainted: G        W     3.16.0-rc2-00027-g777b409 #1
[   20.493701] Hardware name:                  /DQ67SW, BIOS SWQ6710H.86A.0066.2012.1105.1504 11/05/2012
[   20.503561]  000000000000001f ffff8801192abcc8 ffffffff816e5bc2 000000000000001f
[   20.511479]  ffff8801192abd18 ffff8801192abd08 ffffffff810a0187 0000000000000000
[   20.519396]  ffff88010e8ff000 ffffffff819b632b ffff880118e421e8 ffff880118e410a8
[   20.527337] Call Trace:
[   20.530022]  [<ffffffff816e5bc2>] dump_stack+0x51/0x6b
[   20.535541]  [<ffffffff810a0187>] warn_slowpath_common+0x87/0xb0
[   20.541986]  [<ffffffff810a0251>] warn_slowpath_fmt+0x41/0x50
[   20.548155]  [<ffffffff81245243>] ? kernfs_path+0x53/0x70
[   20.553966]  [<ffffffff812473fa>] sysfs_warn_dup+0x6a/0x80
[   20.559855]  [<ffffffff81246e56>] sysfs_add_file_mode_ns+0x126/0x160
[   20.566668]  [<ffffffff81246eb5>] sysfs_create_file_ns+0x25/0x30
[   20.573110]  [<ffffffff81476343>] device_create_file+0x43/0xb0
[   20.579361]  [<ffffffff81369d13>] pci_create_sysfs_dev_files+0x2c3/0x3e0
[   20.586546]  [<ffffffff81d1ffa5>] pci_sysfs_init+0x1f/0x51
[   20.592429]  [<ffffffff81d1ff86>] ? pci_driver_init+0x12/0x12
[   20.598592]  [<ffffffff81d1ff86>] ? pci_driver_init+0x12/0x12
[   20.604748]  [<ffffffff81002089>] do_one_initcall+0x89/0x1b0
[   20.610833]  [<ffffffff81ce4b30>] kernel_init_freeable+0x167/0x1fd
[   20.617487]  [<ffffffff81ce4bc6>] ? kernel_init_freeable+0x1fd/0x1fd
[   20.624296]  [<ffffffff816dd7c0>] ? rest_init+0x90/0x90
[   20.629910]  [<ffffffff816dd7c9>] kernel_init+0x9/0xf0
[   20.635433]  [<ffffffff816eb27c>] ret_from_fork+0x7c/0xb0
[   20.641219]  [<ffffffff816dd7c0>] ? rest_init+0x90/0x90
[   20.646846] ---[ end trace 956618df162d6136 ]---
[   20.661457]   Magic number: 6:892:343

with this patch and command line:
debug console=hvc0 xen-blkback.log_stats=1 kgdboc=hvc0 xen-pciback.hide=(04:00.0)(07:00.0)(00:16.*)(03:01.0)(03:02.0)


>From 777b4097bc6f2d83a8690d844a2a6285f392b7fa Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Mon, 21 Apr 2014 16:32:23 -0400
Subject: [PATCH] xen/pciback: PCI reset slot or bus - David's

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/xen-pciback/pci_stub.c |   84 ++++++++++++++++++++++++++++++------
 1 files changed, 70 insertions(+), 14 deletions(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 030ac8f..21754fe 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -49,6 +49,8 @@ struct pcistub_device {
 
 	struct pci_dev *dev;
 	struct xen_pcibk_device *pdev;/* non-NULL if struct pci_dev is in use */
+
+	bool created_reset_file;
 };
 
 /* Access to pcistub_devices & seized_devices lists and the initialize_devices
@@ -63,6 +65,7 @@ static LIST_HEAD(pcistub_devices);
 static int initialize_devices;
 static LIST_HEAD(seized_devices);
 
+void pcistub_device_reset(struct work_struct *work);
 static struct pcistub_device *pcistub_device_alloc(struct pci_dev *dev)
 {
 	struct pcistub_device *psdev;
@@ -85,6 +88,8 @@ static struct pcistub_device *pcistub_device_alloc(struct pci_dev *dev)
 	return psdev;
 }
 
+static void pcistub_remove_reset_file(struct pcistub_device *psdev);
+
 /* Don't call this directly as it's called by pcistub_device_put */
 static void pcistub_device_release(struct kref *kref)
 {
@@ -100,14 +105,11 @@ static void pcistub_device_release(struct kref *kref)
 
 	xen_unregister_device_domain_owner(dev);
 
-	/* Call the reset function which does not take lock as this
-	 * is called from "unbind" which takes a device_lock mutex.
-	 */
-	__pci_reset_function_locked(dev);
+	/* Reset is done by the toolstack by using 'reset' on the SysFS. */
 	if (pci_load_and_free_saved_state(dev, &dev_data->pci_saved_state))
 		dev_dbg(&dev->dev, "Could not reload PCI state\n");
-	else
-		pci_restore_state(dev);
+
+	pcistub_remove_reset_file(psdev);
 
 	if (dev->msix_cap) {
 		struct physdev_pci_device ppdev = {
@@ -123,9 +125,6 @@ static void pcistub_device_release(struct kref *kref)
 				 err);
 	}
 
-	/* Disable the device */
-	xen_pcibk_reset_device(dev);
-
 	kfree(dev_data);
 	pci_set_drvdata(dev, NULL);
 
@@ -136,17 +135,22 @@ static void pcistub_device_release(struct kref *kref)
 	dev->dev_flags &= ~PCI_DEV_FLAGS_ASSIGNED;
 	pci_dev_put(dev);
 
+	dev_dbg(&dev->dev, "pcistub_device_release finished. Device gone\n");
+
 	kfree(psdev);
 }
 
 static inline void pcistub_device_get(struct pcistub_device *psdev)
 {
 	kref_get(&psdev->kref);
+	pr_debug("%s, ref count is NOW at %d, %p\n", __func__, atomic_read(&psdev->kref.refcount), pci_get_drvdata(psdev->dev));
 }
 
 static inline void pcistub_device_put(struct pcistub_device *psdev)
 {
+	pr_debug("%s, ref count is at %d %p\n", __func__, atomic_read(&psdev->kref.refcount), pci_get_drvdata(psdev->dev));
 	kref_put(&psdev->kref, pcistub_device_release);
+	pr_debug("%s, ref count is at %d %p\n", __func__, atomic_read(&psdev->kref.refcount), pci_get_drvdata(psdev->dev));
 }
 
 static struct pcistub_device *pcistub_device_find(int domain, int bus,
@@ -248,9 +252,10 @@ static void pcistub_reset_pci_dev(struct pci_dev *dev)
 	 * and want to inhibit the user from fiddling with 'reset'
 	 */
 
-	dev_dbg(&dev->dev, "resetting (FLR, D3, etc) the device\n");
+	dev_dbg(&dev->dev, "resetting (FLR, D3, bus, slot, etc) the device\n");
 
 	pci_reset_function(dev);
+
 	pci_restore_state(dev);
 
 	/* This disables the device. */
@@ -258,6 +263,52 @@ static void pcistub_reset_pci_dev(struct pci_dev *dev)
 
 	/* And cleanup up our emulated fields. */
 	xen_pcibk_config_reset_dev(dev);
+
+	/* Implement the rest. */
+}
+
+static ssize_t pcistub_reset_store(struct device *dev,
+                                  struct device_attribute *attr,
+                                  const char *buf, size_t count)
+{
+       struct pci_dev *pdev = to_pci_dev(dev);
+       unsigned long val;
+       ssize_t result = strict_strtoul(buf, 0, &val);
+
+       if (result < 0)
+               return result;
+
+       if (val != 1)
+               return -EINVAL;
+
+	pcistub_reset_pci_dev(pdev);
+
+	return 0;
+}
+static DEVICE_ATTR(reset, 0200, NULL, pcistub_reset_store);
+static void pcistub_remove_reset_file(struct pcistub_device *psdev)
+{
+       if (psdev && psdev->created_reset_file)
+               device_remove_file(&psdev->dev->dev, &dev_attr_reset);
+}
+
+static int pcistub_try_create_reset_file(struct pcistub_device *psdev)
+{
+       struct device *dev = &psdev->dev->dev;
+       struct kernfs_node *reset_dirent;
+       int ret;
+
+       reset_dirent = sysfs_get_dirent(dev->kobj.sd, "reset");
+       if (reset_dirent) {
+               sysfs_put(dev->kobj.sd);
+               return 0;
+       }
+
+       ret = device_create_file(dev, &dev_attr_reset);
+       if (ret < 0)
+               return ret;
+       psdev->created_reset_file = true;
+       return 0;
 }
 
 /*
@@ -291,10 +342,10 @@ void pcistub_put_pci_dev(struct pci_dev *dev)
 	* pcistub and xen_pcibk when AER is in processing
 	*/
 	down_write(&pcistub_sem);
-	/* Cleanup our device
-	 * (so it's ready for the next domain)
+	/* Cleanup our device (so it's ready for the next domain)
+	 * That is the job of the toolstack which has to call 'reset' before
+	 * providing the PCI device to a guest (see pcistub_reset_store).
 	 */
-	pcistub_reset_pci_dev(dev);
 
 	xen_unregister_device_domain_owner(dev);
 
@@ -409,7 +460,7 @@ static int pcistub_init_device(struct pci_dev *dev)
 	if (!dev_data->pci_saved_state)
 		dev_err(&dev->dev, "Could not store PCI conf saved state!\n");
 	else {
-		dev_dbg(&dev->dev, "resetting (FLR, D3, etc) the device\n");
+		dev_dbg(&dev->dev, "resetting (FLR, D4, etc) the device\n");
 		__pci_reset_function_locked(dev);
 		pci_restore_state(dev);
 	}
@@ -483,6 +534,10 @@ static int pcistub_seize(struct pci_dev *dev)
 	if (!psdev)
 		return -ENOMEM;
 
+       err = pcistub_try_create_reset_file(psdev);
+       if (err < 0)
+               goto out;
+
 	spin_lock_irqsave(&pcistub_devices_lock, flags);
 
 	if (initialize_devices) {
@@ -502,6 +557,7 @@ static int pcistub_seize(struct pci_dev *dev)
 
 	spin_unlock_irqrestore(&pcistub_devices_lock, flags);
 
+out:
 	if (err)
 		pcistub_device_put(psdev);
 
-- 
1.7.7.6

> 
> > 
> > David
