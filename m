Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934189AbbA1COI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:14:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41182 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617AbbA1B2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3.18 05/61] mfd: tps65218: Make INT[12] and STATUS registers volatile
Date: Tue, 27 Jan 2015 17:26:17 -0800
Message-Id: <20150128012637.430539182@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012636.936333725@linuxfoundation.org>
References: <20150128012636.936333725@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit 773328da243978bebac82bf4c45604281edb6975 upstream.

STATUS register can be modified by the HW, so we
should bypass cache because of that.

In the case of INT[12] registers, they are the ones
that actually clear the IRQ source at the time they
are read. If we rely on the cache for them, we will
never be able to clear the interrupt, which will cause
our IRQ line to be disabled due to IRQ throttling.

Fixes: 44b4dc6 mfd: tps65218: Add driver for the TPS65218 PMIC
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mfd/tps65218.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/mfd/tps65218.c
+++ b/drivers/mfd/tps65218.c
@@ -125,10 +125,21 @@ int tps65218_clear_bits(struct tps65218
 }
 EXPORT_SYMBOL_GPL(tps65218_clear_bits);
 
+static const struct regmap_range tps65218_yes_ranges[] = {
+	regmap_reg_range(TPS65218_REG_INT1, TPS65218_REG_INT2),
+	regmap_reg_range(TPS65218_REG_STATUS, TPS65218_REG_STATUS),
+};
+
+static const struct regmap_access_table tps65218_volatile_table = {
+	.yes_ranges = tps65218_yes_ranges,
+	.n_yes_ranges = ARRAY_SIZE(tps65218_yes_ranges),
+};
+
 static struct regmap_config tps65218_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 	.cache_type = REGCACHE_RBTREE,
+	.volatile_table = &tps65218_volatile_table,
 };
 
 static const struct regmap_irq tps65218_irqs[] = {


