Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaJBTIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 15:08:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42832 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751357AbaJBTIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 15:08:10 -0400
Date: Thu, 2 Oct 2014 21:08:05 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Tejun Heo <tj@kernel.org>, "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, tiwai@suse.de,
        arjan@linux.intel.com, teg@jklm.no, rmilasan@suse.com, werner@suse.com,
        oleg@redhat.com, hare@suse.com, bpoirier@suse.de, santosh@chelsio.com,
        pmladek@suse.cz, dbueso@suse.com, linux-kernel@vger.kernel.org,
        Doug Thompson <dougthompson@xmission.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-edac@vger.kernel.org
Subject: Re: [PATCH v1 3/5] amd64_edac: enforce synchronous probe
Message-ID: <20141002190805.GP14081@wotan.suse.de>
References: <1411768637-6809-1-git-send-email-mcgrof@do-not-panic.com> <1411768637-6809-4-git-send-email-mcgrof@do-not-panic.com> <20140928144123.GB5023@mtj.dyndns.org> <20140930072328.GD14081@wotan.suse.de> <20141001223959.GN14081@wotan.suse.de> <20141002091800.GA31189@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141002091800.GA31189@pd.tnic>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 11:18:00AM +0200, Borislav Petkov wrote:
> On Thu, Oct 02, 2014 at 12:39:59AM +0200, Luis R. Rodriguez wrote:
> > ...
> > and my system was still useless and even end up in some fun page faults,
> > but again I think this is all related. I reviewed sysfs / kernfs code
> > and didn't see issues there with how symlinks are handled so I started
> > reviewing the driver itself a bit and saw it had strong use of sysfs
> > on itself and also on helpers such as edac_create_sysfs_mci_device().
> > I would not be surprised if the issue lies more in there than elsewhere.
> 
> Right, but that would point at sysfs being not asyns-ready, right? I
> mean, the driver is just a user of sysfs and doesn't do anything out of
> the ordinary in that respect. And the sysfs usage comes from the EDAC
> core so I think you'll basically end up marking *all* EDAC drivers as
> sync because they all call edac_create_sysfs_mci_device() - you just
> happened to run an AMD box and see it there.
> 
> This might turn fast into a nasty game if other drivers do similar things
> so I'd say this needs to get properly debugged to see what is causing it
> and fixed there. And my money goes on that
> 
> 	WARNING: CPU: 2 PID: 127 at fs/kernfs/dir.c:377 kernfs_get+0x31/0x40()
> 
> which is there for some reason and apparently shouldn't be happening...

I looked into this further and I've determined the issue was a driver
side issue, it actually *does* rely on synchronous probe, it calls on
a routine which expects at least one device to be registered already
otherwise it fails early on its init routine. The patch below fixes
the issue, for example. This patch is only correct if my interpretation
that the driver only wants to call the setup routine once is valid,
which it seems it is the case, and it does this only for the first
registered device.

With these changes the driver can probe asynchronously. The race
that was happing was that since the probe async and since the init
routine did assume sync probe towards the end if a device was not
yet registered it would bail and pci_unregister_driver() the driver
and obviously that would delete the sysfs directory for the PCI device.
The symlink attempt that was ongoing during probe for place a symlink
name driver on the PCI sysfs directory was taken underneath probe.

This begs a few questions:

The original code seems to have run setup_pci_device() only once
and it was for the first ID device matching 0 that could be returned by
amd_get_node_id(). If its ensured that the first probed device
should always match the ID 0 for amd_get_node_id() (since setup_pci_device()
uses mci = mcis[0]) and if calling edac_pci_create_generic_ctl() is safe
only right after this ID 0 device is registered then we could simplify
the code below even further by just calling amd64_edac_register() without
a workqueue for the first probed device.

Please revise and let me know what is preferred. In the meantime I'll
continue on with the series and this can be handled orthogonally.

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index dc997ae..1d4dbdf 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -16,9 +16,9 @@ module_param(ecc_enable_override, int, 0644);
 static struct msr __percpu *msrs;
 
 /*
- * count successfully initialized driver instances for setup_pci_device()
+ * Prevent two runs on setup_pci_device()
  */
