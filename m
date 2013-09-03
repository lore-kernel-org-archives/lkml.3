Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932944Ab3ICQ2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:28:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46573 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932452Ab3ICQ1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:27:40 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 34/58] iwlwifi: dvm: fix calling ieee80211_chswitch_done() with NULL
Date: Tue,  3 Sep 2013 09:23:38 -0700
Message-Id: <1378225442-20654-35-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 9186a1fd9ed190739423db84bc344d258ef3e3d7 upstream.

If channel switch is pending and we remove interface we can
crash like showed below due to passing NULL vif to mac80211:

BUG: unable to handle kernel paging request at fffffffffffff8cc
IP: [<ffffffff8130924d>] strnlen+0xd/0x40
Call Trace:
 [<ffffffff8130ad2e>] string.isra.3+0x3e/0xd0
 [<ffffffff8130bf99>] vsnprintf+0x219/0x640
 [<ffffffff8130c481>] vscnprintf+0x11/0x30
 [<ffffffff81061585>] vprintk_emit+0x115/0x4f0
 [<ffffffff81657bd5>] printk+0x61/0x63
 [<ffffffffa048987f>] ieee80211_chswitch_done+0xaf/0xd0 [mac80211]
 [<ffffffffa04e7b34>] iwl_chswitch_done+0x34/0x40 [iwldvm]
 [<ffffffffa04f83c3>] iwlagn_commit_rxon+0x2a3/0xdc0 [iwldvm]
 [<ffffffffa04ebc50>] ? iwlagn_set_rxon_chain+0x180/0x2c0 [iwldvm]
 [<ffffffffa04e5e76>] iwl_set_mode+0x36/0x40 [iwldvm]
 [<ffffffffa04e5f0d>] iwlagn_mac_remove_interface+0x8d/0x1b0 [iwldvm]
 [<ffffffffa0459b3d>] ieee80211_do_stop+0x29d/0x7f0 [mac80211]

This is because we nulify ctx->vif in iwlagn_mac_remove_interface()
before calling some other functions that teardown interface. To fix
just check ctx->vif on iwl_chswitch_done(). We should not call
ieee80211_chswitch_done() as channel switch works were already canceled
by mac80211 in ieee80211_do_stop() -> ieee80211_mgd_stop().

Resolve:
https://bugzilla.redhat.com/show_bug.cgi?id=979581

Reported-by: Lukasz Jagiello <jagiello.lukasz@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index c784f69..70c32db 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -961,7 +961,10 @@ void iwl_chswitch_done(struct iwl_priv *priv, bool is_success)
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	if (test_and_clear_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status))
+	if (!test_and_clear_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status))
+		return;
+
+	if (ctx->vif)
 		ieee80211_chswitch_done(ctx->vif, is_success);
 }
 
-- 
1.8.1.2

