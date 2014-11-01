Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752AbaKAWxt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:53:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60134 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751574AbaKAWj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:28 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David Spinadel" <david.spinadel@intel.com>,
        "Johannes Berg" <johannes.berg@intel.com>,
        "Assaf Azulay" <assaf.azulay@intel.com>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.706933721@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 060/102] nl80211: clear skb cb before passing to netlink
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/wireless/nl80211.c | 6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4804,6 +4804,9 @@ int cfg80211_testmode_reply(struct sk_bu
 	void *hdr = ((void **)skb->cb)[1];
 	struct nlattr *data = ((void **)skb->cb)[2];
 
+	/* clear CB data for netlink core to own from now on */
+	memset(skb->cb, 0, sizeof(skb->cb));
+
 	if (WARN_ON(!rdev->testmode_info)) {
 		kfree_skb(skb);
 		return -EINVAL;
@@ -4830,6 +4833,9 @@ void cfg80211_testmode_event(struct sk_b
 	void *hdr = ((void **)skb->cb)[1];
 	struct nlattr *data = ((void **)skb->cb)[2];
 
+	/* clear CB data for netlink core to own from now on */
+	memset(skb->cb, 0, sizeof(skb->cb));
+
 	nla_nest_end(skb, data);
 	genlmsg_end(skb, hdr);
 	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), skb, 0,

