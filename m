Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbaJAWkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 18:40:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48959 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975AbaJAWkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 18:40:04 -0400
Date: Thu, 2 Oct 2014 00:39:59 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, gregkh@linuxfoundation.org,
        dmitry.torokhov@gmail.com, tiwai@suse.de, arjan@linux.intel.com,
        teg@jklm.no, rmilasan@suse.com, werner@suse.com, oleg@redhat.com,
        hare@suse.com, bpoirier@suse.de, santosh@chelsio.com, pmladek@suse.cz,
        dbueso@suse.com, linux-kernel@vger.kernel.org,
        Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <bp@alien8.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-edac@vger.kernel.org
Subject: Re: [PATCH v1 3/5] amd64_edac: enforce synchronous probe
Message-ID: <20141001223959.GN14081@wotan.suse.de>
References: <1411768637-6809-1-git-send-email-mcgrof@do-not-panic.com> <1411768637-6809-4-git-send-email-mcgrof@do-not-panic.com> <20140928144123.GB5023@mtj.dyndns.org> <20140930072328.GD14081@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140930072328.GD14081@wotan.suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 09:23:28AM +0200, Luis R. Rodriguez wrote:
> On Sun, Sep 28, 2014 at 10:41:23AM -0400, Tejun Heo wrote:
> > On Fri, Sep 26, 2014 at 02:57:15PM -0700, Luis R. Rodriguez wrote:
> > ...
> > > [   14.414746]  [<ffffffff814d2cf9>] ? dump_stack+0x41/0x51
> > > [   14.414790]  [<ffffffff81061972>] ? warn_slowpath_common+0x72/0x90
> > > [   14.414834]  [<ffffffff810619d7>] ? warn_slowpath_fmt+0x47/0x50
> > > [   14.414880]  [<ffffffff814d0ac3>] ? printk+0x4f/0x51
> > > [   14.414921]  [<ffffffff811f8593>] ? kernfs_remove_by_name_ns+0x83/0x90
> > > [   14.415000]  [<ffffffff8137433d>] ? driver_sysfs_remove+0x1d/0x40
> > > [   14.415046]  [<ffffffff81374a15>] ? driver_probe_device+0x1d5/0x250
> > > [   14.415099]  [<ffffffff81374b4b>] ? __driver_attach+0x7b/0x80
> > > [   14.415149]  [<ffffffff81374ad0>] ? __device_attach+0x40/0x40
> > > [   14.415204]  [<ffffffff81372a13>] ? bus_for_each_dev+0x53/0x90
> > > [   14.415254]  [<ffffffff81373913>] ? driver_attach_workfn+0x13/0x80
> > > [   14.415298]  [<ffffffff81077403>] ? process_one_work+0x143/0x3c0
> > > [   14.415342]  [<ffffffff81077a44>] ? worker_thread+0x114/0x480
> > > [   14.415384]  [<ffffffff81077930>] ? rescuer_thread+0x2b0/0x2b0
> > > [   14.415427]  [<ffffffff8107c261>] ? kthread+0xc1/0xe0
> > > [   14.415468]  [<ffffffff8107c1a0>] ? kthread_create_on_node+0x170/0x170
> > > [   14.415511]  [<ffffffff814d883c>] ? ret_from_fork+0x7c/0xb0
> > > [   14.415554]  [<ffffffff8107c1a0>] ? kthread_create_on_node+0x170/0x170
> > 
> > Do you have CONFIG_FRAME_POINTER turned off?
> 
> Yeah..

So the above warn came from having DWARF2 EH-frame based stack unwinding
but no CONFIG_FRAME_POINTER. By enabling CONFIG_FRAME_POINTER *and*
removing the DWARF2 EH-frame based stack unwinding patches the warning
I get is slightly different:

