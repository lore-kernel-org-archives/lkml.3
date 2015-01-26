Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480AbbAZQ5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:57:14 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:44528 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbbAZQ5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:57:11 -0500
From: Dmitry Osipenko <digetx@gmail.com>
To: digetx@gmail.com, Wolfram Sang <wsa@the-dreams.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>,
        Bob Mottram <bob.mottram@codethink.co.uk>, linux-tegra@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] i2c: tegra: Maintain CPU endianness
Date: Mon, 26 Jan 2015 19:55:02 +0300
Message-Id: <1422291305-32514-1-git-send-email-digetx@gmail.com>
X-Mailer: git-send-email 2.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support CPU BE mode by adding endianness conversion for memcpy interactions.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Acked-by: Alexandre Courbot <acourbot@nvidia.com>
---
Changelog:
v2: For consistency cpu_to_le32() changed to le32_to_cpu() because
    i2c_writel() takes BE value in BE CPU mode and value is in LE format.
v3: Removed "val = 0;", it turned out it wasn't needed. For some reason
    it wasn't working at first time, hope it was just me doing something
    wrong and it's not a heisenbug. I've checked kernel with all memory
    corruption detection options enabled and it didn't show any problems.

 drivers/i2c/busses/i2c-tegra.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
index 28b87e6..29f1433 100644
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
@@ -344,6 +345,7 @@ static int tegra_i2c_fill_tx_fifo(struct tegra_i2c_dev *i2c_dev)
 	if (tx_fifo_avail > 0 && buf_remaining > 0) {
 		BUG_ON(buf_remaining > 3);
 		memcpy(&val, buf, buf_remaining);
+		val = le32_to_cpu(val);
 
 		/* Again update before writing to FIFO to make sure isr sees. */
 		i2c_dev->msg_buf_remaining = 0;
-- 
2.2.1

