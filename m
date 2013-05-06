Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab3EFMVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 08:21:07 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:56503 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab3EFMVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 08:21:03 -0400
From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
To: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, linaro-kernel@lists.linaro.org,
        patches@linaro.org, anup.patel@linaro.org, amit.shah@redhat.com,
        Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Subject: [PATCH V2 3/3] arm64: earlyprintk support for virtio-mmio console.
Date: Mon,  6 May 2013 17:49:51 +0530
Message-Id: <1367842791-30285-4-git-send-email-pranavkumar@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367842791-30285-1-git-send-email-pranavkumar@linaro.org>
References: <1367842791-30285-1-git-send-email-pranavkumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements earlyprintk based on virtio console
using emerg_wr config register.

Kernel args for using this will be:
earlyprintk=virtio-console,<phys_address>

Signed-off-by: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Signed-off-by: Anup Patel <anup.patel@linaro.org>
---
 arch/arm64/kernel/early_printk.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/arch/arm64/kernel/early_printk.c b/arch/arm64/kernel/early_printk.c
index ac974f4..ea3d2f5 100644
--- a/arch/arm64/kernel/early_printk.c
+++ b/arch/arm64/kernel/early_printk.c
@@ -25,6 +25,9 @@
 
 #include <linux/amba/serial.h>
 #include <linux/serial_reg.h>
+#include <linux/virtio_ids.h>
+#include <linux/virtio_mmio.h>
+#include <linux/virtio_console.h>
 
 static void __iomem *early_base;
 static void (*printch)(char ch);
@@ -53,6 +56,37 @@ static void smh_printch(char ch)
 }
 
 /*
+ * VIRTIO MMIO console single character Tx.
+ */
+static void virtio_console_printch(char ch)
+{
+	u32 tmp;
+	static u32 init_done;
+	static u32 can_write;
+	struct virtio_console_config *p = early_base + VIRTIO_MMIO_CONFIG;
+
+	if (!init_done) {
+		tmp = readl_relaxed(early_base + VIRTIO_MMIO_DEVICE_ID);
+		if (tmp != VIRTIO_ID_CONSOLE) {
+			init_done = 1;
+			return;
+		}
+
+		tmp = readl_relaxed(early_base + VIRTIO_MMIO_HOST_FEATURES);
+		if (!(tmp & (1 << VIRTIO_CONSOLE_F_EMERG_WRITE))) {
+			init_done = 1;
+			return;
+		}
+
+		init_done = 1;
+		can_write = 1;
+	}
+
+	if (can_write)
+		writeb_relaxed(ch, &p->emerg_wr);
+}
+
+/*
  * 8250/16550 (8-bit aligned registers) single character TX.
  */
 static void uart8250_8bit_printch(char ch)
@@ -82,6 +116,7 @@ static const struct earlycon_match earlycon_match[] __initconst = {
 	{ .name = "smh", .printch = smh_printch, },
 	{ .name = "uart8250-8bit", .printch = uart8250_8bit_printch, },
 	{ .name = "uart8250-32bit", .printch = uart8250_32bit_printch, },
+	{ .name = "virtio-console", .printch = virtio_console_printch, },
 	{}
 };
 
-- 
1.7.9.5

