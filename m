Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757089Ab3HRUqx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 16:46:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159Ab3HRUew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 16:34:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 13/45] iwl4965: reset firmware after rfkill off
Date: Sun, 18 Aug 2013 13:36:02 -0700
Message-Id: <20130818203621.910970906@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130818203620.996166594@linuxfoundation.org>
References: <20130818203620.996166594@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlegacy/4965-mac.c |   10 +++++-----
 drivers/net/wireless/iwlegacy/common.c   |    1 +
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -4442,12 +4442,12 @@ il4965_irq_tasklet(struct il_priv *il)
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
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -4660,6 +4660,7 @@ il_force_reset(struct il_priv *il, bool
 
 	return 0;
 }
+EXPORT_SYMBOL(il_force_reset);
 
 int
 il_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,


