Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab3FQReZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:34:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50548 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753715Ab3FQReV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:34:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 70/84] ath9k: Use minstrel rate control by default
Date: Mon, 17 Jun 2013 10:31:14 -0700
Message-Id: <1371490288-23167-71-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

commit 5efac94999ff218e0101f67a059e44abb4b0b523 upstream.

The ath9k rate control algorithm has various architectural
issues that make it a poor fit in scenarios like congested
environments etc.

An example: https://bugzilla.redhat.com/show_bug.cgi?id=927191

Change the default to minstrel which is more robust in such cases.
The ath9k RC code is left in the driver for now, maybe it can
be removed altogether later on.

Cc: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/ath/ath9k/Kconfig  | 10 +++++++---
 drivers/net/wireless/ath/ath9k/Makefile |  2 +-
 drivers/net/wireless/ath/ath9k/init.c   |  4 ----
 drivers/net/wireless/ath/ath9k/rc.h     |  2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/Kconfig b/drivers/net/wireless/ath/ath9k/Kconfig
index 7647ed6..c83fd02 100644
--- a/drivers/net/wireless/ath/ath9k/Kconfig
+++ b/drivers/net/wireless/ath/ath9k/Kconfig
@@ -91,13 +91,17 @@ config ATH9K_MAC_DEBUG
 	  This option enables collection of statistics for Rx/Tx status
 	  data and some other MAC related statistics
 
-config ATH9K_RATE_CONTROL
+config ATH9K_LEGACY_RATE_CONTROL
 	bool "Atheros ath9k rate control"
 	depends on ATH9K
-	default y
+	default n
 	---help---
 	  Say Y, if you want to use the ath9k specific rate control
-	  module instead of minstrel_ht.
+	  module instead of minstrel_ht. Be warned that there are various
+	  issues with the ath9k RC and minstrel is a more robust algorithm.
+	  Note that even if this option is selected, "ath9k_rate_control"
+	  has to be passed to mac80211 using the module parameter,
+	  ieee80211_default_rc_algo.
 
 config ATH9K_HTC
        tristate "Atheros HTC based wireless cards support"
diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wireless/ath/ath9k/Makefile
index 2ad8f94..75ee9e7 100644
--- a/drivers/net/wireless/ath/ath9k/Makefile
+++ b/drivers/net/wireless/ath/ath9k/Makefile
@@ -8,7 +8,7 @@ ath9k-y +=	beacon.o \
 		antenna.o
 
 ath9k-$(CONFIG_ATH9K_BTCOEX_SUPPORT) += mci.o
-ath9k-$(CONFIG_ATH9K_RATE_CONTROL) += rc.o
+ath9k-$(CONFIG_ATH9K_LEGACY_RATE_CONTROL) += rc.o
 ath9k-$(CONFIG_ATH9K_PCI) += pci.o
 ath9k-$(CONFIG_ATH9K_AHB) += ahb.o
 ath9k-$(CONFIG_ATH9K_DEBUGFS) += debug.o
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index c4ef015..53f8368 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -816,10 +816,6 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	sc->ant_rx = hw->wiphy->available_antennas_rx;
 	sc->ant_tx = hw->wiphy->available_antennas_tx;
 
-#ifdef CONFIG_ATH9K_RATE_CONTROL
-	hw->rate_control_algorithm = "ath9k_rate_control";
-#endif
-
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ)
 		hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
 			&sc->sbands[IEEE80211_BAND_2GHZ];
diff --git a/drivers/net/wireless/ath/ath9k/rc.h b/drivers/net/wireless/ath/ath9k/rc.h
index 267dbfc..b9a8738 100644
--- a/drivers/net/wireless/ath/ath9k/rc.h
+++ b/drivers/net/wireless/ath/ath9k/rc.h
@@ -231,7 +231,7 @@ static inline void ath_debug_stat_retries(struct ath_rate_priv *rc, int rix,
 }
 #endif
 
-#ifdef CONFIG_ATH9K_RATE_CONTROL
+#ifdef CONFIG_ATH9K_LEGACY_RATE_CONTROL
 int ath_rate_control_register(void);
 void ath_rate_control_unregister(void);
 #else
-- 
1.8.1.2

