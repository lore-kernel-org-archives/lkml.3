Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab3FJVIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 17:08:45 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:40283 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab3FJVIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 17:08:21 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: george.dunlap@eu.citrix.com, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] xen/pci: Deal with toolstack missing an 'XenbusStateClosing'.
Date: Mon, 10 Jun 2013 17:06:39 -0400
Message-Id: <1370898399-20968-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1370898399-20968-1-git-send-email-konrad.wilk@oracle.com>
References: <20130610202456.GA17822@phenom.dumpdata.com>
 <1370898399-20968-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two tool-stack that can instruct the Xen PCI frontend
and backend to change states: 'xm' (Python code with a daemon),
and 'xl' (C library - does not keep state changes).

With the 'xm', the path to disconnect a PCI device (xm pci-detach
<guest> <BDF>)is:

4(Connected)->7(Reconfiguring*)-> 8(Reconfigured)-> 4(Connected)->5(Closing*).

The * is for states that the tool-stack sets. For 'xl', it is similar:

4(Connected)->7(Reconfiguring*)-> 8(Reconfigured)-> 4(Connected)

Both of them also tear down the XenBus structure, so the backend
state ends up going in the 3(Initialised) and calls pcifront_xenbus_remove.

When a PCI device is plugged in (xm pci-attach <guest> <BDF>)
both of them follow the same pattern:
2(InitWait*), 3(Initialized*), 4(Connected*)->4(Connected).

[xen-pcifront ignores the 2,3 state changes and only acts when
4 (Connected) has been reached]

The problem is that git commit 3d925320e9e2de162bd138bf97816bda8c3f71be
("xen/pcifront: Use Xen-SWIOTLB when initting if required") introduced
a mechanism to initialize the SWIOTLB when the Xen PCI front moves to
Connected state. It also had some aggressive seatbelt code check that
would warn the user if one tried to change to Connected state without
hitting first the Closing state:

 pcifront pci-0: PCI frontend already installed!

However, that code can be relaxed and we can continue on working
even if the frontend is instructed to be the 'Connected' state with
no devices and then gets tickled to be in 'Connected' state again.

In other words, this 4(Connected)->5(Closing)->4(Connected) state
was expected, while 4(Connected)->.... anything but 5(Closing)->4(Connected)
was not. This patch removes that aggressive check and allows
Xen pcifront to work with the 'xl' toolstack.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/pci/xen-pcifront.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index ac99515..cc46e253 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -675,10 +675,9 @@ static int pcifront_connect_and_init_dma(struct pcifront_device *pdev)
 	if (!pcifront_dev) {
 		dev_info(&pdev->xdev->dev, "Installing PCI frontend\n");
 		pcifront_dev = pdev;
-	} else {
-		dev_err(&pdev->xdev->dev, "PCI frontend already installed!\n");
+	} else
 		err = -EEXIST;
-	}
+
 	spin_unlock(&pcifront_dev_lock);
 
 	if (!err && !swiotlb_nr_tbl()) {
@@ -846,7 +845,7 @@ static int pcifront_try_connect(struct pcifront_device *pdev)
 		goto out;
 
 	err = pcifront_connect_and_init_dma(pdev);
-	if (err) {
+	if (err && err != -EEXIST) {
 		xenbus_dev_fatal(pdev->xdev, err,
 				 "Error setting up PCI Frontend");
 		goto out;
-- 
1.8.1.4

