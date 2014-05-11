Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933491AbaEKTYU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 15:24:20 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48273 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933445AbaEKTYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 15:24:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Miller <almiller_1@yahoo.co.uk>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 3.14 53/83] rtlwifi: rtl8192se: Fix regression due to commit 1bf4bbb
Date: Sun, 11 May 2014 21:19:54 +0200
Message-Id: <20140511191914.037707176@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140511191907.024339448@linuxfoundation.org>
References: <20140511191907.024339448@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/trx.c
@@ -49,6 +49,12 @@ static u8 _rtl92se_map_hwqueue_to_fwqueu
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
 


