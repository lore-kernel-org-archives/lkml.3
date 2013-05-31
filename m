Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab3EaL7d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:59:33 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:55879 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab3EaL7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:59:22 -0400
MIME-Version: 1.0
Date: Fri, 31 May 2013 19:59:20 +0800
Message-ID: <CAPgLHd89ByaKLsvu=C-im9cg=7X7jNANuS+BaHt_EGotc-8hmA@mail.gmail.com>
Subject: [PATCH] xen-pciback: fix error return code in pcistub_irq_handler_switch()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: konrad.wilk@oracle.com, jeremy@goop.org, jbeulich@suse.com,
        shemminger@vyatta.com, gregkh@linuxfoundation.org, jkosina@suse.cz
Cc: yongjun_wei@trendmicro.com.cn, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOENT in the pcistub_device_find() and pci_get_drvdata()
error handling case instead of 0(overwrite to 0 by str_to_slot()), as done
elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/xen/xen-pciback/pci_stub.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/xen-pciback/pci_stub.c b/drivers/xen/xen-pciback/pci_stub.c
index 4e8ba38..0020899 100644
--- a/drivers/xen/xen-pciback/pci_stub.c
+++ b/drivers/xen/xen-pciback/pci_stub.c
@@ -1196,19 +1196,23 @@ static ssize_t pcistub_irq_handler_switch(struct device_driver *drv,
 	struct pcistub_device *psdev;
 	struct xen_pcibk_dev_data *dev_data;
 	int domain, bus, slot, func;
-	int err = -ENOENT;
+	int err;
 
 	err = str_to_slot(buf, &domain, &bus, &slot, &func);
 	if (err)
 		return err;
 
 	psdev = pcistub_device_find(domain, bus, slot, func);
-	if (!psdev)
+	if (!psdev) {
+		err = -ENOENT;
 		goto out;
+	}
 
 	dev_data = pci_get_drvdata(psdev->dev);
-	if (!dev_data)
+	if (!dev_data) {
+		err = -ENOENT;
 		goto out;
+	}
 
 	dev_dbg(&psdev->dev->dev, "%s fake irq handler: %d->%d\n",
 		dev_data->irq_name, dev_data->isr_on,

