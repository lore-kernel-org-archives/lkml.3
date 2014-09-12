Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443AbaILSDy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:03:54 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:40697 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378AbaILSDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:03:50 -0400
Subject: [PATCH v1 09/13] PCI: Apply _HPP settings to PCIe devices as well
 as PCI and PCI-X
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rajat Jain <rajatxjain@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Date: Fri, 12 Sep 2014 12:03:48 -0600
Message-ID: <20140912180348.1630.24201.stgit@bhelgaas-glaptop2.roam.corp.google.com>
In-Reply-To: <20140912180141.1630.17120.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20140912180141.1630.17120.stgit@bhelgaas-glaptop2.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ACPI _HPP method was defined before PCIe existed, so its documentation
only mentions PCI.  The _HPX Type 0 setting record is essentially identical
to _HPP, but the spec (ACPI rev 5.0, sec 6.2.8.1) says it should be applied
to PCI, PCI-X, and PCIe devices, with settings being ignored if they are
not applicable.

Some platforms with both conventional PCI and PCIe devices provide only
_HPP (not _HPX), so treat _HPP the same way as an _HPX Type 0 record and
apply it to PCIe devices as well as PCI and PCI-X.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/probe.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 4b3b29bc7a82..003d112a783d 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1249,15 +1249,8 @@ static void program_hpp_type0(struct pci_dev *dev, struct hpp_type0 *hpp)
 {
 	u16 pci_cmd, pci_bctl;
 
-	if (!hpp) {
-		/*
-		 * Perhaps we *should* use default settings for PCIe, but
-		 * pciehp didn't, so we won't either.
-		 */
-		if (pci_is_pcie(dev))
-			return;
+	if (!hpp)
 		hpp = &pci_default_type0;
-	}
 
 	if (hpp->revision > 1) {
 		dev_warn(&dev->dev,

