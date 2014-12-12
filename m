Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760206AbaLLG47 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:56:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51749 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758680AbaLLGQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:54 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Tomas Winkler" <tomas.winkler@intel.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.62808724@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 158/164] mei: add mei_quirk_probe function
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Winkler <tomas.winkler@intel.com>

commit 9a123f19832702753805afe0e93db26799b91b07 upstream.

The main purpose of this function is to exclude ME devices
without support for MEI/HECI interface from binding

Currently affected systems are C600/X79 based servers
that expose PCI device even though it doesn't supported ME Interface.
MEI driver accessing such nonfunctional device can corrupt
the system.

[Backported to 3.2: files were moved]
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/staging/mei/main.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/staging/mei/main.c b/drivers/staging/mei/main.c
index eb05c36f45d4..44ed7a859ecd 100644
--- a/drivers/staging/mei/main.c
+++ b/drivers/staging/mei/main.c
@@ -106,6 +106,27 @@ MODULE_DEVICE_TABLE(pci, mei_pci_tbl);
 static DEFINE_MUTEX(mei_mutex);
 
 /**
+ * mei_quirk_probe - probe for devices that doesn't valid ME interface
+ * @pdev: PCI device structure
+ * @ent: entry into pci_device_table
+ *
+ * returns true if ME Interface is valid, false otherwise
+ */
+static bool __devinit mei_quirk_probe(struct pci_dev *pdev,
+				const struct pci_device_id *ent)
+{
+	u32 reg;
+	if (ent->device == MEI_DEV_ID_PBG_1) {
+		pci_read_config_dword(pdev, 0x48, &reg);
+		/* make sure that bit 9 is up and bit 10 is down */
+		if ((reg & 0x600) == 0x200) {
+			dev_info(&pdev->dev, "Device doesn't have valid ME Interface\n");
+			return false;
+		}
+	}
+	return true;
+}
+/**
  * mei_probe - Device Initialization Routine
  *
  * @pdev: PCI device structure
@@ -120,6 +141,12 @@ static int __devinit mei_probe(struct pci_dev *pdev,
 	int err;
 
 	mutex_lock(&mei_mutex);
+
+	if (!mei_quirk_probe(pdev, ent)) {
+		err = -ENODEV;
+		goto end;
+	}
+
 	if (mei_device) {
 		err = -EEXIST;
 		goto end;

