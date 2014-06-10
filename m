Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbaFJUQU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 16:16:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35306 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142AbaFJTvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 15:51:39 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 100/160] irqchip: armada-370-xp: fix invalid cast of signed value into unsigned variable
Date: Tue, 10 Jun 2014 12:45:40 -0700
Message-Id: <1402429600-20477-101-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1402429600-20477-1-git-send-email-kamal@canonical.com>
References: <1402429600-20477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>

commit da343fc776e0bcb238b65d9d24610819b95d0ef4 upstream.

The armada_370_xp_alloc_msi() function returns a signed int, which is
negative on error. However, we store the return value into an
irq_hw_number_t, which is unsigned. Therefore, we actually never test
if armada_370_xp_alloc_msi() returns an error or not, which may lead
us to use hwirq numbers of as 0xffffffe4 (when
armada_370_xp_alloc_msi() returns -ENOSPC).

This commit fixes that by storing the return value of
armada_370_xp_alloc_msi() in a signed variable.

Fixes: 31f614edb726fcc4d5aa0f2895fbdec9b04a3ca4 ('irqchip: armada-370-xp: implement MSI support')
Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Link: https://lkml.kernel.org/r/1397823593-1932-2-git-send-email-thomas.petazzoni@free-electrons.com
Tested-by: Neil Greatorex <neil@fatboyfat.co.uk>
Signed-off-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/irqchip/irq-armada-370-xp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-armada-370-xp.c b/drivers/irqchip/irq-armada-370-xp.c
index 3fac063..79eb0d1 100644
--- a/drivers/irqchip/irq-armada-370-xp.c
+++ b/drivers/irqchip/irq-armada-370-xp.c
@@ -132,8 +132,7 @@ static int armada_370_xp_setup_msi_irq(struct msi_chip *chip,
 				       struct msi_desc *desc)
 {
 	struct msi_msg msg;
-	irq_hw_number_t hwirq;
-	int virq;
+	int virq, hwirq;
 
 	hwirq = armada_370_xp_alloc_msi();
 	if (hwirq < 0)
-- 
1.9.1

