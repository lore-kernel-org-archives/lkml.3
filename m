Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbaCHBMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:12:34 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424AbaCHBH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:07:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lukasz Jagiello <jagiello.lukasz@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Ben Hutchings <ben@decadent.org.uk>, Jianguo Wu <wujianguo@huawei.com>
Subject: [PATCH 3.4 95/99] iwlwifi: dvm: fix calling ieee80211_chswitch_done() with NULL
Date: Fri,  7 Mar 2014 17:08:31 -0800
Message-Id: <20140308010614.610475672@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context, filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
[wujg: Backported to 3.4: - adjust context]
Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -801,7 +801,10 @@ void iwl_chswitch_done(struct iwl_priv *
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return;
 
-	if (test_and_clear_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status))
+	if (!test_and_clear_bit(STATUS_CHANNEL_SWITCH_PENDING, &priv->status))
+		return;
+
+	if (ctx->vif)
 		ieee80211_chswitch_done(ctx->vif, is_success);
 }
 


