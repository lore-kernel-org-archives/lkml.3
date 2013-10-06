Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab3JFTbl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 15:31:41 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:60940 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754283Ab3JFTbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 15:31:40 -0400
Date: Sun, 6 Oct 2013 13:31:20 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Ashley Lai <ashley@ashleylai.com>
Cc: Peter H?we <PeterHuewe@gmx.de>, tpmdd-devel@lists.sourceforge.net,
        Leonidas Da Silva Barbosa <leosilva@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Rajiv Andrade <mail@srajiv.net>,
        Sirrix AG <tpmdd@sirrix.com>
Subject: TPM patches for 2.13
Message-ID: <20131006193120.GA26137@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've prepared this branch:

https://github.com/jgunthorpe/linux/commits/for-tpm
dd783708a8c6fd713c784be68fcbcb7000c43c49

Jason Gunthorpe (11):
      tpm: ibmvtpm: Use %zd formatting for size_t format arguments
      tpm atmel: Call request_region with the correct base
      tpm: Store devname in the tpm_chip
      tpm: Use container_of to locate the tpm_chip in tpm_open
      tpm: Remove redundant dev_set_drvdata
      tpm: st33: Remove chip->data_buffer access from this driver
      tpm: Remove tpm_show_caps_1_2
      tpm: Rename tpm.c to tpm-interface.c
      tpm: Merge the tpm-bios module with tpm.o
      tpm: Add support for the Nuvoton NPCT501 I2C TPM
      tpm: Add support for Atmel I2C TPMs

Which contains the first half of the clean-up patches and my two
drivers. The cleanups are well ack'd now, and I've done quite a bit of
testing with the two drivers, so I'd like to see agreement that this
batch can move forward as a series, and the other patches can sit
ontop of this series.

I will post the two new patches to the list, the others are not really
changed from prior postings except the commit comments are revised to
reflect acks/etc. Please advise if people would like to see this whole
series posted again.

I've prepared a 2nd branch:

https://github.com/jgunthorpe/linux/commits/tpm-devel
bba72a2e956230af28a7a448f25b4b1076559b40

Jason Gunthorpe:
      TPM: STMicroelectronics st33 driver SPI
      tpm: Pull everything related to /dev/tpmX into tpm-dev.c
      tpm: Pull everything related to sysfs into tpm-sysfs.c
      tpm: Create a tpm_class_ops structure and use it in the drivers
      tpm: Use the ops structure instead of a copy in tpm_vendor_specific
      tpm: Make tpm-dev allocate a per-file structure

Which contains the clean up patches that have not yet had any Acks,
rebased ontop of for-tpm

For reference, here is a top level diff of all source changes relative
to my last posting:

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 2c876a9..2c23374 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -1,14 +1,15 @@
 #
 # Makefile for the kernel tpm device drivers.
 #
-obj-$(CONFIG_TCG_TPM) += tpm.o tpm-dev.o tpm-sysfs.o
+obj-$(CONFIG_TCG_TPM) += tpm.o
+tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o
+tpm-$(CONFIG_ACPI) += tpm_ppi.o
+
 ifdef CONFIG_ACPI
-	obj-$(CONFIG_TCG_TPM) += tpm_bios.o
-	tpm_bios-objs += tpm_eventlog.o tpm_acpi.o tpm_ppi.o
+	tpm-y += tpm_eventlog.o tpm_acpi.o
 else
 ifdef CONFIG_TCG_IBMVTPM
-	obj-$(CONFIG_TCG_TPM) += tpm_bios.o
-	tpm_bios-objs += tpm_eventlog.o tpm_of.o
+	tpm-y += tpm_eventlog.o tpm_of.o
 endif
 endif
 obj-$(CONFIG_TCG_TIS) += tpm_tis.o
diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm-interface.c
similarity index 100%
rename from drivers/char/tpm/tpm.c
rename to drivers/char/tpm/tpm-interface.c
diff --git a/drivers/char/tpm/tpm_eventlog.c b/drivers/char/tpm/tpm_eventlog.c
index 84ddc55..59f7cb2 100644
--- a/drivers/char/tpm/tpm_eventlog.c
+++ b/drivers/char/tpm/tpm_eventlog.c
@@ -406,7 +406,6 @@ out_tpm:
 out:
 	return NULL;
 }
