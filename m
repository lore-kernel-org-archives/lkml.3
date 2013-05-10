Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab3EJO1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:27:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57281 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755989Ab3EJOWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:22:00 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Yinghai Lu" <yinghai@kernel.org>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        "Chris J. Benenati" <chris.j.benenati@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.43833515@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [033/118] PCI/PM: Fix fallback to PCI_D0 in pci_platform_power_transition()
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 769ba7212f2059ca9fe0c73371e3d415c8c1c529 upstream.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pci/pci.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -664,15 +664,11 @@ static int pci_platform_power_transition
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

