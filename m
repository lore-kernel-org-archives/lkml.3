Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819Ab3CSJAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 05:00:53 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12907 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094Ab3CSJAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 05:00:49 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 19 Mar 2013 02:00:45 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: <sameo@linux.intel.com>
CC: <swarren@nvidia.com>, <broonie@opensource.wolfsonmicro.com>,
        <gg@slimlogic.co.uk>, <linux-kernel@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] mfd: palmas: initialise client->of_node for dummy created client
Date: Tue, 19 Mar 2013 14:28:20 +0530
Message-ID: <1363683500-24891-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Palmas device have three different i2c addresses. The device creates
the two new dummy i2c clients for accessing the register by using
primary client adapter. This new dummy i2c client have their of_node
as NULL.

The dummy i2c client is used for registering interrupt and on this,
it creates irq domain handle. This created irq domain handle has
their of_node as NULL.

Now when any child of this device is registered through the DT as
follows:
         palmas: tps65913@58 {
         	::::::::::::::::::

         	#interrupt-cells = <2>;
                interrupt-controller;

                palmas_rtc {
                       compatible = "ti,palmas-rtc";
                       interrupt-parent = <&palmas>;
                       interrupts = <8 0>;
                };
                ::::::::::;;;
         };

And child driver (palam-rtc in this case) get their irq number as
	irq = platform_get_irq(pdev, 0);

The returned irq number is error in this case. The reason is that
the created irq_domain handle for the palmas interrupt does not have
valid node and so matching of node fails with palmas node.

Hence initialising the newly dummy created client->of_node with the
primary clients of_node so that irq_domain handle have proper of_node
for matching.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
 drivers/mfd/palmas.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
index 73bf76d..a3f2836 100644
--- a/drivers/mfd/palmas.c
+++ b/drivers/mfd/palmas.c
@@ -349,6 +349,7 @@ static int palmas_i2c_probe(struct i2c_client *i2c,
 				ret = -ENOMEM;
 				goto err;
 			}
+			palmas->i2c_clients[i]->dev.of_node = of_node_get(node);
 		}
 		palmas->regmap[i] = devm_regmap_init_i2c(palmas->i2c_clients[i],
 				&palmas_regmap_config[i]);
-- 
1.7.1.1

