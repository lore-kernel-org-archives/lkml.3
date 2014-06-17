Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965986AbaFQRCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 13:02:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50405 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933639AbaFQQPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:15:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 003/121] mac80211: fix software remain-on-channel implementation
Date: Tue, 17 Jun 2014 09:13:16 -0700
Message-Id: <1403021714-16320-4-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403021714-16320-1-git-send-email-kamal@canonical.com>
References: <1403021714-16320-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/mac80211/offchannel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 7acbdaa..8eb1c81 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -357,6 +357,7 @@ void ieee80211_sw_roc_work(struct work_struct *work)
 		struct ieee80211_roc_work *dep;
 
 		/* start this ROC */
+		ieee80211_offchannel_stop_vifs(local);
 
 		/* switch channel etc */
 		ieee80211_recalc_idle(local);
-- 
1.9.1