-EXPORT_SYMBOL_GPL(tpm_bios_log_setup);
 
 void tpm_bios_log_teardown(struct dentry **lst)
 {
@@ -415,5 +414,3 @@ void tpm_bios_log_teardown(struct dentry **lst)
 	for (i = 0; i < 3; i++)
 		securityfs_remove(lst[i]);
 }
-EXPORT_SYMBOL_GPL(tpm_bios_log_teardown);
-MODULE_LICENSE("GPL");
diff --git a/drivers/char/tpm/tpm_i2c_atmel.c b/drivers/char/tpm/tpm_i2c_atmel.c
index ecdd32a..7576abc 100644
--- a/drivers/char/tpm/tpm_i2c_atmel.c
+++ b/drivers/char/tpm/tpm_i2c_atmel.c
@@ -74,7 +74,7 @@ static int i2c_atmel_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 	struct i2c_client *client = to_i2c_client(chip->dev);
 	struct tpm_output_header *hdr =
 		(struct tpm_output_header *)priv->buffer;
-	unsigned int expected_len;
+	u32 expected_len;
 	int rc;
 
 	if (priv->len == 0)
@@ -89,7 +89,7 @@ static int i2c_atmel_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 
 	if (priv->len >= expected_len) {
 		dev_dbg(chip->dev,
-			"%s early(buf=%*ph count=%0zx) -> ret=%zd\n", __func__,
+			"%s early(buf=%*ph count=%0zx) -> ret=%d\n", __func__,
 			(int)min_t(size_t, 64, expected_len), buf, count,
 			expected_len);
 		memcpy(buf, priv->buffer, expected_len);
@@ -98,7 +98,7 @@ static int i2c_atmel_recv(struct tpm_chip *chip, u8 *buf, size_t count)
 
 	rc = i2c_master_recv(client, buf, expected_len);
 	dev_dbg(chip->dev,
-		"%s reread(buf=%*ph count=%0zx) -> ret=%zd\n", __func__,
+		"%s reread(buf=%*ph count=%0zx) -> ret=%d\n", __func__,
 		(int)min_t(size_t, 64, expected_len), buf, count,
 		expected_len);
 	return rc;
diff --git a/drivers/char/tpm/tpm_ppi.c b/drivers/char/tpm/tpm_ppi.c
index 2168d15..8e562dc 100644
--- a/drivers/char/tpm/tpm_ppi.c
+++ b/drivers/char/tpm/tpm_ppi.c
@@ -452,12 +452,8 @@ int tpm_add_ppi(struct kobject *parent)
 {
 	return sysfs_create_group(parent, &ppi_attr_grp);
 }
-EXPORT_SYMBOL_GPL(tpm_add_ppi);
 
 void tpm_remove_ppi(struct kobject *parent)
 {
 	sysfs_remove_group(parent, &ppi_attr_grp);
 }
-EXPORT_SYMBOL_GPL(tpm_remove_ppi);
-
-MODULE_LICENSE("GPL");
diff --git a/drivers/char/tpm/tpm_spi_stm_st33.c b/drivers/char/tpm/tpm_spi_stm_st33.c
index 81c61f6..3060d57 100644
--- a/drivers/char/tpm/tpm_spi_stm_st33.c
+++ b/drivers/char/tpm/tpm_spi_stm_st33.c
@@ -743,7 +743,6 @@ tpm_st33_spi_probe(struct spi_device *dev)
 
 	tpm_get_timeouts(chip);
 
-	/* attach chip datas to client */
 	platform_data->bchipf = false;
 
 	pr_info("TPM SPI Initialized\n");
diff --git a/include/linux/tpm.h b/include/linux/tpm.h
index a14bf63..fff1d09 100644
--- a/include/linux/tpm.h
+++ b/include/linux/tpm.h
@@ -41,9 +41,6 @@ struct tpm_class_ops {
 	u8 (*status) (struct tpm_chip *chip);
 };
 
-struct tpm_chip *tpmm_alloc_dev(struct device *dev,
-				const struct tpm_class_ops *ops);
-
 #if defined(CONFIG_TCG_TPM) || defined(CONFIG_TCG_TPM_MODULE)
 
 extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
