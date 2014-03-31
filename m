Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbaCaKIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 06:08:14 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:43374 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006AbaCaKIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 06:08:12 -0400
From: Daeseok Youn <daeseok.youn@gmail.com>
To: konrad.wilk@oracle.com
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com, joe@perches.com,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH] xen: fix memory leak in __xen_pcibk_add_pci_dev()
Date: Mon, 31 Mar 2014 19:08:06 +0900
Message-ID: <2186395.ZOncrV6nFS@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It need to free dev_entry when it failed to assign to a new
slot on the virtual PCI bus.

smatch says:
 drivers/xen/xen-pciback/vpci.c:142 __xen_pcibk_add_pci_dev() warn:
possible memory leak of 'dev_entry'

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/xen/xen-pciback/vpci.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/xen/xen-pciback/vpci.c b/drivers/xen/xen-pciback/vpci.c
index 3165ce3..657e50f 100644
--- a/drivers/xen/xen-pciback/vpci.c
+++ b/drivers/xen/xen-pciback/vpci.c
@@ -130,6 +130,7 @@ static int __xen_pcibk_add_pci_dev(struct xen_pcibk_device *pdev,
 	err = -ENOMEM;
 	xenbus_dev_fatal(pdev->xdev, err,
 			 "No more space on root virtual PCI bus");
+	kfree(dev_entry);
 
 unlock:
 	mutex_unlock(&vpci_dev->lock);
-- 
1.7.4.4


