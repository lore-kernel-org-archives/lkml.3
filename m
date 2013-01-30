Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753062Ab3A3ALP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 19:11:15 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:51710 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab3A3ALM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 19:11:12 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: [PATCH] nl80211: avoid "wdev_id may be used uninitialized"
Date: Tue, 29 Jan 2013 17:11:02 -0700
Message-Id: <1359504662-23561-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.10.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen Warren <swarren@nvidia.com>

Silence the following:
net/wireless/nl80211.c: In function '__cfg80211_wdev_from_attrs.clone.119':
net/wireless/nl80211.c:57:6: warning: 'wdev_id' may be used uninitialized in this function

... by always initializing wdev_id to zero. I assume that wiphy_idx and
ifidx are set to -1 for similar reasons, so this change simply propagates
the same workaround.

In practice, this warning is false, since wdev_id is both set and used
under the condition if (have_wdev_id). However, at least my compiler
can't be coerced into realizing this; almost any code between the if
blocks that set and use the variable causes this warning.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
---
 net/wireless/nl80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 33de803..389e62a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -54,7 +54,7 @@ __cfg80211_wdev_from_attrs(struct net *netns, struct nlattr **attrs)
 	struct wireless_dev *result = NULL;
 	bool have_ifidx = attrs[NL80211_ATTR_IFINDEX];
 	bool have_wdev_id = attrs[NL80211_ATTR_WDEV];
-	u64 wdev_id;
+	u64 wdev_id = 0;
 	int wiphy_idx = -1;
 	int ifidx = -1;
 
-- 
1.7.10.4

