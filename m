Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab3DRFxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 01:53:18 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:45189 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab3DRFxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 01:53:16 -0400
From: PranavkumarSawargaonkar <pranavkumar@linaro.org>
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au,
        Pranavkumar Sawargaonkar <pranavkumar@linaro.org>,
        Anup Patel <anup.patel@linaro.org>
Subject: [RFC] arm64: Early printk support for virtio-mmio console devices.
Date: Thu, 18 Apr 2013 11:22:24 +0530
Message-Id: <1366264344-28025-1-git-send-email-pranavkumar@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>

This patch implements early printk support for virtio-mmio console devices without using any hypercalls.

The current virtio early printk code in kernel expects that hypervisor will provide some mechanism generally a hypercall to support early printk. This patch does not break existing hypercall based early print support.

This implementation adds:
1. Early read-write register named early_rw in virtio console's config space.
2. Two host feature flags namely VIRTIO_CONSOLE_F_EARLY_READ and VIRTIO_CONSOLE_F_EARLY_WRITE for telling guest about early-read and early-write capability in console device.

Early write mechanism:
1. When a guest wants to out some character, it has to simply write the character to early_rw register in config space of virtio console device.

Early read mechanism:
1. When a guest wants to in some character, it has to simply read the early_rw register in config space of virtio console device. Lets say we get 32-bit value X.
2. If most significant bit of X is set (i.e. X & 0x80000000 == 0x80000000) then least significant 8 bits of X represents input charaacter else guest need to try again reading early_rw register.

Note: This patch only includes kernel side changes for early printk, the host/hypervisor side emulation of early_rw register is out of scope here.

Signed-off-by: Anup Patel <anup.patel@linaro.org>
---
 arch/arm64/kernel/early_printk.c    |   24 ++++++++++++++++++++++++
 include/uapi/linux/virtio_console.h |    4 ++++
 2 files changed, 28 insertions(+)

diff --git a/arch/arm64/kernel/early_printk.c b/arch/arm64/kernel/early_printk.c
index ac974f4..a82b5aa 100644
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
@@ -53,6 +56,26 @@ static void smh_printch(char ch)
 }
 
 /*
+ * VIRTIO MMIO based debug console.
+ */
+static void virtio_console_early_printch(char ch)
+{
+	u32 tmp;
+	struct virtio_console_config *p = early_base + VIRTIO_MMIO_CONFIG;
+
+	tmp = readl_relaxed(early_base + VIRTIO_MMIO_DEVICE_ID);
+	if (tmp != VIRTIO_ID_CONSOLE) {
+		return;
+	}
+
+	tmp = readl_relaxed(early_base + VIRTIO_MMIO_HOST_FEATURES);
+	if (!(tmp & (1 << VIRTIO_CONSOLE_F_EARLY_WRITE))) {
+		return;
+	}
+	writeb_relaxed(ch, &p->early_rw);
+}
+
+/*
  * 8250/16550 (8-bit aligned registers) single character TX.
  */
 static void uart8250_8bit_printch(char ch)
@@ -82,6 +105,7 @@ static const struct earlycon_match earlycon_match[] __initconst = {
 	{ .name = "smh", .printch = smh_printch, },
 	{ .name = "uart8250-8bit", .printch = uart8250_8bit_printch, },
 	{ .name = "uart8250-32bit", .printch = uart8250_32bit_printch, },
+	{ .name = "virtio-console", .printch = virtio_console_early_printch, },
 	{}
 };
 
diff --git a/include/uapi/linux/virtio_console.h b/include/uapi/linux/virtio_console.h
index ee13ab6..1171cb4 100644
--- a/include/uapi/linux/virtio_console.h
+++ b/include/uapi/linux/virtio_console.h
@@ -38,6 +38,8 @@
 /* Feature bits */
 #define VIRTIO_CONSOLE_F_SIZE	0	/* Does host provide console size? */
 #define VIRTIO_CONSOLE_F_MULTIPORT 1	/* Does host provide multiple ports? */
+#define VIRTIO_CONSOLE_F_EARLY_READ 2	/* Does host support early read? */
+#define VIRTIO_CONSOLE_F_EARLY_WRITE 3	/* Does host support early write? */
 
 #define VIRTIO_CONSOLE_BAD_ID		(~(u32)0)
 
@@ -48,6 +50,8 @@ struct virtio_console_config {
 	__u16 rows;
 	/* max. number of ports this device can hold */
 	__u32 max_nr_ports;
+	/* early read/write register */
+	__u32 early_rw;
 } __attribute__((packed));
 
 /*
-- 
1.7.9.5

