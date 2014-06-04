Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaFDLgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 07:36:12 -0400
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:58890 "EHLO dev.rtsoft.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752718AbaFDLgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 07:36:04 -0400
From: nyushchenko@dev.rtsoft.ru
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, lugovskoy@dev.rtsoft.ru,
        Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
Subject: [PATCH 11/21] mfd: use devm_irq_of_parse_and_map() where appropriate
Date: Wed,  4 Jun 2014 15:13:11 +0400
Message-Id: <1401880402-30091-12-git-send-email-nyushchenko@dev.rtsoft.ru>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
References: <1401880402-30091-1-git-send-email-nyushchenko@dev.rtsoft.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>

This avoids leak of IRQ mapping on error paths, and makes it possible
to use devm_request_irq() without facing unmap-while-handler-installed
issues.

Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
---
 drivers/mfd/max8997.c |    4 +++-
 drivers/mfd/max8998.c |    4 +++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/max8997.c b/drivers/mfd/max8997.c
index 8cf7a01..6ae0786 100644
--- a/drivers/mfd/max8997.c
+++ b/drivers/mfd/max8997.c
@@ -153,7 +153,9 @@ static struct max8997_platform_data *max8997_i2c_parse_dt_pdata(
 		return ERR_PTR(-ENOMEM);
 	}
 
-	pd->ono = irq_of_parse_and_map(dev->of_node, 1);
+	pd->ono = devm_irq_of_parse_and_map(dev, dev->of_node, 1);
+	if (pd->ono < 0)
+		return ERR_PTR(pd->ono);
 
 	/*
 	 * ToDo: the 'wakeup' member in the platform data is more of a linux
diff --git a/drivers/mfd/max8998.c b/drivers/mfd/max8998.c
index 592db06..6b62dd7 100644
--- a/drivers/mfd/max8998.c
+++ b/drivers/mfd/max8998.c
@@ -159,7 +159,9 @@ static struct max8998_platform_data *max8998_i2c_parse_dt_pdata(
 	if (!pd)
 		return ERR_PTR(-ENOMEM);
 
-	pd->ono = irq_of_parse_and_map(dev->of_node, 1);
+	pd->ono = devm_irq_of_parse_and_map(dev, dev->of_node, 1);
+	if (pd->ono < 0)
+		return ERR_PTR(pd->ono);
 
 	/*
 	 * ToDo: the 'wakeup' member in the platform data is more of a linux
-- 
1.7.10.4

