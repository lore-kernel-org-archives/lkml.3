Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946901Ab3BHSTb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 13:19:31 -0500
Received: from smtp2.infineon.com ([217.10.60.23]:10961 "EHLO
	smtp2.infineon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946722Ab3BHST2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 13:19:28 -0500
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Feb 2013 13:19:27 EST
X-SBRS: None
From: Peter Huewe <peter.huewe@infineon.com>
To: Kent Yoder <key@linux.vnet.ibm.com>
CC: <tpmdd-devel@lists.sourceforge.net>,
        <linux-security-module@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Peter Huewe <peter.huewe@infineon.com>
Subject: =?UTF-8?q?=5BPATCH=5D=20tpm=3A=20Add=20support=20for=20new=20Infineon=20I2C=20TPM=20=28SLB=209645=20TT=201=2E2=20I2C=29?=
Date: Fri, 8 Feb 2013 19:09:16 +0100
Message-ID: <1360346956-7920-1-git-send-email-peter.huewe@infineon.com>
X-Mailer: git-send-email 1.7.11.msysgit.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.29.170.139]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver adds support for Infineon's new SLB 9645 TT 1.2 I2C TPMs,
which supports clockstretching, combined reads and a bus speed of
up to 400khz. The device also has a new device id.

The driver works now also fine with device trees, so you can
instantiate your device by adding:
 +       tpm {
 +               compatible = "infineon,slb9645tt";
 +               reg = <0x20>;
 +       };
 for SLB 9645 devices or

 +       tpm {
 +               compatible = "infineon,slb9635tt";
 +               reg = <0x20>;
 +       };
 for SLB 9635 devices

to your device tree.
tpm_i2c_infineon is also retained as a compatible id as a fallback to
slb9635 protocol.

The driver was tested on Beaglebone.

Signed-off-by: Peter Huewe <peter.huewe@infineon.com>
---
Patch against Kent's tpmdd-02-05-13 branch

You might get an out-of-office reply, but I'm monitoring this email address nevertheless.
Thanks, Peter

 .../devicetree/bindings/i2c/trivial-devices.txt    |   2 +
 drivers/char/tpm/tpm_i2c_infineon.c                | 157 +++++++++++++++------
 2 files changed, 115 insertions(+), 44 deletions(-)

diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
index 446859f..ad6a738 100644
--- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
+++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
@@ -35,6 +35,8 @@ fsl,mc13892		MC13892: Power Management Integrated Circuit (PMIC) for i.MX35/51
 fsl,mma8450		MMA8450Q: Xtrinsic Low-power, 3-axis Xtrinsic Accelerometer
 fsl,mpr121		MPR121: Proximity Capacitive Touch Sensor Controller
 fsl,sgtl5000		SGTL5000: Ultra Low-Power Audio Codec
+infineon,slb9635tt	Infineon SLB9635 (Soft-) I2C TPM (old protocol, max 100khz)
+infineon,slb9645tt	Infineon SLB9645 I2C TPM (new protocol, max 400khz)
 maxim,ds1050		5 Bit Programmable, Pulse-Width Modulator
 maxim,max1237		Low-Power, 4-/12-Channel, 2-Wire Serial, 12-Bit ADCs
 maxim,max6625		9-Bit/12-Bit Temperature Sensors with I²C-Compatible Serial Interface
diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index 8fe7ac3..c4b3b9a 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (C) 2012 Infineon Technologies
+ * Copyright (C) 2012,2013 Infineon Technologies
  *
  * Authors:
  * Peter Huewe <peter.huewe@infineon.com>
@@ -56,13 +56,21 @@
 #define TPM_TIMEOUT_US_HI  (TPM_TIMEOUT_US_LOW + 2000)
 
 /* expected value for DIDVID register */
-#define TPM_TIS_I2C_DID_VID 0x000b15d1L
+#define TPM_TIS_I2C_DID_VID_9635 0xd1150b00L
+#define TPM_TIS_I2C_DID_VID_9645 0x001a15d1L
+
+enum i2c_chip_type {
+	SLB9635,
+	SLB9645,
+	UNKNOWN,
+};
 
 /* Structure to store I2C TPM specific stuff */
 struct tpm_inf_dev {
 	struct i2c_client *client;
 	u8 buf[TPM_BUFSIZE + sizeof(u8)]; /* max. buffer size + addr */
 	struct tpm_chip *chip;
+	enum i2c_chip_type chip_type;
 };
 
 static struct tpm_inf_dev tpm_dev;
