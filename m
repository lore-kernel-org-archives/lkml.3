Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbaGQFeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 01:34:15 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34914 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753461AbaGQFeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 01:34:11 -0400
X-Sasl-enc: Xs9kRP9GSZQbCL+fGJntL13GnLUvfRUn7wSbQ6f4dgJ2 1405575249
Date: Wed, 16 Jul 2014 22:33:47 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Alexander Kolesnikov <akolesni@codeaurora.org>,
        Konstantin Dorfman <kdorfman@codeaurora.org>
Subject: Re: char interface to sdio, chdio.c
Message-ID: <20140717053347.GB22970@kroah.com>
References: <20140716032655.GB30412@kroah.com>
 <53C6C2C5.1050804@codeaurora.org>
 <20140716184409.GB10633@kroah.com>
 <53C6D4B6.3030506@codeaurora.org>
 <53C705DB.3040700@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C705DB.3040700@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 04:08:11PM -0700, Stephen Boyd wrote:
> On 07/16/14 12:38, Stephen Boyd wrote:
> > On 07/16/14 11:44, Greg KH wrote:
> >> My specific question is why 2 different interfaces?
> > Ok. It definitely looks odd to support set/get of the VDD with sysfs and
> > ioctl interfaces. I'm just guessing, but I suspect it's a permissions
> > thing given that the patch that introduces the VDD stuff also updates
> > the permissions of the device node. Of course, the commit text only
> > mentions an ioctl, nothing about sysfs. The only other sysfs stuff seems
> > to be module parameters to change the vendor ids.
> >
> > I'll have to go repo diving to figure out if the sysfs interface was
> > ever used. Maybe Alex or Konstantin can respond before I have to do that.
> >
> >
> 
> I couldn't find any usage of the sysfs interface. The only thing I see
> used is the host_name field when the module is inserted, if that even
> happens at all (I'm not sure because it's behind some ifdef that may or
> may not be defined). Sorry this doesn't explain why there are two
> different interfaces for the VDD stuff. Hopefully Alex or Konstantin can
> help.

The duplication of the vdd interface is odd, I'll just go delete it.

In looking further at the code, it only supports 1 single device, set at
build time, or module load time.  That's not good, or generic.  Any
objection to me making it so it can support any sdio device in the
system, and multiple devices as well, and actually work on a 64bit
kernel, with multiple cores?

Oh, and this obviously didn't run on a phone that had a kernel log
enabled, as it logs every single little thing that happens to the
device, just short of a raw byte stream.  I'll fix that up, and I got it
building on a 3.16-rc kernel.  Patch that builds is below if anyone is
curious.

Oh, and checkout the code that goes and modifies the permissions of the
device node in /dev/ from the kernel itself.  The hoops Android
developers have to go through because they were not using a udev-like
programs is crazy.  Hopefully devtmpfs is being used these days...

thanks,

greg k-h

----------------------

mmc: Char SDIO Device Driver

Squashed commit of the following:

commit c3fb53893cbc4b5e217ef176010d1b88982a9454
Author: Alexander Kolesnikov <akolesni@codeaurora.org>
Date:   Wed Sep 15 17:16:52 2010 +0200

    csdio: Set/get vdd ioctl support

    Implement power up/down sequence for internal UBM chip.
    This commit includes generic, platform independent part.

    CRs-Fixed: 255849
    Change-Id: I526c78765ba32b310463a231c5cf578cb37c6deb
    Signed-off-by: Alexander Kolesnikov <akolesni@codeaurora.org>

commit e1ba27311fcf3de2a5ca9a3fc1303328720dd120
Author: Nela Gurevich <nelag@codeaurora.org>
Date:   Thu Aug 19 14:00:09 2010 +0300

    csdio: Move csdio.h to kernel/include

    Change-Id: Idf8df750e9f3bcc014d1afa673c9c27c97253195
    Signed-off-by: Nela Gurevich <nelag@codeaurora.org>

commit 31d1b09c677c26efb71fa36ff6fe1e7f2d83abbc
Author: Alexander Kolesnikov <akolesni@codeaurora.org>
Date:   Tue Aug 10 13:26:20 2010 +0300

    mmc: Char SDIO Device Driver

    The Char SDIO Device Driver is an interface which exposes an SDIO
    card/function from kernel space as a char device in user space.

    Change-Id: If298cdd6d4426b700e69affa5a3602cd221ad89c
    Signed-off-by: Alexander Kolesnikov <akolesni@codeaurora.org>

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 Documentation/csdio.txt   |  189 ++++++++
 drivers/char/Kconfig      |   23 
 drivers/char/Makefile     |    1 
 drivers/char/csdio.c      | 1070 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/csdio.h     |   37 +
 include/uapi/linux/Kbuild |    1 
 6 files changed, 1321 insertions(+)

