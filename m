Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab3HEUmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 16:42:45 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:50971 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755026Ab3HEUml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 16:42:41 -0400
Message-ID: <1b0e51235c447fb704b0868902746d74f4c1dcbe.1375733180.git.cmetcalf@tilera.com>
In-Reply-To: <cover.1375733180.git.cmetcalf@tilera.com>
References: <cover.1375733180.git.cmetcalf@tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 5 Aug 2013 16:06:20 -0400
Subject: [PATCH 04/20] tile PCI RC: tweak the the pcie_rc_delay support
To: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow longer delays if requested, and print the info messages
as we are performing the delay, not when parsing the arguments.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/pci_gx.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/arch/tile/kernel/pci_gx.c b/arch/tile/kernel/pci_gx.c
index 1142563..e99809e 100644
--- a/arch/tile/kernel/pci_gx.c
+++ b/arch/tile/kernel/pci_gx.c
@@ -69,17 +69,14 @@ static int pcie_rc[TILEGX_NUM_TRIO][TILEGX_TRIO_PCIES];
  * a HW PCIe link-training bug. The exact delay is specified with
  * a kernel boot argument in the form of "pcie_rc_delay=T,P,S",
  * where T is the TRIO instance number, P is the port number and S is
- * the delay in seconds. If the delay is not provided, the value
- * will be DEFAULT_RC_DELAY.
+ * the delay in seconds. If the argument is specified, but the delay is
+ * not provided, the value will be DEFAULT_RC_DELAY.
  */
 static int rc_delay[TILEGX_NUM_TRIO][TILEGX_TRIO_PCIES];
 
 /* Default number of seconds that the PCIe RC port probe can be delayed. */
 #define DEFAULT_RC_DELAY	10
 
-/* Max number of seconds that the PCIe RC port probe can be delayed. */
-#define MAX_RC_DELAY		20
-
 /* Array of the PCIe ports configuration info obtained from the BIB. */
 struct pcie_port_property pcie_ports[TILEGX_NUM_TRIO][TILEGX_TRIO_PCIES];
 
@@ -570,14 +567,9 @@ static int setup_pcie_rc_delay(char *str)
 		if (!isdigit(*str))
 			return -EINVAL;
 		delay = simple_strtoul(str, (char **)&str, 10);
-		if (delay > MAX_RC_DELAY)
-			return -EINVAL;
 	}
 
 	rc_delay[trio_index][mac] = delay ? : DEFAULT_RC_DELAY;
-	pr_info("Delaying PCIe RC link training for %u sec"
-		" on MAC %lu on TRIO %lu\n", rc_delay[trio_index][mac],
-		mac, trio_index);
 	return 0;
 }
 early_param("pcie_rc_delay", setup_pcie_rc_delay);
@@ -682,12 +674,6 @@ int __init pcibios_init(void)
 			continue;
 		}
 
-		/*
-		 * Delay the RC link training if needed.
-		 */
-		if (rc_delay[trio_index][mac])
-			msleep(rc_delay[trio_index][mac] * 1000);
-
 		ret = gxio_trio_force_rc_link_up(trio_context, mac);
 		if (ret < 0)
 			pr_err("PCI: PCIE_FORCE_LINK_UP failure, "
@@ -697,10 +683,21 @@ int __init pcibios_init(void)
 			trio_index, controller->mac);
 
 		/*
-		 * Wait a bit here because some EP devices take longer
-		 * to come up.
+		 * Delay the bus probe if needed.
 		 */
-		msleep(1000);
+		if (rc_delay[trio_index][mac]) {
+			pr_info("Delaying PCIe RC bus enumerating %d sec"
+				" on MAC %d on TRIO %d\n",
+				rc_delay[trio_index][mac], mac,
+				trio_index);
+			msleep(rc_delay[trio_index][mac] * 1000);
+		} else {
+			/*
+			 * Wait a bit here because some EP devices
+			 * take longer to come up.
+			 */
+			msleep(1000);
+		}
 
 		/*
 		 * Check for PCIe link-up status.
-- 
1.8.3.1

