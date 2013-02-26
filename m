Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130Ab3BZX6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:58:37 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42274 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933062Ab3BZX6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "stable@vger.kernel.org, jan.brummer@tabos.org, Johannes Berg" 
	<johannes.berg@intel.com>,
        Jan-Michael Brummer <jan.brummer@tabos.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 137/150] mac80211: always unblock CSA queue stop when disconnecting
Date: Tue, 26 Feb 2013 15:56:34 -0800
Message-Id: <20130226235538.583063292@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235523.930663721@linuxfoundation.org>
References: <20130226235523.930663721@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Johannes Berg <johannes.berg@intel.com>

Commit 5b36ebd8249f403c7edf7cf68d68e9a0d0f55243 upstream.

In some cases when disconnecting after (or during?) CSA
the queues might not recover, and then the only way to
recover is reloading the module.

Fix this by always unblocking the queue CSA reason when

disconnecting.

Reported-by: Jan-Michael Brummer <jan.brummer@tabos.org>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/mlme.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1812,6 +1812,8 @@ static void __ieee80211_disconnect(struc
 			       WLAN_REASON_DISASSOC_DUE_TO_INACTIVITY,
 			       transmit_frame, frame_buf);
 	ifmgd->flags &= ~IEEE80211_STA_CSA_RECEIVED;
+	ieee80211_wake_queues_by_reason(&sdata->local->hw,
+					IEEE80211_QUEUE_STOP_REASON_CSA);
 	mutex_unlock(&ifmgd->mtx);
 
 	/*
@@ -1856,8 +1858,6 @@ static void ieee80211_csa_connection_dro
 		container_of(work, struct ieee80211_sub_if_data,
 			     u.mgd.csa_connection_drop_work);
 
-	ieee80211_wake_queues_by_reason(&sdata->local->hw,
-					IEEE80211_QUEUE_STOP_REASON_CSA);
 	__ieee80211_disconnect(sdata, true);
 }
 


