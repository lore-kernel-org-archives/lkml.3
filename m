Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab3K0Evi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 23:51:38 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:52678 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3K0Evg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 23:51:36 -0500
Message-ID: <52957ADA.2080704@gmail.com>
Date: Wed, 27 Nov 2013 12:53:46 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: rkuo <rkuo@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org,
        netdev <netdev@vger.kernel.org>
Subject: [PATCH] net: mac80211: tx.c: be sure of 'sdata->vif.type' must be
 NL80211_IFTYPE_AP when be in NL80211_IFTYPE_AP case
References: <528AEFB7.4060301@gmail.com> <20131125011938.GB18921@codeaurora.org> <5292B845.3010404@gmail.com> <5292B8A0.7020409@gmail.com> <5294255E.7040105@gmail.com>
In-Reply-To: <5294255E.7040105@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In next-20131122 tree, if "sdata->vif.type != NL80211_IFTYPE_AP",
'chanctx_conf' will be not initialized, so need check it. Related
warning (with allmodconfig under hexagon):

    CC [M]  net/mac80211/tx.o
  net/mac80211/tx.c: In function 'ieee80211_subif_start_xmit':
  net/mac80211/tx.c:1827:27: warning: 'chanctx_conf' may be used uninitialized in this function [-Wuninitialized]


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 net/mac80211/tx.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c558b24..f3245d6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1814,8 +1814,9 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 			break;
 		/* fall through */
 	case NL80211_IFTYPE_AP:
-		if (sdata->vif.type == NL80211_IFTYPE_AP)
-			chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+		if (sdata->vif.type != NL80211_IFTYPE_AP)
+			goto fail_rcu;
+		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 		if (!chanctx_conf)
 			goto fail_rcu;
 		fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS);
-- 
1.7.7.6
