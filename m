Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbaHTL6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:58:20 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58966 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573AbaHTLoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
        Eliad Peller <eliadx.peller@intel.com>,
        Johannes Berg <johannes.berg@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 060/104] mac80211: reset probe_send_count also in HW_CONNECTION_MONITOR case
Date: Wed, 20 Aug 2014 13:43:23 +0200
Message-Id: <cfaf9b6286a0e61b259c2b3b572ecb623ab85bd4.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eliad Peller <eliad@wizery.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 448cd2e248732326632957e52ea9c44729affcb2 upstream.

In case of beacon_loss with IEEE80211_HW_CONNECTION_MONITOR
device, mac80211 probes the ap (and disconnects on timeout)
but ignores the ack.

If we already got an ack, there's no reason to continue
disconnecting. this can help devices that supports
IEEE80211_HW_CONNECTION_MONITOR only partially (e.g. take
care of keep alives, but does not probe the ap.

In case the device wants to disconnect without probing,
it can just call ieee80211_connection_loss.

Signed-off-by: Eliad Peller <eliadx.peller@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/net/mac80211.h | 2 --
 net/mac80211/mlme.c    | 4 ++--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cc6035f1a2f1..0218c3d67f46 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1449,8 +1449,6 @@ struct ieee80211_tx_control {
  * @IEEE80211_HW_CONNECTION_MONITOR:
  *	The hardware performs its own connection monitoring, including
  *	periodic keep-alives to the AP and probing the AP on beacon loss.
- *	When this flag is set, signaling beacon-loss will cause an immediate
- *	change to disassociated state.
  *
  * @IEEE80211_HW_NEED_DTIM_BEFORE_ASSOC:
  *	This device needs to get data from beacon before association (i.e.
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index cd8d55c99ceb..591d990a06e7 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -131,13 +131,13 @@ void ieee80211_sta_reset_conn_monitor(struct ieee80211_sub_if_data *sdata)
 	if (unlikely(!sdata->u.mgd.associated))
 		return;
 
+	ifmgd->probe_send_count = 0;
+
 	if (sdata->local->hw.flags & IEEE80211_HW_CONNECTION_MONITOR)
 		return;
 
 	mod_timer(&sdata->u.mgd.conn_mon_timer,
 		  round_jiffies_up(jiffies + IEEE80211_CONNECTION_IDLE_TIME));
-
-	ifmgd->probe_send_count = 0;
 }
 
 static int ecw2cw(int ecw)
-- 
2.0.4

