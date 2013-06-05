Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952Ab3FEWK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 18:10:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37633 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757879Ab3FEVfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 011/127] cfg80211: fix WoWLAN wakeup tracing
Date: Wed,  5 Jun 2013 14:32:58 -0700
Message-Id: <20130605213219.307616997@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit a92eecbbeaf01ea2267751569dd3301248513915 upstream.

If the device reports a non-wireless wakeup reason, the
tracing code crashes trying to dereference a NULL pointer.
Fix this by checking the pointer on all accesses and also
add a non_wireless tag to the event.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/trace.h |   23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -2386,6 +2386,7 @@ TRACE_EVENT(cfg80211_report_wowlan_wakeu
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		WDEV_ENTRY
+		__field(bool, non_wireless)
 		__field(bool, disconnect)
 		__field(bool, magic_pkt)
 		__field(bool, gtk_rekey_failure)
@@ -2394,20 +2395,22 @@ TRACE_EVENT(cfg80211_report_wowlan_wakeu
 		__field(bool, rfkill_release)
 		__field(s32, pattern_idx)
 		__field(u32, packet_len)
-		__dynamic_array(u8, packet, wakeup->packet_present_len)
+		__dynamic_array(u8, packet,
+				wakeup ? wakeup->packet_present_len : 0)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
 		WDEV_ASSIGN;
-		__entry->disconnect = wakeup->disconnect;
-		__entry->magic_pkt = wakeup->magic_pkt;
-		__entry->gtk_rekey_failure = wakeup->gtk_rekey_failure;
-		__entry->eap_identity_req = wakeup->eap_identity_req;
-		__entry->four_way_handshake = wakeup->four_way_handshake;
-		__entry->rfkill_release = wakeup->rfkill_release;
-		__entry->pattern_idx = wakeup->pattern_idx;
-		__entry->packet_len = wakeup->packet_len;
-		if (wakeup->packet && wakeup->packet_present_len)
+		__entry->non_wireless = !wakeup;
+		__entry->disconnect = wakeup ? wakeup->disconnect : false;
+		__entry->magic_pkt = wakeup ? wakeup->magic_pkt : false;
+		__entry->gtk_rekey_failure = wakeup ? wakeup->gtk_rekey_failure : false;
+		__entry->eap_identity_req = wakeup ? wakeup->eap_identity_req : false;
+		__entry->four_way_handshake = wakeup ? wakeup->four_way_handshake : false;
+		__entry->rfkill_release = wakeup ? wakeup->rfkill_release : false;
+		__entry->pattern_idx = wakeup ? wakeup->pattern_idx : false;
+		__entry->packet_len = wakeup ? wakeup->packet_len : false;
+		if (wakeup && wakeup->packet && wakeup->packet_present_len)
 			memcpy(__get_dynamic_array(packet), wakeup->packet,
 			       wakeup->packet_present_len);
 	),


