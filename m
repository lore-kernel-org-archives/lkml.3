Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbaHVBNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 21:13:37 -0400
Received: from regular1.263xmail.com ([211.150.99.139]:55794 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467AbaHVBNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 21:13:36 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: wsa@the-dreams.de
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <7d671f892ba0f169f174ba818e410ea9>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Addy Ke <addy.ke@rock-chips.com>
To: wsa@the-dreams.de, max.schwarz@online.de, heiko@sntech.de, olof@lixom.net,
        dianders@chromium.org
Cc: sergei.shtylyov@cogentembedded.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, cf@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, hj@rock-chips.com, kever.yang@rock-chips.com,
        hl@rock-chips.com, caesar.wang@rock-chips.com, zhengsq@rock-chips.com,
        Addy Ke <addy.ke@rock-chips.com>
Subject: [PATCH v3] i2c: rk3x: fix bug that cause transfer fails in master receive mode
Date: Fri, 22 Aug 2014 09:13:11 +0800
Message-Id: <1408669991-9703-1-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1408657107-8715-1-git-send-email-addy.ke@rock-chips.com>
References: <1408657107-8715-1-git-send-email-addy.ke@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In rk3x SOC, the I2C controller can receive/transmit up to 32 bytes data
in one chunk, so the size of data to be write/read to/from TXDATAx/RXDATAx
must be less than or equal 32 bytes at a time.

Tested on rk3288-pinky board, elan receive 158 bytes data.

Acked-by: Max Schwarz <max.schwarz@online.de>
Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
---
Changes in v2:
- Use cleaner syntax as suggested by Sergei.
- Update commit message as suggested by Wolfram.

Changes in v3:
- fix typo: maste --> master and double spaces after 'len'

 drivers/i2c/busses/i2c-rk3x.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
index 69e1185..806724a 100644
--- a/drivers/i2c/busses/i2c-rk3x.c
+++ b/drivers/i2c/busses/i2c-rk3x.c
@@ -323,6 +323,10 @@ static void rk3x_i2c_handle_read(struct rk3x_i2c *i2c, unsigned int ipd)
 	/* ack interrupt */
 	i2c_writel(i2c, REG_INT_MBRF, REG_IPD);
 
+	/* Can only handle a maximum of 32 bytes at a time */
+	if (unlikely(len > 32))
+		len = 32;
+
 	/* read the data from receive buffer */
 	for (i = 0; i < len; ++i) {
 		if (i % 4 == 0)
-- 
1.8.3.2


