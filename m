Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab3KDRJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 12:09:46 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:44234 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab3KDRJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 12:09:40 -0500
From: Frank Haverkamp <haver@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, cody@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, utz.bacher@de.ibm.com, mmarek@suse.cz,
        rmallon@gmail.com, jsvogt@de.ibm.com, MIJUNG@de.ibm.com,
        cascardo@linux.vnet.ibm.com, michael@ibmra.de,
        haver@linux.vnet.ibm.com
Subject: [PATCH 6/9] GenWQE: Remove/rework module parameters
Date: Mon,  4 Nov 2013 18:08:06 +0100
Message-Id: <1383584889-21594-7-git-send-email-haver@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1383584889-21594-1-git-send-email-haver@linux.vnet.ibm.com>
References: <1383584889-21594-1-git-send-email-haver@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110417-1948-0000-0000-000006C9391C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The module parameter genwqe_vf_jobtimeout_msec is changed into
a debugfs interface:
  /sys/kernel/debug/genwqe/genwqe<n>_card/vf<0..14>_jobtimeout_msec
The setting is applied when the virtual functions are enabled.
Switching during operation is not allowed.

The following thow former module parameters are now constants:
  genwqe_pf_jobtimeout_msec
  genwqe_health_check_interval

Signed-off-by: Frank Haverkamp <haver@linux.vnet.ibm.com>
---
 Documentation/ABI/testing/debugfs-driver-genwqe |   13 +++
 drivers/misc/genwqe/card_base.c                 |   93 ++++++++++-------------
 drivers/misc/genwqe/card_base.h                 |    9 +-
 drivers/misc/genwqe/card_debugfs.c              |   15 ++++-
 4 files changed, 71 insertions(+), 59 deletions(-)

diff --git a/Documentation/ABI/testing/debugfs-driver-genwqe b/Documentation/ABI/testing/debugfs-driver-genwqe
index c3503a4..548883a 100644
--- a/Documentation/ABI/testing/debugfs-driver-genwqe
+++ b/Documentation/ABI/testing/debugfs-driver-genwqe
@@ -55,3 +55,16 @@ Date:           Oct 2013
 Contact:        haver@linux.vnet.ibm.com
 Description:    Possibility to inject error cases to ensure that the drivers
                 error handling code works well.
+
+What:           /sys/kernel/debug/genwqe/genwqe<n>_card/vf<0..14>_jobtimeout_msec
+Date:           Oct 2013
+Contact:        haver@linux.vnet.ibm.com
+Description:    Default VF timeout 250ms. Testing might require 1000ms.
+                Using 0 will use the cards default value (whatever that is).
+
+                The timeout depends on the max number of available cards
+                in the system and the maximum allowed queue size.
+
+                The driver ensures that the settings are done just before
+                the VFs get enabled. Changing the timeouts in flight is not
+                possible.
diff --git a/drivers/misc/genwqe/card_base.c b/drivers/misc/genwqe/card_base.c
index c649ef7..67ca5bc 100644
--- a/drivers/misc/genwqe/card_base.c
+++ b/drivers/misc/genwqe/card_base.c
@@ -52,40 +52,6 @@ MODULE_DESCRIPTION("GenWQE Card");
 MODULE_VERSION(DRV_VERS_STRING);
 MODULE_LICENSE("GPL");
 
-/*
- * We like to be able to disable the health checking entirely in some
- * cases e.g. if a card is broken and needs to be analyzed. I
- * considered using debugfs/sysfs attributes, but I did not see a way
- * to prevent the thread from being started at driver load time other
- * than starting it later manually, what I did not like either
- * in this case (e.g. like the new SRIOV enablement).
- */
-static int genwqe_health_check_interval = 4;   /* <= 0: disabled */
-module_param(genwqe_health_check_interval, int, 0644);  /* read/writeable */
-MODULE_PARM_DESC(genwqe_health_check_interval,
-		 "check card health every N seconds (0 = disabled)");
-
-/*
- * GenWQE Driver: Need SLC timeout set to 250ms (temporary setting for
- * testing of 1000ms due to decompressor testcase failing)
- *
- * There is a requirement by the card users that the timeout must not
- * exceed the 250ms.
- *
- * In this case the settings must be done before any interaction to
- * the device can be done, since we cannot change the settings without
- * stopping the queues.
- */
-int genwqe_vf_jobtimeout_msec = 250;
-module_param(genwqe_vf_jobtimeout_msec, int, 0444); /* readable */
-MODULE_PARM_DESC(genwqe_vf_jobtimeout_msec,
-		 "Job timeout for virtual functions");
-
-int genwqe_pf_jobtimeout_msec = 8000;	/* 8sec should be ok */
-module_param(genwqe_pf_jobtimeout_msec, int, 0444); /* readable */
-MODULE_PARM_DESC(genwqe_pf_jobtimeout_msec,
-		 "Job timeout for physical function");
-
 static char genwqe_driver_name[] = GENWQE_DEVNAME;
 static struct class *class_genwqe;
 static struct dentry *debugfs_genwqe;
