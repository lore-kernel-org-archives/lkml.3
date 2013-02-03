Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab3BCO6r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:58:47 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34669 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753072Ab3BCO6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:58:44 -0500
Message-Id: <20130203144654.635190691@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:44 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Ian Abbott <abbotti@mev.co.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 120/128] staging: comedi: dont hijack hardware device private data
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Abbott <abbotti@mev.co.uk>

commit c43435d7722134ed1fda58ce1025f41029bd58ad upstream.

comedi_auto_config() associates a Comedi minor device number with an
auto-configured hardware device and comedi_auto_unconfig() disassociates
it.  Currently, these use the hardware device's private data pointer to
point to some allocated storage holding the minor device number.  This
is a bit of a waste of the hardware device's private data pointer,
preventing it from being used for something more useful by the low-level
comedi device drivers.  For example, it would make more sense if
comedi_usb_auto_config() was passed a pointer to the struct
usb_interface instead of the struct usb_device, but this cannot be done
currently because the low-level comedi drivers already use the private
data pointer in the struct usb_interface for something more useful.

This patch stops the comedi core hijacking the hardware device's private
data pointer.  Instead, comedi_auto_config() stores a pointer to the
hardware device's struct device in the struct comedi_device_file_info
associated with the minor device number, and comedi_auto_unconfig()
calls new function comedi_find_board_minor() to recover the minor device
number associated with the hardware device.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/comedi/comedi_fops.c |   18 ++++++++++++++++++
 drivers/staging/comedi/comedidev.h   |    1 +
 drivers/staging/comedi/drivers.c     |   34 ++++++++++------------------------
 drivers/staging/comedi/internal.h    |    1 +
 4 files changed, 30 insertions(+), 24 deletions(-)

--- a/drivers/staging/comedi/comedi_fops.c
+++ b/drivers/staging/comedi/comedi_fops.c
@@ -2207,6 +2207,7 @@ int comedi_alloc_board_minor(struct devi
 		kfree(info);
 		return -ENOMEM;
 	}
+	info->hardware_device = hardware_device;
 	comedi_device_init(info->device);
 	spin_lock_irqsave(&comedi_file_info_table_lock, flags);
 	for (i = 0; i < COMEDI_NUM_BOARD_MINORS; ++i) {
@@ -2295,6 +2296,23 @@ void comedi_free_board_minor(unsigned mi
 	}
 }
 
+int comedi_find_board_minor(struct device *hardware_device)
+{
+	int minor;
+	struct comedi_device_file_info *info;
+
+	for (minor = 0; minor < COMEDI_NUM_BOARD_MINORS; minor++) {
+		spin_lock(&comedi_file_info_table_lock);
+		info = comedi_file_info_table[minor];
+		if (info && info->hardware_device == hardware_device) {
+			spin_unlock(&comedi_file_info_table_lock);
+			return minor;
+		}
+		spin_unlock(&comedi_file_info_table_lock);
+	}
+	return -ENODEV;
+}
+
 int comedi_alloc_subdevice_minor(struct comedi_device *dev,
 				 struct comedi_subdevice *s)
 {
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -234,6 +234,7 @@ struct comedi_device_file_info {
 	struct comedi_device *device;
 	struct comedi_subdevice *read_subdevice;
 	struct comedi_subdevice *write_subdevice;
+	struct device *hardware_device;
 };
 
 #ifdef CONFIG_COMEDI_DEBUG
--- a/drivers/staging/comedi/drivers.c
+++ b/drivers/staging/comedi/drivers.c
@@ -823,25 +823,14 @@ static int comedi_auto_config(struct dev
 	int minor;
 	struct comedi_device_file_info *dev_file_info;
 	int retval;
-	unsigned *private_data = NULL;
 
-	if (!comedi_autoconfig) {
-		dev_set_drvdata(hardware_device, NULL);
+	if (!comedi_autoconfig)
 		return 0;
-	}
 
 	minor = comedi_alloc_board_minor(hardware_device);
 	if (minor < 0)
 		return minor;
 
-	private_data = kmalloc(sizeof(unsigned), GFP_KERNEL);
-	if (private_data == NULL) {
-		retval = -ENOMEM;
-		goto cleanup;
-	}
-	*private_data = minor;
-	dev_set_drvdata(hardware_device, private_data);
-
 	dev_file_info = comedi_get_device_file_info(minor);
 
 	memset(&it, 0, sizeof(it));
@@ -854,25 +843,22 @@ static int comedi_auto_config(struct dev
 	retval = comedi_device_attach(dev_file_info->device, &it);
 	mutex_unlock(&dev_file_info->device->mutex);
 
-cleanup:
-	if (retval < 0) {
-		kfree(private_data);
+	if (retval < 0)
 		comedi_free_board_minor(minor);
-	}
 	return retval;
 }
 
 static void comedi_auto_unconfig(struct device *hardware_device)
 {
-	unsigned *minor = (unsigned *)dev_get_drvdata(hardware_device);
-	if (minor == NULL)
-		return;
-
-	BUG_ON(*minor >= COMEDI_NUM_BOARD_MINORS);
+	int minor;
 
-	comedi_free_board_minor(*minor);
-	dev_set_drvdata(hardware_device, NULL);
-	kfree(minor);
+	if (hardware_device == NULL)
+		return;
+	minor = comedi_find_board_minor(hardware_device);
+	if (minor < 0)
+		return;
+	BUG_ON(minor >= COMEDI_NUM_BOARD_MINORS);
+	comedi_free_board_minor(minor);
 }
 
 int comedi_pci_auto_config(struct pci_dev *pcidev, const char *board_name)
--- a/drivers/staging/comedi/internal.h
+++ b/drivers/staging/comedi/internal.h
@@ -7,6 +7,7 @@ int insn_inval(struct comedi_device *dev
 	       struct comedi_insn *insn, unsigned int *data);
 int comedi_alloc_board_minor(struct device *hardware_device);
 void comedi_free_board_minor(unsigned minor);
+int comedi_find_board_minor(struct device *hardware_device);
 void comedi_reset_async_buf(struct comedi_async *async);
 int comedi_buf_alloc(struct comedi_device *dev, struct comedi_subdevice *s,
 		     unsigned long new_size);


