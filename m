Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab3IKE6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297Ab3IKE5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:01 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=IvcuioqBnLAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=__ViwIN3ecIA:10 a=20KFwNOVAAAA:8 a=zriiK5QFAAAA:8 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=JC73tPrrgw3kd7rbresA:9 a=jEp0ucaQiEUA:10 a=4ZdwZZXJGkcA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042924.950506810@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [197/251] iwl4965: reset firmware after rfkill off
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0197-iwl4965-reset-firmware-after-rfkill-off.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

[ Upstream commit 788f7a56fce1bcb2067b62b851a086fca48a0056 ]

Using rfkill switch can make firmware unstable, what cause various
Microcode errors and kernel warnings. Reseting firmware just after
rfkill off (radio on) helped with that.

Resolve:
https://bugzilla.redhat.com/show_bug.cgi?id=977053

Reported-and-tested-by: Justin Pearce <whitefox@guardianfox.net>
Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/iwlegacy/4965-mac.c |   10 +++++-----
 drivers/net/wireless/iwlegacy/common.c   |    1 +
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index ab56f92..f6624b8 100644
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
index 0370403..3d26831 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -4658,6 +4658,7 @@ il_force_reset(struct il_priv *il, bool external)
 
 	return 0;
 }
+EXPORT_SYMBOL(il_force_reset);
 
 int
 il_mac_change_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
-- 
1.7.10.4


