Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858AbbAVSN6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 13:13:58 -0500
Received: from mail-lb0-f178.google.com ([209.85.217.178]:34699 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbbAVSN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 13:13:56 -0500
From: Dmitry Osipenko <digetx@gmail.com>
To: digetx@gmail.com, Wolfram Sang <wsa@the-dreams.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>,
        Bob Mottram <bob.mottram@codethink.co.uk>, linux-tegra@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] i2c: tegra: Maintain CPU endianness
Date: Thu, 22 Jan 2015 21:12:21 +0300
Message-Id: <1421950352-26515-1-git-send-email-digetx@gmail.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support CPU BE mode by adding endianness conversion for memcpy interactions.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
---
Changelog:
v2: For consistency cpu_to_le32() changed to le32_to_cpu() because
    i2c_writel() takes BE value in BE CPU mode and value is in LE format.

 drivers/i2c/busses/i2c-tegra.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 28b87e6..b5afb9f 100644
--- a/drivers/i2c/busses/i2c-tegra.c
+++ b/drivers/i2c/busses/i2c-tegra.c
@@ -286,6 +286,7 @@ static int tegra_i2c_empty_rx_fifo(struct tegra_i2c_dev *i2c_dev)
 	if (rx_fifo_avail > 0 && buf_remaining > 0) {
 		BUG_ON(buf_remaining > 3);
 		val = i2c_readl(i2c_dev, I2C_RX_FIFO);
+		val = cpu_to_le32(val);
 		memcpy(buf, &val, buf_remaining);
 		buf_remaining = 0;
 		rx_fifo_avail--;
@@ -343,7 +344,9 @@ static int tegra_i2c_fill_tx_fifo(struct tegra_i2c_dev *i2c_dev)
 	 */
 	if (tx_fifo_avail > 0 && buf_remaining > 0) {
 		BUG_ON(buf_remaining > 3);
+		val = 0;
 		memcpy(&val, buf, buf_remaining);
+		val = le32_to_cpu(val);
 
 		/* Again update before writing to FIFO to make sure isr sees. */
 		i2c_dev->msg_buf_remaining = 0;
-- 
2.2.1

