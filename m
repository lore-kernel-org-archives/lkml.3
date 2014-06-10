Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290AbaFJTwG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 15:52:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35369 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755129AbaFJTwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:52:02 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 135/160] rtlwifi: rtl8192se: Fix regression due to commit 1bf4bbb
Date: Tue, 10 Jun 2014 12:46:15 -0700
Message-Id: <1402429600-20477-136-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

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
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
index 27efbcd..d27abef 100644
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
1.9.1

