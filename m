Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967129AbaFTLfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 07:35:30 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:54732 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966619AbaFTLf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 07:35:28 -0400
From: Maxime COQUELIN <maxime.coquelin@st.com>
To: Linus Walleij <linus.walleij@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc: kernel@stlinux.com, patrice.chotard@st.com, maxime.coquelin@st.com
Subject: [PATCH] pinctrl: st: Fix irqmux handler
Date: Fri, 20 Jun 2014 13:34:54 +0200
Message-Id: <1403264094-16140-1-git-send-email-maxime.coquelin@st.com>
X-Mailer: git-send-email 1.9.1
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-20_04:2014-06-20,2014-06-20,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

st_gpio_irqmux_handler() reads the status register to find out
which banks inside the controller have pending IRQs.
For each banks having pending IRQs, it calls the corresponding handler.

Problem is that current code restricts the number of possible banks inside the
controller to ST_GPIO_PINS_PER_BANK. This define represents the number of pins
inside a bank, so it shouldn't be used here.

On STiH407, PIO_FRONT0 controller has 10 banks, so IRQs pending in the two
last banks (PIO18 & PIO19) aren't handled.

This patch replace ST_GPIO_PINS_PER_BANK by the number of banks inside the
controller.

Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: <stable@vger.kernel.org> #v3.15+
Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
---
 drivers/pinctrl/pinctrl-st.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-st.c b/drivers/pinctrl/pinctrl-st.c
index 1bd6363bc9..9f43916 100644
--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -1431,7 +1431,7 @@ static void st_gpio_irqmux_handler(unsigned irq, struct irq_desc *desc)
 
 	status = readl(info->irqmux_base);
 
-	for_each_set_bit(n, &status, ST_GPIO_PINS_PER_BANK)
+	for_each_set_bit(n, &status, info->nbanks)
 		__gpio_irq_handler(&info->banks[n]);
 
 	chained_irq_exit(chip, desc);
-- 
1.9.1

