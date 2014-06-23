Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbaFWIiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:38:12 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:55616 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752678AbaFWIca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 002/111] rtlwifi: rtl8192se: Fix regression due to commit 1bf4bbb
Date: Mon, 23 Jun 2014 10:30:37 +0200
Message-Id: <bb15aa8c7ad5a323914de79bc8cc6fa47cb34a68.1403512280.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
References: <55d5f044a1fc96a74e4470e318c0a24f27a9ab7e.1403512280.git.jslaby@suse.cz>
In-Reply-To: <cover.1403512280.git.jslaby@suse.cz>
References: <cover.1403512280.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5f9186990ec4579ee5b7a99b3254c29eda479f36 upstream.

Beginning with kernel 3.13, this driver fails on some systems. The problem
was bisected to:

Commit 1bf4bbb4024dcdab5e57634dd8ae1072d42a53ac
Author: Felix Fietkau <nbd@openwrt.org>
Title: mac80211: send control port protocol frames to the VO queue

There is noting wrong with the above commit. The regression occurs because
V0 queue on RTL8192SE cards uses priority 6, not the usual 7. The fix is to
modify the rtl8192se routine that sets the correct transmit queue.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=74541

Reported-by: Alex Miller <almiller_1@yahoo.co.uk>
Tested-by: Alex Miller <almiller_1@yahoo.co.uk>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org>    [3.13+]
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
index 7d0f2e20f1a2..c240b7591cf0 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
@@ -49,6 +49,12 @@ static u8 _rtl92se_map_hwqueue_to_fwqueue(struct sk_buff *skb,	u8 skb_queue)
 	if (ieee80211_is_nullfunc(fc))
 		return QSLT_HIGH;
 
+	/* Kernel commit 1bf4bbb4024dcdab changed EAPOL packets to use
+	 * queue V0 at priority 7; however, the RTL8192SE appears to have
+	 * that queue at priority 6
+	 */
+	if (skb->priority == 7)
+		return QSLT_VO;
 	return skb->priority;
 }
 
-- 
2.0.0

