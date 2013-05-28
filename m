Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934717Ab3E1P5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 11:57:00 -0400
Received: from emvm-gh1-uea09.nsa.gov ([63.239.67.10]:55913 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934600Ab3E1P46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 11:56:58 -0400
X-TM-IMSS-Message-ID: <4b3b85b2000e1aa7@nsa.gov>
From: Daniel De Graaf <dgdegra@tycho.nsa.gov>
To: linux-kernel@vger.kernel.org, tpmdd-devel@lists.sourceforge.net
Cc: konrad.wilk@oracle.com, xen-devel@lists.xen.org, mail@srajiv.net,
        tpmdd@selhorst.net, tpmdd@sirrix.com, leosilva@linux.vnet.ibm.com,
        adlai@linux.vnet.ibm.com, shpedoikal@gmail.com,
        Daniel De Graaf <dgdegra@tycho.nsa.gov>
Subject: [PATCH v3] drivers/tpm: add xen tpmfront interface
Date: Tue, 28 May 2013 11:40:32 -0400
Message-Id: <1369755632-2753-1-git-send-email-dgdegra@tycho.nsa.gov>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a complete rewrite of the Xen TPM frontend driver, taking
advantage of a simplified frontend/backend interface and adding support
for cancellation and timeouts.  The backend for this driver is provided
by a vTPM stub domain using the interface in Xen 4.3.

Signed-off-by: Daniel De Graaf <dgdegra@tycho.nsa.gov>
Acked-by: Matthew Fioravante <matthew.fioravante@jhuapl.edu>

---

Changes since v1:
 * Added some wmb()s for clarity
 * Removed a few magic numbers
 * Fix a misused length in memcpy
 * Style/comment fixes

 Documentation/xen-tpmfront.txt   | 116 ++++++++++
 drivers/char/tpm/Kconfig         |  11 +
 drivers/char/tpm/Makefile        |   1 +
 drivers/char/tpm/xen-tpmfront.c  | 470 +++++++++++++++++++++++++++++++++++++++
 include/xen/interface/io/tpmif.h |  50 +++++
 5 files changed, 648 insertions(+)
 create mode 100644 Documentation/xen-tpmfront.txt
 create mode 100644 drivers/char/tpm/xen-tpmfront.c
 create mode 100644 include/xen/interface/io/tpmif.h

diff --git a/Documentation/xen-tpmfront.txt b/Documentation/xen-tpmfront.txt
new file mode 100644
index 0000000..8a61d6f
--- /dev/null
+++ b/Documentation/xen-tpmfront.txt
@@ -0,0 +1,116 @@
+Copyright (c) 2010-2012 United States Government, as represented by
+the Secretary of Defense.  All rights reserved.
+November 12 2012
+Authors: Matthew Fioravante (JHUAPL), Daniel De Graaf (NSA)
+
+This document describes the virtual Trusted Platform Module (vTPM) subsystem for
+Xen. The reader is assumed to have familiarity with building and installing Xen,
+Linux, and a basic understanding of the TPM and vTPM concepts.
+
+------------------------------
+INTRODUCTION
+------------------------------
+
+The goal of this work is to provide a TPM functionality to a virtual guest
+operating system (in Xen terms, a DomU).  This allows programs to interact with
+a TPM in a virtual system the same way they interact with a TPM on the physical
+system.  Each guest gets its own unique, emulated, software TPM.  However, each
+of the vTPM's secrets (Keys, NVRAM, etc) are managed by a vTPM Manager domain,
+which seals the secrets to the Physical TPM.  If the process of creating each of
+these domains (manager, vTPM, and guest) is trusted, the vTPM subsystem extends
+the chain of trust rooted in the hardware TPM to virtual machines in Xen. Each
+major component of vTPM is implemented as a separate domain, providing secure
+separation guaranteed by the hypervisor. The vTPM domains are implemented in
+mini-os to reduce memory and processor overhead.
+
+This mini-os vTPM subsystem was built on top of the previous vTPM work done by
+IBM and Intel corporation.
+
+------------------------------
+DESIGN OVERVIEW
+------------------------------
+
+The architecture of vTPM is described below:
+
++------------------+
+|    Linux DomU    | ...
+|       |  ^       |
+|       v  |       |
+|   xen-tpmfront   |
++------------------+
+        |  ^
+        v  |
++------------------+
+| mini-os/tpmback  |
+|       |  ^       |
+|       v  |       |
+|  vtpm-stubdom    | ...
+|       |  ^       |
+|       v  |       |
+| mini-os/tpmfront |
++------------------+
+        |  ^
+        v  |
++------------------+
+| mini-os/tpmback  |
+|       |  ^       |
+|       v  |       |
+| vtpmmgr-stubdom  |
+|       |  ^       |
+|       v  |       |
+| mini-os/tpm_tis  |
++------------------+
+        |  ^
+        v  |
++------------------+
+|   Hardware TPM   |
++------------------+
+
+ * Linux DomU: The Linux based guest that wants to use a vTPM. There many be
+	       more than one of these.
+
+ * xen-tpmfront.ko: Linux kernel virtual TPM frontend driver. This driver
+                    provides vTPM access to a Linux-based DomU.
+
+ * mini-os/tpmback: Mini-os TPM backend driver. The Linux frontend driver
+		    connects to this backend driver to facilitate communications
+		    between the Linux DomU and its vTPM. This driver is also
+		    used by vtpmmgr-stubdom to communicate with vtpm-stubdom.
+
+ * vtpm-stubdom: A mini-os stub domain that implements a vTPM. There is a
+		 one to one mapping between running vtpm-stubdom instances and
+                 logical vtpms on the system. The vTPM Platform Configuration
+                 Registers (PCRs) are normally all initialized to zero.
+
+ * mini-os/tpmfront: Mini-os TPM frontend driver. The vTPM mini-os domain
+		     vtpm-stubdom uses this driver to communicate with
+		     vtpmmgr-stubdom. This driver is also used in mini-os
+		     domains such as pv-grub that talk to the vTPM domain.
+
+ * vtpmmgr-stubdom: A mini-os domain that implements the vTPM manager. There is
+		    only one vTPM manager and it should be running during the
+		    entire lifetime of the machine.  This domain regulates
+		    access to the physical TPM on the system and secures the
+		    persistent state of each vTPM.
+
+ * mini-os/tpm_tis: Mini-os TPM version 1.2 TPM Interface Specification (TIS)
+                    driver. This driver used by vtpmmgr-stubdom to talk directly to
+                    the hardware TPM. Communication is facilitated by mapping
+                    hardware memory pages into vtpmmgr-stubdom.
+
+ * Hardware TPM: The physical TPM that is soldered onto the motherboard.
+
+------------------------------
+INTEGRATION WITH XEN
+------------------------------
+
+Support for the vTPM driver was added in Xen using the libxl toolstack in Xen
+4.3.  See the Xen documentation (docs/misc/vtpm.txt) for details on setting up
+the vTPM and vTPM Manager stub domains.  Once the stub domains are running, a
+vTPM device is set up in the same manner as a disk or network device in the
+domain's configuration file.
+
+In order to use features such as IMA that require a TPM to be loaded prior to
+the initrd, the xen-tpmfront driver must be compiled in to the kernel.  If not
+using such features, the driver can be compiled as a module and will be loaded
+as usual.
diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index dbfd564..205ed35 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -91,4 +91,15 @@ config TCG_ST33_I2C
         To compile this driver as a module, choose M here; the module will be
         called tpm_stm_st33_i2c.
 
+config TCG_XEN
+	tristate "XEN TPM Interface"
+	depends on TCG_TPM && XEN
+	---help---
+	  If you want to make TPM support available to a Xen user domain,
+	  say Yes and it will be accessible from within Linux. See
+	  the manpages for xl, xl.conf, and docs/misc/vtpm.txt in
+	  the Xen source repository for more details.
+	  To compile this driver as a module, choose M here; the module
+	  will be called xen-tpmfront.
+
 endif # TCG_TPM
diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index a3736c9..eb41ff9 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -18,3 +18,4 @@ obj-$(CONFIG_TCG_ATMEL) += tpm_atmel.o
 obj-$(CONFIG_TCG_INFINEON) += tpm_infineon.o
 obj-$(CONFIG_TCG_IBMVTPM) += tpm_ibmvtpm.o
 obj-$(CONFIG_TCG_ST33_I2C) += tpm_i2c_stm_st33.o
+obj-$(CONFIG_TCG_XEN) += xen-tpmfront.o
diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfront.c
new file mode 100644
index 0000000..4c0fb12
--- /dev/null
+++ b/drivers/char/tpm/xen-tpmfront.c
@@ -0,0 +1,470 @@
+/*
+ * Implementation of the Xen vTPM device frontend
+ *
+ * Author:  Daniel De Graaf <dgdegra@tycho.nsa.gov>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2,
+ * as published by the Free Software Foundation.
+ */
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+#include <xen/events.h>
+#include <xen/interface/io/tpmif.h>
+#include <xen/grant_table.h>
+#include <xen/xenbus.h>
+#include <xen/page.h>
+#include "tpm.h"
+
+struct tpm_private {
+	struct tpm_chip *chip;
+	struct xenbus_device *dev;
+
+	struct vtpm_shared_page *shr;
+
+	unsigned int evtchn;
+	int ring_ref;
+	domid_t backend_id;
+};
+
+enum status_bits {
+	VTPM_STATUS_RUNNING  = 0x1,
+	VTPM_STATUS_IDLE     = 0x2,
+	VTPM_STATUS_RESULT   = 0x4,
+	VTPM_STATUS_CANCELED = 0x8,
+};
+
+static u8 vtpm_status(struct tpm_chip *chip)
+{
+	struct tpm_private *priv = TPM_VPRIV(chip);
+	switch (priv->shr->state) {
+	case VTPM_STATE_IDLE:
+		return VTPM_STATUS_IDLE | VTPM_STATUS_CANCELED;
+	case VTPM_STATE_FINISH:
+		return VTPM_STATUS_IDLE | VTPM_STATUS_RESULT;
+	case VTPM_STATE_SUBMIT:
+	case VTPM_STATE_CANCEL: /* cancel requested, not yet canceled */
+		return VTPM_STATUS_RUNNING;
+	default:
+		return 0;
+	}
+}
+
+static bool vtpm_req_canceled(struct tpm_chip *chip, u8 status)
+{
+	return status & VTPM_STATUS_CANCELED;
+}
+
+static void vtpm_cancel(struct tpm_chip *chip)
+{
+	struct tpm_private *priv = TPM_VPRIV(chip);
+	priv->shr->state = VTPM_STATE_CANCEL;
+	wmb();
+	notify_remote_via_evtchn(priv->evtchn);
+}
+
+static unsigned int shr_data_offset(struct vtpm_shared_page *shr)
+{
+	return sizeof(*shr) + sizeof(u32) * shr->nr_extra_pages;
+}
+
+static int vtpm_send(struct tpm_chip *chip, u8 *buf, size_t count)
+{
+	struct tpm_private *priv = TPM_VPRIV(chip);
+	struct vtpm_shared_page *shr = priv->shr;
+	unsigned int offset = shr_data_offset(shr);
+
+	u32 ordinal;
+	unsigned long duration;
+
+	if (offset > PAGE_SIZE)
+		return -EIO;
+
+	if (offset + count > PAGE_SIZE)
+		return -EIO;
+
+	/* Wait for completion of any existing command or cancellation */
+	if (wait_for_tpm_stat(chip, VTPM_STATUS_IDLE, chip->vendor.timeout_c,
+			&chip->vendor.read_queue, true) < 0) {
+		vtpm_cancel(chip);
+		return -ETIME;
+	}
+
+	memcpy(offset + (u8 *)shr, buf, count);
+	shr->length = count;
+	barrier();
+	shr->state = VTPM_STATE_SUBMIT;
+	wmb();
+	notify_remote_via_evtchn(priv->evtchn);
+
+	ordinal = be32_to_cpu(((struct tpm_input_header*)buf)->ordinal);
+	duration = tpm_calc_ordinal_duration(chip, ordinal);
+
+	if (wait_for_tpm_stat(chip, VTPM_STATUS_IDLE, duration,
+			&chip->vendor.read_queue, true) < 0) {
+		/* got a signal or timeout, try to cancel */
+		vtpm_cancel(chip);
+		return -ETIME;
+	}
+
+	return count;
+}
+
+static int vtpm_recv(struct tpm_chip *chip, u8 *buf, size_t count)
+{
+	struct tpm_private *priv = TPM_VPRIV(chip);
+	struct vtpm_shared_page *shr = priv->shr;
+	unsigned int offset = shr_data_offset(shr);
+	size_t length = shr->length;
+
+	if (shr->state == VTPM_STATE_IDLE)
+		return -ECANCELED;
+
+	/* In theory the wait at the end of _send makes this one unnecessary */
+	if (wait_for_tpm_stat(chip, VTPM_STATUS_RESULT, chip->vendor.timeout_c,
+			&chip->vendor.read_queue, true) < 0) {
+		vtpm_cancel(chip);
+		return -ETIME;
+	}
+
+	if (offset > PAGE_SIZE)
+		return -EIO;
+
+	if (offset + length > PAGE_SIZE)
+		length = PAGE_SIZE - offset;
+
+	if (length > count)
+		length = count;
+
+	memcpy(buf, offset + (u8 *)shr, length);
+
+	return length;
+}
+
+ssize_t tpm_show_locality(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+	struct tpm_private *priv = TPM_VPRIV(chip);
+	u8 locality = priv->shr->locality;
+
+	return sprintf(buf, "%d\n", locality);
+}
+
+ssize_t tpm_store_locality(struct device *dev, struct device_attribute *attr,
+			const char *buf, size_t len)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+	struct tpm_private *priv = TPM_VPRIV(chip);
+	u8 val;
+
+	int rv = kstrtou8(buf, 0, &val);
+	if (rv)
+		return rv;
+
+	priv->shr->locality = val;
+
+	return len;
+}
+
+static const struct file_operations vtpm_ops = {
+	.owner = THIS_MODULE,
+	.llseek = no_llseek,
+	.open = tpm_open,
+	.read = tpm_read,
+	.write = tpm_write,
+	.release = tpm_release,
+};
+
+static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
+static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
+static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
+static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
+static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
+static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated,
+		NULL);
+static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps, NULL);
+static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
+static DEVICE_ATTR(durations, S_IRUGO, tpm_show_durations, NULL);
+static DEVICE_ATTR(timeouts, S_IRUGO, tpm_show_timeouts, NULL);
+static DEVICE_ATTR(locality, S_IRUGO | S_IWUSR, tpm_show_locality,
+		tpm_store_locality);
+
+static struct attribute *vtpm_attrs[] = {
+	&dev_attr_pubek.attr,
+	&dev_attr_pcrs.attr,
+	&dev_attr_enabled.attr,
+	&dev_attr_active.attr,
+	&dev_attr_owned.attr,
+	&dev_attr_temp_deactivated.attr,
+	&dev_attr_caps.attr,
+	&dev_attr_cancel.attr,
+	&dev_attr_durations.attr,
+	&dev_attr_timeouts.attr,
+	&dev_attr_locality.attr,
+	NULL,
+};
+
+static struct attribute_group vtpm_attr_grp = {
+	.attrs = vtpm_attrs,
+};
+
+#define TPM_LONG_TIMEOUT   (10 * 60 * HZ)
+
+static const struct tpm_vendor_specific tpm_vtpm = {
+	.status = vtpm_status,
+	.recv = vtpm_recv,
+	.send = vtpm_send,
+	.cancel = vtpm_cancel,
+	.req_complete_mask = VTPM_STATUS_IDLE | VTPM_STATUS_RESULT,
+	.req_complete_val  = VTPM_STATUS_IDLE | VTPM_STATUS_RESULT,
+	.req_canceled      = vtpm_req_canceled,
+	.attr_group = &vtpm_attr_grp,
+	.miscdev = {
+		.fops = &vtpm_ops,
+	},
+	.duration = {
+		TPM_LONG_TIMEOUT,
+		TPM_LONG_TIMEOUT,
+		TPM_LONG_TIMEOUT,
+	},
+};
+
+static irqreturn_t tpmif_interrupt(int dummy, void *dev_id)
+{
+	struct tpm_private *priv = dev_id;
+
+	switch (priv->shr->state) {
+	case VTPM_STATE_IDLE:
+	case VTPM_STATE_FINISH:
+		wake_up_interruptible(&priv->chip->vendor.read_queue);
+		break;
+	case VTPM_STATE_SUBMIT:
+	case VTPM_STATE_CANCEL:
+	default:
+		break;
+	}
+	return IRQ_HANDLED;
+}
+
+static int setup_chip(struct device *dev, struct tpm_private *priv)
+{
+	struct tpm_chip *chip;
+
+	chip = tpm_register_hardware(dev, &tpm_vtpm);
+	if (!chip)
+		return -ENODEV;
+
+	init_waitqueue_head(&chip->vendor.read_queue);
+
+	priv->chip = chip;
+	TPM_VPRIV(chip) = priv;
+
+	return 0;
+}
+
+/* caller must clean up in case of errors */
+static int setup_ring(struct xenbus_device *dev, struct tpm_private *priv)
+{
+	struct xenbus_transaction xbt;
+	const char *message = NULL;
+	int rv;
+
+	priv->shr = (void *)__get_free_page(GFP_KERNEL|__GFP_ZERO);
+	if (!priv->shr) {
+		xenbus_dev_fatal(dev, -ENOMEM, "allocating shared ring");
+		return -ENOMEM;
+	}
+
+	rv = xenbus_grant_ring(dev, virt_to_mfn(priv->shr));
+	if (rv < 0)
+		return rv;
+
+	priv->ring_ref = rv;
+
+	rv = xenbus_alloc_evtchn(dev, &priv->evtchn);
+	if (rv)
+		return rv;
+
+	rv = bind_evtchn_to_irqhandler(priv->evtchn, tpmif_interrupt, 0,
+				       "tpmif", priv);
+	if (rv <= 0) {
+		xenbus_dev_fatal(dev, rv, "allocating TPM irq");
+		return rv;
+	}
+	priv->chip->vendor.irq = rv;
+
+ again:
+	rv = xenbus_transaction_start(&xbt);
+	if (rv) {
+		xenbus_dev_fatal(dev, rv, "starting transaction");
+		return rv;
+	}
+
+	rv = xenbus_printf(xbt, dev->nodename,
+			"ring-ref", "%u", priv->ring_ref);
+	if (rv) {
+		message = "writing ring-ref";
+		goto abort_transaction;
+	}
+
+	rv = xenbus_printf(xbt, dev->nodename, "event-channel", "%u",
+			priv->evtchn);
+	if (rv) {
+		message = "writing event-channel";
+		goto abort_transaction;
+	}
+
+	rv = xenbus_printf(xbt, dev->nodename, "feature-protocol-v2", "1");
+	if (rv) {
+		message = "writing feature-protocol-v2";
+		goto abort_transaction;
+	}
+
+	rv = xenbus_transaction_end(xbt, 0);
+	if (rv == -EAGAIN)
+		goto again;
+	if (rv) {
+		xenbus_dev_fatal(dev, rv, "completing transaction");
+		return rv;
+	}
+
+	xenbus_switch_state(dev, XenbusStateInitialised);
+
+	return 0;
+
+ abort_transaction:
+	xenbus_transaction_end(xbt, 1);
+	if (message)
+		xenbus_dev_error(dev, rv, "%s", message);
+
+	return rv;
+}
+
+static void ring_free(struct tpm_private *priv)
+{
+	if (!priv)
+		return;
+
+	if (priv->ring_ref)
+		gnttab_end_foreign_access(priv->ring_ref, 0,
+				(unsigned long)priv->shr);
+	else
+		free_page((unsigned long)priv->shr);
+
+	if (priv->chip && priv->chip->vendor.irq)
+		unbind_from_irqhandler(priv->chip->vendor.irq, priv);
+
+	kfree(priv);
+}
+
+static int tpmfront_probe(struct xenbus_device *dev,
+		const struct xenbus_device_id *id)
+{
+	struct tpm_private *priv;
+	int rv;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		xenbus_dev_fatal(dev, -ENOMEM, "allocating priv structure");
+		return -ENOMEM;
+	}
+
+	rv = setup_chip(&dev->dev, priv);
+	if (rv) {
+		kfree(priv);
+		return rv;
+	}
+
+	rv = setup_ring(dev, priv);
+	if (rv) {
+		tpm_remove_hardware(&dev->dev);
+		ring_free(priv);
+		return rv;
+	}
+
+	tpm_get_timeouts(priv->chip);
+
+	dev_set_drvdata(&dev->dev, priv->chip);
+
+	return rv;
+}
+
+static int tpmfront_remove(struct xenbus_device *dev)
+{
+	struct tpm_chip *chip = dev_get_drvdata(&dev->dev);
+	struct tpm_private *priv = TPM_VPRIV(chip);
+	tpm_remove_hardware(&dev->dev);
+	ring_free(priv);
+	TPM_VPRIV(chip) = NULL;
+	return 0;
+}
+
+static int tpmfront_resume(struct xenbus_device *dev)
+{
+	/* A suspend/resume/migrate will interrupt a vTPM anyway */
+	tpmfront_remove(dev);
+	return tpmfront_probe(dev, NULL);
+}
+
+static void backend_changed(struct xenbus_device *dev,
+		enum xenbus_state backend_state)
+{
+	int val;
+
+	switch (backend_state) {
+	case XenbusStateInitialised:
+	case XenbusStateConnected:
+		if (xenbus_scanf(XBT_NIL, dev->otherend,
+				"feature-protocol-v2", "%d", &val) < 0)
+			val = 0;
+		if (!val) {
+			xenbus_dev_fatal(dev, -EINVAL,
+					"vTPM protocol 2 required");
+			return;
+		}
+		xenbus_switch_state(dev, XenbusStateConnected);
+		break;
+
+	case XenbusStateClosing:
+	case XenbusStateClosed:
+		device_unregister(&dev->dev);
+		xenbus_frontend_closed(dev);
+		break;
+	default:
+		break;
+	}
+}
+
+static const struct xenbus_device_id tpmfront_ids[] = {
+	{ "vtpm" },
+	{ "" }
+};
+MODULE_ALIAS("xen:vtpm");
+
+static DEFINE_XENBUS_DRIVER(tpmfront, ,
+		.probe = tpmfront_probe,
+		.remove = tpmfront_remove,
+		.resume = tpmfront_resume,
+		.otherend_changed = backend_changed,
+	);
+
+static int __init xen_tpmfront_init(void)
+{
+	if (!xen_domain())
+		return -ENODEV;
+
+	return xenbus_register_frontend(&tpmfront_driver);
+}
+module_init(xen_tpmfront_init);
+
+static void __exit xen_tpmfront_exit(void)
+{
+	xenbus_unregister_driver(&tpmfront_driver);
+}
+module_exit(xen_tpmfront_exit);
+
+MODULE_AUTHOR("Daniel De Graaf <dgdegra@tycho.nsa.gov>");
+MODULE_DESCRIPTION("Xen vTPM Driver");
+MODULE_LICENSE("GPL");
diff --git a/include/xen/interface/io/tpmif.h b/include/xen/interface/io/tpmif.h
new file mode 100644
index 0000000..92522a4
--- /dev/null
+++ b/include/xen/interface/io/tpmif.h
@@ -0,0 +1,50 @@
+/******************************************************************************
+ * tpmif.h
+ *
+ * TPM I/O interface for Xen guest OSes, v2
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this software and associated documentation files (the "Software"), to
+ * deal in the Software without restriction, including without limitation the
+ * rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
+ * sell copies of the Software, and to permit persons to whom the Software is
+ * furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
+ * DEALINGS IN THE SOFTWARE.
+ *
+ */
+
+#ifndef __XEN_PUBLIC_IO_TPMIF_H__
+#define __XEN_PUBLIC_IO_TPMIF_H__
+
+enum vtpm_shared_page_state {
+	VTPM_STATE_IDLE,         /* no contents / vTPM idle / cancel complete */
+	VTPM_STATE_SUBMIT,       /* request ready / vTPM working */
+	VTPM_STATE_FINISH,       /* response ready / vTPM idle */
+	VTPM_STATE_CANCEL,       /* cancel requested / vTPM working */
+};
+/* The backend should only change state to IDLE or FINISH, while the
+ * frontend should only change to SUBMIT or CANCEL. */
+
+
+struct vtpm_shared_page {
+	uint32_t length;         /* request/response length in bytes */
+
+	uint8_t state;           /* enum vtpm_shared_page_state */
+	uint8_t locality;        /* for the current request */
+	uint8_t pad;
+
+	uint8_t nr_extra_pages;  /* extra pages for long packets; may be zero */
+	uint32_t extra_pages[0]; /* grant IDs; length in nr_extra_pages */
+};
+
+#endif
-- 
1.8.1.4

