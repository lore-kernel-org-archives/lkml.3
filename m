Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab3J2SY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 14:24:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59285 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab3J2SFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 14:05:13 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Grygorii Strashko <grygorii.strashko@ti.com>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 13/81] i2c: omap: Clear ARDY bit twice
Date: Tue, 29 Oct 2013 11:03:34 -0700
Message-Id: <1383069882-11437-14-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383069882-11437-1-git-send-email-kamal@canonical.com>
References: <1383069882-11437-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taras Kondratiuk <taras.kondratiuk@linaro.org>

commit 4cdbf7d346e7461c3b93a26707c852e2c9db3753 upstream.

Initially commit cb527ede1bf6ff2008a025606f25344b8ed7b4ac
"i2c-omap: Double clear of ARDY status in IRQ handler"
added a workaround for undocumented errata ProDB0017052.
But then commit 1d7afc95946487945cc7f5019b41255b72224b70
"i2c: omap: ack IRQ in parts" refactored code and missed
one of ARDY clearings. So current code violates errata.
It causes often i2c bus timeouts on my Pandaboard.

This patch adds a second clearing in place.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/i2c/busses/i2c-omap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 4cc2f05..6fc54cd 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -941,6 +941,9 @@ omap_i2c_isr_thread(int this_irq, void *dev_id)
 		/*
 		 * ProDB0017052: Clear ARDY bit twice
 		 */
+		if (stat & OMAP_I2C_STAT_ARDY)
+			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_ARDY);
+
 		if (stat & (OMAP_I2C_STAT_ARDY | OMAP_I2C_STAT_NACK |
 					OMAP_I2C_STAT_AL)) {
 			omap_i2c_ack_stat(dev, (OMAP_I2C_STAT_RRDY |
-- 
1.8.1.2

