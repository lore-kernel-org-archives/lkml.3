Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147AbaDXIx7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:53:59 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46633 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbaDXIxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:53:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Michael Braun <michael-dev@fami-braun.de>,
        Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 082/182] mac80211: fix WPA with VLAN on AP side with ps-sta again
Date: Thu, 24 Apr 2014 09:50:07 +0100
Message-Id: <1398329507-5911-83-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Braun <michael-dev@fami-braun.de>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5d0beec..5fd26c6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2706,7 +2706,7 @@ ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
 				cpu_to_le16(IEEE80211_FCTL_MOREDATA);
 		}
 
-		if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+		if (sdata->vif.type == NL80211_IFTYPE_AP)
 			sdata = IEEE80211_DEV_TO_SUB_IF(skb->dev);
 		if (!ieee80211_tx_prepare(sdata, &tx, skb))
 			break;
-- 
1.9.1