[   13.208930] EDAC MC: Ver: 3.0.0
[   13.213807] MCE: In-kernel MCE decoding enabled.
[   13.235121] AMD64 EDAC driver v3.4.0
[   13.235170] bus: 'pci': probe for driver amd64_edac is run asynchronously
[   13.235236] ------------[ cut here ]------------
[   13.235283] WARNING: CPU: 2 PID: 127 at fs/kernfs/dir.c:377 kernfs_get+0x31/0x40()
[   13.235323] Modules linked in: amd64_edac_mod(-) lrw serio_raw gf128mul edac_mce_amd glue_helper edac_core sp5100_tco pcspkr snd_timer i2c_piix4 k10temp fam15h_power snd soundcore i2c_core wmi button xen_acpi_processor processor thermal_sys xen_pciback xen_netback xen_blkback xen_gntalloc xen_gntdev xen_evtchn loop fuse autofs4 ext4 crc16 mbcache jbd2 sg sd_mod crc_t10dif crct10dif_generic crct10dif_common hid_logitech_dj usbhid hid dm_mod ahci xhci_hcd ohci_pci libahci ohci_hcd ehci_pci ehci_hcd libata usbcore scsi_mod r8169 usb_common mii
[   13.237129] CPU: 2 PID: 127 Comm: kworker/u16:5 Not tainted 3.17.0-rc7+ #2
[   13.237165] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97, BIOS 1605 10/25/2012
[   13.237207] Workqueue: events_unbound driver_attach_workfn
[   13.237271]  0000000000000009 ffff88040a7e7c48 ffffffff814f7f1f 0000000000000000
[   13.237426]  ffff88040a7e7c80 ffffffff81066378 ffff880409a63be0 ffff88040a259a78
[   13.237582]  ffff880409a63be0 ffff880409a63be0 ffff88040f15cf00 ffff88040a7e7c90
[   13.237740] Call Trace:
[   13.237777]  [<ffffffff814f7f1f>] dump_stack+0x45/0x56
[   13.237814]  [<ffffffff81066378>] warn_slowpath_common+0x78/0xa0
[   13.237851]  [<ffffffff81066455>] warn_slowpath_null+0x15/0x20
[   13.237887]  [<ffffffff8120f6c1>] kernfs_get+0x31/0x40
[   13.237950]  [<ffffffff812107e1>] kernfs_new_node+0x31/0x40
[   13.238003]  [<ffffffff812122ce>] kernfs_create_link+0x1e/0x80
[   13.238052]  [<ffffffff81212e7a>] sysfs_do_create_link_sd.isra.2+0x5a/0xb0
[   13.238097]  [<ffffffff81212ef0>] sysfs_create_link+0x20/0x40
[   13.238143]  [<ffffffff8139ab70>] driver_sysfs_add+0x50/0xb0
[   13.238216]  [<ffffffff8139b159>] driver_probe_device+0x59/0x250
[   13.238253]  [<ffffffff8139b41b>] __driver_attach+0x8b/0x90
[   13.238290]  [<ffffffff8139b390>] ? __device_attach+0x40/0x40
[   13.238327]  [<ffffffff81399033>] bus_for_each_dev+0x63/0xa0
[   13.238367]  [<ffffffff8139ac99>] driver_attach+0x19/0x20
[   13.238409]  [<ffffffff813999a8>] driver_attach_workfn+0x18/0x80
[   13.238446]  [<ffffffff8107d3df>] process_one_work+0x14f/0x400
[   13.238482]  [<ffffffff8107dc9b>] worker_thread+0x6b/0x4b0
[   13.238519]  [<ffffffff8107dc30>] ? rescuer_thread+0x270/0x270
[   13.238556]  [<ffffffff810826d6>] kthread+0xd6/0xf0
[   13.238592]  [<ffffffff81082600>] ? kthread_create_on_node+0x180/0x180
[   13.238630]  [<ffffffff814fddfc>] ret_from_fork+0x7c/0xb0
[   13.238666]  [<ffffffff81082600>] ? kthread_create_on_node+0x180/0x180
[   13.238702] ---[ end trace bfbfc1541fcb030e ]---
[   13.238739] really_probe: driver_sysfs_add(0000:00:18.2) failed
[   13.238776] amd64_edac: probe of 0000:00:18.2 failed with error 0
[   13.299111] AVX version of gcm_enc/dec engaged.
[   13.312828] alg: No test for __gcm-aes-aesni (__driver-gcm-aes-aesni)

I tried looking into this but a later in a later kernel I had enabled
a few other things I had forgotten (like acpi thermal stuff) and then
the kernel just spewed out similar error and unfortunately I was not
able to capture the top but it all seemed related to the above.

I decided to try this:

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index dc997ae..f8bf000 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2872,7 +2872,6 @@ static struct pci_driver amd64_pci_driver = {
 	.probe		= probe_one_instance,
 	.remove		= remove_one_instance,
 	.id_table	= amd64_pci_table,
-	.driver.sync_probe = true,
 };
 
 static void setup_pci_device(void)
diff --git a/fs/sysfs/symlink.c b/fs/sysfs/symlink.c
index aecb15f..8401c0a 100644
--- a/fs/sysfs/symlink.c
+++ b/fs/sysfs/symlink.c
@@ -41,6 +41,9 @@ static int sysfs_do_create_link_sd(struct kernfs_node *parent,
 	if (!target)
 		return -ENOENT;
 
+	if (WARN_ON(!atomic_read(&target->count)))
+		return -ENOENT;
+
 	kn = kernfs_create_link(parent, name, target);
 	kernfs_put(target);
 

and my system was still useless and even end up in some fun page faults,
but again I think this is all related. I reviewed sysfs / kernfs code
and didn't see issues there with how symlinks are handled so I started
reviewing the driver itself a bit and saw it had strong use of sysfs
on itself and also on helpers such as edac_create_sysfs_mci_device().
I would not be surprised if the issue lies more in there than elsewhere.

I could keep on debugging but I think at this point this is enough
work to at least show the driver does need sync probe. I do not think this
is a core driver issue at this point.

  Luis
