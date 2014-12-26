Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbaLZJQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 04:16:22 -0500
Received: from regular1.263xmail.com ([211.150.99.134]:40459 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbaLZJQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 04:16:18 -0500
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-ADDR-CHECKED: 0
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: robh+dt@kernel.org
X-SENDER-IP: 58.22.7.114
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <28872ce8a4d5b6b5720a5f24a754f919>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
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
Subject: [PATCH v4] mmc: dw_mmc: add quirk for broken data transfer over scheme
Date: Fri, 26 Dec 2014 17:13:43 +0800
Message-Id: <1419585223-8214-1-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1417576563-5033-1-git-send-email-addy.ke@rock-chips.com>
References: <1417576563-5033-1-git-send-email-addy.ke@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add a new quirk to add a s/w timer to notify the driver
to terminate current transfer and report a data timeout to the core,
if DTO interrupt does NOT come within the given time.

dw_mmc call mmc_request_done func to finish transfer depends on
DTO interrupt. If DTO interrupt does not come in sending data state,
the current transfer will be blocked.

We got the reply from synopsys:
There are two counters but both use the same value of [31:8] bits.
Data timeout counter doesn't wait for stop clock and you should get
DRTO even when the clock is not stopped.
Host Starvation timeout counter is triggered with stop clock condition.

This means that host should get DRTO and DTO interrupt.

But this case really exists, when driver reads tuning data from
card on RK3288-pink2 board. I measured waveforms by oscilloscope
and found that card clock was always on and data lines were always
holded high level in sending data state.

There are two possibility that data over interrupt doesn't come in
reading data state on RK3X SoCs:
- get command done interrupt, but doesn't get any data-related interrupt.
- get data error interrupt, but doesn't get data over interrupt.

We don't know why we have this problem, but we need it to fix this problem now.
And I will post a follow up change when we find the root cause.

Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
---
Changes in v2:
- fix some typo.
- remove extra timeout value (250ms).
- remove dw_mci_dto_start_monitor func.
- use "broken-dto" for new quirk and change Subject for it.

Changes in v3:
- Remove dts for broken-dto, just add this quirk in dw_mci_rockchip_init

Changes in v4:
- fix bug that may cause 32 bit overflow by (drto_clks * 1000).
- doesn't call mod_timer in writing data state, becase TMOUT register only
  for reading data.

 drivers/mmc/host/dw_mmc-rockchip.c |  3 ++
 drivers/mmc/host/dw_mmc.c          | 64 ++++++++++++++++++++++++++++++++++++--
 include/linux/mmc/dw_mmc.h         |  5 +++
 3 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc-rockchip.c b/drivers/mmc/host/dw_mmc-rockchip.c
index 5650ac4..ba92ebd 100644
--- a/drivers/mmc/host/dw_mmc-rockchip.c
+++ b/drivers/mmc/host/dw_mmc-rockchip.c
@@ -73,6 +73,9 @@ static int dw_mci_rockchip_init(struct dw_mci *host)
 	/* It is slot 8 on Rockchip SoCs */
 	host->sdio_id0 = 8;
 
+	/* It needs this quirk on all Rockchip SoCs */
+	host->pdata->quirks |= DW_MCI_QUIRK_BROKEN_DTO;
+
 	return 0;
 }
 
diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 6e4d864..385dc0f 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1477,6 +1477,8 @@ static void dw_mci_tasklet_func(unsigned long priv)
 	enum dw_mci_state state;
 	enum dw_mci_state prev_state;
 	unsigned int err;
+	unsigned int drto_clks;
+	unsigned int drto_ms;
 
 	spin_lock(&host->lock);
 
@@ -1542,8 +1544,22 @@ static void dw_mci_tasklet_func(unsigned long priv)
 			}
 
 			if (!test_and_clear_bit(EVENT_XFER_COMPLETE,
-						&host->pending_events))
+						&host->pending_events)) {
+				drto_clks = mci_readl(host, TMOUT) >> 8;
+				drto_ms = DIV_ROUND_UP(drto_clks,
+						       host->bus_hz / 1000);
+
+				/*
+				 * If all data-related interrupts don't come
+				 * within the given time in reading data state.
+				 * */
+				if ((host->quirks & DW_MCI_QUIRK_BROKEN_DTO) &&
+				    (host->dir_status == DW_MCI_RECV_STATUS)) {
+					mod_timer(&host->dto_timer, jiffies +
+						  msecs_to_jiffies(drto_ms));
+				}
 				break;
+			}
 
 			set_bit(EVENT_XFER_COMPLETE, &host->completed_events);
 
