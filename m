Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697AbaEMKX3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:23:29 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:33415 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932769AbaEMKL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:11:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 156/182] mac80211: fix software remain-on-channel implementation
Date: Tue, 13 May 2014 11:28:28 +0200
Message-Id: <cbcad1ef044b969d34e0f3c6242566f7229d22c6.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 115b943a6ea12656088fa1ff6634c0d30815e55b upstream.

Jouni reported that when doing off-channel transmissions mixed
with on-channel transmissions, the on-channel ones ended up on
the off-channel in some cases.

The reason for that is that during the refactoring of the off-
channel code, I lost the part that stopped all activity and as
a consequence the on-channel frames (including data frames)
were no longer queued but would be transmitted on the temporary
channel.

Fix this by simply restoring the lost activity stop call.

Fixes: 2eb278e083549 ("mac80211: unify SW/offload remain-on-channel")
Reported-by: Jouni Malinen <j@w1.fi>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/mac80211/offchannel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 0c2a29484c07..6fb38558a5e6 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -355,6 +355,7 @@ void ieee80211_sw_roc_work(struct work_struct *work)
 		struct ieee80211_roc_work *dep;
 
 		/* start this ROC */
+		ieee80211_offchannel_stop_vifs(local);
 
 		/* switch channel etc */
 		ieee80211_recalc_idle(local);
-- 
1.9.3