--- /dev/null
+++ b/Documentation/csdio.txt
@@ -0,0 +1,189 @@
+Introduction
+============
+The Char SDIO Device Driver is an interface which exposes an SDIO
+card/function from kernel space as a char device in user space.
+
+The driver doesn't interact with any HW directly. It relies on SDIO
+card/function interface provided as a part of Linux kernel.
+
+Hardware description
+====================
+Each SDIO device/card contains an SDIO client HW block.
+The host interacts with the device by sending byte sequences called
+command (CMD). Some commands can be followed by data blocks. The
+device sends back a byte sequence called response (R) and a data
+block if required. CMD3, CMD5 and CMD7 are used to initialize the
+device. CMD52 and CMD53 are used to access the device. Command
+format and properties are defined by SDIO Specification document
+published by SD Association:
+    http://www.sdcard.org/developers/tech/sdio/.
+
+CMD52 and CMD53 can access up to 8 address spaces called Functions.
+Function 0 contains system information predefined by SD/SDIO
+standard and Functions 1-7 are defined by the SDIO device
+manufacturer.
+
+An SDIO device/card can send an interrupt to SDIO host. This
+interrupt is intercepted and handled by SDIO host.
+
+Software description
+====================
+Linux provides a framework for handling SDIO devices. It implements
+kind of plug-and-play model in which the Linux SDIO Host Driver is
+responsible for initializing an SDIO device upon insertion. It also
+reads device/card identification information and enumerates functions
+provided by the device and then looks up in the list of
+preregistered user SDIO drivers for a suitable one.
+
+During its lifecycle the user SDIO driver interacts with the Linux
+SDIO Host Driver in order to send/receive information to/from SDIO
+device/card. The user SDIO driver doesn't work with CMD52/CMD53
+directly. Instead it uses an abstraction provided by the Linux SDIO
+Host Driver.
+
+The Linux SDIO Host Driver is also in charge of handling SDIO
+interrupts. User SDIO driver can register its own callback in SDIO
+Host Driver and get a notification about interrupt event.
+
+The Char SDIO Device Driver follows the design guidelines mentioned
+above. It provides the following functionality:
+
+ - Register itself in the user SDIO drivers list;
+ - Handle Probe event upon insertion of supported card/device;
+ - Creates and maintains a char device driver for each SDIO Function
+   found in the card/device;
+ - Translates read/write/ioctl calls to appropriate SDIO call
+   sequences;
+
+In order to handle general SDIO configuration functionality and
+Function 0 the Char SDIO Device Driver provides additional
+simplified char device driver.
+
+The Manufacturer and Device IDs of handled SDIO device should be
+provided as parameters for kernel module or as configuration
+parameters in case of statically linked driver.
+
+Design
+======
+The main goal of the Char SDIO Device Driver is to expose an SDIO
+card/device from kernel space to user space as a char device driver.
+The driver should be generic and simple as far as possible.
+
+The biggest design tradeoff is maintaining a balance between the
+system call overhead required to initiate an SDIO transaction from
+user space and overall SDIO communication performance. But luckily,
+because of nature of SDIO protocol, this overhead is negligible
+comparing to time required to execute SDIO transaction itself. So,
+each CMD52 (read or write) consists from single ioctl system call.
+And each CMD53 invokes single ioctl system call followed by read or
+write system call.
+
+The Char SDIO Device Driver registers its own class of the devices
+called 'csdio'. This class will serve as a common roof for all SDIO
+devices served by different instances of the Char SDIO Device Driver.
+Additional benefit from maintaining its own class is the driver
+ability to overwrite default permissions of the dev nodes created by
+the driver.
+
+Power Management
+================
+None
+
+SMP/multi-core
+==============
+The driver does not anticipate any issues related to multi-core
+since it is expected to run on one core only.
+
+Security
+========
+None
+
+Performance
+===========
+None
+
+Interface
+=========
+The Char SDIO Device Driver has two char device interfaces:
+ - Control Interface;
+ - Function Interface.
+
+Char SDIO Device Driver Control Interface consists of:
+ - open()   - device node is /dev/csdio0;
+ - close()
+ - ioctl()  - the following options are available:
+   - CSDIO_IOC_ENABLE_HIGHSPEED_MODE;
+   - CSDIO_IOC_SET_DATA_TRANSFER_CLOCKS;
+   - CSDIO_IOC_ENABLE_ISR;
+   - CSDIO_IOC_DISABLE_ISR.
+
+Char SDIO Device Driver Function Interface consists of:
+ - open()  - device node is /dev/csdiofX, where X is Function Id;
+ - close()
+ - read()  - send CMD53 read;
+ - write() - send CMD53 write;
+ - ioctl() - the following options are available:
+   - CSDIO_IOC_SET_OP_CODE - 0 fixed adrress, 1 autoincrement.
+   - CSDIO_IOC_FUNCTION_SET_BLOCK_SIZE;
+   - CSDIO_IOC_SET_BLOCK_MODE - 0 byte mode, 1 block mode;
+   - CSDIO_IOC_CMD52 - execute CMD52, receives the
+        following structure as a parameter:
+            struct csdio_cmd52_ctrl_t {
+	            uint32_t    m_write; // 0 - read, 1 -write
+	            uint32_t    m_address;
+	            uint32_t    m_data;  // data to write or read data
+	            uint32_t    m_ret;   // command execution status
+            }__attribute__ ((packed));
+   - CSDIO_IOC_CMD53 - setup CMD53 data transfer, receives the
+        following structure as a parameter:
+            struct csdio_cmd53_ctrl_t {
+	            uint32_t    m_block_mode;
+	            uint32_t    m_op_code;
+	            uint32_t    m_address;
+            }__attribute__ ((packed));
+   - CSDIO_IOC_CONNECT_ISR;
+   - CSDIO_IOC_DISCONNECT_ISR;
+   - CSDIO_IOC_GET_VDD;
+   - CSDIO_IOC_SET_VDD.
+
+Additionally, user space application can use fcntl system call with
+parameters F_SETOWN and F_SETFL in order to set an asynchronous
+callback for SDIO interrupt.
+
+Driver parameters
+=================
+If the driver is compiled as a kernel module, the following
+parameters can be used in order to provide Manufacturer and Device IDs
+upon module download:
+ - csdio_vendor_id;
+ - csdio_device_id.
+If the driver is intended to work with specific SDIO host the
+host_name parameter should be added followed by the name of the MMC
+host platform device.
+
+Config options
+==============
+These are the kernel configuration options:
+ - CONFIG_CSDIO_VENDOR_ID;
+ - CONFIG_CSDIO_DEVICE_ID.
+
+Dependencies
+============
+The Char SDIO Device Driver depends on Linux SDIO Host Driver.
+
+User space utilities
+====================
+None
+
+Other
+=====
+None
+
+Known issues
+============
+None
+
+To do
+=====
+Provide mechanism to support a number of SDIO devices simultaneously
+connected to different SDIO hosts.
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -600,5 +600,28 @@ config TILE_SROM
 	  device appear much like a simple EEPROM, and knows
 	  how to partition a single ROM for multiple purposes.
 
+config MMC_GENERIC_CSDIO
+	tristate "Generic sdio driver"
+	default n
+	help
+	  SDIO function driver that extends SDIO card as character device
+	  in user space.
+
+config CSDIO_VENDOR_ID
+	hex "Card VendorId"
+	depends on MMC_GENERIC_CSDIO
+	default "0"
+	help
+	  Enter vendor id for targeted sdio device, this may be overwritten by
+	  module parameters.
+
+config CSDIO_DEVICE_ID
+	hex "CardDeviceId"
+	depends on MMC_GENERIC_CSDIO
+	default "0"
+	help
+	  Enter device id for targeted sdio device, this may be overwritten by
+	  module parameters.
+.
 endmenu
 
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@ -61,3 +61,4 @@ obj-$(CONFIG_JS_RTC)		+= js-rtc.o
 js-rtc-y = rtc.o
 
 obj-$(CONFIG_TILE_SROM)		+= tile-srom.o