@@ -1573,8 +1589,22 @@ static void dw_mci_tasklet_func(unsigned long priv)
 
 		case STATE_DATA_BUSY:
 			if (!test_and_clear_bit(EVENT_DATA_COMPLETE,
-						&host->pending_events))
+						&host->pending_events)) {
+				drto_clks = mci_readl(host, TMOUT) >> 8;
+				drto_ms = DIV_ROUND_UP(drto_clks,
+						       host->bus_hz / 1000);
+				/*
+				 * If data error interrupt comes but data over
+				 * interrupt doesn't come within the given time.
+				 * in reading data state.
+				 * */
+				if ((host->quirks & DW_MCI_QUIRK_BROKEN_DTO) &&
+				    (host->dir_status == DW_MCI_RECV_STATUS)) {
+					mod_timer(&host->dto_timer, jiffies +
+						  msecs_to_jiffies(drto_ms));
+				}
 				break;
+			}
 
 			host->data = NULL;
 			set_bit(EVENT_DATA_COMPLETE, &host->completed_events);
@@ -2135,6 +2165,10 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
 		}
 
 		if (pending & SDMMC_INT_DATA_OVER) {
+			if ((host->quirks & DW_MCI_QUIRK_BROKEN_DTO) &&
+			    (host->dir_status == DW_MCI_RECV_STATUS))
+				del_timer(&host->dto_timer);
+
 			mci_writel(host, RINTSTS, SDMMC_INT_DATA_OVER);
 			if (!host->data_status)
 				host->data_status = pending;
@@ -2522,6 +2556,28 @@ ciu_out:
 	return ret;
 }
 
+static void dw_mci_dto_timer(unsigned long arg)
+{
+	struct dw_mci *host = (struct dw_mci *)arg;
+
+	switch (host->state) {
+	case STATE_SENDING_DATA:
+	case STATE_DATA_BUSY:
+		/*
+		 * If DTO interrupt does NOT come in sending data state,
+		 * we should notify the driver to terminate current transfer
+		 * and report a data timeout to the core.
+		 */
+		host->data_status = SDMMC_INT_DRTO;
+		set_bit(EVENT_DATA_ERROR, &host->pending_events);
+		set_bit(EVENT_DATA_COMPLETE, &host->pending_events);
+		tasklet_schedule(&host->tasklet);
+		break;
+	default:
+		break;
+	}
+}
+
 #ifdef CONFIG_OF
 static struct dw_mci_of_quirks {
 	char *quirk;
@@ -2670,6 +2726,10 @@ int dw_mci_probe(struct dw_mci *host)
 
 	host->quirks = host->pdata->quirks;
 
+	if (host->quirks & DW_MCI_QUIRK_BROKEN_DTO)
+		setup_timer(&host->dto_timer,
+			    dw_mci_dto_timer, (unsigned long)host);
+
 	spin_lock_init(&host->lock);
 	spin_lock_init(&host->irq_lock);
 	INIT_LIST_HEAD(&host->queue);
diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
index 471fb31..2ece0dd 100644
--- a/include/linux/mmc/dw_mmc.h
+++ b/include/linux/mmc/dw_mmc.h
@@ -98,6 +98,7 @@ struct mmc_data;
  * @irq_flags: The flags to be passed to request_irq.
  * @irq: The irq value to be passed to request_irq.
  * @sdio_id0: Number of slot0 in the SDIO interrupt registers.
+ * @dto_timer: Timer for broken data transfer over scheme.
  *
  * Locking
  * =======
@@ -202,6 +203,8 @@ struct dw_mci {
 	int			irq;
 
 	int			sdio_id0;
+
+	struct timer_list       dto_timer;
 };
 
 /* DMA ops for Internal/External DMAC interface */
@@ -226,6 +229,8 @@ struct dw_mci_dma_ops {
 #define DW_MCI_QUIRK_BROKEN_CARD_DETECTION	BIT(3)
 /* No write protect */
 #define DW_MCI_QUIRK_NO_WRITE_PROTECT		BIT(4)
+/* Timer for broken data transfer over scheme */
+#define DW_MCI_QUIRK_BROKEN_DTO			BIT(5)
 
 /* Slot level quirks */
 /* This slot has no write protect */
-- 
1.8.3.2


