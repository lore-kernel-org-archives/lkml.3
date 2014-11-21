Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbaKUSYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:24:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55029 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbaKUSY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:24:29 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 4/4] PCI: quirk Atheros AR93xx to avoid bus reset
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Date: Fri, 21 Nov 2014 11:24:27 -0700
Message-ID: <20141121182427.26669.82417.stgit@gimli.home>
In-Reply-To: <20141121180322.26669.65689.stgit@gimli.home>
References: <20141121180322.26669.65689.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reports against the TL-WDN4800 card indicate that PCI bus reset of
this Atheros device cause system lock-ups and resets.  I've also
been able to confirm this behavior on multiple systems.  The device
never returns from reset and attempts to access config space of the
device after reset result in hangs.  Blacklist bus reset for the
device to avoid this issue.

Reported-by: Andreas Hartmann <andihartmann@freenet.de>
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Tested-by: Andreas Hartmann <andihartmann@freenet.de>
---

 drivers/pci/quirks.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 561e10d..ebbd5b4 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3029,6 +3029,20 @@ static void quirk_no_pm_reset(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_CLASS_HEADER(PCI_VENDOR_ID_ATI, PCI_ANY_ID,
 			       PCI_CLASS_DISPLAY_VGA, 8, quirk_no_pm_reset);
 
+static void quirk_no_bus_reset(struct pci_dev *dev)
+{
+	dev->dev_flags |= PCI_DEV_FLAGS_NO_BUS_RESET;
+}
+
+/*
+ * Atheros AR93xx chips do not behave after a bus reset.  The device will
+ * throw a Link Down error on AER capable system and regardless of AER,
+ * config space of the device is never accessible again and typically
+ * causes the system to hang or reset when access is attempted.
+ * http://www.spinics.net/lists/linux-pci/msg34797.html
+ */
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0030, quirk_no_bus_reset);
+
 #ifdef CONFIG_ACPI
 /*
  * Apple: Shutdown Cactus Ridge Thunderbolt controller.