+obj-$(CONFIG_MMC_GENERIC_CSDIO)	+= csdio.o
--- /dev/null
+++ b/drivers/char/csdio.c
@@ -0,0 +1,1070 @@
+/*
+ * Copyright (c) 2010, Code Aurora Forum. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/mutex.h>
+#include <linux/serial_reg.h>
+#include <linux/circ_buf.h>
+#include <linux/gfp.h>
+#include <linux/uaccess.h>
+#include <linux/slab.h>
+#include <linux/platform_device.h>
+
+/* Char device */
+#include <linux/cdev.h>
+#include <linux/fs.h>
+
+/* Sdio device */
+#include <linux/mmc/core.h>
+#include <linux/mmc/host.h>
+#include <linux/mmc/card.h>
+#include <linux/mmc/sdio.h>
+#include <linux/mmc/sdio_func.h>
+#include <linux/mmc/sdio_ids.h>
+
+#include <linux/csdio.h>
+
+#define VERSION                     "0.5"
+#define CSDIO_NUM_OF_SDIO_FUNCTIONS 7
+#define CSDIO_DEV_NAME              "csdio"
+#define TP_DEV_NAME                 CSDIO_DEV_NAME"f"
+#define CSDIO_DEV_PERMISSIONS       0666
+
+#define CSDIO_SDIO_BUFFER_SIZE      (64*512)
+
+int csdio_major;
+int csdio_minor;
+int csdio_transport_nr_devs = CSDIO_NUM_OF_SDIO_FUNCTIONS;
+static uint csdio_vendor_id;
+static uint csdio_device_id;
+static char *host_name;
+
+static struct csdio_func_t {
+	struct sdio_func   *m_func;
+	int                 m_enabled;
+	struct cdev         m_cdev;      /* char device structure */
+	struct device      *m_device;
+	u32                 m_block_size;
+} *g_csdio_func_table[CSDIO_NUM_OF_SDIO_FUNCTIONS] = {0};
+
+struct csdio_t {
+	struct cdev             m_cdev;
+	struct device          *m_device;
+	struct class           *m_driver_class;
+	struct fasync_struct   *m_async_queue;
+	unsigned char           m_current_irq_mask; /* currently enabled irqs */
+	struct mmc_host        *m_host;
+	unsigned int            m_num_of_func;
+} g_csdio;
+
+struct csdio_file_descriptor {
+	struct csdio_func_t    *m_port;
+	u32                     m_block_mode;/* data tran. byte(0)/block(1) */
+	u32                     m_op_code;   /* address auto increment flag */
+	u32                     m_address;
+};
+
+static void *g_sdio_buffer;
+
+/*
+ * Open and release
+ */
+static int csdio_transport_open(struct inode *inode, struct file *filp)
+{
+	int ret = 0;
+	struct csdio_func_t *port = NULL; /*  device information */
+	struct sdio_func *func = NULL;
+	struct csdio_file_descriptor *descriptor = NULL;
+
+	port = container_of(inode->i_cdev, struct csdio_func_t, m_cdev);
+	func = port->m_func;
+	descriptor = kzalloc(sizeof(struct csdio_file_descriptor), GFP_KERNEL);
+	if (!descriptor) {
+		ret = -ENOMEM;
+		goto exit;
+	}
+
+	pr_info(TP_DEV_NAME"%d: open: func=%p, port=%p\n",
+			func->num, func, port);
+	sdio_claim_host(func);
+	ret = sdio_enable_func(func);
+	if (ret) {
+		pr_err(TP_DEV_NAME"%d:Enable func failed (%d)\n",
+				func->num, ret);
+		ret = -EIO;
+		goto free_descriptor;
+	}
+	descriptor->m_port = port;
+	filp->private_data = descriptor;
+	goto release_host;
+
+free_descriptor:
+	kfree(descriptor);
+release_host:
+	sdio_release_host(func);
+exit:
+	return ret;
+}
+
+static int csdio_transport_release(struct inode *inode, struct file *filp)
+{
+	int ret = 0;
+	struct csdio_file_descriptor *descriptor = filp->private_data;
+	struct csdio_func_t *port = descriptor->m_port;
+	struct sdio_func *func = port->m_func;
+
+	pr_info(TP_DEV_NAME"%d: release\n", func->num);
+	sdio_claim_host(func);
+	ret = sdio_disable_func(func);
+	if (ret) {
+		pr_err(TP_DEV_NAME"%d:Disable func failed(%d)\n",
+				func->num, ret);
+		ret = -EIO;
+	}
+	sdio_release_host(func);
+	kfree(descriptor);
+	return ret;
+}
+
+/*
+ * Data management: read and write
+ */
+static ssize_t csdio_transport_read(struct file *filp,
+		char __user *buf,
+		size_t count,
+		loff_t *f_pos)
+{
+	ssize_t ret = 0;
+	struct csdio_file_descriptor *descriptor = filp->private_data;
+	struct csdio_func_t *port = descriptor->m_port;
+	struct sdio_func *func = port->m_func;
+	size_t t_count = count;
+
+	if (descriptor->m_block_mode) {
+		pr_info(TP_DEV_NAME "%d: CMD53 read, Md:%d, Addr:0x%04X,"
+				" Un:%zd (Bl:%zd, BlSz:%d)\n", func->num,
+				descriptor->m_block_mode,
+				descriptor->m_address,
+				count*port->m_block_size,
+				count, port->m_block_size);
+		/* recalculate size */
+		count *= port->m_block_size;
+	}
+	sdio_claim_host(func);
+	if (descriptor->m_op_code) {
+		/* auto increment */
+		ret = sdio_memcpy_fromio(func, g_sdio_buffer,
+				descriptor->m_address, count);
+	} else { /* FIFO */
+		ret = sdio_readsb(func, g_sdio_buffer,
+				descriptor->m_address, count);
+	}
+	sdio_release_host(func);
+	if (!ret) {
+		if (copy_to_user(buf, g_sdio_buffer, count))
+			ret = -EFAULT;
+		else
+			ret = t_count;
+	}
+	if (ret < 0) {
+		pr_err(TP_DEV_NAME "%d: CMD53 read failed (%zd)"
+				"(Md:%d, Addr:0x%04X, Sz:%zd)\n",
+				func->num, ret,
+				descriptor->m_block_mode,
+				descriptor->m_address, count);
+	}
+	return ret;
+}
+
+static ssize_t csdio_transport_write(struct file *filp,
+		const char __user *buf,
+		size_t count,
+		loff_t *f_pos)
+{
+	ssize_t ret = 0;
+	struct csdio_file_descriptor *descriptor = filp->private_data;
+	struct csdio_func_t *port = descriptor->m_port;
+	struct sdio_func *func = port->m_func;
+	size_t t_count = count;
+
+	if (descriptor->m_block_mode)
+		count *= port->m_block_size;
+
+	if (copy_from_user(g_sdio_buffer, buf, count)) {
+		pr_err(TP_DEV_NAME"%d:copy_from_user failed\n", func->num);
+		ret = -EFAULT;
+	} else {
+		sdio_claim_host(func);
+		if (descriptor->m_op_code) {
+			/* auto increment */
+			ret = sdio_memcpy_toio(func, descriptor->m_address,
+					g_sdio_buffer, count);
+		} else {
+			/* FIFO */
+			ret = sdio_writesb(func, descriptor->m_address,
+					g_sdio_buffer, count);
+		}
+		sdio_release_host(func);
+		if (!ret) {
+			ret = t_count;
+		} else {
+			pr_err(TP_DEV_NAME "%d: CMD53 write failed (%zd)"
+				"(Md:%d, Addr:0x%04X, Sz:%zd)\n",
+				func->num, ret, descriptor->m_block_mode,
+				descriptor->m_address, count);
+		}
+	}
+	return ret;
+}
+
+/* disable interrupt for sdio client */
+static int disable_sdio_client_isr(struct sdio_func *func)
+{
+	int ret;
+
+	/* disable for all functions, to restore interrupts
+	 * use g_csdio.m_current_irq_mask */
+	sdio_f0_writeb(func, 0, SDIO_CCCR_IENx, &ret);
+	if (ret)
+		pr_err(CSDIO_DEV_NAME" Can't sdio_f0_writeb (%d)\n", ret);
+
+	return ret;
+}
+
+/*
+ * This handles the interrupt from SDIO.
+ */
+static void csdio_sdio_irq(struct sdio_func *func)
+{
+	int ret;
+
+	pr_info(CSDIO_DEV_NAME" csdio_sdio_irq: func=%d\n", func->num);
+	ret = disable_sdio_client_isr(func);
+	if (ret) {
+		pr_err(CSDIO_DEV_NAME" Can't disable client isr(%d)\n", ret);
+		return;
+	}
+	/*  signal asynchronous readers */
+	if (g_csdio.m_async_queue)
+		kill_fasync(&g_csdio.m_async_queue, SIGIO, POLL_IN);
+}
+
+/*
+ * The ioctl() implementation
+ */
+static long csdio_transport_ioctl(struct file *filp,
+		unsigned int cmd,
+		unsigned long arg)
+{
+	int err = 0;
+	int ret = 0;
+	struct csdio_file_descriptor *descriptor = filp->private_data;
+	struct csdio_func_t *port = descriptor->m_port;
+	struct sdio_func *func = port->m_func;
+
+	/*  extract the type and number bitfields
+	    sanity check: return ENOTTY (inappropriate ioctl) before
+	    access_ok()
+	*/
+	if ((_IOC_TYPE(cmd) != CSDIO_IOC_MAGIC) ||
+			(_IOC_NR(cmd) > CSDIO_IOC_MAXNR)) {
+		pr_err(TP_DEV_NAME "Wrong ioctl command parameters\n");
+		ret = -ENOTTY;
+		goto exit;
+	}
+
+	/*  the direction is a bitmask, and VERIFY_WRITE catches R/W
+	 *  transfers. `Type' is user-oriented, while access_ok is
+	    kernel-oriented, so the concept of "read" and "write" is reversed
+	*/
+	if (_IOC_DIR(cmd) & _IOC_READ) {
+		err = !access_ok(VERIFY_WRITE, (void __user *)arg,
+				_IOC_SIZE(cmd));
+	} else {
+		if (_IOC_DIR(cmd) & _IOC_WRITE) {
+			err =  !access_ok(VERIFY_READ, (void __user *)arg,
+					_IOC_SIZE(cmd));
+		}
+	}
+	if (err) {
+		pr_err(TP_DEV_NAME "Wrong ioctl access direction\n");
+		ret = -EFAULT;
+		goto exit;
+	}
+
+	switch (cmd) {
+	case CSDIO_IOC_SET_OP_CODE:
+		{
+			pr_info(TP_DEV_NAME"%d:SET_OP_CODE=%d\n",
+					func->num, descriptor->m_op_code);
+			ret = get_user(descriptor->m_op_code,
+					(unsigned char __user *)arg);
+			if (ret) {
+				pr_err(TP_DEV_NAME"%d:SET_OP_CODE get data"
+						" from user space failed(%d)\n",
+						func->num, ret);
+				ret = -ENOTTY;
+				break;
+			}
+		}
+		break;
+	case CSDIO_IOC_FUNCTION_SET_BLOCK_SIZE:
+		{
+			unsigned block_size;
+
+			ret = get_user(block_size, (unsigned __user *)arg);
+			if (ret) {
+				pr_err(TP_DEV_NAME"%d:SET_BLOCK_SIZE get data"
+						" from user space failed(%d)\n",
+						func->num, ret);
+				ret = -ENOTTY;
+				break;
+			}
+			pr_info(TP_DEV_NAME"%d:SET_BLOCK_SIZE=%d\n",
+					func->num, block_size);
+			sdio_claim_host(func);
+			ret = sdio_set_block_size(func, block_size);
+			if (!ret) {
+				port->m_block_size = block_size;
+			} else {
+				pr_err(TP_DEV_NAME"%d:SET_BLOCK_SIZE set block"
+						" size to %d failed (%d)\n",
+						func->num, block_size, ret);
+				ret = -ENOTTY;
+				break;
+			}
+			sdio_release_host(func);
+		}
+		break;
+	case CSDIO_IOC_SET_BLOCK_MODE:
+		{
+			pr_info(TP_DEV_NAME"%d:SET_BLOCK_MODE=%d\n",
+					func->num, descriptor->m_block_mode);
+			ret = get_user(descriptor->m_block_mode,
+					(unsigned char __user *)arg);
+			if (ret) {
+				pr_err(TP_DEV_NAME"%d:SET_BLOCK_MODE get data"
+						" from user space failed\n",
+						func->num);
+				ret = -ENOTTY;
+				break;
+			}
+		}
+		break;
+	case CSDIO_IOC_CMD52:
+		{
+			struct csdio_cmd52_ctrl_t cmd52ctrl;
+			int cmd52ret;
+
+			if (copy_from_user(&cmd52ctrl,
+					(const unsigned char __user *)arg,
+					sizeof(cmd52ctrl))) {
+				pr_err(TP_DEV_NAME"%d:IOC_CMD52 get data"
+						" from user space failed\n",
+						func->num);
+				ret = -ENOTTY;
+				break;
+			}
+			sdio_claim_host(func);
+			if (cmd52ctrl.m_write)
+				sdio_writeb(func, cmd52ctrl.m_data,
+						cmd52ctrl.m_address, &cmd52ret);
+			else
+				cmd52ctrl.m_data = sdio_readb(func,
+						cmd52ctrl.m_address, &cmd52ret);
+
+			cmd52ctrl.m_ret = cmd52ret;
+			sdio_release_host(func);
+			if (cmd52ctrl.m_ret)
+				pr_err(TP_DEV_NAME"%d:IOC_CMD52 failed (%d)\n",
+						func->num, cmd52ctrl.m_ret);
+
+			if (copy_to_user((unsigned char __user *)arg,
+						&cmd52ctrl,
+						sizeof(cmd52ctrl))) {
+				pr_err(TP_DEV_NAME"%d:IOC_CMD52 put data"
+						" to user space failed\n",
+						func->num);
+				ret = -ENOTTY;
+				break;
+			}
+		}
+		break;
+	case CSDIO_IOC_CMD53:
+		{
+			struct csdio_cmd53_ctrl_t csdio_cmd53_ctrl;
+
+			if (copy_from_user(&csdio_cmd53_ctrl,
+						(const char __user *)arg,
+						sizeof(csdio_cmd53_ctrl))) {
+				ret = -EPERM;
+				pr_err(TP_DEV_NAME"%d:"
+					"Get data from user space failed\n",
+					func->num);
+				break;
+			}
+			descriptor->m_block_mode =
+				csdio_cmd53_ctrl.m_block_mode;
+			descriptor->m_op_code = csdio_cmd53_ctrl.m_op_code;
+			descriptor->m_address = csdio_cmd53_ctrl.m_address;
+		}
+		break;
+	case CSDIO_IOC_CONNECT_ISR:
+		{
+			pr_info(CSDIO_DEV_NAME" SDIO_CONNECT_ISR"
+				" func=%d, csdio_sdio_irq=%pK\n",
+				func->num, csdio_sdio_irq);
+			sdio_claim_host(func);
+			ret = sdio_claim_irq(func, csdio_sdio_irq);
+			sdio_release_host(func);
+			if (ret) {
+				pr_err(CSDIO_DEV_NAME" SDIO_CONNECT_ISR"
+						" claim irq failed(%d)\n", ret);
+			} else {
+				/* update current irq mask for disable/enable */
+				g_csdio.m_current_irq_mask |= (1 << func->num);
+			}
+		}
+		break;
+	case CSDIO_IOC_DISCONNECT_ISR:
+		{
+			pr_info(CSDIO_DEV_NAME " SDIO_DISCONNECT_ISR func=%d\n",
+					func->num);
+			sdio_claim_host(func);
+			sdio_release_irq(func);
+			sdio_release_host(func);
+			/* update current irq mask for disable/enable */
+			g_csdio.m_current_irq_mask &= ~(1 << func->num);
+		}
+		break;
+	default:  /*  redundant, as cmd was checked against MAXNR */
+		pr_warning(TP_DEV_NAME"%d: Redundant IOCTL\n",
+				func->num);
+		ret = -ENOTTY;
+	}
+exit:
+	return ret;
+}
+
+static const struct file_operations csdio_transport_fops = {
+	.owner =    THIS_MODULE,
+	.read =     csdio_transport_read,
+	.write =    csdio_transport_write,
+	.unlocked_ioctl =    csdio_transport_ioctl,
+	.open =     csdio_transport_open,
+	.release =  csdio_transport_release,
+};
+
+static void csdio_transport_cleanup(struct csdio_func_t *port)
+{
+	int devno = MKDEV(csdio_major, csdio_minor + port->m_func->num);
+	device_destroy(g_csdio.m_driver_class, devno);
+	port->m_device = NULL;
+	cdev_del(&port->m_cdev);
+}
+
+#if defined(CONFIG_DEVTMPFS)
+static inline int csdio_cdev_update_permissions(
+    const char *devname, int dev_minor)
+{
+	return 0;
+}
+#else
+static int csdio_cdev_update_permissions(
+    const char *devname, int dev_minor)
+{
+	int ret = 0;
+	mm_segment_t fs;
+	struct file *file;
+	struct inode *inode;
+	struct iattr newattrs;
+	int mode = CSDIO_DEV_PERMISSIONS;
+	char dev_file[64];
+
+	fs = get_fs();
+	set_fs(get_ds());
+
+	snprintf(dev_file, sizeof(dev_file), "/dev/%s%d",
+		devname, dev_minor);
+	file = filp_open(dev_file, O_RDWR, 0);
+	if (IS_ERR(file)) {
+		ret = -EFAULT;
+		goto exit;
+	}
+
+	inode = file->f_path.dentry->d_inode;
+
+	mutex_lock(&inode->i_mutex);
+	newattrs.ia_mode =
+		(mode & S_IALLUGO) | (inode->i_mode & ~S_IALLUGO);
+	newattrs.ia_valid = ATTR_MODE | ATTR_CTIME;
+	ret = notify_change(file->f_path.dentry, &newattrs);
+	mutex_unlock(&inode->i_mutex);
+
+	filp_close(file, NULL);
+
+exit:
+	set_fs(fs);
+	return ret;
+}
+#endif
+
+static struct device *csdio_cdev_init(struct cdev *char_dev,
+		const struct file_operations *file_op, int dev_minor,
+		const char *devname, struct device *parent)
+{
+	int ret = 0;
+	struct device *new_device = NULL;
+	dev_t devno = MKDEV(csdio_major, dev_minor);
+
+	/*  Initialize transport device */
+	cdev_init(char_dev, file_op);
+	char_dev->owner = THIS_MODULE;
+	char_dev->ops = file_op;
+	ret = cdev_add(char_dev, devno, 1);
+
+	/*  Fail gracefully if need be */
+	if (ret) {
+		pr_warning("Error %d adding CSDIO char device '%s%d'",
+				ret, devname, dev_minor);
+		goto exit;
+	}
+	pr_info("'%s%d' char driver registered\n", devname, dev_minor);
+
+	/*  create a /dev entry for transport drivers */
+	new_device = device_create(g_csdio.m_driver_class, parent, devno, NULL,
+			"%s%d", devname, dev_minor);
+	if (!new_device) {
+		pr_err("Can't create device node '/dev/%s%d'\n",
+				devname, dev_minor);
+		goto cleanup;
+	}
+	/* no irq attached */
+	g_csdio.m_current_irq_mask = 0;
+
+	if (csdio_cdev_update_permissions(devname, dev_minor)) {
+		pr_warning("%s%d: Unable to update access permissions of the"
+			" '/dev/%s%d'\n",
+			devname, dev_minor, devname, dev_minor);
+	}
+
+	pr_info("%s%d: Device node '/dev/%s%d' created successfully\n",
+			devname, dev_minor, devname, dev_minor);
+	goto exit;
+cleanup:
+	cdev_del(char_dev);
+exit:
+	return new_device;
+}
+
+/* Looks for first non empty function, returns NULL otherwise */
+static struct sdio_func *get_active_func(void)
+{
+	int i;
+
+	for (i = 0; i < CSDIO_NUM_OF_SDIO_FUNCTIONS; i++) {
+		if (g_csdio_func_table[i])
+			return g_csdio_func_table[i]->m_func;
+	}
+	return NULL;
+}
+
+static ssize_t
+show_vdd(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	if (NULL == g_csdio.m_host)
+		return snprintf(buf, PAGE_SIZE, "N/A\n");
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+		g_csdio.m_host->ios.vdd);
+}
+
+static int
+set_vdd_helper(int value)
+{
+	struct mmc_ios *ios = NULL;
+
+	if (NULL == g_csdio.m_host) {
+		pr_err("%s0: Set VDD, no MMC host assigned\n", CSDIO_DEV_NAME);
+		return -ENXIO;
+	}
+
+	mmc_claim_host(g_csdio.m_host);
+	ios = &g_csdio.m_host->ios;
+	ios->vdd = value;
+	g_csdio.m_host->ops->set_ios(g_csdio.m_host, ios);
+	mmc_release_host(g_csdio.m_host);
+	return 0;
+}
+
+static ssize_t
+set_vdd(struct device *dev, struct device_attribute *att,
+	const char *buf, size_t count)
+{
+	int value = 0;
+
+	sscanf(buf, "%d", &value);
+	if (set_vdd_helper(value))
+		return -ENXIO;
+	return count;
+}
+
+static DEVICE_ATTR(vdd, S_IRUGO | S_IWUSR,
+	show_vdd, set_vdd);
+
+static struct attribute *dev_attrs[] = {
+	&dev_attr_vdd.attr,
+	NULL,
+};
+
+static struct attribute_group dev_attr_grp = {
+	.attrs = dev_attrs,
+};
+
+/*
+ * The ioctl() implementation for control device
+ */
+static long csdio_ctrl_ioctl(struct file *filp,
+		unsigned int cmd, unsigned long arg)
+{
+	int err = 0;
+	int ret = 0;
+
+	pr_info("CSDIO ctrl ioctl.\n");
+
+	/*  extract the type and number bitfields
+	    sanity check: return ENOTTY (inappropriate ioctl) before
+	    access_ok()
+	*/
+	if ((_IOC_TYPE(cmd) != CSDIO_IOC_MAGIC) ||
+			(_IOC_NR(cmd) > CSDIO_IOC_MAXNR)) {
+		pr_err(CSDIO_DEV_NAME "Wrong ioctl command parameters\n");
+		ret = -ENOTTY;
+		goto exit;
+	}
+
+	/*  the direction is a bitmask, and VERIFY_WRITE catches R/W
+	  transfers. `Type' is user-oriented, while access_ok is
+	  kernel-oriented, so the concept of "read" and "write" is reversed
+	  */
+	if (_IOC_DIR(cmd) & _IOC_READ) {
+		err = !access_ok(VERIFY_WRITE, (void __user *)arg,
+				_IOC_SIZE(cmd));
+	} else {
+		if (_IOC_DIR(cmd) & _IOC_WRITE)
+			err =  !access_ok(VERIFY_READ, (void __user *)arg,
+					_IOC_SIZE(cmd));
+	}
+	if (err) {
+		pr_err(CSDIO_DEV_NAME "Wrong ioctl access direction\n");
+		ret = -EFAULT;
+		goto exit;
+	}
+
+	switch (cmd) {
+	case CSDIO_IOC_ENABLE_HIGHSPEED_MODE:
+		pr_info(CSDIO_DEV_NAME" ENABLE_HIGHSPEED_MODE\n");
+		break;
+	case CSDIO_IOC_SET_DATA_TRANSFER_CLOCKS:
+		{
+			struct mmc_host *host = g_csdio.m_host;
+			struct mmc_ios *ios = NULL;
+
+			if (NULL == host) {
+				pr_err("%s0: "
+					"CSDIO_IOC_SET_DATA_TRANSFER_CLOCKS,"
+					" no MMC host assigned\n",
+					CSDIO_DEV_NAME);
+				ret = -EFAULT;
+				goto exit;
+			}
+			ios = &host->ios;
+
+			mmc_claim_host(host);
+			ret = get_user(host->ios.clock,
+					(unsigned int __user *)arg);
+			if (ret) {
+				pr_err(CSDIO_DEV_NAME
+					" get data from user space failed\n");
+			} else {
+				pr_err(CSDIO_DEV_NAME
+					"SET_DATA_TRANSFER_CLOCKS(%d-%d)(%d)\n",
+					host->f_min, host->f_max,
+					host->ios.clock);
+				host->ops->set_ios(host, ios);
+			}
+			mmc_release_host(host);
+		}
+		break;
+	case CSDIO_IOC_ENABLE_ISR:
+		{
+			int ret;
+			unsigned char reg;
+			struct sdio_func *func = get_active_func();
+
+			if (!func) {
+				pr_err(CSDIO_DEV_NAME " CSDIO_IOC_ENABLE_ISR"
+						" no active sdio function\n");
+				ret = -EFAULT;
+				goto exit;
+			}
+			pr_info(CSDIO_DEV_NAME
+					" CSDIO_IOC_ENABLE_ISR func=%d\n",
+					func->num);
+			reg = g_csdio.m_current_irq_mask | 1;
+
+			sdio_claim_host(func);
+			sdio_f0_writeb(func, reg, SDIO_CCCR_IENx, &ret);
+			sdio_release_host(func);
+			if (ret) {
+				pr_err(CSDIO_DEV_NAME
+						" Can't sdio_f0_writeb (%d)\n",
+						ret);
+				goto exit;
+			}
+		}
+		break;
+	case CSDIO_IOC_DISABLE_ISR:
+		{
+			int ret;
+			struct sdio_func *func = get_active_func();
+			if (!func) {
+				pr_err(CSDIO_DEV_NAME " CSDIO_IOC_ENABLE_ISR"
+						" no active sdio function\n");
+				ret = -EFAULT;
+				goto exit;
+			}
+			pr_info(CSDIO_DEV_NAME
+					" CSDIO_IOC_DISABLE_ISR func=%p\n",
+					func);
+
+			sdio_claim_host(func);
+			ret = disable_sdio_client_isr(func);
+			sdio_release_host(func);
+			if (ret) {
+				pr_err("%s0: Can't disable client isr (%d)\n",
+					CSDIO_DEV_NAME, ret);
+				goto exit;
+			}
+		}
+	break;
+	case CSDIO_IOC_SET_VDD:
+		{
+			unsigned int vdd = 0;
+
+			ret = get_user(vdd, (unsigned int __user *)arg);
+			if (ret) {
+				pr_err("%s0: CSDIO_IOC_SET_VDD,"
+					" get data from user space failed\n",
+					CSDIO_DEV_NAME);
+				goto exit;
+			}
+			pr_info(CSDIO_DEV_NAME" CSDIO_IOC_SET_VDD - %d\n", vdd);
+
+			ret = set_vdd_helper(vdd);
+			if (ret)
+				goto exit;
+		}
+	break;
+	case CSDIO_IOC_GET_VDD:
+		{
+			if (NULL == g_csdio.m_host) {
+				pr_err("%s0: CSDIO_IOC_GET_VDD,"
+					" no MMC host assigned\n",
+					CSDIO_DEV_NAME);
+				ret = -EFAULT;
+				goto exit;
+			}
+			ret = put_user(g_csdio.m_host->ios.vdd,
+				(unsigned short __user *)arg);
+			if (ret) {
+				pr_err("%s0: CSDIO_IOC_GET_VDD, put data"
+					" to user space failed\n",
+					CSDIO_DEV_NAME);
+				goto exit;
+			}
+		}
+	break;
+	default:  /*  redundant, as cmd was checked against MAXNR */
+		pr_warning(CSDIO_DEV_NAME" Redundant IOCTL\n");
+		ret = -ENOTTY;
+	}
+exit:
+	return ret;
+}
+
+static int csdio_ctrl_fasync(int fd, struct file *filp, int mode)
+{
+	pr_info(CSDIO_DEV_NAME
+			" csdio_ctrl_fasync: fd=%d, filp=%p, mode=%d\n",
+			fd, filp, mode);
+	return fasync_helper(fd, filp, mode, &g_csdio.m_async_queue);
+}
+
+/*
+ * Open and close
+ */
+static int csdio_ctrl_open(struct inode *inode, struct file *filp)
+{
+	int ret = 0;
+	struct csdio_t *csdio_ctrl_drv = NULL; /*  device information */
+
+	pr_info("CSDIO ctrl open.\n");
+	csdio_ctrl_drv = container_of(inode->i_cdev, struct csdio_t, m_cdev);
+	filp->private_data = csdio_ctrl_drv; /*  for other methods */
+	return ret;
+}
+
+static int csdio_ctrl_release(struct inode *inode, struct file *filp)
+{
+	pr_info("CSDIO ctrl release.\n");
+	/*  remove this filp from the asynchronously notified filp's */
+	csdio_ctrl_fasync(-1, filp, 0);
+	return 0;
+}
+
+static const struct file_operations csdio_ctrl_fops = {
+	.owner =	THIS_MODULE,
+	.unlocked_ioctl =	csdio_ctrl_ioctl,
+	.open  =	csdio_ctrl_open,
+	.release =	csdio_ctrl_release,
+	.fasync =	csdio_ctrl_fasync,
+};
+
+static int csdio_probe(struct sdio_func *func,
+		const struct sdio_device_id *id)
+{
+	struct csdio_func_t *port;
+	int ret = 0;
+	struct mmc_host *host = func->card->host;
+
+	if (NULL != g_csdio.m_host && g_csdio.m_host != host) {
+		pr_info("%s: Device is on unexpected host\n",
+			CSDIO_DEV_NAME);
+		ret = -ENODEV;
+		goto exit;
+	}
+
+	/* enforce single instance policy */
+	if (g_csdio_func_table[func->num-1]) {
+		pr_err("%s - only single SDIO device supported",
+				sdio_func_id(func));
+		ret = -EEXIST;
+		goto exit;
+	}
+
+	port = kzalloc(sizeof(struct csdio_func_t), GFP_KERNEL);
+	if (!port) {
+		pr_err("Can't allocate memory\n");
+		ret = -ENOMEM;
+		goto exit;
+	}
+
+	/* initialize SDIO side */
+	port->m_func = func;
+	sdio_set_drvdata(func, port);
+
+	pr_info("%s - SDIO device found. Function %d\n",
+			sdio_func_id(func), func->num);
+
+	port->m_device = csdio_cdev_init(&port->m_cdev, &csdio_transport_fops,
+			csdio_minor + port->m_func->num,
+			TP_DEV_NAME, &port->m_func->dev);
+
+	/* create appropriate char device */
+	if (!port->m_device)
+		goto free;
+
+	if (0 == g_csdio.m_num_of_func && NULL == host_name)
+		g_csdio.m_host = host;
+	g_csdio.m_num_of_func++;
+	g_csdio_func_table[func->num-1] = port;
+	port->m_enabled = 1;
+	goto exit;
+free:
+	kfree(port);
+exit:
+	return ret;
+}
+
+static void csdio_remove(struct sdio_func *func)
+{
+	struct csdio_func_t *port = sdio_get_drvdata(func);
+
+	csdio_transport_cleanup(port);
+	sdio_claim_host(func);
+	sdio_release_irq(func);
+	sdio_disable_func(func);
+	sdio_release_host(func);
+	kfree(port);
+	g_csdio_func_table[func->num-1] = NULL;
+	g_csdio.m_num_of_func--;
+	if (0 == g_csdio.m_num_of_func && NULL == host_name)
+		g_csdio.m_host = NULL;
+	pr_info("%s%d: Device removed (%s). Function %d\n",
+		CSDIO_DEV_NAME, func->num, sdio_func_id(func), func->num);
+}
+
+/* CONFIG_CSDIO_VENDOR_ID and CONFIG_CSDIO_DEVICE_ID are defined in Kconfig.
+ * Use kernel configuration to change the values or overwrite them through
+ * module parameters */
+static struct sdio_device_id csdio_ids[] = {
+	{ SDIO_DEVICE(CONFIG_CSDIO_VENDOR_ID, CONFIG_CSDIO_DEVICE_ID) },
+	{ /* end: all zeroes */},
+};
+
+MODULE_DEVICE_TABLE(sdio, csdio_ids);
+
+static struct sdio_driver csdio_driver = {
+	.probe      = csdio_probe,
+	.remove     = csdio_remove,
+	.name       = "csdio",
+	.id_table   = csdio_ids,
+};
+
+static void __exit csdio_exit(void)
+{
+	dev_t devno = MKDEV(csdio_major, csdio_minor);
+
+	sdio_unregister_driver(&csdio_driver);
+	sysfs_remove_group(&g_csdio.m_device->kobj, &dev_attr_grp);
+	kfree(g_sdio_buffer);
+	device_destroy(g_csdio.m_driver_class, devno);
+	cdev_del(&g_csdio.m_cdev);
+	class_destroy(g_csdio.m_driver_class);
+	unregister_chrdev_region(devno, csdio_transport_nr_devs);
+	pr_info("%s: Exit driver module\n", CSDIO_DEV_NAME);
+}
+
+static char *csdio_devnode(struct device *dev, mode_t *mode)
+{
+	*mode = CSDIO_DEV_PERMISSIONS;
+	return NULL;
+}
+
+static int __init csdio_init(void)
+{
+	int ret = 0;
+	dev_t devno = 0;
+
+	pr_info("Init CSDIO driver module.\n");
+
+	/*  Get a range of minor numbers to work with, asking for a dynamic */
+	/*  major unless directed otherwise at load time. */
+	if (csdio_major) {
+		devno = MKDEV(csdio_major, csdio_minor);
+		ret = register_chrdev_region(devno, csdio_transport_nr_devs,
+				CSDIO_DEV_NAME);
+	} else {
+		ret = alloc_chrdev_region(&devno, csdio_minor,
+				csdio_transport_nr_devs, CSDIO_DEV_NAME);
+		csdio_major = MAJOR(devno);
+	}
+	if (ret < 0) {
+		pr_err("CSDIO: can't get major %d\n", csdio_major);
+		goto exit;
+	}
+	pr_info("CSDIO char driver major number is %d\n", csdio_major);
+
+	/* kernel module got parameters: overwrite vendor and device id's */
+	if ((csdio_vendor_id != 0) && (csdio_device_id != 0)) {
+		csdio_ids[0].vendor = (u16)csdio_vendor_id;
+		csdio_ids[0].device = (u16)csdio_device_id;
+	}
+
+	/*  prepare create /dev/... instance */
+	g_csdio.m_driver_class = class_create(THIS_MODULE, CSDIO_DEV_NAME);
+	if (IS_ERR(g_csdio.m_driver_class)) {
+		ret = -ENOMEM;
+		pr_err(CSDIO_DEV_NAME " class_create failed\n");
+		goto unregister_region;
+	}
+	g_csdio.m_driver_class->devnode = csdio_devnode;
+
+	/*  create CSDIO ctrl driver */
+	g_csdio.m_device = csdio_cdev_init(&g_csdio.m_cdev,
+		&csdio_ctrl_fops, csdio_minor, CSDIO_DEV_NAME, NULL);
+	if (!g_csdio.m_device) {
+		pr_err("%s: Unable to create ctrl driver\n",
+			CSDIO_DEV_NAME);
+		goto destroy_class;
+	}
+
+	g_sdio_buffer = kmalloc(CSDIO_SDIO_BUFFER_SIZE, GFP_KERNEL);
+	if (!g_sdio_buffer) {
+		pr_err("Unable to allocate %d bytes\n", CSDIO_SDIO_BUFFER_SIZE);
+		ret = -ENOMEM;
+		goto destroy_cdev;
+	}
+
+	ret = sysfs_create_group(&g_csdio.m_device->kobj, &dev_attr_grp);
+	if (ret) {
+		pr_err("%s: Unable to create device attribute\n",
+			CSDIO_DEV_NAME);
+		goto free_sdio_buff;
+	}
+
+	g_csdio.m_num_of_func = 0;
+	g_csdio.m_host = NULL;
+
+	if (NULL != host_name) {
+		struct device *dev = bus_find_device_by_name(&platform_bus_type,
+			NULL, host_name);
+		if (NULL != dev) {
+			g_csdio.m_host = dev_get_drvdata(dev);
+		} else {
+			pr_err("%s: Host '%s' doesn't exist!\n", CSDIO_DEV_NAME,
+				host_name);
+		}
+	}
+
+	pr_info("%s: Match with VendorId=0x%X, DeviceId=0x%X, Host = %s\n",
+		CSDIO_DEV_NAME, csdio_device_id, csdio_vendor_id,
+		(NULL == host_name) ? "Any" : host_name);
+
+	/* register sdio driver */
+	ret = sdio_register_driver(&csdio_driver);
+	if (ret) {
+		pr_err("%s: Unable to register as SDIO driver\n",
+			CSDIO_DEV_NAME);
+		goto remove_group;
+	}
+
+	goto exit;
+
+remove_group:
+	sysfs_remove_group(&g_csdio.m_device->kobj, &dev_attr_grp);
+free_sdio_buff:
+	kfree(g_sdio_buffer);
+destroy_cdev:
+	cdev_del(&g_csdio.m_cdev);
+destroy_class:
+	class_destroy(g_csdio.m_driver_class);
+unregister_region:
+	unregister_chrdev_region(devno, csdio_transport_nr_devs);
+exit:
+	return ret;
+}
+module_param(csdio_vendor_id, uint, S_IRUGO);
+module_param(csdio_device_id, uint, S_IRUGO);
+module_param(host_name, charp, S_IRUGO);
+
+module_init(csdio_init);
+module_exit(csdio_exit);
+
+MODULE_AUTHOR("Code Aurora Forum");
+MODULE_DESCRIPTION("CSDIO device driver version " VERSION);
+MODULE_VERSION(VERSION);
+MODULE_LICENSE("GPL v2");
--- /dev/null
+++ b/include/linux/csdio.h
@@ -0,0 +1,37 @@
+#ifndef CSDIO_H
+#define CSDIO_H
+
+#include <linux/ioctl.h>
+
+#define CSDIO_IOC_MAGIC  'm'
+
+#define CSDIO_IOC_ENABLE_HIGHSPEED_MODE      _IO(CSDIO_IOC_MAGIC, 0)
+#define CSDIO_IOC_SET_DATA_TRANSFER_CLOCKS   _IO(CSDIO_IOC_MAGIC, 1)
+#define CSDIO_IOC_SET_OP_CODE                _IO(CSDIO_IOC_MAGIC, 2)
+#define CSDIO_IOC_FUNCTION_SET_BLOCK_SIZE    _IO(CSDIO_IOC_MAGIC, 3)
+#define CSDIO_IOC_SET_BLOCK_MODE             _IO(CSDIO_IOC_MAGIC, 4)
+#define CSDIO_IOC_CONNECT_ISR                _IO(CSDIO_IOC_MAGIC, 5)
+#define CSDIO_IOC_DISCONNECT_ISR             _IO(CSDIO_IOC_MAGIC, 6)
+#define CSDIO_IOC_CMD52                      _IO(CSDIO_IOC_MAGIC, 7)
+#define CSDIO_IOC_CMD53                      _IO(CSDIO_IOC_MAGIC, 8)
+#define CSDIO_IOC_ENABLE_ISR                 _IO(CSDIO_IOC_MAGIC, 9)
+#define CSDIO_IOC_DISABLE_ISR                _IO(CSDIO_IOC_MAGIC, 10)
+#define CSDIO_IOC_SET_VDD                    _IO(CSDIO_IOC_MAGIC, 11)
+#define CSDIO_IOC_GET_VDD                    _IO(CSDIO_IOC_MAGIC, 12)
+
+#define CSDIO_IOC_MAXNR   12
+
+struct csdio_cmd53_ctrl_t {
+	uint32_t    m_block_mode;   /* data tran. byte(0)/block(1) mode */
+	uint32_t    m_op_code;      /* address auto increment flag */
+	uint32_t    m_address;
+} __attribute__ ((packed));
+
+struct csdio_cmd52_ctrl_t {
+	uint32_t    m_write;
+	uint32_t    m_address;
+	uint32_t    m_data;
+	uint32_t    m_ret;
+} __attribute__ ((packed));
+
+#endif
--- a/include/uapi/linux/Kbuild
+++ b/include/uapi/linux/Kbuild
@@ -86,6 +86,7 @@ header-y += coff.h
 header-y += connector.h
 header-y += const.h
 header-y += cramfs_fs.h
+header-y += csdio.h
 header-y += cuda.h
 header-y += cyclades.h
 header-y += cycx_cfm.h
