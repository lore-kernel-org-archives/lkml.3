Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933775Ab3FRVsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:48:43 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:38219 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933154Ab3FRVsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:48:40 -0400
Date: Tue, 18 Jun 2013 23:47:56 +0200
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
        Juan David Gonzalez Cobas <juan.david.gonzalez.cobas@cern.ch>,
        "Emilio G. Cota" <cota@braap.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH V3 5/6] FMC: add a driver to write mezzanine EEPROM
Message-ID: <54a7d0f626fe799e9a38a5146cb427b3686de47f.1371591538.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1371591538.git.rubini@gnudd.com>
In-Reply-To: <cover.1371591538.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver allows to reprogram the EEPROM in a mezzanine, to store
its own identifiers during manufacturing or to save other useful data.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Juan David Gonzalez Cobas <dcobas@cern.ch>
Acked-by: Emilio G. Cota <cota@braap.org>
Acked-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 Documentation/fmc/00-INDEX             |    3 +
 Documentation/fmc/fmc-write-eeprom.txt |  125 ++++++++++++++++++++++
 drivers/fmc/Kconfig                    |    8 ++
 drivers/fmc/Makefile                   |    1 +
 drivers/fmc/fmc-write-eeprom.c         |  176 ++++++++++++++++++++++++++++++++
 5 files changed, 313 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/fmc/fmc-write-eeprom.txt
 create mode 100644 drivers/fmc/fmc-write-eeprom.c

diff --git a/Documentation/fmc/00-INDEX b/Documentation/fmc/00-INDEX
index c22d687..177c3e4 100644
--- a/Documentation/fmc/00-INDEX
+++ b/Documentation/fmc/00-INDEX
@@ -30,3 +30,6 @@ fmc-fakedev.txt
 
 fmc-trivial.txt
 	- about drivers/fmc/fmc-trivial.ko
