Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985AbaDVUXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 16:23:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:36504 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756AbaDVUXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 16:23:03 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Felix Fietkau <nbd@openwrt.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 067/133] ath9k: fix ready time of the multicast buffer queue
Date: Tue, 22 Apr 2014 13:13:25 -0700
Message-Id: <1398197671-12786-68-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398197671-12786-1-git-send-email-kamal@canonical.com>
References: <1398197671-12786-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.22 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index d134faa..846bff1 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1465,7 +1465,7 @@ int ath_cabq_update(struct ath_softc *sc)
 	else if (sc->config.cabqReadytime > ATH9K_READY_TIME_HI_BOUND)
 		sc->config.cabqReadytime = ATH9K_READY_TIME_HI_BOUND;
 
-	qi.tqi_readyTime = (cur_conf->beacon_interval *
+	qi.tqi_readyTime = (TU_TO_USEC(cur_conf->beacon_interval) *
 			    sc->config.cabqReadytime) / 100;
 	ath_txq_update(sc, qnum, &qi);
 
-- 
1.9.1