@@ -89,11 +97,20 @@ static struct i2c_driver tpm_tis_i2c_driver;
  */
 static int iic_tpm_read(u8 addr, u8 *buffer, size_t len)
 {
+	struct i2c_msg msg1 = {
+		.addr = tpm_dev.client->addr,
+		.len = 1,
+		.buf = &addr,
+	};
+	struct i2c_msg msg2 = {
+		.addr = tpm_dev.client->addr,
+		.flags = I2C_M_RD,
+		.len = len,
+		.buf = buffer,
+	};
+	struct i2c_msg msgs[] = {msg1, msg2};
 
-	struct i2c_msg msg1 = { tpm_dev.client->addr, 0, 1, &addr };
-	struct i2c_msg msg2 = { tpm_dev.client->addr, I2C_M_RD, len, buffer };
-
-	int rc;
+	int rc = 0;
 	int count;
 
 	/* Lock the adapter for the duration of the whole sequence. */
@@ -101,30 +118,49 @@ static int iic_tpm_read(u8 addr, u8 *buffer, size_t len)
 		return -EOPNOTSUPP;
 	i2c_lock_adapter(tpm_dev.client->adapter);
 
-	for (count = 0; count < MAX_COUNT; count++) {
-		rc = __i2c_transfer(tpm_dev.client->adapter, &msg1, 1);
-		if (rc > 0)
-			break;	/* break here to skip sleep */
-
-		usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
-	}
-
-	if (rc <= 0)
-		goto out;
-
-	/* After the TPM has successfully received the register address it needs
-	 * some time, thus we're sleeping here again, before retrieving the data
-	 */
-	for (count = 0; count < MAX_COUNT; count++) {
-		usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
-		rc = __i2c_transfer(tpm_dev.client->adapter, &msg2, 1);
-		if (rc > 0)
-			break;
+	if (tpm_dev.chip_type == SLB9645) {
+		/* use a combined read for newer chips
+		 * unfortunately the smbus functions are not suitable due to
+		 * the 32 byte limit of the smbus.
+		 * retries should usually not be needed, but are kept just to
+		 * be on the safe side.
+		*/
+		for (count = 0; count < MAX_COUNT; count++) {
+			rc = __i2c_transfer(tpm_dev.client->adapter, msgs, 2);
+			if (rc > 0)
+				break;	/* break here to skip sleep */
+			usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
+		}
+	} else {
+		/* slb9635 protocol should work in all cases */
+		for (count = 0; count < MAX_COUNT; count++) {
+			rc = __i2c_transfer(tpm_dev.client->adapter, &msg1, 1);
+			if (rc > 0)
+				break;	/* break here to skip sleep */
+
+			usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
+		}
 
+		if (rc <= 0)
+			goto out;
+
+		/* After the TPM has successfully received the register address
+		 * it needs some time, thus we're sleeping here again, before
+		 * retrieving the data
+		 */
+		for (count = 0; count < MAX_COUNT; count++) {
+			usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
+			rc = __i2c_transfer(tpm_dev.client->adapter, &msg2, 1);
+			if (rc > 0)
+				break;
+		}
 	}
 
 out:
 	i2c_unlock_adapter(tpm_dev.client->adapter);
+	/* take care of 'guard time' */
+	usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
+
 	if (rc <= 0)
 		return -EIO;
 
@@ -138,7 +174,11 @@ static int iic_tpm_write_generic(u8 addr, u8 *buffer, size_t len,
 	int rc = -EIO;
 	int count;
 
-	struct i2c_msg msg1 = { tpm_dev.client->addr, 0, len + 1, tpm_dev.buf };
+	struct i2c_msg msg1 = {
+		.addr = tpm_dev.client->addr,
+		.len = len + 1,
+		.buf = tpm_dev.buf,
+	 };
 
 	if (len > TPM_BUFSIZE)
 		return -EINVAL;
@@ -154,16 +194,19 @@ static int iic_tpm_write_generic(u8 addr, u8 *buffer, size_t len,
 	/*
 	 * NOTE: We have to use these special mechanisms here and unfortunately
 	 * cannot rely on the standard behavior of i2c_transfer.
+	 * Even for newer chips the smbus functions are not
+	 * suitable due to the 32 byte limit of the smbus.
 	 */
 	for (count = 0; count < max_count; count++) {
 		rc = __i2c_transfer(tpm_dev.client->adapter, &msg1, 1);
 		if (rc > 0)
 			break;
-
 		usleep_range(sleep_low, sleep_hi);
 	}
 
 	i2c_unlock_adapter(tpm_dev.client->adapter);
+	/* take care of 'guard time' */
+	usleep_range(SLEEP_DURATION_LOW, SLEEP_DURATION_HI);
 	if (rc <= 0)
 		return -EIO;
 
@@ -283,11 +326,18 @@ static int request_locality(struct tpm_chip *chip, int loc)
 static u8 tpm_tis_i2c_status(struct tpm_chip *chip)
 {
 	/* NOTE: since I2C read may fail, return 0 in this case --> time-out */
-	u8 buf;
-	if (iic_tpm_read(TPM_STS(chip->vendor.locality), &buf, 1) < 0)
-		return 0;
-	else
-		return buf;
+	u8 buf = 0xFF;
+	u8 i = 0;
+
+	do {
+		if (iic_tpm_read(TPM_STS(chip->vendor.locality), &buf, 1) < 0)
+			return 0;
+
+		i++;
+	/* if locallity is set STS should not be 0xFF */
+	} while ((buf == 0xFF) && i < 10);
+
+	return buf;
 }
 
 static void tpm_tis_i2c_ready(struct tpm_chip *chip)
@@ -328,7 +378,7 @@ static int wait_for_stat(struct tpm_chip *chip, u8 mask, unsigned long timeout,
 
 	/* check current status */
 	*status = tpm_tis_i2c_status(chip);
-	if ((*status & mask) == mask)
+	if ((*status != 0xFF) && (*status & mask) == mask)
 		return 0;
 
 	stop = jiffies + timeout;
@@ -372,7 +422,6 @@ static int recv_data(struct tpm_chip *chip, u8 *buf, size_t count)
 		/* avoid endless loop in case of broken HW */
 		if (retries > MAX_COUNT_LONG)
 			return -EIO;
-
 	}
 	return size;
 }
@@ -480,7 +529,6 @@ static int tpm_tis_i2c_send(struct tpm_chip *chip, u8 *buf, size_t len)
 			rc = -EIO;
 			goto out_err;
 		}
-
 	}
 
 	/* write last byte */
@@ -568,6 +616,7 @@ static int tpm_tis_i2c_init(struct device *dev)
 
 	chip = tpm_register_hardware(dev, &tpm_tis_i2c);
 	if (!chip) {
+		dev_err(dev, "could not register hardware\n");
 		rc = -ENODEV;
 		goto out_err;
 	}
@@ -582,20 +631,24 @@ static int tpm_tis_i2c_init(struct device *dev)
 	chip->vendor.timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
 
 	if (request_locality(chip, 0) != 0) {
+		dev_err(dev, "could not request locality\n");
 		rc = -ENODEV;
 		goto out_vendor;
 	}
 
 	/* read four bytes from DID_VID register */
 	if (iic_tpm_read(TPM_DID_VID(0), (u8 *)&vendor, 4) < 0) {
+		dev_err(dev, "could not read vendor id\n");
 		rc = -EIO;
 		goto out_release;
 	}
 
-	/* create DID_VID register value, after swapping to little-endian */
-	vendor = be32_to_cpu((__be32) vendor);
-
-	if (vendor != TPM_TIS_I2C_DID_VID) {
+	if (vendor == TPM_TIS_I2C_DID_VID_9645) {
+		tpm_dev.chip_type = SLB9645;
+	} else if (vendor == TPM_TIS_I2C_DID_VID_9635) {
+		tpm_dev.chip_type = SLB9635;
+	} else {
+		dev_err(dev, "vendor id did not match! ID was %08x\n", vendor);
 		rc = -ENODEV;
 		goto out_release;
 	}
@@ -631,22 +684,38 @@ out_err:
 
 static const struct i2c_device_id tpm_tis_i2c_table[] = {
 	{"tpm_i2c_infineon", 0},
+	{"slb9635tt", 0},
+	{"slb9645tt", 1},
 	{},
 };
 
 MODULE_DEVICE_TABLE(i2c, tpm_tis_i2c_table);
+
+#ifdef CONFIG_OF
+static const struct of_device_id tpm_tis_i2c_of_match[] = {
+	{ .compatible = "infineon,tpm_i2c_infineon", .data = (void *)0 },
+	{ .compatible = "infineon,slb9635tt", .data = (void *)0 },
+	{ .compatible = "infineon,slb9645tt", .data = (void *)1 },
+	{},
+};
+MODULE_DEVICE_TABLE(of, tpm_tis_i2c_of_match);
+#endif
+
 static SIMPLE_DEV_PM_OPS(tpm_tis_i2c_ops, tpm_pm_suspend, tpm_pm_resume);
 
 static int tpm_tis_i2c_probe(struct i2c_client *client,
 			     const struct i2c_device_id *id)
 {
 	int rc;
-	if (tpm_dev.client != NULL)
+	struct device *dev = &(client->dev);
+
+	if (tpm_dev.client != NULL) {
+		dev_err(dev, "This driver only supports one client at a time\n");
 		return -EBUSY;	/* We only support one client */
+	}
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
-		dev_err(&client->dev,
-			"no algorithms associated to the i2c bus\n");
+		dev_err(dev, "no algorithms associated to the i2c bus\n");
 		return -ENODEV;
 	}
 
@@ -682,7 +751,6 @@ static int tpm_tis_i2c_remove(struct i2c_client *client)
 }
 
 static struct i2c_driver tpm_tis_i2c_driver = {
-
 	.id_table = tpm_tis_i2c_table,
 	.probe = tpm_tis_i2c_probe,
 	.remove = tpm_tis_i2c_remove,
@@ -690,11 +758,12 @@ static struct i2c_driver tpm_tis_i2c_driver = {
 		   .name = "tpm_i2c_infineon",
 		   .owner = THIS_MODULE,
 		   .pm = &tpm_tis_i2c_ops,
+		   .of_match_table = of_match_ptr(tpm_tis_i2c_of_match),
 		   },
 };
 
 module_i2c_driver(tpm_tis_i2c_driver);
 MODULE_AUTHOR("Peter Huewe <peter.huewe@infineon.com>");
 MODULE_DESCRIPTION("TPM TIS I2C Infineon Driver");
-MODULE_VERSION("2.1.5");
+MODULE_VERSION("2.2.0");
 MODULE_LICENSE("GPL");
-- 
1.7.11.msysgit.0

