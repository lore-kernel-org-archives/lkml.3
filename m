Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751438AbaK2Get (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 01:34:49 -0500
Received: from mail-by2on0147.outbound.protection.outlook.com ([207.46.100.147]:28112
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750995AbaK2Ger convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 01:34:47 -0500
X-Greylist: delayed 50064 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Nov 2014 01:34:47 EST
From: Muthu Mani <muth@cypress.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>, <gregkh@linuxfoundation.org>,
        Johan Hovold <johan@kernel.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, <linux-gpio@vger.kernel.org>,
        Muthu Mani <muth@cypress.com>, Rajaram Regupathy <rera@cypress.com>
Subject: [PATCH v4 2/3] i2c: add support for Cypress CYUSBS234 USB-I2C adapter
Date: Sat, 29 Nov 2014 11:49:46 +0530
Message-ID: <1417241986-17841-1-git-send-email-muth@cypress.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Originating-IP: [121.243.89.10]
X-ClientProxiedBy: HKXPR03CA0060.apcprd03.prod.outlook.com (10.141.129.50) To
 BN1PR06MB069.namprd06.prod.outlook.com (10.242.211.11)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB069;
Content-Transfer-Encoding: 7BIT
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB069;
X-Forefront-PRVS: 041032FF37
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(199003)(51164003)(189002)(46102003)(62966003)(77156002)(21056001)(101416001)(15202345003)(50986999)(97736003)(15975445006)(20776003)(47776003)(102836001)(48376002)(19580405001)(31966008)(66066001)(104166001)(19580395003)(64706001)(50466002)(106356001)(120916001)(42186005)(87286001)(92566001)(92726001)(95666004)(93916002)(99396003)(86362001)(107046002)(229853001)(122386002)(40100003)(4396001)(50226001)(36756003)(33646002)(88136002)(87976001)(89996001)(105586002)(77096004)(21314002)(2101003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR06MB069;H:prji-Latitude-E6420.india.cypress.com;FPR:;SPF:None;MLV:sfv;PTR:InfoNoRecords;A:1;MX:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR06MB069;
X-OriginatorOrg: cypress.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for USB-I2C interface of Cypress Semiconductor
CYUSBS234 USB-Serial Bridge controller.

The read/write operation is setup using vendor command through control endpoint
and actual data transfer happens through bulk in/out endpoints.

Details about the device can be found at:
http://www.cypress.com/?rID=84126

Signed-off-by: Muthu Mani <muth@cypress.com>
Signed-off-by: Rajaram Regupathy <rera@cypress.com>
---
Changes since v3:
* corrected typo

Changes since v2:
* Retrieved the i2c transfer status using interrupt in endpoint
* Used kstrtol instead of manually parsing and scnprintf instead of sprintf
* Given i2c adapter device for dev_xxx
* cleaned up the code

Changes since v1:
* allocated memory on heap for usb transfer data
* Used DEVICE_ATTR_xx and friends and attribute groups
* Added the device files under i2c-adapter rather than platform device

 drivers/i2c/busses/Kconfig         |  12 +
 drivers/i2c/busses/Makefile        |   1 +
 drivers/i2c/busses/i2c-cyusbs23x.c | 584 +++++++++++++++++++++++++++++++++++++
 3 files changed, 597 insertions(+)
 create mode 100644 drivers/i2c/busses/i2c-cyusbs23x.c

diff --git a/drivers/i2c/busses/Kconfig b/drivers/i2c/busses/Kconfig
index 917c358..533bdda 100644
--- a/drivers/i2c/busses/Kconfig
+++ b/drivers/i2c/busses/Kconfig
@@ -871,6 +871,18 @@ config I2C_RCAR

 comment "External I2C/SMBus adapter drivers"

+config I2C_CYUSBS23X
+       tristate "CYUSBS23x I2C adapter"
+       depends on MFD_CYUSBS23X && USB
+       help
+         Say yes if you would like to access Cypress CYUSBS23x I2C device.
+
+         This driver enables the I2C interface of CYUSBS23x USB Serial Bridge
+         controller.
+
+         This driver can also be built as a module. If so, the module will be
+         called i2c-cyusbs23x.
+
 config I2C_DIOLAN_U2C
        tristate "Diolan U2C-12 USB adapter"
        depends on USB
diff --git a/drivers/i2c/busses/Makefile b/drivers/i2c/busses/Makefile
index 78d56c5..3199908 100644
--- a/drivers/i2c/busses/Makefile
+++ b/drivers/i2c/busses/Makefile
@@ -86,6 +86,7 @@ obj-$(CONFIG_I2C_XLR)         += i2c-xlr.o
 obj-$(CONFIG_I2C_RCAR)         += i2c-rcar.o

 # External I2C/SMBus adapter drivers
+obj-$(CONFIG_I2C_CYUSBS23X)    += i2c-cyusbs23x.o
 obj-$(CONFIG_I2C_DIOLAN_U2C)   += i2c-diolan-u2c.o
 obj-$(CONFIG_I2C_PARPORT)      += i2c-parport.o
 obj-$(CONFIG_I2C_PARPORT_LIGHT)        += i2c-parport-light.o
diff --git a/drivers/i2c/busses/i2c-cyusbs23x.c b/drivers/i2c/busses/i2c-cyusbs23x.c
new file mode 100644
index 0000000..4bae6d0
--- /dev/null
+++ b/drivers/i2c/busses/i2c-cyusbs23x.c
@@ -0,0 +1,584 @@
+/*
+ * I2C subdriver for Cypress CYUSBS234 USB-Serial Bridge controller.
+ * Details about the device can be found at:
+ *    http://www.cypress.com/?rID=84126
+ *
+ * Copyright (c) 2014 Cypress Semiconductor Corporation.
+ *
+ * Author:
+ *   Rajaram Regupathy <rera@cypress.com>
+ *
+ * Additional contributors include:
+ *   Muthu Mani <muth@cypress.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+/*
+ * It exposes sysfs entries under the i2c adapter for getting the i2c transfer
+ * status, reset i2c read/write module, get/set nak and stop bits.
+ */
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/mutex.h>
+#include <linux/platform_device.h>
+
+#include <linux/usb.h>
+#include <linux/i2c.h>
+
+#include <linux/mfd/cyusbs23x.h>
+
+enum cy_i2c_io_mode {
+       CY_I2C_MODE_READ         = 0,
+       CY_I2C_MODE_WRITE        = 1
+};
+
+#define CY_I2C_XFER_STATUS_LEN     3
+
+struct cyusbs_i2c_config {
+       /* Frequency of operation. Only valid values are 100KHz and 400KHz */
+       u32 frequency;
+       u8 slave_addr;        /* Slave address to be used when in slave mode */
+       u8 is_msb_first;      /* Whether to transmit MSB first */
+       /*
+        * Whether block is configured as a master:
+        * 1 - The block functions as I2C master;
+        * 0 - The block functions as I2C slave
+        */
+       u8 is_master;
+       u8 s_ignore;          /* Ignore general call in slave mode */
+       /* Whether to stretch clock in case of no FIFO availability */
+       u8 clock_stretch;
+       /* Whether to loop back TX data to RX. Valid only for debug purposes */
+       u8 is_loopback;
+       u8 reserved[6];       /* Reserved for future use */
+} __packed;
+
+struct cyusbs_i2c {
+       struct i2c_adapter i2c_adapter;
+       struct cyusbs_i2c_config *i2c_config;
+       struct mutex lock;
+
+       bool is_stop_bit;     /* set the stop bit for i2c transfer */
+       bool is_nak_bit;      /* set the nak bit for i2c transfer */
+};
+
+#define to_cyusbs_i2c(a) container_of(a, struct cyusbs_i2c, i2c_adapter)
+
+static int cy_i2c_get_status(struct i2c_adapter *adapter, u8 *buf, u16 mode);
+static int cy_i2c_reset(struct i2c_adapter *adapter, u16 mode);
+
+static ssize_t i2c_read_status_show(struct device *d,
+                                   struct device_attribute *attr, char *buf)
+{
+       struct i2c_adapter *adapter = to_i2c_adapter(d);
+
+       /* Updates buffer with 3 bytes status (hex data) */
+       return cy_i2c_get_status(adapter, buf, CY_I2C_MODE_READ);
+}
+
+static ssize_t i2c_write_status_show(struct device *d,
+                                    struct device_attribute *attr, char *buf)
+{
+       struct i2c_adapter *adapter = to_i2c_adapter(d);
+
+       /* Updates buffer with 3 bytes status (hex data) */
+       return cy_i2c_get_status(adapter, buf, CY_I2C_MODE_WRITE);
+}
+
+static ssize_t i2c_read_reset_store(struct device *d,
+                                struct device_attribute *attr,
+                                const char *buf, size_t count)
+{
+       int ret;
+       long value;
+       struct i2c_adapter *adapter = to_i2c_adapter(d);
+
+       ret = kstrtol(buf, 0, &value);
+       if (ret)
+               return ret;
+
+       if (value != 1)
+               return -EINVAL;
+
+       ret = cy_i2c_reset(adapter, CY_I2C_MODE_READ);
+       if (!ret)
+               ret = count;
+
+       return ret;
+}
+
+static ssize_t i2c_write_reset_store(struct device *d,
+                                 struct device_attribute *attr,
+                                 const char *buf, size_t count)
+{
+       int ret;
+       long value;
+       struct i2c_adapter *adapter = to_i2c_adapter(d);
+
+       ret = kstrtol(buf, 0, &value);
+       if (ret)
+               return ret;
+
+       if (value != 1)
+               return -EINVAL;
+
+       ret = cy_i2c_reset(adapter, CY_I2C_MODE_WRITE);
+       if (!ret)
+               ret = count;
+
+       return ret;
+}
+
+static ssize_t is_stop_bit_show(struct device *d,
+                               struct device_attribute *attr, char *buf)
+{
+       struct i2c_adapter *adapter = to_i2c_adapter(d);
+       struct cyusbs_i2c *cy_i2c = to_cyusbs_i2c(adapter);
+
+       return scnprintf(buf, 3, "%d\n", cy_i2c->is_stop_bit);
+}
+
+static ssize_t is_stop_bit_store(struct device *d,
+                                struct device_attribute *attr,
+                                const char *buf, size_t count)
+{
+       struct i2c_adapter *adapter = to_i2c_adapter(d);
+       struct cyusbs_i2c *cy_i2c = to_cyusbs_i2c(adapter);
+       long value;
+       int ret;
+
+       ret = kstrtol(buf, 0, &value);
+       if (ret)
+               return ret;
+
+       if (value != 0 && value != 1)
+               return -EINVAL;
+
+       cy_i2c->is_stop_bit = (bool)value;
+
+       return count;
+}
+
+static ssize_t is_nak_bit_show(struct device *d,
+                              struct device_attribute *attr, char *buf)
+{
+       struct i2c_adapter *adapter = to_i2c_adapter(d);
+       struct cyusbs_i2c *cy_i2c = to_cyusbs_i2c(adapter);
+
+       return scnprintf(buf, 3, "%d\n", cy_i2c->is_nak_bit);
+}
+
+static ssize_t is_nak_bit_store(struct device *d,
+                               struct device_attribute *attr,
+                               const char *buf, size_t count)
+{
+       struct i2c_adapter *adapter = to_i2c_adapter(d);
+       struct cyusbs_i2c *cy_i2c = to_cyusbs_i2c(adapter);
+       long value;
+       int ret;
+
+       ret = kstrtol(buf, 0, &value);
+       if (ret)
+               return ret;
+
+       if (value != 0 && value != 1)
+               return -EINVAL;
+
+       cy_i2c->is_nak_bit = (bool)value;
+
+       return count;
+}
+
+static DEVICE_ATTR_RO(i2c_read_status);
+static DEVICE_ATTR_RO(i2c_write_status);
+static DEVICE_ATTR_WO(i2c_read_reset);
+static DEVICE_ATTR_WO(i2c_write_reset);
+static DEVICE_ATTR_RW(is_stop_bit);
+static DEVICE_ATTR_RW(is_nak_bit);
+
+static struct attribute *cyusbs_i2c_device_attrs[] = {
+       &dev_attr_i2c_read_status.attr,
+       &dev_attr_i2c_write_status.attr,
+       &dev_attr_i2c_read_reset.attr,
+       &dev_attr_i2c_write_reset.attr,
+       &dev_attr_is_stop_bit.attr,
+       &dev_attr_is_nak_bit.attr,
+       NULL
+};
+
+ATTRIBUTE_GROUPS(cyusbs_i2c_device);
+
+static int cy_i2c_get_status(struct i2c_adapter *adapter, u8 *buf, u16 mode)
+{
+       int ret;
+       u16 wIndex, wValue, scb_index;
+       u8 *data;
+       struct cyusbs23x *cyusbs = (struct cyusbs23x *)adapter->algo_data;
+       struct cyusbs_i2c *cy_i2c = to_cyusbs_i2c(adapter);
+
+       scb_index = cyusbs->intf_num & 0x01;
+       wValue = ((scb_index << CY_SCB_INDEX_SHIFT) | mode);
+       wIndex = 0;
+       data = kmalloc(CY_I2C_XFER_STATUS_LEN, GFP_KERNEL);
+       if (data == NULL)
+               return -ENOMEM;
+
+       mutex_lock(&cy_i2c->lock);
+       /* read the i2c transfer status */
+       ret = usb_control_msg(cyusbs->usb_dev,
+                       usb_rcvctrlpipe(cyusbs->usb_dev, 0),
+                       CY_I2C_GET_STATUS_CMD,
+                       USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
+                       wValue, wIndex, data, CY_I2C_XFER_STATUS_LEN,
+                       CY_USBS_CTRL_XFER_TIMEOUT);
+       mutex_unlock(&cy_i2c->lock);
+       if (ret != CY_I2C_XFER_STATUS_LEN) {
+               dev_err(&adapter->dev, "%s: failed to get status: %d",
+                       __func__, ret);
+               ret = usb_translate_errors(ret);
+               goto status_error;
+       }
+
+       memcpy(buf, data, CY_I2C_XFER_STATUS_LEN);
+       buf[CY_I2C_XFER_STATUS_LEN] = 0;
+
+       dev_dbg(&adapter->dev, "%s: %02x %02x %02x\n", __func__,
+               buf[0], buf[1], buf[2]);
+
+status_error:
+       kfree(data);
+       return ret;
+}
+
+static int cy_i2c_reset(struct i2c_adapter *adapter, u16 mode)
+{
+       int ret;
+       u16 wIndex, wValue, scb_index;
+       struct cyusbs23x *cyusbs = (struct cyusbs23x *)adapter->algo_data;
+       struct cyusbs_i2c *cy_i2c = to_cyusbs_i2c(adapter);
+
+       scb_index = cyusbs->intf_num & 0x01;
+       wValue = ((scb_index << CY_SCB_INDEX_SHIFT) | mode);
+       wIndex = 0;
+
+       mutex_lock(&cy_i2c->lock);
+       ret = usb_control_msg(cyusbs->usb_dev,
+                       usb_sndctrlpipe(cyusbs->usb_dev, 0),
+                       CY_I2C_RESET_CMD,
+                       USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
+                       wValue, wIndex, NULL, 0, CY_USBS_CTRL_XFER_TIMEOUT);
+       mutex_unlock(&cy_i2c->lock);
+       if (ret) {
+               dev_err(&adapter->dev, "%s: failed to reset: %d",
+                       __func__, ret);
+               ret = usb_translate_errors(ret);
+       }
+
+       return ret;
+}
+
+static int cy_i2c_recv_status(struct i2c_adapter *adapter)
+{
+       int ret, actual_len;
+       u8 *data;
+       struct cyusbs23x *cyusbs = (struct cyusbs23x *)adapter->algo_data;
+
+       data = kmalloc(CY_I2C_XFER_STATUS_LEN, GFP_KERNEL);
+       if (data == NULL)
+               return -ENOMEM;
+
+       /* read the i2c transfer status */
+       ret = usb_interrupt_msg(cyusbs->usb_dev,
+                       usb_rcvintpipe(cyusbs->usb_dev, cyusbs->intr_in_ep_num),
+                       data, CY_I2C_XFER_STATUS_LEN, &actual_len,
+                       CY_USBS_INTR_XFER_TIMEOUT);
+       if (ret < 0) {
+               dev_err(&adapter->dev,
+                       "Failed to read from interrupt ep: %d\n", ret);
+               ret = usb_translate_errors(ret);
+               goto intr_ep_error;
+       }
+
+       dev_dbg(&adapter->dev, "%s: %02x %02x %02x\n", __func__,
+               data[0], data[1], data[2]);
+
+       if (data[0] & 0x1)
+               ret = -ETIMEDOUT;
+
+intr_ep_error:
+       kfree(data);
+       return ret;
+}
+
+static int cy_get_i2c_config(struct cyusbs23x *cyusbs,
+                               struct cyusbs_i2c *cy_i2c)
+{
+       int ret;
+       u16 scb_index;
+
+       scb_index = (cyusbs->intf_num & 0x01) << CY_SCB_INDEX_SHIFT;
+
+       ret = usb_control_msg(cyusbs->usb_dev,
+                       usb_rcvctrlpipe(cyusbs->usb_dev, 0),
+                       CY_I2C_GET_CONFIG_CMD,
+                       USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_IN,
+                       scb_index, 0, cy_i2c->i2c_config,
+                       sizeof(*cy_i2c->i2c_config), CY_USBS_CTRL_XFER_TIMEOUT);
+       if (ret != sizeof(*cy_i2c->i2c_config)) {
+               dev_err(&cyusbs->usb_intf->dev, "%s: %d\n",
+                       __func__, ret);
+               ret = usb_translate_errors(ret);
+               goto config_error;
+       }
+
+       dev_dbg(&cyusbs->usb_intf->dev,
+               "%s: freq=%d, slave_addr=0x%02x, msb_first=%d, master=%d, ignore=%d, clock_stretch=%d, loopback=%d\n",
+               __func__, cy_i2c->i2c_config->frequency,
+               cy_i2c->i2c_config->slave_addr,
+               cy_i2c->i2c_config->is_msb_first,
+               cy_i2c->i2c_config->is_master,
+               cy_i2c->i2c_config->s_ignore,
+               cy_i2c->i2c_config->clock_stretch,
+               cy_i2c->i2c_config->is_loopback);
+
+config_error:
+       return ret;
+}
+
+static int cy_i2c_set_data_config(struct cyusbs23x *cyusbs,
+                                 struct cyusbs_i2c *cy_i2c, u16 slave_addr,
+                                 u16 length, u8 command)
+{
+       int ret;
+       u16 wIndex, wValue, scb_index;
+
+       scb_index = (cyusbs->intf_num & 0x01) << CY_SCB_INDEX_SHIFT;
+       slave_addr = (slave_addr & 0x7F);
+       wValue = scb_index | cy_i2c->is_stop_bit | cy_i2c->is_nak_bit << 1;
+       wValue |= (slave_addr << 8);
+       wIndex = length;
+
+       dev_dbg(&cy_i2c->i2c_adapter.dev,
+               "%s, cmd=0x%x, val=0x%x, idx=0x%x\n",
+               __func__, command, wValue, wIndex);
+
+       ret = usb_control_msg(cyusbs->usb_dev,
+               usb_sndctrlpipe(cyusbs->usb_dev, 0),
+               command, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_DIR_OUT,
+               wValue, wIndex, NULL, 0, CY_USBS_CTRL_XFER_TIMEOUT);
+
+       return ret;
+}
+
+static int cy_i2c_read(struct i2c_adapter *adapter, struct i2c_msg *msgs)
+{
+       int ret;
+       int actual_read_len = 0;
+       struct cyusbs23x *cyusbs = (struct cyusbs23x *)adapter->algo_data;
+
+       dev_dbg(&adapter->dev, "%s\n", __func__);
+
+       ret = usb_bulk_msg(cyusbs->usb_dev,
+               usb_rcvbulkpipe(cyusbs->usb_dev, cyusbs->bulk_in_ep_num),
+               msgs[0].buf,
+               msgs[0].len,
+               &actual_read_len, CY_USBS_BULK_XFER_TIMEOUT);
+       if (ret)
+               dev_err(&adapter->dev,
+                       "read %d/%d returned %d\n",
+                       actual_read_len, msgs[0].len, ret);
+
+       ret = cy_i2c_recv_status(adapter);
+
+       return ret;
+}
+
+static int cy_i2c_write(struct i2c_adapter *adapter, struct i2c_msg *msgs)
+{
+       int ret;
+       int actual_write_len = 0;
+       struct cyusbs23x *cyusbs = (struct cyusbs23x *)adapter->algo_data;
+
+       dev_dbg(&adapter->dev, "%s\n", __func__);
+
+       ret = usb_bulk_msg(cyusbs->usb_dev,
+               usb_sndbulkpipe(cyusbs->usb_dev, cyusbs->bulk_out_ep_num),
+               msgs[0].buf,
+               msgs[0].len,
+               &actual_write_len, CY_USBS_BULK_XFER_TIMEOUT);
+       if (ret)
+               dev_err(&adapter->dev,
+                       "write %d/%d returned %d\n",
+                       actual_write_len, msgs[0].len, ret);
+
+       ret = cy_i2c_recv_status(adapter);
+
+       return ret;
+}
+
+static int cy_i2c_xfer(struct i2c_adapter *adapter,
+                      struct i2c_msg *msgs, int num)
+{
+       int ret = 0;
+       struct cyusbs_i2c *cy_i2c;
+       struct cyusbs23x *cyusbs = (struct cyusbs23x *)adapter->algo_data;
+
+       dev_dbg(&adapter->dev, "%s\n", __func__);
+
+       if (num > 1) {
+               dev_err(&adapter->dev, "i2c_msg number is > 1\n");
+               return -EIO;
+       }
+
+       cy_i2c = to_cyusbs_i2c(adapter);
+
+       mutex_lock(&cy_i2c->lock);
+       if (msgs[0].flags & I2C_M_RD) {
+               dev_dbg(&adapter->dev,
+                       "I2C read requested for addr 0x%02x, data length %d\n",
+                       msgs[0].addr, msgs[0].len);
+
+               ret = cy_i2c_set_data_config(cyusbs, cy_i2c, msgs[0].addr,
+                               msgs[0].len, CY_I2C_READ_CMD);
+               if (ret < 0) {
+                       dev_err(&adapter->dev,
+                               "Set Config (read) failed with %d\n", ret);
+                       goto io_error;
+               }
+
+               ret = cy_i2c_read(adapter, msgs);
+               if (ret) {
+                       dev_err(&adapter->dev,
+                               "Read failed with error code %d\n", ret);
+                       goto io_error;
+               }
+       } else {
+               dev_dbg(&adapter->dev,
+                       "I2C write requested for addr 0x%02x, data length %d\n",
+                       msgs[0].addr, msgs[0].len);
+
+               ret = cy_i2c_set_data_config(cyusbs, cy_i2c, msgs[0].addr,
+                               msgs[0].len, CY_I2C_WRITE_CMD);
+               if (ret < 0) {
+                       dev_err(&adapter->dev,
+                       "Set Config (write) failed with %d\n", ret);
+                       goto io_error;
+               }
+
+               ret = cy_i2c_write(adapter, msgs);
+               if (ret) {
+                       dev_err(&adapter->dev,
+                               "Write failed with error code %d\n", ret);
+                       goto io_error;
+               }
+       }
+       mutex_unlock(&cy_i2c->lock);
+       return ret;
+
+io_error:
+       mutex_unlock(&cy_i2c->lock);
+       return ret;
+}
+
+static u32 cy_i2c_func(struct i2c_adapter *adapter)
+{
+       return I2C_FUNC_I2C;
+}
+
+static const struct i2c_algorithm i2c_cyusbs23x_algorithm = {
+       .master_xfer    = cy_i2c_xfer,
+       .functionality  = cy_i2c_func,
+};
+
+static int cyusbs23x_i2c_probe(struct platform_device *pdev)
+{
+       struct cyusbs23x *cyusbs;
+       struct cyusbs_i2c *cy_i2c;
+       int ret = 0;
+
+       dev_dbg(&pdev->dev, "%s\n", __func__);
+
+       cyusbs = dev_get_drvdata(pdev->dev.parent);
+
+       cy_i2c = devm_kzalloc(&pdev->dev, sizeof(*cy_i2c), GFP_KERNEL);
+       if (cy_i2c == NULL)
+               return -ENOMEM;
+
+       cy_i2c->i2c_config = devm_kzalloc(&pdev->dev,
+                                       sizeof(struct cyusbs_i2c_config),
+                                       GFP_KERNEL);
+       if (cy_i2c->i2c_config == NULL)
+               return -ENOMEM;
+
+       mutex_init(&cy_i2c->lock);
+       cy_i2c->is_stop_bit = 1;
+       cy_i2c->is_nak_bit = 1;
+
+       cy_i2c->i2c_adapter.owner = THIS_MODULE;
+       cy_i2c->i2c_adapter.class = I2C_CLASS_HWMON;
+       cy_i2c->i2c_adapter.algo = &i2c_cyusbs23x_algorithm;
+       cy_i2c->i2c_adapter.algo_data = cyusbs;
+       snprintf(cy_i2c->i2c_adapter.name, sizeof(cy_i2c->i2c_adapter.name),
+                       "cyusbs23x_i2c at bus %03d dev %03d intf %03d",
+                       cyusbs->usb_dev->bus->busnum, cyusbs->usb_dev->devnum,
+                       cyusbs->intf_num);
+       cy_i2c->i2c_adapter.dev.parent = &pdev->dev;
+       cy_i2c->i2c_adapter.dev.groups = cyusbs_i2c_device_groups;
+
+       ret = cy_get_i2c_config(cyusbs, cy_i2c);
+       if (ret < 0) {
+               dev_err(&pdev->dev, "error to get i2c config\n");
+               goto error;
+       }
+
+       if (!cy_i2c->i2c_config->is_master) {
+               ret = -ENODEV;
+               dev_err(&pdev->dev, "not an I2C master\n");
+               goto error;
+       }
+
+       ret = i2c_add_adapter(&cy_i2c->i2c_adapter);
+       if (ret != 0) {
+               dev_err(&pdev->dev, "failed to add i2c adapter\n");
+               goto error;
+       }
+
+       platform_set_drvdata(pdev, cy_i2c);
+
+       dev_dbg(&pdev->dev, "added I2C adapter\n");
+       return 0;
+
+error:
+       dev_err(&pdev->dev, "error occurred %d\n", ret);
+       return ret;
+}
+
+static int cyusbs23x_i2c_remove(struct platform_device *pdev)
+{
+       struct cyusbs_i2c *cy_i2c = platform_get_drvdata(pdev);
+
+       dev_dbg(&pdev->dev, "%s\n", __func__);
+       i2c_del_adapter(&cy_i2c->i2c_adapter);
+       return 0;
+}
+
+static struct platform_driver cyusbs23x_i2c_driver = {
+       .driver.name    = "cyusbs23x-i2c",
+       .probe          = cyusbs23x_i2c_probe,
+       .remove         = cyusbs23x_i2c_remove,
+};
+
+module_platform_driver(cyusbs23x_i2c_driver);
+
+MODULE_AUTHOR("Rajaram Regupathy <rera@cypress.com>");
+MODULE_AUTHOR("Muthu Mani <muth@cypress.com>");
+MODULE_DESCRIPTION("I2C adapter driver for CYUSBS23x");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:cyusbs23x-i2c");
--
1.8.3.2


This message and any attachments may contain Cypress (or its subsidiaries) confidential information. If it has been received in error, please advise the sender and immediately delete this message.
