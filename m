Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167AbaEMKYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:24:07 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933480AbaEMKL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Michael Braun <michael-dev@fami-braun.de>,
        Johannes Berg <johannes.berg@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 154/182] mac80211: fix WPA with VLAN on AP side with ps-sta again
Date: Tue, 13 May 2014 11:28:26 +0200
Message-Id: <0fc0d68253ef2002ef27bc19b323c1294dd9043f.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Braun <michael-dev@fami-braun.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 112c44b2df0984121a52fbda89425843b8e1a457 upstream.

commit de74a1d9032f4d37ea453ad2a647e1aff4cd2591
  "mac80211: fix WPA with VLAN on AP side with ps-sta"
fixed an issue where queued multicast packets would
be sent out encrypted with the key of an other bss.

commit "7cbf9d017dbb5e3276de7d527925d42d4c11e732"
  "mac80211: fix oops on mesh PS broadcast forwarding"
essentially reverted it, because vif.type cannot be AP_VLAN
due to the check to vif.type in ieee80211_get_buffered_bc before.

As the later commit intended to fix the MESH case, fix it
by checking for IFTYPE_AP instead of IFTYPE_AP_VLAN.

Fixes: 7cbf9d017dbb ("mac80211: fix oops on mesh PS broadcast forwarding")
Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d6a47e76efff..267bc8e4b8b6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2806,7 +2806,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 				cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 		}
 
-		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		if (sdata->vif.type == NL80211_IFTYPE_AP)
 			sdata = IEEE80211_DEV_TO_SUB_IF(skb->dev);
 		if (!ieee80211_tx_prepare(sdata, &tx, skb))
 			break;
-- 
1.9.3

