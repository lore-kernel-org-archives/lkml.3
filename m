Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab3IKE6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 00:58:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3257 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab3IKE4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:56:52 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=1EkJrXYOyqQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=ys2x8bRpFFAA:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=QyXUC8HyAAAA:8 a=FSAokOOsd0ypDeaCx5wA:9 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042930.687806996@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:30:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Lukasz Jagiello <jagiello.lukasz@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [231/251] iwlwifi: dvm: fix calling ieee80211_chswitch_done() with NULL
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0231-iwlwifi-dvm-fix-calling-ieee80211_chswitch_done-with.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

[ Upstream commit 9186a1fd9ed190739423db84bc344d258ef3e3d7 ]

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

Cc: stable@vger.kernel.org
Reported-by: Lukasz Jagiello <jagiello.lukasz@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 7a2cf52..515376d 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -941,7 +941,10 @@ void iwl_chswitch_done(struct iwl_priv *priv, bool is_success)
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
1.7.10.4


