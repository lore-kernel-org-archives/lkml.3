Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758574AbaGCJWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:22:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51828 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758518AbaGCJWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:22:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>, Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 073/198] mac80211: fix a memory leak on sta rate selection table
Date: Thu,  3 Jul 2014 10:18:36 +0100
Message-Id: <1404379241-8590-74-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 53d045258ee2e38b1e882617cb0799a04d05f5fa upstream.

If the rate control algorithm uses a selection table, it
is leaked when the station is destroyed - fix that.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Reported-by: Christophe Prévotaux <cprevotaux@nltinc.com>
Fixes: 0d528d85c519 ("mac80211: improve the rate control API")
[add commit log entry, remove pointless NULL check]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

