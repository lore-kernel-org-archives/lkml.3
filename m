Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbaILSED (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:04:03 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:56999 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbaILSD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:03:58 -0400
Subject: [PATCH v1 10/13] PCI: Preserve BIOS PCI_COMMAND_SERR and
 PCI_COMMAND_PARITY settings
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rajat Jain <rajatxjain@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Date: Fri, 12 Sep 2014 12:03:54 -0600
Message-ID: <20140912180354.1630.57838.stgit@bhelgaas-glaptop2.roam.corp.google.com>
In-Reply-To: <20140912180141.1630.17120.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20140912180141.1630.17120.stgit@bhelgaas-glaptop2.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not clear PCI_COMMAND_SERR or PCI_COMMAND_PARITY based on _HPP.  The
spec (ACPI rev 5.0, sec 6.2.7) says that when "Enable SERR" is set to 1,
we should enable SERR in the command register.  It says nothing about
*disabling* SERR or PERR; in fact, the example in 6.2.7.1 says we should
leave PERR alone unless "Enable PERR" is 1.

For hot-added devices, this probably doesn't matter because they power up
with these bits cleared.  But in addition to hot-plugged devices, the spec
allows the platform to use _HPP for "configuration of PCI devices not
configured by the BIOS at system boot," and it may make a difference for
devices present at boot.

This change means that if BIOS enables SERR or PERR on a device, and it
supplies _HPP or _HPX with the SERR or PERR bits *cleared*, we will leave
SERR or PERR reporting enabled on that device instead of disabling it.

See also 40abb96c51bb ("pciehp: Fix programming hotplug parameters"), where
this code was first added.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/probe.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 003d112a783d..a16b3472b70d 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1264,12 +1264,8 @@ static void program_hpp_type0(struct pci_dev *dev, struct hpp_type0 *hpp)
 	pci_read_config_word(dev, PCI_COMMAND, &pci_cmd);
 	if (hpp->enable_serr)
 		pci_cmd |= PCI_COMMAND_SERR;
-	else
-		pci_cmd &= ~PCI_COMMAND_SERR;
 	if (hpp->enable_perr)
 		pci_cmd |= PCI_COMMAND_PARITY;
-	else
-		pci_cmd &= ~PCI_COMMAND_PARITY;
 	pci_write_config_word(dev, PCI_COMMAND, pci_cmd);
 
 	/* Program bridge control value */
@@ -1279,12 +1275,8 @@ static void program_hpp_type0(struct pci_dev *dev, struct hpp_type0 *hpp)
 		pci_read_config_word(dev, PCI_BRIDGE_CONTROL, &pci_bctl);
 		if (hpp->enable_serr)
 			pci_bctl |= PCI_BRIDGE_CTL_SERR;
-		else
-			pci_bctl &= ~PCI_BRIDGE_CTL_SERR;
 		if (hpp->enable_perr)
 			pci_bctl |= PCI_BRIDGE_CTL_PARITY;
-		else
-			pci_bctl &= ~PCI_BRIDGE_CTL_PARITY;
 		pci_write_config_word(dev, PCI_BRIDGE_CONTROL, pci_bctl);
 	}
 }