@@ -156,7 +122,7 @@ MODULE_DEVICE_TABLE(pci, genwqe_device_table);
  */
 static struct genwqe_dev *genwqe_dev_alloc(void)
 {
-	int i = 0;
+	unsigned int i = 0, j;
 	struct genwqe_dev *cd;
 
 	for (i = 0; i < GENWQE_CARD_NO_MAX; i++) {
@@ -185,6 +151,9 @@ static struct genwqe_dev *genwqe_dev_alloc(void)
 	cd->ddcb_software_timeout = genwqe_ddcb_software_timeout;
 	cd->kill_timeout = genwqe_kill_timeout;
 
+	for (j = 0; j < GENWQE_MAX_VFS; j++)
+		cd->vf_jobtimeout_msec[j] = genwqe_vf_jobtimeout_msec;
+
 	genwqe_devices[i] = cd;
 	return cd;
 }
@@ -338,7 +307,7 @@ static int genwqe_T_psec(struct genwqe_dev *cd)
 }
 
 /**
- * genwqe_setup_jtimer() - Setup PF/VF hardware timeouts for DDCB execution
+ * genwqe_setup_pf_jtimer() - Setup PF hardware timeouts for DDCB execution
  *
  * Do this _after_ card_reset() is called. Otherwise the values will
  * vanish. The settings need to be done when the queues are inactive.
@@ -346,32 +315,43 @@ static int genwqe_T_psec(struct genwqe_dev *cd)
  * The max. timeout value is 2^(10+x) * T (6ns for 166MHz) * 15/16.
  * The min. timeout value is 2^(10+x) * T (6ns for 166MHz) * 14/16.
  */
