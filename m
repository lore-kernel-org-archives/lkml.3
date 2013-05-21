Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab3EUKlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 06:41:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:23781 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940Ab3EUKkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 06:40:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,713,1363158000"; 
   d="scan'208";a="305622766"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: linux-usb@vger.kernel.org
Cc: <sarah.a.sharp@intel.com>, <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [RFC PATCH v2 4/4] usb: add usb2 Link PM variables to sysfs and usb_device
Date: Tue, 21 May 2013 13:43:37 +0300
Message-Id: <1369133017-3035-5-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1369133017-3035-1-git-send-email-mathias.nyman@linux.intel.com>
References: <1369133017-3035-1-git-send-email-mathias.nyman@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds abitilty to tune L1 timeout (inactivity timer for usb2 link sleep)
and BESL (best effort service latency)via sysfs.

This also adds a new usb2_lpm_parameters structure with those variables to
struct usb_device.

Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
---
 drivers/usb/core/sysfs.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/usb/host/xhci.c  |    6 +++-
 include/linux/usb.h      |   17 ++++++++++++++
 3 files changed, 75 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
index aa38db4..62dc4c7 100644
--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -497,8 +497,62 @@ set_usb2_hardware_lpm(struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR(usb2_hardware_lpm, S_IRUGO | S_IWUSR, show_usb2_hardware_lpm,
 			set_usb2_hardware_lpm);
 
+static ssize_t
+show_usb2_lpm_l1_timeout(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct usb_device *udev = to_usb_device(dev);
+	return sprintf(buf, "%d\n", udev->l1_params.timeout);
+}
+
+static ssize_t
+set_usb2_lpm_l1_timeout(struct device *dev, struct device_attribute *attr,
+			const char *buf, size_t count)
+{
+	struct usb_device *udev = to_usb_device(dev);
+	u8 timeout;
+
+	if (kstrtou8(buf, 0, &timeout))
+		return -EINVAL;
+
+	udev->l1_params.timeout = timeout;
+
+	return count;
+}
+
+static DEVICE_ATTR(usb2_lpm_l1_timeout, S_IRUGO | S_IWUSR,
+		   show_usb2_lpm_l1_timeout, set_usb2_lpm_l1_timeout);
+
+static ssize_t
+show_usb2_lpm_besl(struct device *dev, struct device_attribute *attr,
+		   char *buf)
+{
+	struct usb_device *udev = to_usb_device(dev);
+	return sprintf(buf, "%d\n", udev->l1_params.besl);
+}
+
+static ssize_t
+set_usb2_lpm_besl(struct device *dev, struct device_attribute *attr,
+		const char *buf, size_t count)
+{
+	struct usb_device *udev = to_usb_device(dev);
+	u8 besl;
+
+	if (kstrtou8(buf, 0, &besl) || besl > 15)
+		return -EINVAL;
+
+	udev->l1_params.besl = besl;
+
+	return count;
+}
+
+static DEVICE_ATTR(usb2_lpm_besl, S_IRUGO | S_IWUSR,
+		   show_usb2_lpm_besl, set_usb2_lpm_besl);
+
 static struct attribute *usb2_hardware_lpm_attr[] = {
 	&dev_attr_usb2_hardware_lpm.attr,
+	&dev_attr_usb2_lpm_l1_timeout.attr,
+	&dev_attr_usb2_lpm_besl.attr,
 	NULL,
 };
 static struct attribute_group usb2_hardware_lpm_attr_group = {
diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 22932d9..da4215f 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -3900,7 +3900,7 @@ static int xhci_calculate_hird_besl(struct xhci_hcd *xhci,
 static int xhci_calculate_usb2_hw_lpm_params(struct usb_device *udev)
 {
 	u32 field;
-	int l1 =  XHCI_L1_TIMEOUT;
+	int l1 =  udev->l1_params.timeout;
 	int besld = 0;
 	int hirdm = 0;
 
@@ -4088,7 +4088,7 @@ int xhci_set_usb2_hardware_lpm(struct usb_hcd *hcd,
 			    (field & USB_BESL_BASELINE_VALID))
 				hird = USB_GET_BESL_BASELINE(field);
 			else
-				hird = XHCI_DEFAULT_BESL;
+				hird = udev->l1_params.besl;
 
 			exit_latency = xhci_besl_encoding[hird];
 			spin_unlock_irqrestore(&xhci->lock, flags);
@@ -4178,6 +4178,8 @@ int xhci_update_device(struct usb_hcd *hcd, struct usb_device *udev)
 		if (xhci->hw_lpm_support == 1 &&
 		    xhci_check_usb2_port_capability(xhci, portnum, XHCI_HLC)) {
 			udev->usb2_hw_lpm_capable = 1;
+			udev->l1_params.timeout = XHCI_L1_TIMEOUT;
+			udev->l1_params.besl = XHCI_DEFAULT_BESL;
 			if (xhci_check_usb2_port_capability(xhci, portnum,
 							    XHCI_BLC))
 				udev->usb2_hw_lpm_besl_capable = 1;
diff --git a/include/linux/usb.h b/include/linux/usb.h
index 3a1b864..08f6c63 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -394,6 +394,21 @@ enum usb_port_connect_type {
 };
 
 /*
+ * USB 2.0 Link Power Management (LPM) parameters.
+ */
+struct usb2_lpm_parameters {
+	/* Best effort service latency indicate how long the host will drive
+	 * resume on an exit from L1.
+	 */
+	unsigned int besl;
+
+	/* Timeout value for the L1 inactivity timer (LPM Timer). When the timer
+	 * counts to zero, the parent hub will initiate an LPM transition to L1.
+	 */
+	int timeout;
+};
+
+/*
  * USB 3.0 Link Power Management (LPM) parameters.
  *
  * PEL and SEL are USB 3.0 Link PM latencies for device-initiated LPM exit.
@@ -488,6 +503,7 @@ struct usb3_lpm_parameters {
  *	specific data for the device.
  * @slot_id: Slot ID assigned by xHCI
  * @removable: Device can be physically removed from this port
+ * @l1_params: best effor service latency for USB2 L1 LPM state, and L1 timeout.
  * @u1_params: exit latencies for USB3 U1 LPM state, and hub-initiated timeout.
  * @u2_params: exit latencies for USB3 U2 LPM state, and hub-initiated timeout.
  * @lpm_disable_count: Ref count used by usb_disable_lpm() and usb_enable_lpm()
@@ -568,6 +584,7 @@ struct usb_device {
 	struct wusb_dev *wusb_dev;
 	int slot_id;
 	enum usb_device_removable removable;
+	struct usb2_lpm_parameters l1_params;
 	struct usb3_lpm_parameters u1_params;
 	struct usb3_lpm_parameters u2_params;
 	unsigned lpm_disable_count;
-- 
1.7.4.1

