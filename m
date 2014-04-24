Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbaDXI5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:57:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47193 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932156AbaDXI4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:56:43 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 182/182] ath9k: fix ready time of the multicast buffer queue
Date: Thu, 24 Apr 2014 09:51:47 +0100
Message-Id: <1398329507-5911-183-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@openwrt.org>

commit 3b3e0efb5c72c4fc940af50b33626b8a78a907dc upstream.

qi->tqi_readyTime is written directly to registers that expect
microseconds as unit instead of TU.
When setting the CABQ ready time, cur_conf->beacon_interval is in TU, so
convert it to microseconds before passing it to ath9k_hw.

This should hopefully fix some Tx DMA issues with buffered multicast
frames in AP mode.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index f0aaeb2..7542d0f 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1576,7 +1576,7 @@ int ath_cabq_update(struct ath_softc *sc)
 	else if (sc->config.cabqReadytime > ATH9K_READY_TIME_HI_BOUND)
 		sc->config.cabqReadytime = ATH9K_READY_TIME_HI_BOUND;
 
-	qi.tqi_readyTime = (cur_conf->beacon_interval *
+	qi.tqi_readyTime = (TU_TO_USEC(cur_conf->beacon_interval) *
 			    sc->config.cabqReadytime) / 100;
 	ath_txq_update(sc, qnum, &qi);
 
-- 
1.9.1

