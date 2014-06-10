Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880AbaFJUkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:40:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34847 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbaFJTq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:46:56 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 004/160] mac80211: fix software remain-on-channel implementation
Date: Tue, 10 Jun 2014 12:44:04 -0700
Message-Id: <1402429600-20477-5-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

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
index 0c2a294..6fb3855 100644
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

