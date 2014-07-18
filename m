Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935159AbaGRNQo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:16:44 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17879 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934422AbaGRNQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:16:42 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
        Johannes Berg <johannes.berg@intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 098/170] mac80211: fix a memory leak on sta rate selection table
Date: Fri, 18 Jul 2014 14:11:43 +0200
Message-Id: <2cee62888af61f9786994e8662b267a9de6cb88d.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felix Fietkau <nbd@openwrt.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 53d045258ee2e38b1e882617cb0799a04d05f5fa upstream.

If the rate control algorithm uses a selection table, it
is leaked when the station is destroyed - fix that.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Christophe Prévotaux <cprevotaux@nltinc.com>
Fixes: 0d528d85c519 ("mac80211: improve the rate control API")
[add commit log entry, remove pointless NULL check]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/mac80211/sta_info.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index db41c190e76d..37025725c369 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -271,6 +271,7 @@ void sta_info_free(struct ieee80211_local *local, struct sta_info *sta)
 
 	sta_dbg(sta->sdata, "Destroyed STA %pM\n", sta->sta.addr);
 
+	kfree(rcu_dereference_raw(sta->sta.rates));
 	kfree(sta);
 }
 
-- 
2.0.0

