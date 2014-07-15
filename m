Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759645AbaGOViY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:38:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54807 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759575AbaGOViJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:38:09 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <stf_xl@wp.pl>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 170/198] rt2x00: fix rfkill regression on rt2500pci
Date: Tue, 15 Jul 2014 14:30:40 -0700
Message-Id: <1405459868-15089-171-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <stf_xl@wp.pl>

commit 616a8394b5df8c88f4dd416f4527439a4e365034 upstream.

As reported by Niels, starting rfkill polling during device probe
(commit e2bc7c5, generally sane change) broke rfkill on rt2500pci
device. I considered that bug as some initalization issue, which
should be fixed on rt2500pci specific code. But after several
attempts (see bug report for details) we fail to find working solution.
Hence I decided to revert to old behaviour on rt2500pci to fix
regression.

Additionally patch also unregister rfkill on device remove instead
of ifconfig down, what was another issue introduced by bad commit.

Bug report:
https://bugzilla.kernel.org/show_bug.cgi?id=73821

Fixes: e2bc7c5f3cb8 ("rt2x00: Fix rfkill_polling register function.")
Bisected-by: Niels <nille0386@googlemail.com>
Reported-and-tested-by: Niels <nille0386@googlemail.com>
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/rt2x00/rt2500pci.c |  7 ++++++-
 drivers/net/wireless/rt2x00/rt2x00.h    |  1 +
 drivers/net/wireless/rt2x00/rt2x00dev.c | 24 +++++++++++++++++++++---
 3 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500pci.c b/drivers/net/wireless/rt2x00/rt2500pci.c
index 0ac5c58..13f557a 100644
--- a/drivers/net/wireless/rt2x00/rt2500pci.c
+++ b/drivers/net/wireless/rt2x00/rt2500pci.c
@@ -1684,8 +1684,13 @@ static int rt2500pci_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Detect if this device has an hardware controlled radio.
 	 */
-	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_HARDWARE_RADIO))
+	if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_HARDWARE_RADIO)) {
 		__set_bit(CAPABILITY_HW_BUTTON, &rt2x00dev->cap_flags);
+		/*
+		 * On this device RFKILL initialized during probe does not work.
+		 */
+		__set_bit(REQUIRE_DELAYED_RFKILL, &rt2x00dev->cap_flags);
+	}
 
 	/*
 	 * Check if the BBP tuning should be enabled.
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index e4ba2ce..c06ffb7 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -695,6 +695,7 @@ enum rt2x00_capability_flags {
 	REQUIRE_SW_SEQNO,
 	REQUIRE_HT_TX_DESC,
 	REQUIRE_PS_AUTOWAKE,
+	REQUIRE_DELAYED_RFKILL,
 
 	/*
 	 * Capabilities
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 9dd92a7..78d0056 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -1128,9 +1128,10 @@ static void rt2x00lib_uninitialize(struct rt2x00_dev *rt2x00dev)
 		return;
 
 	/*
-	 * Unregister extra components.
+	 * Stop rfkill polling.
 	 */
-	rt2x00rfkill_unregister(rt2x00dev);
+	if (test_bit(REQUIRE_DELAYED_RFKILL, &rt2x00dev->cap_flags))
+		rt2x00rfkill_unregister(rt2x00dev);
 
 	/*
 	 * Allow the HW to uninitialize.
@@ -1168,6 +1169,12 @@ static int rt2x00lib_initialize(struct rt2x00_dev *rt2x00dev)
 
 	set_bit(DEVICE_STATE_INITIALIZED, &rt2x00dev->flags);
 
+	/*
+	 * Start rfkill polling.
+	 */
+	if (test_bit(REQUIRE_DELAYED_RFKILL, &rt2x00dev->cap_flags))
+		rt2x00rfkill_register(rt2x00dev);
+
 	return 0;
 }
 
@@ -1377,7 +1384,12 @@ int rt2x00lib_probe_dev(struct rt2x00_dev *rt2x00dev)
 	rt2x00link_register(rt2x00dev);
 	rt2x00leds_register(rt2x00dev);
 	rt2x00debug_register(rt2x00dev);
-	rt2x00rfkill_register(rt2x00dev);
+
+	/*
+	 * Start rfkill polling.
+	 */
+	if (!test_bit(REQUIRE_DELAYED_RFKILL, &rt2x00dev->cap_flags))
+		rt2x00rfkill_register(rt2x00dev);
 
 	return 0;
 
@@ -1393,6 +1405,12 @@ void rt2x00lib_remove_dev(struct rt2x00_dev *rt2x00dev)
 	clear_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags);
 
 	/*
+	 * Stop rfkill polling.
+	 */
+	if (!test_bit(REQUIRE_DELAYED_RFKILL, &rt2x00dev->cap_flags))
+		rt2x00rfkill_unregister(rt2x00dev);
+
+	/*
 	 * Disable radio.
 	 */
 	rt2x00lib_disable_radio(rt2x00dev);
-- 
1.9.1

