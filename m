Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab3IHDUQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:20:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56128 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755663Ab3IHDSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:50 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Johannes Berg" <johannes.berg@intel.com>,
        "Michal Kazior" <michal.kazior@tieto.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.297215628@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [025/121] nl80211: fix mgmt tx status and testmode reporting for
 netns
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Kazior <michal.kazior@tieto.com>

commit a0ec570f4f69c4cb700d743a915096c2c8f56a99 upstream.

These two events were sent to the default network
namespace.

This caused AP mode in a non-default netns to not
work correctly. Mgmt tx status was multicasted to
a different (default) netns instead of the one the
AP was in.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/wireless/nl80211.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4826,12 +4826,14 @@ EXPORT_SYMBOL(cfg80211_testmode_alloc_ev
 
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
@@ -7282,7 +7284,8 @@ void nl80211_send_mgmt_tx_status(struct
 		return;
 	}
 
-	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, gfp);
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
 	return;
 
  nla_put_failure:

