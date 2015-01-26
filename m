Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbbAZMFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:05:16 -0500
Received: from regular1.263xmail.com ([211.150.99.137]:45006 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753414AbbAZMFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:05:12 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-ADDR-CHECKED: 0
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: robh+dt@kernel.org
X-SENDER-IP: 124.248.208.12
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <88a8fcc971529b92d68cfb6f6db37fef>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Addy Ke <addy.ke@rock-chips.com>
To: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        rdunlap@infradead.org, tgih.jun@samsung.com, jh80.chung@samsung.com,
        chris@printf.net, ulf.hansson@linaro.org, dinguyen@altera.com,
        heiko@sntech.de, olof@lixom.net, dianders@chromium.org,
        sonnyrao@chromium.org, amstan@chromium.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, lintao@rock-chips.com, chenfen@rock-chips.com,
        zyf@rock-chips.com, xjq@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, hj@rock-chips.com,
        kever.yang@rock-chips.com, zhangqing@rock-chips.com, hl@rock-chips.com,
        Addy Ke <addy.ke@rock-chips.com>
Subject: [PATCH] mmc: dw_mmc: fix bug that cause mmc_test failture
Date: Mon, 26 Jan 2015 20:04:09 +0800
Message-Id: <1422273849-29773-1-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The STOP command can terminate a data transfer between a memory card and
mmc controller.

As show in Synopsys DesignWare Cores Mobile Stroage Host Databook:
Data timeout and Data end-bit error will terminate further data transfer
by mmc controller. So we should not send abort command to terminate a
data transfer again if we got DRTO and EBE interrupt.

After this patch, all mmc_test cases can pass on RK3288-Pink2 board.

Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
---
 drivers/mmc/host/dw_mmc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 4d2e3c2..4bd7df1 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1520,7 +1520,10 @@ static void dw_mci_tasklet_func(unsigned long priv)
 			if (test_and_clear_bit(EVENT_DATA_ERROR,
 					       &host->pending_events)) {
 				dw_mci_stop_dma(host);
-				send_stop_abort(host, data);
+				if (data->stop ||
+				    !(host->data_status & SDMMC_INT_DRTO) ||
+				    !(host->data_status & SDMMC_INT_EBE))
+					send_stop_abort(host, data);
 				state = STATE_DATA_ERROR;
 				break;
 			}
@@ -1547,7 +1550,10 @@ static void dw_mci_tasklet_func(unsigned long priv)
 			if (test_and_clear_bit(EVENT_DATA_ERROR,
 					       &host->pending_events)) {
 				dw_mci_stop_dma(host);
-				send_stop_abort(host, data);
+				if (data->stop ||
+				    !(host->data_status & SDMMC_INT_DRTO) ||
+				    !(host->data_status & SDMMC_INT_EBE))
+					send_stop_abort(host, data);
 				state = STATE_DATA_ERROR;
 				break;
 			}
-- 
1.8.3.2


