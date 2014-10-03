Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257AbaJCXib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:38:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757347AbaJCWDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:42 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Assaf Azulay <assaf.azulay@intel.com>,
        David Spinadel <david.spinadel@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.16 315/357] nl80211: clear skb cb before passing to netlink
Date: Fri,  3 Oct 2014 14:31:41 -0700
Message-Id: <20141003212942.936152506@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/wireless/nl80211.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6978,6 +6978,9 @@ void __cfg80211_send_event_skb(struct sk
 	struct nlattr *data = ((void **)skb->cb)[2];
 	enum nl80211_multicast_groups mcgrp = NL80211_MCGRP_TESTMODE;
 
+	/* clear CB data for netlink core to own from now on */
+	memset(skb->cb, 0, sizeof(skb->cb));
+
 	nla_nest_end(skb, data);
 	genlmsg_end(skb, hdr);
 
@@ -9300,6 +9303,9 @@ int cfg80211_vendor_cmd_reply(struct sk_
 	void *hdr = ((void **)skb->cb)[1];
 	struct nlattr *data = ((void **)skb->cb)[2];
 
+	/* clear CB data for netlink core to own from now on */
+	memset(skb->cb, 0, sizeof(skb->cb));
+
 	if (WARN_ON(!rdev->cur_cmd_info)) {
 		kfree_skb(skb);
 		return -EINVAL;


