Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567AbaFAQN5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 12:13:57 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:59804 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752335AbaFAQN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 12:13:56 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: andreas.noever@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, greg@kroah.com,
        bhelgaas@google.com, Matthew Garrett <matthew.garrett@nebula.com>
Date: Sun,  1 Jun 2014 12:13:43 -0400
Message-Id: <1401639223-3441-1-git-send-email-matthew.garrett@nebula.com>
X-Mailer: git-send-email 2.0.0
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.207.143
X-SA-Exim-Mail-From: matthew.garrett@nebula.com
X-Spam-ASN: 
Subject: [PATCH] Thunderbolt: Add support for Thunderbolt 2 host controllers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:54:46 +0000)
X-SA-Exim-Scanned: Yes (on cavan.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding extra device IDs is enough to get this working on the second-gen
Thunderbolt controller in the Mac Pro.

Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>
---
 drivers/pci/quirks.c         | 2 ++
 drivers/thunderbolt/nhi.c    | 5 +++++
 drivers/thunderbolt/switch.c | 5 ++++-
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index c3170d4..20e76d0 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3083,6 +3083,8 @@ out:
 }
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_INTEL, 0x1547,
 			       quirk_apple_wait_for_thunderbolt);
+DECLARE_PCI_FIXUP_SUSPEND_LATE(PCI_VENDOR_ID_INTEL, 0x156d,
+			       quirk_apple_wait_for_thunderbolt);
 #endif
 
 static void pci_do_fixups(struct pci_dev *dev, struct pci_fixup *f,
diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index 6f666fa..85b11d6 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -642,6 +642,11 @@ struct pci_device_id nhi_ids[] = {
 		.vendor = PCI_VENDOR_ID_INTEL, .device = 0x1547,
 		.subvendor = 0x2222, .subdevice = 0x1111,
 	},
+	{
+		.class = PCI_CLASS_SYSTEM_OTHER << 8, .class_mask = ~0,
+		.vendor = PCI_VENDOR_ID_INTEL, .device = 0x156c,
+		.subvendor = 0x2222, .subdevice = 0x1111,
+	},
 	{ 0,}
 };
 
diff --git a/drivers/thunderbolt/switch.c b/drivers/thunderbolt/switch.c
index 2e19045..1fccdbf 100644
--- a/drivers/thunderbolt/switch.c
+++ b/drivers/thunderbolt/switch.c
@@ -294,8 +294,11 @@ static int tb_plug_events_active(struct tb_switch *sw, bool active)
 
 	if (active) {
 		data = data & 0xFFFFFF83;
-		if (sw->config.device_id == 0x1547)
+		switch (sw->config.device_id) {
+		case 0x1547:
+		case 0x156d:
 			data |= 4;
+		}
 	} else {
 		data = data | 0x7c;
 	}
-- 
2.0.0

