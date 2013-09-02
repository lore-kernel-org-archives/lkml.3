Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353Ab3IBIzG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:55:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:37654 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758295Ab3IBIy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:54:57 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 08/58] iwl4965: reset firmware after rfkill off
Date: Mon,  2 Sep 2013 09:53:53 +0100
Message-Id: <1378112083-9475-9-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
References: <1378112083-9475-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.21 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 788f7a56fce1bcb2067b62b851a086fca48a0056 upstream.

Using rfkill switch can make firmware unstable, what cause various
Microcode errors and kernel warnings. Reseting firmware just after
rfkill off (radio on) helped with that.

Resolve:
https://bugzilla.redhat.com/show_bug.cgi?id=977053

Reported-and-tested-by: Justin Pearce <whitefox@guardianfox.net>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c | 10 +++++-----
 drivers/net/wireless/iwlegacy/common.c   |  1 +
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index b7528ef..cbcf6f2 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -4411,12 +4411,12 @@ il4965_irq_tasklet(struct il_priv *il)
 		 * is killed. Hence update the killswitch state here. The
 		 * rfkill handler will care about restarting if needed.
 		 */
-		if (!test_bit(S_ALIVE, &il->status)) {
-			if (hw_rf_kill)
-				set_bit(S_RFKILL, &il->status);
-			else
-				clear_bit(S_RFKILL, &il->status);
+		if (hw_rf_kill) {
+			set_bit(S_RFKILL, &il->status);
+		} else {
+			clear_bit(S_RFKILL, &il->status);
 			wiphy_rfkill_set_hw_state(il->hw->wiphy, hw_rf_kill);
+			il_force_reset(il, true);
 		}
 
 		handled |= CSR_INT_BIT_RF_KILL;
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index e2b25eb..6f9c1fa 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -4659,6 +4659,7 @@ il_force_reset(struct il_priv *il, bool external)
 
 	return 0;
 }
+EXPORT_SYMBOL(il_force_reset);
 
 int
 il_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-- 
1.8.3.2

