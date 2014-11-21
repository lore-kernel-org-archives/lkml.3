Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752013AbaKUSYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:24:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbaKUSYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:24:21 -0500
From: Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 2/4] PCI: quirk AMD/ATI VGA cards to avoid PM reset
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Date: Fri, 21 Nov 2014 11:24:14 -0700
Message-ID: <20141121182414.26669.48397.stgit@gimli.home>
In-Reply-To: <20141121180322.26669.65689.stgit@gimli.home>
References: <20141121180322.26669.65689.stgit@gimli.home>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some AMD/ATI GPUs report that they support PM reset (NoSoftRst-) but
initiating such a reset has no apparent affect on the device.  The
monitor remains sync'd, the framebuffer contents are retained, etc.
Callers of pci_reset_function() don't necessarily have a way to
validate whether a reset was effective, so we really want to avoid
making use of a known non-effective reset.  Returning an error in
such cases appears to be the better option.  For users like vfio-pci,
this allows the driver to escalate to the bus reset interfaces.

If a device lives on the root bus, there's really no further
escalation path, so we exempt PM reset as potentially better than
nothing.

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
---

 drivers/pci/quirks.c |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 90acb32..561e10d 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3008,6 +3008,27 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_REALTEK, 0x8169,
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MELLANOX, PCI_ANY_ID,
 			 quirk_broken_intx_masking);
 
+static void quirk_no_pm_reset(struct pci_dev *dev)
+{
+	/*
+	 * A non-effective PM reset may be better than nothing
+	 * if we can't do a bus reset
+	 */
+	if (!pci_is_root_bus(dev->bus))
+		dev->dev_flags |= PCI_DEV_FLAGS_NO_PM_RESET;
+}
+
+/*
+ * Some AMD/ATI GPUS (HD8570 - Oland) report supporting PM reset via D3->D0
+ * transition (NoSoftRst-).  This reset mechanims seems to have no effect
+ * whatsoever on the device, even retaining the framebuffer contents and
+ * monitor sync.  Advertising this support makes other layers, like VFIO
+ * assume pci_reset_function() is viable for this device.  Mark it as
+ * unavailable to skip it when testing reset methods.
+ */
+DECLARE_PCI_FIXUP_CLASS_HEADER(PCI_VENDOR_ID_ATI, PCI_ANY_ID,
+			       PCI_CLASS_DISPLAY_VGA, 8, quirk_no_pm_reset);
+
 #ifdef CONFIG_ACPI
 /*
  * Apple: Shutdown Cactus Ridge Thunderbolt controller.

