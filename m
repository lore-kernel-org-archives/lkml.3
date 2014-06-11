Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbaFKDxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 23:53:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:4050 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbaFKDxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 23:53:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,455,1400050800"; 
   d="scan'208,223";a="553609583"
Message-ID: <5397D293.2000401@linux.intel.com>
Date: Wed, 11 Jun 2014 11:52:51 +0800
From: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] brcmfmac: prevent watchdog from interfering with scanning
 and connecting
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 14485894add32aedacb3e486ebb2cc2b73861abf Mon Sep 17 00:00:00 2001
From: Fu zhonghui <zhonghui.fu@linux.intel.com>
Date: Wed, 11 Jun 2014 11:06:55 +0800
Subject: [PATCH] brcmfmac: prevent watchdog from interfering with scanning and connecting

Watchdog in brcmfmac driver may make WiFi chip enter sleep mode
before completion of scanning or connecting.

This will lead to scanning or connecting failure.

Increasing temporarily idle-time threshold during scanning or
connecting can ensure scanning or connecting success without
watchdog interference.

Signed-off-by: Fu zhonghui <zhonghui.fu@linux.intel.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   18 ++++++++++++++++--
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    3 ++-
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 13c89a0..729deab 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -34,6 +34,7 @@
 #include <linux/vmalloc.h>
 #include <linux/platform_data/brcmfmac-sdio.h>
 #include <linux/moduleparam.h>
+#include <net/cfg80211.h>
 #include <asm/unaligned.h>
 #include <defs.h>
 #include <brcmu_wifi.h>
@@ -43,6 +44,10 @@
 #include "sdio_host.h"
 #include "chip.h"
 #include "nvram.h"
+#include "dhd.h"
+#include "fwil_types.h"
+#include "p2p.h"
+#include "wl_cfg80211.h"
 
 #define DCMD_RESP_TIMEOUT  2000	/* In milli second */
 
@@ -307,6 +312,7 @@ struct rte_console {
 					 * when idle
 					 */
 #define BRCMF_IDLE_INTERVAL	1
+#define BRCMF_IDLE_INTERVAL_SCANNING_CONNECTING	100
 
 #define KSO_WAIT_US 50
 #define MAX_KSO_ATTEMPTS (PMU_MAX_TRANSITION_DLY/KSO_WAIT_US)
@@ -3613,9 +3619,9 @@ void brcmf_sdio_isr(struct brcmf_sdio *bus)
 
 static bool brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 {
-#ifdef DEBUG
 	struct brcmf_bus *bus_if = dev_get_drvdata(bus->sdiodev->dev);
-#endif	/* DEBUG */
+	struct brcmf_cfg80211_info *cfg = bus_if->drvr->config;
+	struct brcmf_if *ifp = cfg->pub->iflist[0];
 
 	brcmf_dbg(TIMER, "Enter\n");
 
@@ -3678,6 +3684,14 @@ static bool brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 
 	/* On idle timeout clear activity flag and/or turn off clock */
 	if ((bus->idletime > 0) && (bus->clkstate == CLK_AVAIL)) {
+
+		if (test_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status) ||
+		    test_bit(BRCMF_VIF_STATUS_CONNECTING, &ifp->vif->sme_state)) {
+			bus->idletime = BRCMF_IDLE_INTERVAL_SCANNING_CONNECTING;
+		} else {
+			bus->idletime = BRCMF_IDLE_INTERVAL;
+		}
+
 		if (++bus->idlecount >= bus->idletime) {
 			bus->idlecount = 0;
 			if (bus->activity) {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index be19852..e76517e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -913,6 +913,8 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct brcmf_cfg80211_vif *vif,
 		return -EAGAIN;
 	}
 
+	set_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
+
 	/* If scan req comes for p2p0, send it over primary I/F */
 	if (vif == cfg->p2p.bss_idx[P2PAPI_BSSCFG_DEVICE].vif)
 		vif = cfg->p2p.bss_idx[P2PAPI_BSSCFG_PRIMARY].vif;
@@ -933,7 +935,6 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct brcmf_cfg80211_vif *vif,
 	}
 
 	cfg->scan_request = request;
-	set_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
 	if (escan_req) {
 		cfg->escan_info.run = brcmf_run_escan;
 		err = brcmf_p2p_scan_prep(wiphy, request, vif);
-- 1.7.1

