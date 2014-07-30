Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431AbaG3BxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:53:05 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60765 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbaG3BuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:50:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Maxime Coquelin <maxime.coquelin@st.com>
Subject: [PATCH 3.15 24/37] pinctrl: st: Fix irqmux handler
Date: Tue, 29 Jul 2014 18:49:00 -0700
Message-Id: <20140730014828.867857798@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014827.565626091@linuxfoundation.org>
References: <20140730014827.565626091@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime COQUELIN <maxime.coquelin@st.com>

commit 7a2deccf0ef12f7f6e33150d5875020c0c94fa94 upstream.

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

Cc: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pinctrl/pinctrl-st.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pinctrl/pinctrl-st.c
+++ b/drivers/pinctrl/pinctrl-st.c
@@ -1467,7 +1467,7 @@ static void st_gpio_irqmux_handler(unsig
 
 	status = readl(info->irqmux_base);
 
-	for_each_set_bit(n, &status, ST_GPIO_PINS_PER_BANK)
+	for_each_set_bit(n, &status, info->nbanks)
 		__gpio_irq_handler(&info->banks[n]);
 
 	chained_irq_exit(chip, desc);


