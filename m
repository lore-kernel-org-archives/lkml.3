Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaKBPMr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 10:12:47 -0500
Received: from mout.web.de ([212.227.15.3]:55494 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbaKBPMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 10:12:45 -0500
Message-ID: <545649DE.80304@users.sourceforge.net>
Date: Sun, 02 Nov 2014 16:12:30 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        linux-pci@vger.kernel.org
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org, kernel-janitors@vger.kernel.org,
        trivial@kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: [PATCH 1/1] PCI: Deletion of unnecessary checks before three function
 calls
References: <5307CAA2.8060406@users.sourceforge.net> <alpine.DEB.2.02.1402212321410.2043@localhost6.localdomain6> <530A086E.8010901@users.sourceforge.net> <alpine.DEB.2.02.1402231635510.1985@localhost6.localdomain6> <530A72AA.3000601@users.sourceforge.net> <alpine.DEB.2.02.1402240658210.2090@localhost6.localdomain6> <530B5FB6.6010207@users.sourceforge.net> <alpine.DEB.2.10.1402241710370.2074@hadrien> <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net>
In-Reply-To: <5317A59D.4@users.sourceforge.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:mmme/5mISXoTEOLR5mJV8zfK9+Vqh3VWA48bt8TnfGMcAYin+QQ
 1sOT+J1jGL6szQtmy+SmvVLSZDUKnOOqeeHjmPJoBzbqF1IqjRpymxQg75z2vLYBxmFmd1m
 r7uEzd7DksTk+ruu5PLvZ+nzSW3KXFtqX3KQgRXoaa4qBST/LhgAHHuFyOT2KQftRAmSPd0
 bxee34RUvwDhsfZf1X9pA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions pci_dev_put(), pci_pme_wakeup_bus() and put_device() test
whether their argument is NULL and then return immediately. Thus the test
around the call is not needed.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/pci/pci-acpi.c     | 3 +--
 drivers/pci/probe.c        | 3 +--
 drivers/pci/search.c       | 3 +--
 drivers/pci/xen-pcifront.c | 3 +--
 4 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/pci-acpi.c b/drivers/pci/pci-acpi.c
index 37263b0..a8fe5de 100644
--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -60,8 +60,7 @@ static void pci_acpi_wake_dev(struct work_struct *work)
 	pci_wakeup_event(pci_dev);
 	pm_runtime_resume(&pci_dev->dev);

-	if (pci_dev->subordinate)
-		pci_pme_wakeup_bus(pci_dev->subordinate);
+	pci_pme_wakeup_bus(pci_dev->subordinate);
 }

 /**
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 4170113..e93f16e 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -86,8 +86,7 @@ static void release_pcibus_dev(struct device *dev)
 {
 	struct pci_bus *pci_bus = to_pci_bus(dev);

-	if (pci_bus->bridge)
-		put_device(pci_bus->bridge);
+	put_device(pci_bus->bridge);
 	pci_bus_remove_resources(pci_bus);
 	pci_release_bus_of_node(pci_bus);
 	kfree(pci_bus);
diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index 827ad83..2d806bd 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -305,8 +305,7 @@ static struct pci_dev *pci_get_dev_by_id(const struct
pci_device_id *id,
 			      match_pci_dev_by_id);
 	if (dev)
 		pdev = to_pci_dev(dev);
-	if (from)
-		pci_dev_put(from);
+	pci_dev_put(from);
 	return pdev;
 }

diff --git a/drivers/pci/xen-pcifront.c b/drivers/pci/xen-pcifront.c
index 53df39a..46664cc 100644
--- a/drivers/pci/xen-pcifront.c
+++ b/drivers/pci/xen-pcifront.c
@@ -596,8 +596,7 @@ static pci_ers_result_t pcifront_common_process(int cmd,
 	pcidev = pci_get_bus_and_slot(bus, devfn);
 	if (!pcidev || !pcidev->driver) {
 		dev_err(&pdev->xdev->dev, "device or AER driver is NULL\n");
-		if (pcidev)
-			pci_dev_put(pcidev);
+		pci_dev_put(pcidev);
 		return result;
 	}
 	pdrv = pcidev->driver;
-- 
2.1.3


