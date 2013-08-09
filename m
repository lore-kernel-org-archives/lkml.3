Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967650Ab3HICQi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:16:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55693 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967383Ab3HIB6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:58:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michal Kazior <michal.kazior@tieto.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 037/102] nl80211: fix mgmt tx status and testmode reporting for netns
Date: Thu,  8 Aug 2013 18:57:13 -0700
Message-Id: <20130809015018.555082182@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/nl80211.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6588,12 +6588,14 @@ EXPORT_SYMBOL(cfg80211_testmode_alloc_ev
 
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
@@ -10028,7 +10030,8 @@ void cfg80211_mgmt_tx_status(struct wire
 
 	genlmsg_end(msg, hdr);
 
-	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, gfp);
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
 	return;
 
  nla_put_failure:


