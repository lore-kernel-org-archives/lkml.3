Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933777Ab3GENTJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 09:19:09 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:40548
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756796Ab3GENTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 09:19:05 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.177;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC02.kpit.com;RD:59.163.77.177.static.vsnl.net.in;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23hbe9i1155h)
Subject: [patch v1]mfd: fix for DA9055 driver initialization
From: Ankur Raina <Ankur.Raina@kpitcummins.com>
To: <sameo@linux.intel.com>
CC: <broonie@kernel.org>, <axel.lin@gmail.com>, <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, <david.chen@diasemi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 5 Jul 2013 18:48:30 +0530
Message-ID: <1373030310.1601.30.camel@ankurr1-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.50.126]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch clears all the events received while powering up DA9055.
While powering up DA9055,power sequencer and gpio events are received.
These events remain uncleared after boot up, due to which further event handling also fails.
DA9055 has three event registers.The event register bits are set to '1' on receiving an event.
The events can be cleared on writing a '1' to the set bit, which would then clear that bit to '0'
After applying this patch we have a clean state after boot up.

Signed-off-by: Ankur Raina <Ankur.Raina@kpitcummins.com>
---
 drivers/mfd/da9055-core.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/da9055-core.c b/drivers/mfd/da9055-core.c
index 49cb23d..e4c0596 100644
--- a/drivers/mfd/da9055-core.c
+++ b/drivers/mfd/da9055-core.c
@@ -381,6 +381,7 @@ int da9055_device_init(struct da9055 *da9055)
 {
 	struct da9055_pdata *pdata = da9055->dev->platform_data;
 	int ret;
+	uint8_t clear_events[3] = {0xFF, 0xFF, 0xFF};
 
 	if (pdata && pdata->init != NULL)
 		pdata->init(da9055);
@@ -390,6 +391,10 @@ int da9055_device_init(struct da9055 *da9055)
 	else
 		da9055->irq_base = pdata->irq_base;
 
+	ret = da9055_group_write(da9055, DA9055_REG_EVENT_A, 3, clear_events);
+	if (ret < 0)
+		return ret;
+
 	ret = regmap_add_irq_chip(da9055->regmap, da9055->chip_irq,
 				  IRQF_TRIGGER_LOW | IRQF_ONESHOT,
 				  da9055->irq_base, &da9055_regmap_irq_chip,
-- 
1.7.1


