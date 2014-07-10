Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaGJIHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 04:07:21 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:52743 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaGJIFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 04:05:51 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>
Subject: [PATCH v8 2/4] arm: fiq: Allow ACK and EOI to be passed to the intc
Date: Thu, 10 Jul 2014 09:03:45 +0100
Message-Id: <1404979427-12943-3-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404979427-12943-1-git-send-email-daniel.thompson@linaro.org>
References: <1404118391-3850-1-git-send-email-daniel.thompson@linaro.org>
 <1404979427-12943-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modern ARM interrupt controllers require an ACK as interrupts are taken
and an EOI on completion. The FIQ code currently does not provide any
API to perform this.

This patch provides this API, implemented by adding two callbacks to the
fiq_chip structure.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Acked-by: Nicolas Pitre <nico@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Fabio Estevam <festevam@gmail.com>
---
 arch/arm/include/asm/fiq.h |  9 +++++++++
 arch/arm/kernel/fiq.c      | 19 +++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/arch/arm/include/asm/fiq.h b/arch/arm/include/asm/fiq.h
index ed44528..a25c952 100644
--- a/arch/arm/include/asm/fiq.h
+++ b/arch/arm/include/asm/fiq.h
@@ -22,6 +22,13 @@
 struct fiq_chip {
 	void (*fiq_enable)(struct irq_data *data);
 	void (*fiq_disable)(struct irq_data *data);
+
+	/* .fiq_ack() and .fiq_eoi() will be called from the FIQ
+	 * handler. For this reason they must not use spin locks (or any
+	 * other locks).
+	 */
+	int (*fiq_ack)(struct irq_data *data);
+	void (*fiq_eoi)(struct irq_data *data);
 };
 
 struct fiq_handler {
@@ -44,6 +51,8 @@ extern void release_fiq(struct fiq_handler *f);
 extern void set_fiq_handler(void *start, unsigned int length);
 extern void enable_fiq(int fiq);
 extern void disable_fiq(int fiq);
+extern int ack_fiq(int fiq);
+extern void eoi_fiq(int fiq);
 extern bool has_fiq(int fiq);
 extern void fiq_register_mapping(int irq, struct fiq_chip *chip);
 
diff --git a/arch/arm/kernel/fiq.c b/arch/arm/kernel/fiq.c
index 5d831cf..3ccaa8c 100644
--- a/arch/arm/kernel/fiq.c
+++ b/arch/arm/kernel/fiq.c
@@ -183,6 +183,25 @@ void disable_fiq(int fiq)
 	disable_irq(fiq + fiq_start);
 }
 
+int ack_fiq(int fiq)
+{
+	struct fiq_data *data = lookup_fiq_data(fiq);
+
+	if (data && data->fiq_chip->fiq_ack)
+		return data->fiq_chip->fiq_ack(data->irq_data);
+
+	return fiq;
+}
+
+void eoi_fiq(int fiq)
+{
+	struct fiq_data *data = lookup_fiq_data(fiq);
+
+	if (data && data->fiq_chip->fiq_eoi)
+		data->fiq_chip->fiq_eoi(data->irq_data);
+}
+EXPORT_SYMBOL(eoi_fiq);
+
 bool has_fiq(int fiq)
 {
 	struct fiq_data *data = lookup_fiq_data(fiq);
-- 
1.9.3

