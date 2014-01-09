Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753513AbaAIPgU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 10:36:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750912AbaAIPgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 10:36:12 -0500
Subject: [PATCH] pci/iov: VFs are never multifunction
From: Alex Williamson <alex.williamson@redhat.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: sathya.perla@emulex.com, linux-kernel@vger.kernel.org,
        ajit.khaparde@emulex.com, ddutile@redhat.com,
        subbu.seetharaman@emulex.com, myron.stowe@redhat.com
Date: Thu, 09 Jan 2014 08:36:08 -0700
Message-ID: <20140109153513.21446.31778.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Per the SR-IOV spec rev 1.1:

3.4.1.9 Header Type (Offset 0Eh)

"... For VFs, this register must be RO Zero."

Unfortunately some devices get this wrong, ex. Emulex OneConnect 10Gb
NIC.  When they do it makes us handle ACS testing and therefore IOMMU
groups as if they were actual multifunction devices and require ACS
capabilities to make sure there's no peer-to-peer between functions.
VFs are never traditional multifunction devices, so simply clear this
bit before we get any further into setup.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
---
 drivers/pci/iov.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index 1fe2d6f..e2fbb67 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -84,6 +84,7 @@ static int virtfn_add(struct pci_dev *dev, int id, int reset)
 	virtfn->dev.parent = dev->dev.parent;
 	virtfn->physfn = pci_dev_get(dev);
 	virtfn->is_virtfn = 1;
+	virtfn->multifunction = 0;
 
 	for (i = 0; i < PCI_SRIOV_NUM_BARS; i++) {
 		res = dev->resource + PCI_IOV_RESOURCES + i;