-static atomic_t drv_instances = ATOMIC_INIT(0);
+static bool amd64_first_dev_registered;
 
 /* Per-node driver instances */
 static struct mem_ctl_info **mcis;
@@ -2702,8 +2702,6 @@ static int init_one_instance(struct pci_dev *F2)
 
 	mcis[nid] = mci;
 
-	atomic_inc(&drv_instances);
-
 	return 0;
 
 err_add_sysfs:
@@ -2721,6 +2719,35 @@ err_ret:
 	return ret;
 }
 
+static void amd64_edac_register(struct work_struct *work)
+{
+	struct mem_ctl_info *mci;
+	struct amd64_pvt *pvt;
+
+	if (amd64_first_dev_registered) {
+		pr_warn("amd64_edca: First device already registered\n");
+		return;
+	}
+
+	if (pci_ctl)
+		return;
+
+	mci = mcis[0];
+	if (!mci)
+		return;
+
+	pvt = mci->pvt_info;
+	pci_ctl = edac_pci_create_generic_ctl(&pvt->F2->dev, EDAC_MOD_STR);
+	if (!pci_ctl) {
+		pr_warn("%s(): Unable to create PCI control\n", __func__);
+		pr_warn("%s(): PCI error report via EDAC not set\n", __func__);
+	}
+	amd64_first_dev_registered = true;
+}
+
+static DECLARE_WORK(amd64_edac_work, amd64_edac_register);
+
+
 static int probe_one_instance(struct pci_dev *pdev,
 			      const struct pci_device_id *mc_type)
 {
@@ -2760,6 +2787,9 @@ static int probe_one_instance(struct pci_dev *pdev,
 		restore_ecc_error_reporting(s, nid, F3);
 	}
 
+	if (!schedule_work(&amd64_edac_work))
+		return -EBUSY;
+
 	return ret;
 
 err_enable:
@@ -2872,33 +2902,14 @@ static struct pci_driver amd64_pci_driver = {
 	.probe		= probe_one_instance,
 	.remove		= remove_one_instance,
 	.id_table	= amd64_pci_table,
-	.driver.sync_probe = true,
 };
 
-static void setup_pci_device(void)
-{
-	struct mem_ctl_info *mci;
-	struct amd64_pvt *pvt;
-
-	if (pci_ctl)
-		return;
-
-	mci = mcis[0];
-	if (!mci)
-		return;
-
-	pvt = mci->pvt_info;
-	pci_ctl = edac_pci_create_generic_ctl(&pvt->F2->dev, EDAC_MOD_STR);
-	if (!pci_ctl) {
-		pr_warn("%s(): Unable to create PCI control\n", __func__);
-		pr_warn("%s(): PCI error report via EDAC not set\n", __func__);
-	}
-}
-
 static int __init amd64_edac_init(void)
 {
 	int err = -ENODEV;
 
+	amd64_first_dev_registered = false;
+
 	printk(KERN_INFO "AMD64 EDAC driver v%s\n", EDAC_AMD64_VERSION);
 
 	opstate_init();
@@ -2920,16 +2931,8 @@ static int __init amd64_edac_init(void)
 	if (err)
 		goto err_pci;
 
-	err = -ENODEV;
-	if (!atomic_read(&drv_instances))
-		goto err_no_instances;
-
-	setup_pci_device();
 	return 0;
 
-err_no_instances:
-	pci_unregister_driver(&amd64_pci_driver);
-
 err_pci:
 	msrs_free(msrs);
 	msrs = NULL;
@@ -2947,6 +2950,8 @@ err_ret:
 
 static void __exit amd64_edac_exit(void)
 {
+	cancel_work_sync(&amd64_edac_work);
+
 	if (pci_ctl)
 		edac_pci_release_generic_ctl(pci_ctl);
 
