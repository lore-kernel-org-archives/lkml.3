Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187AbaJVTO7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 15:14:59 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:54398 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaJVTNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 15:13:24 -0400
From: Frans Klaver <fransklaver@gmail.com>
To: Darren Hart <dvhart@infradead.org>
Cc: Frans Klaver <fransklaver@gmail.com>,
        Corentin Chary <corentin.chary@gmail.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/8] eeepc-laptop: pull out eeepc_destroy_rfkill
Date: Wed, 22 Oct 2014 21:12:39 +0200
Message-Id: <1414005163-3461-5-git-send-email-fransklaver@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1414005163-3461-1-git-send-email-fransklaver@gmail.com>
References: <1414005163-3461-1-git-send-email-fransklaver@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In eeepc_rfkill_exit, we implement the same code four times. Pull out a
function that cleans up an rfkill object to get rid of the duplication.

Signed-off-by: Frans Klaver <fransklaver@gmail.com>
---
 drivers/platform/x86/eeepc-laptop.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index e92ea41..73e8d39 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -823,35 +823,29 @@ static char EEEPC_RFKILL_NODE_1[] = "\\_SB.PCI0.P0P5";
 static char EEEPC_RFKILL_NODE_2[] = "\\_SB.PCI0.P0P6";
 static char EEEPC_RFKILL_NODE_3[] = "\\_SB.PCI0.P0P7";
 
+static inline void eeepc_destroy_rfkill(struct rfkill **rfkill)
+{
+	if (!*rfkill)
+		return;
+	rfkill_unregister(*rfkill);
+	rfkill_destroy(*rfkill);
+	*rfkill = NULL;
+}
+
 static void eeepc_rfkill_exit(struct eeepc_laptop *eeepc)
 {
 	eeepc_unregister_rfkill_notifier(eeepc, EEEPC_RFKILL_NODE_1);
 	eeepc_unregister_rfkill_notifier(eeepc, EEEPC_RFKILL_NODE_2);
 	eeepc_unregister_rfkill_notifier(eeepc, EEEPC_RFKILL_NODE_3);
-	if (eeepc->wlan_rfkill) {
-		rfkill_unregister(eeepc->wlan_rfkill);
-		rfkill_destroy(eeepc->wlan_rfkill);
-		eeepc->wlan_rfkill = NULL;
-	}
+
+	eeepc_destroy_rfkill(&eeepc->wlan_rfkill);
 
 	if (eeepc->hotplug_slot)
 		pci_hp_deregister(eeepc->hotplug_slot);
 
-	if (eeepc->bluetooth_rfkill) {
-		rfkill_unregister(eeepc->bluetooth_rfkill);
-		rfkill_destroy(eeepc->bluetooth_rfkill);
-		eeepc->bluetooth_rfkill = NULL;
-	}
-	if (eeepc->wwan3g_rfkill) {
-		rfkill_unregister(eeepc->wwan3g_rfkill);
-		rfkill_destroy(eeepc->wwan3g_rfkill);
-		eeepc->wwan3g_rfkill = NULL;
-	}
-	if (eeepc->wimax_rfkill) {
-		rfkill_unregister(eeepc->wimax_rfkill);
-		rfkill_destroy(eeepc->wimax_rfkill);
-		eeepc->wimax_rfkill = NULL;
-	}
+	eeepc_destroy_rfkill(&eeepc->bluetooth_rfkill);
+	eeepc_destroy_rfkill(&eeepc->wwan3g_rfkill);
+	eeepc_destroy_rfkill(&eeepc->wimax_rfkill);
 }
 
 static int eeepc_rfkill_init(struct eeepc_laptop *eeepc)
-- 
2.1.0

