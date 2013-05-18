Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab3ERCVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:21:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25200 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab3ERCQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:16:54 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=xkOZ05aFNV0A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=3NAxKKBLQYIA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=FTbf8y9vJS30IKzNMQcA:9 a=dGJ0OcVc7YAA:10 a=UTB_XpHje0EA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130518021648.079284488@goodmis.org>
User-Agent: quilt/0.60-1
Date: Fri, 17 May 2013 22:16:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Chris J. Benenati" <chris.j.benenati@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Subject: [ 039/136 ] PCI/PM: Fix fallback to PCI_D0 in pci_platform_power_transition()
References: <20130518021557.139113314@goodmis.org>
Content-Disposition: inline; filename=0039-PCI-PM-Fix-fallback-to-PCI_D0-in-pci_platform_power_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.4 stable review patch.
If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 769ba7212f2059ca9fe0c73371e3d415c8c1c529 ]

Commit b51306c (PCI: Set device power state to PCI_D0 for device
without native PM support) modified pci_platform_power_transition()
by adding code causing dev->current_state for devices that don't
support native PCI PM but are power-manageable by the platform to be
changed to PCI_D0 regardless of the value returned by the preceding
platform_pci_set_power_state().  In particular, that also is done
if the platform_pci_set_power_state() has been successful, which
causes the correct power state of the device set by
pci_update_current_state() in that case to be overwritten by PCI_D0.

Fix that mistake by making the fallback to PCI_D0 only happen if
the platform_pci_set_power_state() has returned an error.

[bhelgaas: folded in Yinghai's simplification, added URL & stable info]
Reference: http://lkml.kernel.org/r/27806FC4E5928A408B78E88BBC67A2306F466BBA@ORSMSX101.amr.corp.intel.com
Reported-by: Chris J. Benenati <chris.j.benenati@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Yinghai Lu <yinghai@kernel.org>
Cc: <stable@vger.kernel.org>	# v3.2+
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/pci/pci.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index a0f8e8f..466b669 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -663,15 +663,11 @@ static int pci_platform_power_transition(struct pci_dev *dev, pci_power_t state)
 		error = platform_pci_set_power_state(dev, state);
 		if (!error)
 			pci_update_current_state(dev, state);
-		/* Fall back to PCI_D0 if native PM is not supported */
-		if (!dev->pm_cap)
-			dev->current_state = PCI_D0;
-	} else {
+	} else
 		error = -ENODEV;
-		/* Fall back to PCI_D0 if native PM is not supported */
-		if (!dev->pm_cap)
-			dev->current_state = PCI_D0;
-	}
+
+	if (error && !dev->pm_cap) /* Fall back to PCI_D0 */
+		dev->current_state = PCI_D0;
 
 	return error;
 }
-- 
1.7.10.4