+
+fmc-write-eeprom.txt
+        - about drivers/fmc/fmc-write-eeprom.ko
diff --git a/Documentation/fmc/fmc-write-eeprom.txt b/Documentation/fmc/fmc-write-eeprom.txt
new file mode 100644
index 0000000..44a3bc6
--- /dev/null
+++ b/Documentation/fmc/fmc-write-eeprom.txt
@@ -0,0 +1,125 @@
+fmc-write-eeprom
+================
+
+This module is designed to load a binary file from /lib/firmware and to
+write it to the internal EEPROM of the mezzanine card. This driver uses
+the `busid' generic parameter.
+
+Overwriting the EEPROM is not something you should do daily, and it is
+expected to only happen during manufacturing. For this reason, the
+module makes it unlikely for the random user to change a working EEPROM.
+
+The module takes the following measures:
+
+   * It accepts a `file=' argument (within /lib/firmware) and if no
+     such argument is received, it doesn't write anything to EEPROM
+     (i.e. there is no default file name).
+
+   * If the file name ends with `.bin' it is written verbatim starting
+     at offset 0.
+
+   * If the file name ends with `.tlv' it is interpreted as
+     type-length-value (i.e., it allows writev(2)-like operation).
+
+   * If the file name doesn't match any of the patterns above, it is
+     ignored and no write is performed.
+
+   * Only cards listed with `busid=' are written to. If no busid is
+     specified, no programming is done (and the probe function of the
+     driver will fail).
+
+
+Each TLV tuple is formatted in this way: the header is 5 bytes,
+followed by data. The first byte is `w' for write, the next two bytes
+represent the address, in little-endian byte order, and the next two
+represent the data length, in little-endian order. The length does not
+include the header (it is the actual number of bytes to be written).
+
+This is a real example: that writes 5 bytes at position 0x110:
+
+        spusa.root# od -t x1 -Ax /lib/firmware/try.tlv
+        000000 77 10 01 05 00 30 31 32 33 34
+        00000a
+        spusa.root# insmod /tmp/fmc-write-eeprom.ko busid=0x0200 file=try.tlv
+        [19983.391498] spec 0000:03:00.0: write 5 bytes at 0x0110
+        [19983.414615] spec 0000:03:00.0: write_eeprom: success
+
+Please note that you'll most likely want to use SDBFS to build your
+EEPROM image, at least if your mezzanines are being used in the White
+Rabbit environment. For this reason the TLV format is not expected to
+be used much and is not expected to be developed further.
+
+If you want to try reflashing fake EEPROM devices, you can use the
+fmc-fakedev.ko module (see *note fmc-fakedev::).  Whenever you change
+the image starting at offset 0, it will deregister and register again
+after two seconds.  Please note, however, that if fmc-write-eeprom is
+still loaded, the system will associate it to the new device, which
+will be reprogrammed and thus will be unloaded after two seconds.  The
+following example removes the module after it reflashed fakedev the
+first time.
+
+     spusa.root# insmod fmc-fakedev.ko
+        [   72.984733]  fake-fmc: Manufacturer: fake-vendor
+        [   72.989434]  fake-fmc: Product name: fake-design-for-testing
+        spusa.root# insmod fmc-write-eeprom.ko busid=0 file=fdelay-eeprom.bin; \
+            rmmod fmc-write-eeprom
+        [  130.874098]  fake-fmc: Matching a generic driver (no ID)
+        [  130.887845]  fake-fmc: programming 6155 bytes
+        [  130.894567]  fake-fmc: write_eeprom: success
+        [  132.895794]  fake-fmc: Manufacturer: CERN
+        [  132.899872]  fake-fmc: Product name: FmcDelay1ns4cha
+
+
+Writing to the EEPROM
+=====================
+
+Once you have created a binary file for your EEPROM, you can write it
+to the storage medium using the fmc-write-eeprom (See *note
+fmc-write-eeprom::, while relying on a carrier driver.  The procedure
+here shown here uses the SPEC driver
+(`http://www.ohwr.org/projects/spec-sw').
+
+The example assumes no driver is already loaded (actually, I unloaded
+them by hand as everything loads automatically at boot time after you
+installed the modules), and shows kernel messages together with
+commands. Here the prompt is spusa.root# and two SPEC cards are plugged
+in the system.
+
+     spusa.root# insmod fmc.ko
+     spusa.root# insmod spec.ko
+     [13972.382818] spec 0000:02:00.0:  probe for device 0002:0000
+     [13972.392773] spec 0000:02:00.0: got file "fmc/spec-init.bin", 1484404 (0x16a674) bytes
+     [13972.591388] spec 0000:02:00.0: FPGA programming successful
+     [13972.883011] spec 0000:02:00.0: EEPROM has no FRU information
+     [13972.888719] spec 0000:02:00.0: No device_id filled, using index
+     [13972.894676] spec 0000:02:00.0: No mezzanine_name found
+     [13972.899863] /home/rubini/wip/spec-sw/kernel/spec-gpio.c - spec_gpio_init
+     [13972.906578] spec 0000:04:00.0:  probe for device 0004:0000
+     [13972.916509] spec 0000:04:00.0: got file "fmc/spec-init.bin", 1484404 (0x16a674) bytes
+     [13973.115096] spec 0000:04:00.0: FPGA programming successful
+     [13973.401798] spec 0000:04:00.0: EEPROM has no FRU information
+     [13973.407474] spec 0000:04:00.0: No device_id filled, using index
+     [13973.413417] spec 0000:04:00.0: No mezzanine_name found
+     [13973.418600] /home/rubini/wip/spec-sw/kernel/spec-gpio.c - spec_gpio_init
+     spusa.root# ls /sys/bus/fmc/devices
+     fmc-0000  fmc-0001
+     spusa.root# insmod fmc-write-eeprom.ko busid=0x0200 file=fdelay-eeprom.bin
+     [14103.966259] spec 0000:02:00.0: Matching an generic driver (no ID)
+     [14103.975519] spec 0000:02:00.0: programming 6155 bytes
+     [14126.373762] spec 0000:02:00.0: write_eeprom: success
+     [14126.378770] spec 0000:04:00.0: Matching an generic driver (no ID)
+     [14126.384903] spec 0000:04:00.0: fmc_write_eeprom: no filename given: not programming
+     [14126.392600] fmc_write_eeprom: probe of fmc-0001 failed with error -2
+
+Reading back the EEPROM
+=======================
+
+In order to read back the binary content of the EEPROM of your
+mezzanine device, the bus creates a read-only sysfs file called eeprom
+for each mezzanine it knows about:
+
+   spusa.root# cd /sys/bus/fmc/devices; ls -l */eeprom
+   -r--r--r-- 1 root root 8192 Apr  9 16:53 FmcDelay1ns4cha-f001/eeprom
+   -r--r--r-- 1 root root 8192 Apr  9 17:19 fake-design-for-testing-f002/eeprom
+   -r--r--r-- 1 root root 8192 Apr  9 17:19 fake-design-for-testing-f003/eeprom
+   -r--r--r-- 1 root root 8192 Apr  9 17:19 fmc-f004/eeprom
diff --git a/drivers/fmc/Kconfig b/drivers/fmc/Kconfig
index 7eacef9..2bb1953 100644
--- a/drivers/fmc/Kconfig
+++ b/drivers/fmc/Kconfig
@@ -32,4 +32,12 @@ config FMC_TRIVIAL
 	  The driver also handles interrupts (we used it with a real carrier
 	  before the mezzanines were produced)
 
+config FMC_WRITE_EEPROM
+	tristate "FMC mezzanine driver to write I2C EEPROM"
+	help
+	  This driver matches every mezzanine device and can write the
+	  internal EEPROM of the PCB, using the firmware loader to get
+	  its binary and the function carrier->reprogram to actually do it.
+	  It is useful when the mezzanines are produced.
+
 endif # FMC
diff --git a/drivers/fmc/Makefile b/drivers/fmc/Makefile
index 52624e6..13701fa 100644
--- a/drivers/fmc/Makefile
+++ b/drivers/fmc/Makefile
@@ -9,3 +9,4 @@ fmc-y += fmc-dump.o
 
 obj-$(CONFIG_FMC_FAKEDEV) += fmc-fakedev.o
 obj-$(CONFIG_FMC_TRIVIAL) += fmc-trivial.o
+obj-$(CONFIG_FMC_WRITE_EEPROM) += fmc-write-eeprom.o
diff --git a/drivers/fmc/fmc-write-eeprom.c b/drivers/fmc/fmc-write-eeprom.c
new file mode 100644
index 0000000..2cc680d
--- /dev/null
+++ b/drivers/fmc/fmc-write-eeprom.c
@@ -0,0 +1,176 @@
+/*
+ * Copyright (C) 2012 CERN (www.cern.ch)
+ * Author: Alessandro Rubini <rubini@gnudd.com>
+ *
+ * Released according to the GNU GPL, version 2 or any later version.
+ *
+ * This work is part of the White Rabbit project, a research effort led
+ * by CERN, the European Institute for Nuclear Research.
+ */
+#include <linux/module.h>
+#include <linux/string.h>
+#include <linux/firmware.h>
+#include <linux/init.h>
+#include <linux/fmc.h>
+#include <asm/unaligned.h>
+
+/*
+ * This module uses the firmware loader to program the whole or part
+ * of the FMC eeprom. The meat is in the _run functions.  However, no
+ * default file name is provided, to avoid accidental mishaps. Also,
+ * you must pass the busid argument
+ */
+static struct fmc_driver fwe_drv;
+
+FMC_PARAM_BUSID(fwe_drv);
+
+/* The "file=" is like the generic "gateware=" used elsewhere */
+static char *fwe_file[FMC_MAX_CARDS];
+static int fwe_file_n;
+module_param_array_named(file, fwe_file, charp, &fwe_file_n, 444);
+
+static int fwe_run_tlv(struct fmc_device *fmc, const struct firmware *fw,
+	int write)
+{
+	const uint8_t *p = fw->data;
+	int len = fw->size;
+	uint16_t thislen, thisaddr;
+	int err;
+
+	/* format is: 'w' addr16 len16 data... */
+	while (len > 5) {
+		thisaddr = get_unaligned_le16(p+1);
+		thislen = get_unaligned_le16(p+3);
+		if (p[0] != 'w' || thislen + 5 > len) {
+			dev_err(&fmc->dev, "invalid tlv at offset %ti\n",
+				p - fw->data);
+			return -EINVAL;
+		}
+		err = 0;
+		if (write) {
+			dev_info(&fmc->dev, "write %i bytes at 0x%04x\n",
+				 thislen, thisaddr);
+			err = fmc->op->write_ee(fmc, thisaddr, p + 5, thislen);
+		}
+		if (err < 0) {
+			dev_err(&fmc->dev, "write failure @0x%04x\n",
+				thisaddr);
+			return err;
+		}
+		p += 5 + thislen;
+		len -= 5 + thislen;
+	}
+	if (write)
+		dev_info(&fmc->dev, "write_eeprom: success\n");
+	return 0;
+}
+
+static int fwe_run_bin(struct fmc_device *fmc, const struct firmware *fw)
+{
+	int ret;
+
+	dev_info(&fmc->dev, "programming %zi bytes\n", fw->size);
+	ret = fmc->op->write_ee(fmc, 0, (void *)fw->data, fw->size);
+	if (ret < 0) {
+		dev_info(&fmc->dev, "write_eeprom: error %i\n", ret);
+		return ret;
+	}
+	dev_info(&fmc->dev, "write_eeprom: success\n");
+	return 0;
+}
+
+static int fwe_run(struct fmc_device *fmc, const struct firmware *fw, char *s)
+{
+	char *last4 = s + strlen(s) - 4;
+	int err;
+
+	if (!strcmp(last4, ".bin"))
+		return fwe_run_bin(fmc, fw);
+	if (!strcmp(last4, ".tlv")) {
+		err = fwe_run_tlv(fmc, fw, 0);
+		if (!err)
+			err = fwe_run_tlv(fmc, fw, 1);
+		return err;
+	}
+	dev_err(&fmc->dev, "invalid file name \"%s\"\n", s);
+	return -EINVAL;
+}
+
+/*
+ * Programming is done at probe time. Morever, only those listed with
+ * busid= are programmed.
+ * card is probed for, only one is programmed. Unfortunately, it's
+ * difficult to know in advance when probing the first card if others
+ * are there.
+ */
+int fwe_probe(struct fmc_device *fmc)
+{
+	int err, index = 0;
+	const struct firmware *fw;
+	struct device *dev = &fmc->dev;
+	char *s;
+
+	if (!fwe_drv.busid_n) {
+		dev_err(dev, "%s: no busid passed, refusing all cards\n",
+			KBUILD_MODNAME);
+		return -ENODEV;
+	}
+	if (fmc->op->validate)
+		index = fmc->op->validate(fmc, &fwe_drv);
+	if (index < 0) {
+		pr_err("%s: refusing device \"%s\"\n", KBUILD_MODNAME,
+		       dev_name(dev));
+		return -ENODEV;
+	}
+	if (index >= fwe_file_n) {
+		pr_err("%s: no filename for device index %i\n",
+			KBUILD_MODNAME, index);
+		return -ENODEV;
+	}
+	s = fwe_file[index];
+	if (!s) {
+		pr_err("%s: no filename for \"%s\" not programming\n",
+		       KBUILD_MODNAME, dev_name(dev));
+		return -ENOENT;
+	}
+	err = request_firmware(&fw, s, dev);
+	if (err < 0) {
+		dev_err(&fmc->dev, "request firmware \"%s\": error %i\n",
+			s, err);
+		return err;
+	}
+	fwe_run(fmc, fw, s);
+	release_firmware(fw);
+	return 0;
+}
+
+int fwe_remove(struct fmc_device *fmc)
+{
+	return 0;
+}
+
+static struct fmc_driver fwe_drv = {
+	.version = FMC_VERSION,
+	.driver.name = KBUILD_MODNAME,
+	.probe = fwe_probe,
+	.remove = fwe_remove,
+	/* no table, as the current match just matches everything */
+};
+
+static int fwe_init(void)
+{
+	int ret;
+
+	ret = fmc_driver_register(&fwe_drv);
+	return ret;
+}
+
+static void fwe_exit(void)
+{
+	fmc_driver_unregister(&fwe_drv);
+}
+
+module_init(fwe_init);
+module_exit(fwe_exit);
+
+MODULE_LICENSE("GPL");
-- 
1.7.7.2
