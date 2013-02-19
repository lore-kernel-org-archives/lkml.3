Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934507Ab3BSTGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:06:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54329 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933459Ab3BSSw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:52:26 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Nathaniel Doherty <ntdoherty@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 34/81] rtlwifi: Fix scheduling while atomic bug
Date: Tue, 19 Feb 2013 15:48:57 -0300
Message-Id: <1361299784-8830-35-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit a5ffbe0a1993a27072742ef7db6cf9839956fce9 upstream.

Kernel commits 41affd5 and 6539306 changed the locking in rtl_lps_leave()
from a spinlock to a mutex by doing the calls indirectly from a work queue
to reduce the time that interrupts were disabled. This change was fine for
most systems; however a scheduling while atomic bug was reported in
https://bugzilla.redhat.com/show_bug.cgi?id=903881. The backtrace indicates
that routine rtl_is_special(), which calls rtl_lps_leave() in three places
was entered in atomic context. These direct calls are replaced by putting a
request on the appropriate work queue.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-and-tested-by: Nathaniel Doherty <ntdoherty@gmail.com>
Cc: Nathaniel Doherty <ntdoherty@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/wireless/rtlwifi/base.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/base.c b/drivers/net/wireless/rtlwifi/base.c
index f4c852c..4110a6d 100644
--- a/drivers/net/wireless/rtlwifi/base.c
+++ b/drivers/net/wireless/rtlwifi/base.c
@@ -980,7 +980,8 @@ u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx)
 					 is_tx ? "Tx" : "Rx");
 
 				if (is_tx) {
-					rtl_lps_leave(hw);
+					schedule_work(&rtlpriv->
+						      works.lps_leave_work);
 					ppsc->last_delaylps_stamp_jiffies =
 					    jiffies;
 				}
@@ -990,7 +991,7 @@ u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx)
 		}
 	} else if (ETH_P_ARP == ether_type) {
 		if (is_tx) {
-			rtl_lps_leave(hw);
+			schedule_work(&rtlpriv->works.lps_leave_work);
 			ppsc->last_delaylps_stamp_jiffies = jiffies;
 		}
 
@@ -1000,7 +1001,7 @@ u8 rtl_is_special_data(struct ieee80211_hw *hw, struct sk_buff *skb, u8 is_tx)
 			 "802.1X %s EAPOL pkt!!\n", is_tx ? "Tx" : "Rx");
 
 		if (is_tx) {
-			rtl_lps_leave(hw);
+			schedule_work(&rtlpriv->works.lps_leave_work);
 			ppsc->last_delaylps_stamp_jiffies = jiffies;
 		}
 
-- 
1.7.9.5

