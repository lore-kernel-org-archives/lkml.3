Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaILSE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 14:04:26 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:61562 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbaILSES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 14:04:18 -0400
Subject: [PATCH v1 13/13] PCI: Configure *all* devices,
 not just hot-added ones
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rajat Jain <rajatxjain@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Date: Fri, 12 Sep 2014 12:04:16 -0600
Message-ID: <20140912180415.1630.57583.stgit@bhelgaas-glaptop2.roam.corp.google.com>
In-Reply-To: <20140912180141.1630.17120.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20140912180141.1630.17120.stgit@bhelgaas-glaptop2.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's not really a good way to determine whether firmware has already
configured a device with _HPP/_HPX settings.  On legacy systems, the BIOS
has probably configured everything, but on UEFI systems it is not required
to do so.

Per the PCI Firmware Specification, rev 3.1, sec 3.5, if PCI_COMMAND_IO or
PCI_COMMAND_MEMORY is set, we can assume firmware has set the corresponding
BARs and maybe we can assume it has configured the rest of the device.  And
if a bridge has PCI_COMMAND_PARITY or PCI_COMMAND_SERR set, we can assume
firmware has configured the bridge.  But we can't tell much about devices
without BARs.

I think it should be safe to apply _HPP and _HPX settings anyway, even if
firmware has already configured the device, so configure everything we
find.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/probe.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index cb411fbb6435..290c657da0b9 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1358,9 +1358,6 @@ static void pci_configure_device(struct pci_dev *dev)
 	struct hotplug_params hpp;
 	int ret;
 
-	if (system_state == SYSTEM_BOOTING)
-		return;
-
 	memset(&hpp, 0, sizeof(hpp));
 	ret = pci_get_hp_params(dev, &hpp);
 	if (ret)

