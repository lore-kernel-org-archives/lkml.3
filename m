Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451Ab3LHJ3L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 04:29:11 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:50996 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab3LHJ1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 04:27:19 -0500
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
        joni.lapilainen@gmail.com, Johannes Berg <johannes@sipsolutions.net>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        David Gnedt <david.gnedt@davizone.at>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali.rohar@gmail.com>
Subject: [PATCH v2 03/16] wl1251: retry power save entry
Date: Sun,  8 Dec 2013 10:25:01 +0100
Message-Id: <1386494714-21070-4-git-send-email-pali.rohar@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1386494714-21070-1-git-send-email-pali.rohar@gmail.com>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com>
 <1386494714-21070-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Gnedt <david.gnedt@davizone.at>

Port of the power save entry retry code from wl1251 driver version included
in the Maemo Fremantle kernel.
This tries to enable power save mode up to 3 times before failing.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
---
 drivers/net/wireless/ti/wl1251/boot.c   |    3 ++-
 drivers/net/wireless/ti/wl1251/event.c  |   44 +++++++++++++++++++++++++++++++
 drivers/net/wireless/ti/wl1251/event.h  |    7 +++++
 drivers/net/wireless/ti/wl1251/main.c   |    2 ++
 drivers/net/wireless/ti/wl1251/wl1251.h |    3 +++
 5 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl1251/boot.c b/drivers/net/wireless/ti/wl1251/boot.c
index a2e5241..2000cd5 100644
--- a/drivers/net/wireless/ti/wl1251/boot.c
+++ b/drivers/net/wireless/ti/wl1251/boot.c
@@ -299,7 +299,8 @@ int wl1251_boot_run_firmware(struct wl1251 *wl)
 		ROAMING_TRIGGER_LOW_RSSI_EVENT_ID |
 		ROAMING_TRIGGER_REGAINED_RSSI_EVENT_ID |
 		REGAINED_BSS_EVENT_ID | BT_PTA_SENSE_EVENT_ID |
-		BT_PTA_PREDICTION_EVENT_ID | JOIN_EVENT_COMPLETE_ID;
+		BT_PTA_PREDICTION_EVENT_ID | JOIN_EVENT_COMPLETE_ID |
+		PS_REPORT_EVENT_ID;
 
 	ret = wl1251_event_unmask(wl);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/ti/wl1251/event.c b/drivers/net/wireless/ti/wl1251/event.c
index 74ae8e1..192cebd 100644
--- a/drivers/net/wireless/ti/wl1251/event.c
+++ b/drivers/net/wireless/ti/wl1251/event.c
@@ -46,6 +46,43 @@ static int wl1251_event_scan_complete(struct wl1251 *wl,
 	return ret;
 }
 
+#define WL1251_PSM_ENTRY_RETRIES  3
+static int wl1251_event_ps_report(struct wl1251 *wl,
+				  struct event_mailbox *mbox)
+{
+	int ret = 0;
+
+	wl1251_debug(DEBUG_EVENT, "ps status: %x", mbox->ps_status);
+
+	switch (mbox->ps_status) {
+	case EVENT_ENTER_POWER_SAVE_FAIL:
+		wl1251_debug(DEBUG_PSM, "PSM entry failed");
+
+		if (wl->station_mode != STATION_POWER_SAVE_MODE) {
+			/* remain in active mode */
+			wl->psm_entry_retry = 0;
+			break;
+		}
+
+		if (wl->psm_entry_retry < WL1251_PSM_ENTRY_RETRIES) {
+			wl->psm_entry_retry++;
+			ret = wl1251_ps_set_mode(wl, STATION_POWER_SAVE_MODE);
+		} else {
+			wl1251_error("Power save entry failed, giving up");
+			wl->psm_entry_retry = 0;
+		}
+		break;
+	case EVENT_ENTER_POWER_SAVE_SUCCESS:
+	case EVENT_EXIT_POWER_SAVE_FAIL:
+	case EVENT_EXIT_POWER_SAVE_SUCCESS:
+	default:
+		wl->psm_entry_retry = 0;
+		break;
+	}
+
+	return 0;
+}
+
 static void wl1251_event_mbox_dump(struct event_mailbox *mbox)
 {
 	wl1251_debug(DEBUG_EVENT, "MBOX DUMP:");
@@ -80,6 +117,13 @@ static int wl1251_event_process(struct wl1251 *wl, struct event_mailbox *mbox)
 		}
 	}
 
+	if (vector & PS_REPORT_EVENT_ID) {
+		wl1251_debug(DEBUG_EVENT, "PS_REPORT_EVENT");
+		ret = wl1251_event_ps_report(wl, mbox);
+		if (ret < 0)
+			return ret;
+	}
+
 	if (vector & SYNCHRONIZATION_TIMEOUT_EVENT_ID) {
 		wl1251_debug(DEBUG_EVENT, "SYNCHRONIZATION_TIMEOUT_EVENT");
 
diff --git a/drivers/net/wireless/ti/wl1251/event.h b/drivers/net/wireless/ti/wl1251/event.h
index 30eb5d1..88570a5 100644
--- a/drivers/net/wireless/ti/wl1251/event.h
+++ b/drivers/net/wireless/ti/wl1251/event.h
@@ -112,6 +112,13 @@ struct event_mailbox {
 	u8 padding[19];
 } __packed;
 
+enum {
+	EVENT_ENTER_POWER_SAVE_FAIL = 0,
+	EVENT_ENTER_POWER_SAVE_SUCCESS,
+	EVENT_EXIT_POWER_SAVE_FAIL,
+	EVENT_EXIT_POWER_SAVE_SUCCESS,
+};
+
 int wl1251_event_unmask(struct wl1251 *wl);
 void wl1251_event_mbox_config(struct wl1251 *wl);
 int wl1251_event_handle(struct wl1251 *wl, u8 mbox);
diff --git a/drivers/net/wireless/ti/wl1251/main.c b/drivers/net/wireless/ti/wl1251/main.c
index ad2fd18..46a2494 100644
--- a/drivers/net/wireless/ti/wl1251/main.c
+++ b/drivers/net/wireless/ti/wl1251/main.c
@@ -480,6 +480,7 @@ static void wl1251_op_stop(struct ieee80211_hw *hw)
 	wl->next_tx_complete = 0;
 	wl->elp = false;
 	wl->station_mode = STATION_ACTIVE_MODE;
+	wl->psm_entry_retry = 0;
 	wl->tx_queue_stopped = false;
 	wl->power_level = WL1251_DEFAULT_POWER_LEVEL;
 	wl->rssi_thold = 0;
@@ -1519,6 +1520,7 @@ struct ieee80211_hw *wl1251_alloc_hw(void)
 	wl->elp = false;
 	wl->station_mode = STATION_ACTIVE_MODE;
 	wl->psm_requested = false;
+	wl->psm_entry_retry = 0;
 	wl->tx_queue_stopped = false;
 	wl->power_level = WL1251_DEFAULT_POWER_LEVEL;
 	wl->rssi_thold = 0;
diff --git a/drivers/net/wireless/ti/wl1251/wl1251.h b/drivers/net/wireless/ti/wl1251/wl1251.h
index 50bae8b..de9e418 100644
--- a/drivers/net/wireless/ti/wl1251/wl1251.h
+++ b/drivers/net/wireless/ti/wl1251/wl1251.h
@@ -374,6 +374,9 @@ struct wl1251 {
 	/* PSM mode requested */
 	bool psm_requested;
 
+	/* retry counter for PSM entries */
+	u8 psm_entry_retry;
+
 	u16 beacon_int;
 	u8 dtim_period;
 
-- 
1.7.9.5

