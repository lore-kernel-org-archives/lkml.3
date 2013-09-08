Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759413Ab3IHDUa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:20:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55993 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754036Ab3IHDSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:52 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "John W. Linville" <linville@tuxdriver.com>,
        "Stanislaw Gruszka" <sgruszka@redhat.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.831665499@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [055/121] iwl4965: reset firmware after rfkill off
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filenames, context, naming]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/iwlegacy/iwl4965-base.c | 10 +++++-----
 drivers/net/wireless/iwlegacy/iwl-core.c     |  1 +
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -868,12 +868,12 @@ static void iwl4965_irq_tasklet(struct i
 		 * is killed. Hence update the killswitch state here. The
 		 * rfkill handler will care about restarting if needed.
 		 */
-		if (!test_bit(STATUS_ALIVE, &priv->status)) {
-			if (hw_rf_kill)
-				set_bit(STATUS_RF_KILL_HW, &priv->status);
-			else
-				clear_bit(STATUS_RF_KILL_HW, &priv->status);
+		if (hw_rf_kill) {
+			set_bit(STATUS_RF_KILL_HW, &priv->status);
+		} else {
+			clear_bit(STATUS_RF_KILL_HW, &priv->status);
 			wiphy_rfkill_set_hw_state(priv->hw->wiphy, hw_rf_kill);
+			iwl_legacy_force_reset(priv, true);
 		}
 
 		handled |= CSR_INT_BIT_RF_KILL;
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -1757,6 +1757,7 @@ int iwl_legacy_force_reset(struct iwl_pr
 
 	return 0;
 }
+EXPORT_SYMBOL(iwl_legacy_force_reset);
 
 int
 iwl_legacy_mac_change_interface(struct ieee80211_hw *hw,

