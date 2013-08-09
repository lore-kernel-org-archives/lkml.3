Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030419Ab3HICLy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:11:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55776 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967647Ab3HIB7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Avinash Patil <patila@marvell.com>, Stone Piao <piaoyun@marvell.com>,
        Bing Zhao <bzhao@marvell.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 058/102] mwifiex: check for bss_role instead of bss_mode for STA operations
Date: Thu,  8 Aug 2013 18:57:34 -0700
Message-Id: <20130809015023.764603700@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avinash Patil <patila@marvell.com>

commit 953b3539ef9301b8ef73f4b6e2fd824b86aae65a upstream.

This patch fixes an issue wherein association would fail on P2P
interfaces. This happened because we are checking priv->mode
against NL80211_IFTYPE_STATION. While this check is correct for
infrastructure stations, it would fail P2P clients for which mode
is NL80211_IFTYPE_P2P_CLIENT.

Better check would be bss_role which has only 2 values: STA/AP.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Stone Piao <piaoyun@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/mwifiex/cfg80211.c |    4 ++--
 drivers/net/wireless/mwifiex/join.c     |    6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -1668,9 +1668,9 @@ mwifiex_cfg80211_connect(struct wiphy *w
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
 	int ret;
 
-	if (priv->bss_mode != NL80211_IFTYPE_STATION) {
+	if (GET_BSS_ROLE(priv) != MWIFIEX_BSS_ROLE_STA) {
 		wiphy_err(wiphy,
-			  "%s: reject infra assoc request in non-STA mode\n",
+			  "%s: reject infra assoc request in non-STA role\n",
 			  dev->name);
 		return -EINVAL;
 	}
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -1290,8 +1290,10 @@ int mwifiex_associate(struct mwifiex_pri
 {
 	u8 current_bssid[ETH_ALEN];
 
-	/* Return error if the adapter or table entry is not marked as infra */
-	if ((priv->bss_mode != NL80211_IFTYPE_STATION) ||
+	/* Return error if the adapter is not STA role or table entry
+	 * is not marked as infra.
+	 */
+	if ((GET_BSS_ROLE(priv) != MWIFIEX_BSS_ROLE_STA) ||
 	    (bss_desc->bss_mode != NL80211_IFTYPE_STATION))
 		return -1;
 


