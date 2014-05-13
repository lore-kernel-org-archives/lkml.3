Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbaEMVfW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 17:35:22 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55683 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbaEMVfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 17:35:00 -0400
From: Andy Gross <agross@codeaurora.org>
To: Mark Brown <broonie@kernel.org>
Cc: linux-spi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Andy Gross <agross@codeaurora.org>
Subject: [PATCH 2/4] spi: qup: Correct selection of FIFO/Block mode
Date: Tue, 13 May 2014 16:34:42 -0500
Message-Id: <1400016884-9568-3-git-send-email-agross@codeaurora.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1400016884-9568-1-git-send-email-agross@codeaurora.org>
References: <1400016884-9568-1-git-send-email-agross@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the calculation for determining whether to use FIFO or BLOCK
mode.

Signed-off-by: Andy Gross <agross@codeaurora.org>
---
 drivers/spi/spi-qup.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-qup.c b/drivers/spi/spi-qup.c
index ea7017b..57b65e9 100644
--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -289,7 +289,7 @@ static irqreturn_t spi_qup_qup_irq(int irq, void *dev_id)
 	writel_relaxed(opflags, controller->base + QUP_OPERATIONAL);
 
 	if (!xfer) {
-		dev_err_ratelimited(controller->dev, "unexpected irq %x08 %x08 %x08\n",
+		dev_err_ratelimited(controller->dev, "unexpected irq %08x %08x %08x\n",
 				    qup_err, spi_err, opflags);
 		return IRQ_HANDLED;
 	}
@@ -368,7 +368,7 @@ static int spi_qup_io_config(struct spi_device *spi, struct spi_transfer *xfer)
 	n_words = xfer->len / w_size;
 	controller->w_size = w_size;
 
-	if (n_words <= controller->in_fifo_sz) {
+	if (n_words <= (controller->in_fifo_sz / sizeof(u32))) {
 		mode = QUP_IO_M_MODE_FIFO;
 		writel_relaxed(n_words, controller->base + QUP_MX_READ_CNT);
 		writel_relaxed(n_words, controller->base + QUP_MX_WRITE_CNT);
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

