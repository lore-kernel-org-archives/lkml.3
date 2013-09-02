Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030Ab3IBCan (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 22:30:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:42449 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab3IBCam (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 22:30:42 -0400
From: George Cherian <george.cherian@ti.com>
To: <linus.walleij@linaro.org>
CC: <linux-gpio@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <kuninori.morimoto.gx@renesas.com>,
        <n.a.balandin@gmail.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH v3 1/3] gpio: pcf857x: change to devm_request_threaded_irq
Date: Mon, 2 Sep 2013 08:00:02 +0530
Message-ID: <1378089004-14478-2-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1378089004-14478-1-git-send-email-george.cherian@ti.com>
References: <1378089004-14478-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the request_irq and use devm_request_threaded_irq
also cleanup free_irq. devm_* takes care of that.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/gpio/gpio-pcf857x.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpio-pcf857x.c b/drivers/gpio/gpio-pcf857x.c
index 947cff4..4d0d28c 100644
--- a/drivers/gpio/gpio-pcf857x.c
+++ b/drivers/gpio/gpio-pcf857x.c
@@ -191,6 +191,25 @@ static int pcf857x_to_irq(struct gpio_chip *chip, unsigned offset)
 	return irq_create_mapping(gpio->irq_domain, offset);
 }
 
+static irqreturn_t pcf857x_irq(int irq, void *data)
+{
+	struct pcf857x  *gpio = data;
+	unsigned long change, i, status, flags;
+
+	status = gpio->read(gpio->client);
+
+	spin_lock_irqsave(&gpio->slock, flags);
+
+	change = gpio->status ^ status;
+	for_each_set_bit(i, &change, gpio->chip.ngpio)
+		generic_handle_irq(irq_find_mapping(gpio->irq_domain, i));
+	gpio->status = status;
+
+	spin_unlock_irqrestore(&gpio->slock, flags);
+
+	return IRQ_HANDLED;
+}
+
 static void pcf857x_irq_demux_work(struct work_struct *work)
 {
 	struct pcf857x *gpio = container_of(work,
@@ -241,8 +260,6 @@ static void pcf857x_irq_domain_cleanup(struct pcf857x *gpio)
 	if (gpio->irq_domain)
 		irq_domain_remove(gpio->irq_domain);
 
-	if (gpio->irq)
-		free_irq(gpio->irq, gpio);
 }
 
 static int pcf857x_irq_domain_init(struct pcf857x *gpio,
@@ -258,8 +275,11 @@ static int pcf857x_irq_domain_init(struct pcf857x *gpio,
 		goto fail;
 
 	/* enable real irq */
-	status = request_irq(client->irq, pcf857x_irq_demux, 0,
-			     dev_name(&client->dev), gpio);
+	status = devm_request_threaded_irq(&client->dev, client->irq,
+				NULL, pcf857x_irq, IRQF_ONESHOT |
+				IRQF_TRIGGER_FALLING,
+				dev_name(&client->dev), gpio);
+
 	if (status)
 		goto fail;
 
-- 
1.8.1.4

