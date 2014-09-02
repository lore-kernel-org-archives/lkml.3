Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbaIBHul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 03:50:41 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35661 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752603AbaIBHuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 03:50:25 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?Ga=C3=ABl=20PORTAY?= <gael.portay@gmail.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH 5/5] clk: at91: fix div by zero in USB clock driver
Date: Tue,  2 Sep 2014 09:50:18 +0200
Message-Id: <1409644218-13677-6-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409644218-13677-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1409644218-13677-1-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Test rate value before calculating the div value to avoid div by zero.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
Reported-by: Gaël PORTAY <gael.portay@gmail.com>
---
 drivers/clk/at91/clk-usb.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/at91/clk-usb.c b/drivers/clk/at91/clk-usb.c
index 1838777..24b5b02 100644
--- a/drivers/clk/at91/clk-usb.c
+++ b/drivers/clk/at91/clk-usb.c
@@ -279,10 +279,13 @@ static int at91rm9200_clk_usb_set_rate(struct clk_hw *hw, unsigned long rate,
 	int i;
 	struct at91rm9200_clk_usb *usb = to_at91rm9200_clk_usb(hw);
 	struct at91_pmc *pmc = usb->pmc;
-	unsigned long div = parent_rate / rate;
+	unsigned long div;
 
-	if (parent_rate % rate)
+	if (!rate || parent_rate % rate)
 		return -EINVAL;
+
+	div = parent_rate / rate;
+
 	for (i = 0; i < RM9200_USB_DIV_TAB_SIZE; i++) {
 		if (usb->divisors[i] == div) {
 			tmp = pmc_read(pmc, AT91_CKGR_PLLBR) &
-- 
1.9.1

