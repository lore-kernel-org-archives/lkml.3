Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149AbaF3JBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 05:01:33 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:41269 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077AbaF3JBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 05:01:18 -0400
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
Subject: [PATCH v7 2/4] arm: fiq: Allow EOI to be communicated to the intc
Date: Mon, 30 Jun 2014 09:53:09 +0100
Message-Id: <1404118391-3850-3-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1404118391-3850-1-git-send-email-daniel.thompson@linaro.org>
References: <1403623097-1153-1-git-send-email-daniel.thompson@linaro.org>
 <1404118391-3850-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modern ARM systems require an EOI to be sent to the interrupt controller
on completion of both IRQ and FIQ. The FIQ code currently does not provide
any API to perform this. This patch provides this API, implemented by
adding a callback to the fiq_chip structure.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Acked-by: Nicolas Pitre <nico@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Fabio Estevam <festevam@gmail.com>
---
 arch/arm/include/asm/fiq.h | 6 ++++++
 arch/arm/kernel/fiq.c      | 9 +++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/arm/include/asm/fiq.h b/arch/arm/include/asm/fiq.h
index ed44528..fbc0df1 100644
--- a/arch/arm/include/asm/fiq.h
+++ b/arch/arm/include/asm/fiq.h
@@ -22,6 +22,11 @@
 struct fiq_chip {
 	void (*fiq_enable)(struct irq_data *data);
 	void (*fiq_disable)(struct irq_data *data);
+
+	/* .fiq_eoi() will be called from the FIQ handler. For this
+	 * reason it must not use spin locks (or any other locks).
+	 */
+	void (*fiq_eoi)(struct irq_data *data);
 };
 
 struct fiq_handler {
@@ -44,6 +49,7 @@ extern void release_fiq(struct fiq_handler *f);
 extern void set_fiq_handler(void *start, unsigned int length);
 extern void enable_fiq(int fiq);
 extern void disable_fiq(int fiq);
+extern void eoi_fiq(int fiq);
 extern bool has_fiq(int fiq);
 extern void fiq_register_mapping(int irq, struct fiq_chip *chip);
 
diff --git a/arch/arm/kernel/fiq.c b/arch/arm/kernel/fiq.c
index 5d831cf..c35fd6a 100644
--- a/arch/arm/kernel/fiq.c
+++ b/arch/arm/kernel/fiq.c
@@ -183,6 +183,15 @@ void disable_fiq(int fiq)
 	disable_irq(fiq + fiq_start);
 }
 
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

