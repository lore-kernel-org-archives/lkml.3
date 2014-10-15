Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbaJOTFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 15:05:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751268AbaJOTFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 15:05:39 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Myron Stowe <mstowe@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Subject: [PATCH] pci, add sysfs numa_node write function
Date: Wed, 15 Oct 2014 15:05:24 -0400
Message-Id: <1413399924-599-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Consider a multi-node, multiple pci root bridge system which can be
configured into one large node or one node/socket.  When configuring the
system the numa_node value for each PCI root bridge is always set
incorrectly to -1, or NUMA_NO_NODE, rather than to the node value of each
socket.  Each PCI device inherits the numa value directly from it's parent
device, so that the NUMA_NO_NODE value is passed through the entire PCI
tree.

Some new drivers, such as the Intel QAT driver, drivers/crypto/qat,
require that a specific node be assigned to the device in order to
achieve maximum performance for the device, and will fail to load if the
device has NUMA_NO_NODE.  The driver would load if the numa_node value
was equal to or greater than -1 and quickly hacking the driver results in
a functional QAT driver.

Using lspci and numactl it is easy to determine what the numa value should
be.  The problem is that there is no way to set it.  This patch adds a
store function for the PCI device's numa_node value.

To use this, one can do

echo 3 > /sys/devices/pci0000:ff/0000:ff:1f.3/numa_node

to set the numa node for PCI device 0000:ff:1f.3.

Cc: Myron Stowe <mstowe@redhat.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/pci/pci-sysfs.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 92b6d9a..c05ed30 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -221,12 +221,33 @@ static ssize_t enabled_show(struct device *dev, struct device_attribute *attr,
 static DEVICE_ATTR_RW(enabled);
 
 #ifdef CONFIG_NUMA
+static ssize_t numa_node_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
+{
+	int node, ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	ret = kstrtoint(buf, 0, &node);
+	if (ret)
+		return ret;
+
+	if (!node_online(node))
+		return -EINVAL;
+
+	dev->numa_node = node;
+
+	return count;
+}
+
 static ssize_t numa_node_show(struct device *dev, struct device_attribute *attr,
 			      char *buf)
 {
 	return sprintf(buf, "%d\n", dev->numa_node);
 }
-static DEVICE_ATTR_RO(numa_node);
+static DEVICE_ATTR_RW(numa_node);
 #endif
 
 static ssize_t dma_mask_bits_show(struct device *dev,
-- 
1.7.9.3

