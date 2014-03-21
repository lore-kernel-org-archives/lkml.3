Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965822AbaCUAIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:08:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36993 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965786AbaCUAIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:08:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.10 17/85] mac80211: clear sequence/fragment number in QoS-null frames
Date: Thu, 20 Mar 2014 17:09:20 -0700
Message-Id: <20140321000601.076824239@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000558.606667505@linuxfoundation.org>
References: <20140321000558.606667505@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 864a6040f395464003af8dd0d8ca86fed19866d4 upstream.

Avoid leaking data by sending uninitialized memory and setting an
invalid (non-zero) fragment number (the sequence number is ignored
anyway) by setting the seq_ctrl field to zero.

Fixes: 3f52b7e328c5 ("mac80211: mesh power save basics")
Fixes: ce662b44ce22 ("mac80211: send (QoS) Null if no buffered frames")
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/mesh_ps.c  |    1 +
 net/mac80211/sta_info.c |    1 +
 2 files changed, 2 insertions(+)

--- a/net/mac80211/mesh_ps.c
+++ b/net/mac80211/mesh_ps.c
@@ -36,6 +36,7 @@ static struct sk_buff *mps_qos_null_get(
 				      sdata->vif.addr);
 	nullfunc->frame_control = fc;
 	nullfunc->duration_id = 0;
+	nullfunc->seq_ctrl = 0;
 	/* no address resolution for this frame -> set addr 1 immediately */
 	memcpy(nullfunc->addr1, sta->sta.addr, ETH_ALEN);
 	memset(skb_put(skb, 2), 0, 2); /* append QoS control field */
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1114,6 +1114,7 @@ static void ieee80211_send_null_response
 	memcpy(nullfunc->addr1, sta->sta.addr, ETH_ALEN);
 	memcpy(nullfunc->addr2, sdata->vif.addr, ETH_ALEN);
 	memcpy(nullfunc->addr3, sdata->vif.addr, ETH_ALEN);
+	nullfunc->seq_ctrl = 0;
 
 	skb->priority = tid;
 	skb_set_queue_mapping(skb, ieee802_1d_to_ac[tid]);


