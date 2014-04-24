Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbaDXJ21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:28:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46995 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833AbaDXIzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:55:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 149/182] mac80211: fix software remain-on-channel implementation
Date: Thu, 24 Apr 2014 09:51:14 +0100
Message-Id: <1398329507-5911-150-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/mac80211/offchannel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index acd1f71..11d3f22 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -355,6 +355,7 @@ void ieee80211_sw_roc_work(struct work_struct *work)
 		struct ieee80211_roc_work *dep;
 
 		/* start this ROC */
+		ieee80211_offchannel_stop_vifs(local);
 
 		/* switch channel etc */
 		ieee80211_recalc_idle(local);
-- 
1.9.1

