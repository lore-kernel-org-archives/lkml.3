Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab3BUSO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:14:59 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:35282 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756240Ab3BUSOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:14:55 -0500
Date: Thu, 21 Feb 2013 19:14:23 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: Juan David Gonzalez Cobas <dcobas@cern.ch>,
        "Emilio G. Cota" <cota@braap.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org
Subject: [PATCH 5/8] FMC: add a software carrier driver
Message-ID: <74d87815a29194b9416e9f40bdfb60969728780a.1361469466.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1361469465.git.rubini@gnudd.com>
In-Reply-To: <cover.1361469465.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fake carrier is designed to understand how a carrier driver
works, and to experiment the behaviour with EEPROM reprogramming (with
a mezzanine driver commited later).

We have real carriers (both on PCI-E and VME), but they are bigger
things and are not part of this submission.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Juan David Gonzalez Cobas <dcobas@cern.ch>
Acked-by: Emilio G. Cota <cota@braap.org>
Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 Documentation/fmc/00-INDEX        |    3 +
 Documentation/fmc/fmc-fakedev.txt |   30 ++++
 drivers/fmc/Kconfig               |   11 ++
 drivers/fmc/Makefile              |    2 +
 drivers/fmc/fmc-fakedev.c         |  308 +++++++++++++++++++++++++++++++++++++
 5 files changed, 354 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/fmc/fmc-fakedev.txt
 create mode 100644 drivers/fmc/fmc-fakedev.c

diff --git a/Documentation/fmc/00-INDEX b/Documentation/fmc/00-INDEX
index 71304b7..34df5cf 100644
--- a/Documentation/fmc/00-INDEX
+++ b/Documentation/fmc/00-INDEX
@@ -24,3 +24,6 @@ mezzanine.txt
 
 identifiers.txt
 	- how identification and matching works
+
+fmc-fakedev.txt
+	- about drivers/fmc/fmc-fakedev.ko
diff --git a/Documentation/fmc/fmc-fakedev.txt b/Documentation/fmc/fmc-fakedev.txt
new file mode 100644
index 0000000..4b0bc6c
--- /dev/null
+++ b/Documentation/fmc/fmc-fakedev.txt
@@ -0,0 +1,30 @@
+fmc-fakedev
+===========
+
+This package includes a software-only device, called fmc-fakedev.
+Unlike the SPEC driver, which creates an FMC device for each PCI cards
+it manages, this module creates a single instance of its device.
+
+It is meant as the simplest possible example of how a driver should be
+written, and it includes a fake EEPROM image (built using the tools
+described in *note FMC Identification::).
+
+You can also use this device to verify the match algorithms, by asking
+it to test your own EEPROM image. You can provide the image by means of
+the eeprom= module parameter: the new EEPROM image is loaded, as usual,
+by means of the firmware loader.  This example shows the defaults and a
+custom EEPROM image:
+
+        spusa.root# insmod fmc-fakedev.ko
+        [  158.355436]  fake-fmc: Manufacturer: fake-vendor
+        [  158.360106]  fake-fmc: Product name: fake-design-for-testing
+        spusa.root# rmmod fmc-fakedev
+        spusa.root# insmod fmc-fakedev.ko eeprom=fdelay-eeprom.bin
+        [  197.182682]  fake-fmc: Manufacturer: CERN
+        [  197.186764]  fake-fmc: Product name: FmcDelay1ns4cha
+        spusa.root# rmmod fmc-fakedev
+
+After loading the device, you can use the write_ee method do modify its
+own internal fake EEPROM: whenever the image is overwritten starting at
+offset 0, the module will unregister and register again the FMC device.
+This is shown in fmc-write-eeprom.txt
diff --git a/drivers/fmc/Kconfig b/drivers/fmc/Kconfig
index e287902..505e96b 100644
--- a/drivers/fmc/Kconfig
+++ b/drivers/fmc/Kconfig
@@ -15,3 +15,14 @@ menuconfig FMC
 	  The framework was born outside of the kernel and at this time
 	  the off-tree code base is more complete.  Code and documentation
 	  is at git://ohwr.org/fmc-projects/fmc-bus.git .
