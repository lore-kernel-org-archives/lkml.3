Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160Ab3IKFcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:32:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11316 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab3IKE5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:21 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Uu6VS0yU1AEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ELkgMbih7bcA:10 a=qb5RLdrWAAAA:8 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=Mbv68m0LDs4A:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042915.087459115@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Michal Kazior <michal.kazior@tieto.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [137/251] nl80211: fix mgmt tx status and testmode reporting for netns
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0137-nl80211-fix-mgmt-tx-status-and-testmode-reporting-fo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Michal Kazior <michal.kazior@tieto.com>

[ Upstream commit a0ec570f4f69c4cb700d743a915096c2c8f56a99 ]

These two events were sent to the default network
namespace.

This caused AP mode in a non-default netns to not
work correctly. Mgmt tx status was multicasted to
a different (default) netns instead of the one the
AP was in.

Cc: stable@vger.kernel.org
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/wireless/nl80211.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 1e37dbf..79ad33d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5542,12 +5542,14 @@ EXPORT_SYMBOL(cfg80211_testmode_alloc_event_skb);
 
 void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp)
 {
+	struct cfg80211_registered_device *rdev = ((void **)skb->cb)[0];
 	void *hdr = ((void **)skb->cb)[1];
 	struct nlattr *data = ((void **)skb->cb)[2];
 
 	nla_nest_end(skb, data);
 	genlmsg_end(skb, hdr);
-	genlmsg_multicast(skb, 0, nl80211_testmode_mcgrp.id, gfp);
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), skb, 0,
+				nl80211_testmode_mcgrp.id, gfp);
 }
 EXPORT_SYMBOL(cfg80211_testmode_event);
 #endif
@@ -8378,7 +8380,8 @@ void nl80211_send_mgmt_tx_status(struct cfg80211_registered_device *rdev,
 
 	genlmsg_end(msg, hdr);
 
-	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, gfp);
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
 	return;
 
  nla_put_failure:
-- 
1.7.10.4


