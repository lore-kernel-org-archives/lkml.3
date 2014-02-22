Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751640AbaBVIL1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 03:11:27 -0500
Received: from relaygw2-3.mclink.it ([213.21.178.138]:58546 "EHLO
	relaygw2-3.mclink.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750965AbaBVILZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 03:11:25 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar0FAGtbCFNNK3Ai/2dsb2JhbABagwY7qzcBlnQWdIJTEy0JCRGBQAmIAAEIyxKNeCOFCASUSYNrkieDLjuBLQgX
Date: Sat, 22 Feb 2014 09:11:12 +0100
From: Alessandro Rubini <rubini@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: Juan David Gonzalez Cobas <juan.david.gonzalez.cobas@cern.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 1/2] FMC: make eeprom attribute writable
Message-ID: <70259a54ccd97ec3c1013291ca58e52e4249b882.1393056460.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows easier modification to the eeprom than loading the
fmc-write-eeprom module.  The carrier driver will refuse writing if
the FPGA is not running the golden gateware image, so writing in
practice is only available at manufacture/development time.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Acked-by: Juan David Gonzalez Cobas <dcobas@cern.ch>
---
 Documentation/fmc/fmc-write-eeprom.txt |   77 ++++++++++---------------------
 drivers/fmc/fmc-core.c                 |   15 ++++++-
 2 files changed, 39 insertions(+), 53 deletions(-)

diff --git a/Documentation/fmc/fmc-write-eeprom.txt b/Documentation/fmc/fmc-write-eeprom.txt
index 44a3bc6..e0a9712 100644
--- a/Documentation/fmc/fmc-write-eeprom.txt
+++ b/Documentation/fmc/fmc-write-eeprom.txt
@@ -9,7 +9,12 @@ Overwriting the EEPROM is not something you should do daily, and it is
 expected to only happen during manufacturing. For this reason, the
 module makes it unlikely for the random user to change a working EEPROM.
 
