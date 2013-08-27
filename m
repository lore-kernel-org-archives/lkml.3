Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab3H0BHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:07:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59575 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab3H0BHa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lukasz Jagiello <jagiello.lukasz@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 61/74] iwlwifi: dvm: fix calling ieee80211_chswitch_done() with NULL
Date: Mon, 26 Aug 2013 18:08:59 -0700
Message-Id: <20130827010437.040427521@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -1059,7 +1059,10 @@ void iwl_chswitch_done(struct iwl_priv *
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	if (test_and_clear_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status))
+	if (!test_and_clear_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status))
+		return;
+
+	if (ctx->vif)
 		ieee80211_chswitch_done(ctx->vif, is_success);
 }
 


