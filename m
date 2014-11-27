Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbaK0Iyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:54:47 -0500
Received: from mail.kernel.org ([198.145.19.201]:42668 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932154AbaK0Itp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:49:45 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 75/91] nl80211: clear skb cb before passing to netlink
Date: Thu, 27 Nov 2014 16:42:58 +0800
Message-Id: <1417077794-9299-75-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit bd8c78e78d5011d8111bc2533ee73b13a3bd6c42 upstream.

In testmode and vendor command reply/event SKBs we use the
skb cb data to store nl80211 parameters between allocation
and sending. This causes the code for CONFIG_NETLINK_MMAP
to get confused, because it takes ownership of the skb cb
data when the SKB is handed off to netlink, and it doesn't
explicitly clear it.

Clear the skb cb explicitly when we're done and before it
gets passed to netlink to avoid this issue.

Reported-by: Assaf Azulay <assaf.azulay@intel.com>
Reported-by: David Spinadel <david.spinadel@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 net/wireless/nl80211.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index add9f94..52646f9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5059,6 +5059,9 @@ int cfg80211_testmode_reply(struct sk_buff *skb)
 	void *hdr = ((void **)skb->cb)[1];
 	struct nlattr *data = ((void **)skb->cb)[2];
 
+	/* clear CB data for netlink core to own from now on */
+	memset(skb->cb, 0, sizeof(skb->cb));
+
 	if (WARN_ON(!rdev->testmode_info)) {
 		kfree_skb(skb);
 		return -EINVAL;
@@ -5085,6 +5088,9 @@ void cfg80211_testmode_event(struct sk_buff *skb, gfp_t gfp)
 	void *hdr = ((void **)skb->cb)[1];
 	struct nlattr *data = ((void **)skb->cb)[2];
 
+	/* clear CB data for netlink core to own from now on */
+	memset(skb->cb, 0, sizeof(skb->cb));
+
 	nla_nest_end(skb, data);
 	genlmsg_end(skb, hdr);
 	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), skb, 0,
-- 
1.9.1

