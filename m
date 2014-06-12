Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905AbaFLXbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:31:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbaFLXR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:17:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexei Starovoitov <ast@plumgrid.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Neil Horman <nhorman@tuxdriver.com>
Subject: [PATCH 3.15 04/12] PCI/MSI: Fix memory leak in free_msi_irqs()
Date: Thu, 12 Jun 2014 16:21:06 -0700
Message-Id: <20140612232045.075678429@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140612232044.886466924@linuxfoundation.org>
References: <20140612232044.886466924@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@plumgrid.com>

commit b701c0b1fe819a2083fc6ec5332e0e4492b9516d upstream.

free_msi_irqs() is leaking memory, since list_for_each_entry(entry,
&dev->msi_list, list) {...} is never executed, because dev->msi_list is
made empty by the loop just above this one.

Fix it by relying on zero termination of attribute array like
populate_msi_sysfs() does.

Fixes: 1c51b50c2995 ("PCI/MSI: Export MSI mode using attributes, not kobjects")
Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/msi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -414,7 +414,7 @@ static void free_msi_irqs(struct pci_dev
 	if (dev->msi_irq_groups) {
 		sysfs_remove_groups(&dev->dev.kobj, dev->msi_irq_groups);
 		msi_attrs = dev->msi_irq_groups[0]->attrs;
-		list_for_each_entry(entry, &dev->msi_list, list) {
+		while (msi_attrs[count]) {
 			dev_attr = container_of(msi_attrs[count],
 						struct device_attribute, attr);
 			kfree(dev_attr->attr.name);