+
+if FMC
+
+config FMC_FAKEDEV
+	tristate "FMC fake device (software testing)"
+	help
+	  This is a fake carrier, bringing a default EEPROM content
+	  that can be rewritten at run time and usef for matching
+	  mezzanines.
+
+endif # FMC
diff --git a/drivers/fmc/Makefile b/drivers/fmc/Makefile
index df98939..9832b79 100644
--- a/drivers/fmc/Makefile
+++ b/drivers/fmc/Makefile
@@ -6,3 +6,5 @@ fmc-y += fmc-match.o
 fmc-y += fmc-sdb.o
 fmc-y += fru-parse.o
 fmc-y += fmc-dump.o
+
+obj-$(CONFIG_FMC_FAKEDEV) += fmc-fakedev.o
diff --git a/drivers/fmc/fmc-fakedev.c b/drivers/fmc/fmc-fakedev.c
new file mode 100644
index 0000000..17ceddb
--- /dev/null
+++ b/drivers/fmc/fmc-fakedev.c
@@ -0,0 +1,308 @@
+/*
+ * Copyright (C) 2012 CERN (www.cern.ch)
+ * Author: Alessandro Rubini <rubini@gnudd.com>
+ *
+ * Released to the public domain, as example to be reused
+ */
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/string.h>
+#include <linux/device.h>
+#include <linux/slab.h>
+#include <linux/firmware.h>
+#include <linux/workqueue.h>
+#include <linux/fmc.h>
+
+static char *ff_eeprom;
+module_param_named(eeprom, ff_eeprom, charp, 0444);
+
+/* Lazily, don't support the "standard" module parameters */
+
+#define FF_EEPROM_SIZE 8192
+
+/*
+ * Eeprom built from these commands:
+
+	../fru-generator -v fake-vendor -n fake-design-for-testing \
+		-s 01234 -p none > IPMI-FRU
+
+	gensdbfs . ../fake-eeprom.bin
+*/
+static char ff_eeimg[FF_EEPROM_SIZE] = {
+	0x01, 0x00, 0x00, 0x01, 0x00, 0x0c, 0x00, 0xf2, 0x01, 0x0b, 0x00, 0xb2,
+	0x86, 0x87, 0xcb, 0x66, 0x61, 0x6b, 0x65, 0x2d, 0x76, 0x65, 0x6e, 0x64,
+	0x6f, 0x72, 0xd7, 0x66, 0x61, 0x6b, 0x65, 0x2d, 0x64, 0x65, 0x73, 0x69,
+	0x67, 0x6e, 0x2d, 0x66, 0x6f, 0x72, 0x2d, 0x74, 0x65, 0x73, 0x74, 0x69,
+	0x6e, 0x67, 0xc5, 0x30, 0x31, 0x32, 0x33, 0x34, 0xc4, 0x6e, 0x6f, 0x6e,
+	0x65, 0xda, 0x32, 0x30, 0x31, 0x32, 0x2d, 0x31, 0x31, 0x2d, 0x31, 0x39,
+	0x20, 0x32, 0x32, 0x3a, 0x34, 0x32, 0x3a, 0x33, 0x30, 0x2e, 0x30, 0x37,
+	0x34, 0x30, 0x35, 0x35, 0xc1, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x87,
+	0x02, 0x02, 0x0d, 0xf7, 0xf8, 0x02, 0xb0, 0x04, 0x74, 0x04, 0xec, 0x04,
+	0x00, 0x00, 0x00, 0x00, 0xe8, 0x03, 0x02, 0x02, 0x0d, 0x5c, 0x93, 0x01,
+	0x4a, 0x01, 0x39, 0x01, 0x5a, 0x01, 0x00, 0x00, 0x00, 0x00, 0xb8, 0x0b,
+	0x02, 0x02, 0x0d, 0x63, 0x8c, 0x00, 0xfa, 0x00, 0xed, 0x00, 0x06, 0x01,
+	0x00, 0x00, 0x00, 0x00, 0xa0, 0x0f, 0x01, 0x02, 0x0d, 0xfb, 0xf5, 0x05,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x01, 0x02, 0x0d, 0xfc, 0xf4, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x02, 0x0d, 0xfd, 0xf3, 0x03,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0xfa, 0x82, 0x0b, 0xea, 0x8f, 0xa2, 0x12, 0x00, 0x00, 0x1e, 0x44, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x53, 0x44, 0x42, 0x2d, 0x00, 0x03, 0x01, 0x01,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x01, 0xc4, 0x46, 0x69, 0x6c, 0x65, 0x44, 0x61, 0x74, 0x61,
+	0x2e, 0x20, 0x20, 0x20, 0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00,
+	0x2e, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
+	0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x00, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0xc0,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0xc4, 0x46, 0x69, 0x6c, 0x65,
+	0x44, 0x61, 0x74, 0x61, 0x6e, 0x61, 0x6d, 0x65, 0x00, 0x00, 0x00, 0x01,
+	0x00, 0x00, 0x00, 0x00, 0x6e, 0x61, 0x6d, 0x65, 0x20, 0x20, 0x20, 0x20,
+	0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x01,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x00,
+	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0xdf,
+	0x46, 0x69, 0x6c, 0x65, 0x44, 0x61, 0x74, 0x61, 0x49, 0x50, 0x4d, 0x49,
+	0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x00, 0x49, 0x50, 0x4d, 0x49,
+	0x2d, 0x46, 0x52, 0x55, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20, 0x20,
+	0x20, 0x20, 0x20, 0x01, 0x66, 0x61, 0x6b, 0x65, 0x0a,
+};
+
+struct ff_dev {
+	struct fmc_device fmc;
+	struct device dev;
+	struct delayed_work work;
+};
+
+static struct ff_dev *ff_current_dev; /* We have 1 carrier, 1 slot */
+
+static int ff_reprogram(struct fmc_device *fmc, struct fmc_driver *drv,
+			  char *gw)
+{
+	const struct firmware *fw;
+	int ret;
+
+	if (!gw) {
+		/* program golden: success */
+		fmc->flags &= ~FMC_DEVICE_HAS_CUSTOM;
+		fmc->flags |= FMC_DEVICE_HAS_GOLDEN;
+		return 0;
+	}
+
+	dev_info(fmc->hwdev, "reprogramming with %s\n", gw);
+	ret = request_firmware(&fw, gw, fmc->hwdev);
+	if (ret < 0) {
+		dev_warn(fmc->hwdev, "request firmware \"%s\": error %i\n",
+			 gw, ret);
+		goto out;
+	}
+	fmc->flags &= ~FMC_DEVICE_HAS_GOLDEN;
+	fmc->flags |= FMC_DEVICE_HAS_CUSTOM;
+
+out:
+	release_firmware(fw);
+	return ret;
+}
+
+static int ff_irq_request(struct fmc_device *fmc, irq_handler_t handler,
+			    char *name, int flags)
+{
+	return -EOPNOTSUPP;
+}
+
+/* FIXME: should also have some fake FMC GPIO mapping */
+
+
+/*
+ * This work function is called when we changed the eeprom. It removes
+ * the current fmc device and registers a new one, probably with different
+ * identifiers.
+ */
+static struct ff_dev *ff_dev_create(void); /* defined later */
+
+static void ff_work_fn(struct work_struct *work)
+{
+	struct delayed_work *dw = to_delayed_work(work);
+	struct ff_dev *ff = container_of(dw, struct ff_dev, work);
+	int ret;
+
+	fmc_device_unregister(&ff->fmc);
+	device_unregister(&ff->dev);
+	ff_current_dev = NULL;
+
+	ff = ff_dev_create();
+	if (IS_ERR(ff)) {
+		pr_warning("%s: can't re-create FMC device\n", __func__);
+		return;
+	}
+	ret = fmc_device_register(&ff->fmc);
+	if (ret < 0) {
+		device_unregister(&ff->dev);
+		pr_warning("%s: can't re-register FMC device\n", __func__);
+		return;
+	}
+
+	ff_current_dev = ff;
+}
+
+/* low-level i2c */
+int ff_eeprom_read(struct fmc_device *fmc, uint32_t offset,
+		void *buf, size_t size)
+{
+	if (offset > FF_EEPROM_SIZE)
+		return -EINVAL;
+	if (offset + size > FF_EEPROM_SIZE)
+		size = FF_EEPROM_SIZE - offset;
+	memcpy(buf, ff_eeimg + offset, size);
+	return size;
+}
+
+int ff_eeprom_write(struct fmc_device *fmc, uint32_t offset,
+		    const void *buf, size_t size)
+{
+	struct ff_dev *ff = fmc->carrier_data;
+
+	if (offset > FF_EEPROM_SIZE)
+		return -EINVAL;
+	if (offset + size > FF_EEPROM_SIZE)
+		size = FF_EEPROM_SIZE - offset;
+	pr_info("%s: size %i\n", __func__, size);
+	memcpy(ff_eeimg + offset, buf, size);
+	schedule_delayed_work(&ff->work, HZ * 2); /* remove, replug, in 2s */
+	return size;
+}
+
+/* i2c operations for fmc */
+static int ff_read_ee(struct fmc_device *fmc, int pos, void *data, int len)
+{
+	if (!(fmc->flags & FMC_DEVICE_HAS_GOLDEN))
+		return -EOPNOTSUPP;
+	return ff_eeprom_read(fmc, pos, data, len);
+}
+
+static int ff_write_ee(struct fmc_device *fmc, int pos,
+			 const void *data, int len)
+{
+	if (!(fmc->flags & FMC_DEVICE_HAS_GOLDEN))
+		return -EOPNOTSUPP;
+	return ff_eeprom_write(fmc, pos, data, len);
+}
+
+/* readl and writel do not do anything. Don't waste RAM with "base" */
+uint32_t ff_readl(struct fmc_device *fmc, int offset)
+{
+	return 0;
+}
+
+void ff_writel(struct fmc_device *fmc, uint32_t value, int offset)
+{
+	return;
+}
+
+static struct fmc_operations ff_fmc_operations = {
+	.readl =		ff_readl,
+	.writel =		ff_writel,
+	.reprogram =		ff_reprogram,
+	.irq_request =		ff_irq_request,
+	.read_ee =		ff_read_ee,
+	.write_ee =		ff_write_ee,
+};
+
+/* This device is kmalloced: release it */
+static void ff_dev_release(struct device *dev)
+{
+	struct ff_dev *ff = container_of(dev, struct ff_dev, dev);
+	kfree(ff);
+}
+
+static struct fmc_device ff_template_fmc = {
+	.version = FMC_VERSION,
+	.owner = THIS_MODULE,
+	.carrier_name = "fake",
+	.device_id = 0xf001, /* fool */
+	.eeprom = ff_eeimg,
+	.eeprom_addr = 0x50,
+	.eeprom_len = sizeof(ff_eeimg),
+	.nr_slots = 1,
+	.memlen = 0x1000, /* 4k, to show something */
+	.op = &ff_fmc_operations,
+	.hwdev = NULL, /* filled at creation time */
+	.flags = FMC_DEVICE_HAS_GOLDEN,
+};
+
+static struct ff_dev *ff_dev_create(void)
+{
+	struct ff_dev *ff;
+	int ret;
+
+	ff = kzalloc(sizeof(*ff), GFP_KERNEL);
+	if (!ff)
+		return ERR_PTR(-ENOMEM);
+	dev_set_name(&ff->dev, "fake-fmc");
+	ff->dev.release = ff_dev_release;
+
+	ret = device_register(&ff->dev);
+	if (ret < 0) {
+		put_device(&ff->dev);
+		kfree(ff);
+		return ERR_PTR(ret);
+	}
+
+	/* Create an fmc structure that refers to this new "hw" device */
+	ff->fmc = ff_template_fmc;
+	ff->fmc.hwdev = &ff->dev;
+	ff->fmc.carrier_data = ff;
+	ff_template_fmc.device_id++; /* for next time */
+
+	INIT_DELAYED_WORK(&ff->work, ff_work_fn);
+	return ff;
+}
+
+/* init and exit */
+int ff_init(void)
+{
+	struct ff_dev *ff;
+	const struct firmware *fw;
+	int len, ret = 0;
+
+
+	ff = ff_dev_create();
+	if (IS_ERR(ff))
+		return PTR_ERR(ff);
+
+	/* If the user passed "eeprom=" as a parameter, fetch it */
+	if (ff_eeprom) {
+		ret = request_firmware(&fw, ff_eeprom, &ff->dev);
+		if (ret < 0) {
+			dev_err(&ff->dev, "Can't load \"%s\" (error %i)\n",
+				ff_eeprom, -ret);
+		} else {
+			len = min_t(size_t, fw->size, (size_t)FF_EEPROM_SIZE);
+			memcpy(ff_eeimg, fw->data, len);
+			release_firmware(fw);
+		}
+	}
+
+	ret = fmc_device_register(&ff->fmc);
+	if (ret) {
+		device_unregister(&ff->dev);
+		return ret;
+	}
+	ff_current_dev = ff;
+	return ret;
+}
+
+void ff_exit(void)
+{
+	if (ff_current_dev) {
+		cancel_delayed_work_sync(&ff_current_dev->work);
+		fmc_device_unregister(&ff_current_dev->fmc);
+		device_unregister(&ff_current_dev->dev);
+	}
+}
+
+module_init(ff_init);
+module_exit(ff_exit);
+
+MODULE_LICENSE("GPL and additional rights");
-- 
1.7.7.2
