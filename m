Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852Ab3BNCcw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 21:32:52 -0500
Received: from mout.gmx.net ([212.227.15.18]:65373 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab3BNCcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 21:32:51 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX198vqMxpPN8ysnb4GlxQ4GXmG7r4CqDx0MUTownSQ
	kvt5A2xo4HMFeU
From: Peter Huewe <peterhuewe@gmx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Devendra Naga <devendra.aaru@gmail.com>, Peter Huewe <peterhuewe@gmx.de>,
        Sebastiaan de Haan <sebastiaan@sebastiaandehaan.org>,
        "Justin P. Mattock" <justinmattock@gmail.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging/wlan-ng: Fix 'Branch condition evaluates to a garbage value' in p80211netdev.c
Date: Thu, 14 Feb 2013 03:37:10 +0100
Message-Id: <1360809430-22333-1-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clang/scan-build complains that:
p80211netdev.c:451:6: warning: Branch condition evaluates to a garbage
value
        if ((p80211_wep.data) && (p80211_wep.data != skb->data))
	            ^~~~~~~~~~~~~~~~~

This can happen in p80211knetdev_hard_start_xmit if
- if (wlandev->state != WLAN_DEVICE_OPEN) evaluates to true.
the execution flow then continues at the 'failed' label where
p80211_wep.data is used without being initialized first.

-> Initialize the data field to NULL to fix this issue.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/wlan-ng/p80211netdev.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
index 750330f..0039e08 100644
--- a/drivers/staging/wlan-ng/p80211netdev.c
+++ b/drivers/staging/wlan-ng/p80211netdev.c
@@ -351,6 +351,8 @@ static int p80211knetdev_hard_start_xmit(struct sk_buff *skb,
 	union p80211_hdr p80211_hdr;
 	struct p80211_metawep p80211_wep;
 
+	p80211_wep.data = NULL;
+
 	if (skb == NULL)
 		return NETDEV_TX_OK;
 
-- 
1.7.8.6