-static int genwqe_setup_jtimer(struct genwqe_dev *cd)
+static bool genwqe_setup_pf_jtimer(struct genwqe_dev *cd)
 {
-	int vf;
 	u32 T = genwqe_T_psec(cd);
 	u64 x;
 
-	if (genwqe_pf_jobtimeout_msec != -1) {
-		/* PF: large value needed, due to flash update 2sec
-		   per block */
-		x = ilog2(genwqe_pf_jobtimeout_msec *
-			  16000000000uL/(T * 15)) - 10;
-		genwqe_write_jtimer(cd, 0, (0xff00 | (x & 0xff)));
-	}
+	if (genwqe_pf_jobtimeout_msec == 0)
+		return false;
+
+	/* PF: large value needed, flash update 2sec per block */
+	x = ilog2(genwqe_pf_jobtimeout_msec *
+		  16000000000uL/(T * 15)) - 10;
 
-	if (genwqe_vf_jobtimeout_msec != -1) {
-		if (cd->num_vfs < 0)
-			return cd->num_vfs;
+	genwqe_write_jtimer(cd, 0, (0xff00 | (x & 0xff)));
+	return true;
+}
 
-		x = ilog2(genwqe_vf_jobtimeout_msec *
+/**
+ * genwqe_setup_vf_jtimer() - Setup VF hardware timeouts for DDCB execution
+ */
+static bool genwqe_setup_vf_jtimer(struct genwqe_dev *cd)
+{
+	struct pci_dev *pci_dev = cd->pci_dev;
+	unsigned int vf;
+	u32 T = genwqe_T_psec(cd);
+	u64 x;
+
+	for (vf = 0; vf < pci_sriov_get_totalvfs(pci_dev); vf++) {
+
+		if (cd->vf_jobtimeout_msec[vf] == 0)
+			continue;
+
+		x = ilog2(cd->vf_jobtimeout_msec[vf] *
 			  16000000000uL/(T * 15)) - 10;
 
-		for (vf = 0; vf < cd->num_vfs; vf++)
-			genwqe_write_jtimer(cd, vf + 1, (0xff00 | (x & 0xff)));
+		genwqe_write_jtimer(cd, vf + 1, (0xff00 | (x & 0xff)));
 	}
-
-	return 0;
+	return true;
 }
 
 static int genwqe_ffdc_buffs_alloc(struct genwqe_dev *cd)
@@ -537,7 +517,9 @@ static int genwqe_start(struct genwqe_dev *cd)
 
 	if (genwqe_is_privileged(cd)) {	 /* code is running _after_ reset */
 		genwqe_tweak_hardware(cd);
-		genwqe_setup_jtimer(cd);	 /* queues must not run */
+
+		genwqe_setup_pf_jtimer(cd);
+		genwqe_setup_vf_jtimer(cd);
 	}
 
 	err = genwqe_device_create(cd);
@@ -1142,7 +1124,10 @@ static void genwqe_err_resume(struct pci_dev *dev)
 
 static int genwqe_sriov_configure(struct pci_dev *dev, int numvfs)
 {
+	struct genwqe_dev *cd = dev_get_drvdata(&dev->dev);
+
 	if (numvfs > 0) {
+		genwqe_setup_vf_jtimer(cd);
 		pci_enable_sriov(dev, numvfs);
 		return numvfs;
 	}
diff --git a/drivers/misc/genwqe/card_base.h b/drivers/misc/genwqe/card_base.h
index 62c2356..21cef33 100644
--- a/drivers/misc/genwqe/card_base.h
+++ b/drivers/misc/genwqe/card_base.h
@@ -43,6 +43,7 @@
 #define GENWQE_MSI_IRQS			4  /* Just one supported, no MSIx */
 #define GENWQE_FLAG_MSI_ENABLED		(1 << 0)
 
+#define GENWQE_MAX_VFS			15 /* maximum 15 VFs are possible */
 #define GENWQE_MAX_FUNCS		16 /* 1 PF and 15 VFs */
 #define GENWQE_CARD_NO_MAX		(16 * GENWQE_MAX_FUNCS)
 
@@ -51,10 +52,9 @@
 #define genwqe_polling_enabled		0  /* in case of irqs not working */
 #define genwqe_ddcb_software_timeout	10 /* timeout per DDCB in seconds */
 #define genwqe_kill_timeout		8  /* time until process gets killed */
-
-/* Module parameters */
-extern int genwqe_pf_jobtimeout_msec;
-extern int genwqe_vf_jobtimeout_msec;
+#define genwqe_vf_jobtimeout_msec	250  /* 250 msec */
+#define genwqe_pf_jobtimeout_msec	8000 /* 8 sec should be ok */
+#define genwqe_health_check_interval	4 /* <= 0: disabled */
 
 /*
  * Config space for Genwqe5 A7:
@@ -318,6 +318,7 @@ struct genwqe_dev {
 	void __iomem *mmio;		/* BAR-0 MMIO start */
 	unsigned long mmio_len;
 	u16 num_vfs;
+	u32 vf_jobtimeout_msec[GENWQE_MAX_VFS];
 	int is_privileged;		/* access to all regs possible */
 
 	/* config regs which we need often */
diff --git a/drivers/misc/genwqe/card_debugfs.c b/drivers/misc/genwqe/card_debugfs.c
index 6a048a1..ebf2f93 100644
--- a/drivers/misc/genwqe/card_debugfs.c
+++ b/drivers/misc/genwqe/card_debugfs.c
@@ -271,7 +271,7 @@ static int genwqe_jtimer_show(struct seq_file *s, void *unused)
 	for (vf_num = 0; vf_num < cd->num_vfs; vf_num++) {
 		jtimer = genwqe_read_jtimer(cd, vf_num + 1);
 		seq_printf(s, "  VF%-2d 0x%016llx %d msec\n", vf_num, jtimer,
-			   genwqe_vf_jobtimeout_msec);
+			   cd->vf_jobtimeout_msec[vf_num]);
 	}
 	return 0;
 }
@@ -425,6 +425,8 @@ int genwqe_init_debugfs(struct genwqe_dev *cd)
 	struct dentry *file;
 	int ret, priv;
 	char card_name[64];
+	char name[64];
+	unsigned int i;
 
 	sprintf(card_name, "%s%u_card", GENWQE_DEVNAME, cd->card_idx);
 
@@ -538,6 +540,17 @@ int genwqe_init_debugfs(struct genwqe_dev *cd)
 		goto err1;
 	}
 
+	for (i = 0; i <  GENWQE_MAX_VFS; i++) {
+		sprintf(name, "vf%d_jobtimeout_msec", i);
+
+		file = debugfs_create_u32(name, 0666, root,
+					  &cd->vf_jobtimeout_msec[i]);
+		if (!file) {
+			ret = -ENOMEM;
+			goto err1;
+		}
+	}
+
 	file = debugfs_create_file("jobtimer", S_IRUGO, root, cd,
 				   &genwqe_jtimer_fops);
 	if (!file) {
-- 
1.7.1

