Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935218AbaKNNHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 08:07:53 -0500
Received: from va-smtp01.263.net ([54.88.144.211]:38301 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933890AbaKNNHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 08:07:51 -0500
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: robh+dt@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <8b746ddb5ebdcdca8f66070ec3c1d909>
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
        Addy <addy.ke@rock-chips.com>
Subject: [PATCH] mmc: dw_mmc: add quirk for data over interrupt timeout
Date: Fri, 14 Nov 2014 21:05:38 +0800
Message-Id: <1415970338-2637-1-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Addy <addy.ke@rock-chips.com>

This patch add a new quirk to notify the driver to teminate
current transfer and report a data timeout to the core,
if data over interrupt does NOT come within the given time.

dw_mmc call mmc_request_done func to finish transfer depends on
data over interrupt. If data over interrupt does not come in
sending data state, the current transfer will be blocked.

But this case really exists, when driver reads tuning data from
card on rk3288-pink2 board. I measured waveforms by oscilloscope
and found that card clock was always on and data lines were always
holded high level in sending data state. This is the cause that
card does NOT send data to host.

According to synopsys designware databook, the timeout counter is
started only after the card clock is stopped.

So if card clock is always on, data read timeout interrupt will NOT come,
and if data lines are always holded high level, all data-related
interrupt such as start-bit error, data crc error, data over interrupt,
end-bit error, and so on, will NOT come too.

So driver can't get the current state, it can do nothing but wait for.

This patch is based on https://patchwork.kernel.org/patch/5227941/

Signed-off-by: Addy <addy.ke@rock-chips.com>
---
 drivers/mmc/host/dw_mmc.c  | 47 +++++++++++++++++++++++++++++++++++++++++++++-
 include/linux/mmc/dw_mmc.h |  5 +++++
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index b4c3044..3960fc3 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -1448,6 +1448,17 @@ static int dw_mci_data_complete(struct dw_mci *host, struct mmc_data *data)
 	return data->error;
 }
 
+static inline void dw_mci_dto_start_monitor(struct dw_mci *host)
+{
+	unsigned int data_tmout_clks;
+	unsigned int data_tmout_ms;
+
+	data_tmout_clks = (mci_readl(host, TMOUT) >> 8);
+	data_tmout_ms = (data_tmout_clks * 1000 / host->bus_hz) + 250;
+
+	mod_timer(&host->dto_timer, jiffies + msecs_to_jiffies(data_tmout_ms));
+}
+
 static void dw_mci_tasklet_func(unsigned long priv)
 {
 	struct dw_mci *host = (struct dw_mci *)priv;
@@ -1522,8 +1533,11 @@ static void dw_mci_tasklet_func(unsigned long priv)
 			}
 
 			if (!test_and_clear_bit(EVENT_XFER_COMPLETE,
-						&host->pending_events))
+						&host->pending_events)) {
+				if (host->quirks & DW_MCI_QUIRK_DTO_TIMER)
+					dw_mci_dto_start_monitor(host);
 				break;
+			}
 
 			set_bit(EVENT_XFER_COMPLETE, &host->completed_events);
 
@@ -2115,6 +2129,9 @@ static irqreturn_t dw_mci_interrupt(int irq, void *dev_id)
 		}
 
 		if (pending & SDMMC_INT_DATA_OVER) {
+			if (host->quirks & DW_MCI_QUIRK_DTO_TIMER)
+				del_timer(&host->dto_timer);
+
 			mci_writel(host, RINTSTS, SDMMC_INT_DATA_OVER);
 			if (!host->data_status)
 				host->data_status = pending;
@@ -2502,6 +2519,28 @@ ciu_out:
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
+		* If data over interrupt does NOT come in sending data state,
+		* we should notify the driver to teminate current transfer
+		* and report a data timeout to the core.
+		*/
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
@@ -2513,6 +2552,9 @@ static struct dw_mci_of_quirks {
 	}, {
 		.quirk	= "disable-wp",
 		.id	= DW_MCI_QUIRK_NO_WRITE_PROTECT,
+	}, {
+		.quirk	= "dto-timer",
+		.id	= DW_MCI_QUIRK_DTO_TIMER,
 	},
 };
 
@@ -2654,6 +2696,9 @@ int dw_mci_probe(struct dw_mci *host)
 
 	spin_lock_init(&host->lock);
 	INIT_LIST_HEAD(&host->queue);
+	if (host->quirks & DW_MCI_QUIRK_DTO_TIMER)
+		setup_timer(&host->dto_timer,
+			    dw_mci_dto_timer, (unsigned long)host);
 
 	/*
 	 * Get the host data width - this assumes that HCON has been set with
diff --git a/include/linux/mmc/dw_mmc.h b/include/linux/mmc/dw_mmc.h
index 42b724e..2477813 100644
--- a/include/linux/mmc/dw_mmc.h
+++ b/include/linux/mmc/dw_mmc.h
@@ -98,6 +98,7 @@ struct mmc_data;
  * @irq_flags: The flags to be passed to request_irq.
  * @irq: The irq value to be passed to request_irq.
  * @sdio_id0: Number of slot0 in the SDIO interrupt registers.
+ * @dto_timer: Timer for data over interrupt timeout.
  *
  * Locking
  * =======
@@ -196,6 +197,8 @@ struct dw_mci {
 	int			irq;
 
 	int			sdio_id0;
+
+	struct timer_list	dto_timer;
 };
 
 /* DMA ops for Internal/External DMAC interface */
@@ -220,6 +223,8 @@ struct dw_mci_dma_ops {
 #define DW_MCI_QUIRK_BROKEN_CARD_DETECTION	BIT(3)
 /* No write protect */
 #define DW_MCI_QUIRK_NO_WRITE_PROTECT		BIT(4)
+/* Timer for data over interrupt timeout */
+#define DW_MCI_QUIRK_DTO_TIMER			BIT(5)
 
 /* Slot level quirks */
 /* This slot has no write protect */
-- 
1.8.3.2