-The module takes the following measures:
+However, since the EEPROM may include application-specific information
+other than the identification, later versions of this packages added
+write-support through sysfs. See *note Accessing the EEPROM::.
+
+To avoid damaging the EEPROM content, the module takes the following
+measures:
 
    * It accepts a `file=' argument (within /lib/firmware) and if no
      such argument is received, it doesn't write anything to EEPROM
@@ -70,56 +75,24 @@ first time.
         [  132.899872]  fake-fmc: Product name: FmcDelay1ns4cha
 
 
-Writing to the EEPROM
+Accessing the EEPROM
 =====================
 
-Once you have created a binary file for your EEPROM, you can write it
-to the storage medium using the fmc-write-eeprom (See *note
-fmc-write-eeprom::, while relying on a carrier driver.  The procedure
-here shown here uses the SPEC driver
-(`http://www.ohwr.org/projects/spec-sw').
-
-The example assumes no driver is already loaded (actually, I unloaded
-them by hand as everything loads automatically at boot time after you
-installed the modules), and shows kernel messages together with
-commands. Here the prompt is spusa.root# and two SPEC cards are plugged
-in the system.
-
-     spusa.root# insmod fmc.ko
-     spusa.root# insmod spec.ko
-     [13972.382818] spec 0000:02:00.0:  probe for device 0002:0000
-     [13972.392773] spec 0000:02:00.0: got file "fmc/spec-init.bin", 1484404 (0x16a674) bytes
-     [13972.591388] spec 0000:02:00.0: FPGA programming successful
-     [13972.883011] spec 0000:02:00.0: EEPROM has no FRU information
-     [13972.888719] spec 0000:02:00.0: No device_id filled, using index
-     [13972.894676] spec 0000:02:00.0: No mezzanine_name found
-     [13972.899863] /home/rubini/wip/spec-sw/kernel/spec-gpio.c - spec_gpio_init
-     [13972.906578] spec 0000:04:00.0:  probe for device 0004:0000
-     [13972.916509] spec 0000:04:00.0: got file "fmc/spec-init.bin", 1484404 (0x16a674) bytes
-     [13973.115096] spec 0000:04:00.0: FPGA programming successful
-     [13973.401798] spec 0000:04:00.0: EEPROM has no FRU information
-     [13973.407474] spec 0000:04:00.0: No device_id filled, using index
-     [13973.413417] spec 0000:04:00.0: No mezzanine_name found
-     [13973.418600] /home/rubini/wip/spec-sw/kernel/spec-gpio.c - spec_gpio_init
-     spusa.root# ls /sys/bus/fmc/devices
-     fmc-0000  fmc-0001
-     spusa.root# insmod fmc-write-eeprom.ko busid=0x0200 file=fdelay-eeprom.bin
-     [14103.966259] spec 0000:02:00.0: Matching an generic driver (no ID)
-     [14103.975519] spec 0000:02:00.0: programming 6155 bytes
-     [14126.373762] spec 0000:02:00.0: write_eeprom: success
-     [14126.378770] spec 0000:04:00.0: Matching an generic driver (no ID)
-     [14126.384903] spec 0000:04:00.0: fmc_write_eeprom: no filename given: not programming
-     [14126.392600] fmc_write_eeprom: probe of fmc-0001 failed with error -2
-
-Reading back the EEPROM
-=======================
-
-In order to read back the binary content of the EEPROM of your
-mezzanine device, the bus creates a read-only sysfs file called eeprom
-for each mezzanine it knows about:
-
-   spusa.root# cd /sys/bus/fmc/devices; ls -l */eeprom
-   -r--r--r-- 1 root root 8192 Apr  9 16:53 FmcDelay1ns4cha-f001/eeprom
-   -r--r--r-- 1 root root 8192 Apr  9 17:19 fake-design-for-testing-f002/eeprom
-   -r--r--r-- 1 root root 8192 Apr  9 17:19 fake-design-for-testing-f003/eeprom
-   -r--r--r-- 1 root root 8192 Apr  9 17:19 fmc-f004/eeprom
+The bus creates a sysfs binary file called eeprom for each mezzanine it
+knows about:
+
+        spusa.root# cd /sys/bus/fmc/devices; ls -l */eeprom
+        -r--r--r-- 1 root root 8192 Feb 21 12:30 FmcAdc100m14b4cha-0800/eeprom
+        -r--r--r-- 1 root root 8192 Feb 21 12:30 FmcDelay1ns4cha-0200/eeprom
+        -r--r--r-- 1 root root 8192 Feb 21 12:30 FmcDio5cha-0400/eeprom
+
+Everybody can read the files and the superuser can also modify it, but
+the operation may on the carrier driver, if the carrier is unable to
+access the I2C bus.  For example, the spec driver can access the bus
+only with its golden gateware: after a mezzanine driver reprogrammed
+the FPGA with a custom circuit, the carrier is unable to access the
+EEPROM and returns ENOTSUPP.
+
+An alternative way to write the EEPROM is the mezzanine driver
+fmc-write-eeprom (See *note fmc-write-eeprom::), but the procedure is
+more complex.
diff --git a/drivers/fmc/fmc-core.c b/drivers/fmc/fmc-core.c
index 5a5e616..353fc54 100644
--- a/drivers/fmc/fmc-core.c
+++ b/drivers/fmc/fmc-core.c
@@ -99,10 +99,23 @@ static ssize_t fmc_read_eeprom(struct file *file, struct kobject *kobj,
 	return count;
 }
 
+static ssize_t fmc_write_eeprom(struct file *file, struct kobject *kobj,
+				struct bin_attribute *bin_attr,
+				char *buf, loff_t off, size_t count)
+{
+	struct device *dev;
+	struct fmc_device *fmc;
+
+	dev = container_of(kobj, struct device, kobj);
+	fmc = container_of(dev, struct fmc_device, dev);
+	return fmc->op->write_ee(fmc, off, buf, count);
+}
+
 static struct bin_attribute fmc_eeprom_attr = {
-	.attr = { .name = "eeprom", .mode = S_IRUGO, },
+	.attr = { .name = "eeprom", .mode = S_IRUGO | S_IWUSR, },
 	.size = 8192, /* more or less standard */
 	.read = fmc_read_eeprom,
+	.write = fmc_write_eeprom,
 };
 
 /*
-- 
1.7.7.2
