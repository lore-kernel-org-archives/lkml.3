Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490Ab3HLSgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 14:36:04 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:18625 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3HLSgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 14:36:00 -0400
Message-ID: <201308121835.r7CIZxjh004270@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 12 Aug 2013 14:09:28 -0400
Subject: [PATCH] tilegx: provide kernel support for the tilegx UART shim
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TILE-Gx chip includes an on-chip UART.  This change adds support
for using the UART from within the kernel.  The UART shim has more
functionality than is exposed here, but to keep the kernel code and
binary simpler, this is a subset of the full API designed to enable
a standard Linux tty serial driver only.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/gxio/Kconfig               |   5 +
 arch/tile/gxio/Makefile              |   1 +
 arch/tile/gxio/iorpc_uart.c          |  77 +++++++++
 arch/tile/gxio/uart.c                |  87 ++++++++++
 arch/tile/include/arch/uart.h        | 300 +++++++++++++++++++++++++++++++++++
 arch/tile/include/arch/uart_def.h    | 120 ++++++++++++++
 arch/tile/include/gxio/iorpc_uart.h  |  40 +++++
 arch/tile/include/gxio/uart.h        | 105 ++++++++++++
 arch/tile/include/hv/drv_uart_intf.h |  33 ++++
 9 files changed, 768 insertions(+)
 create mode 100644 arch/tile/gxio/iorpc_uart.c
 create mode 100644 arch/tile/gxio/uart.c
 create mode 100644 arch/tile/include/arch/uart.h
 create mode 100644 arch/tile/include/arch/uart_def.h
 create mode 100644 arch/tile/include/gxio/iorpc_uart.h
 create mode 100644 arch/tile/include/gxio/uart.h
 create mode 100644 arch/tile/include/hv/drv_uart_intf.h

diff --git a/arch/tile/gxio/Kconfig b/arch/tile/gxio/Kconfig
index d221f8d..d4e10d5 100644
--- a/arch/tile/gxio/Kconfig
+++ b/arch/tile/gxio/Kconfig
@@ -26,3 +26,8 @@ config TILE_GXIO_TRIO
 config TILE_GXIO_USB_HOST
 	bool
 	select TILE_GXIO
+
+# Support direct access to the TILE-Gx UART hardware from kernel space.
+config TILE_GXIO_UART
+	bool
+	select TILE_GXIO
diff --git a/arch/tile/gxio/Makefile b/arch/tile/gxio/Makefile
index 8684bca..26ae2c7 100644
--- a/arch/tile/gxio/Makefile
+++ b/arch/tile/gxio/Makefile
@@ -6,4 +6,5 @@ obj-$(CONFIG_TILE_GXIO) += iorpc_globals.o kiorpc.o
 obj-$(CONFIG_TILE_GXIO_DMA) += dma_queue.o
 obj-$(CONFIG_TILE_GXIO_MPIPE) += mpipe.o iorpc_mpipe.o iorpc_mpipe_info.o
 obj-$(CONFIG_TILE_GXIO_TRIO) += trio.o iorpc_trio.o
+obj-$(CONFIG_TILE_GXIO_UART) += uart.o iorpc_uart.o
 obj-$(CONFIG_TILE_GXIO_USB_HOST) += usb_host.o iorpc_usb_host.o
diff --git a/arch/tile/gxio/iorpc_uart.c b/arch/tile/gxio/iorpc_uart.c
new file mode 100644
index 0000000..b9a6d61
--- /dev/null
+++ b/arch/tile/gxio/iorpc_uart.c
@@ -0,0 +1,77 @@
+/*
+ * Copyright 2013 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/* This file is machine-generated; DO NOT EDIT! */
+#include "gxio/iorpc_uart.h"
+
+struct cfg_interrupt_param {
+	union iorpc_interrupt interrupt;
+};
+
+int gxio_uart_cfg_interrupt(gxio_uart_context_t *context, int inter_x,
+			    int inter_y, int inter_ipi, int inter_event)
+{
+	struct cfg_interrupt_param temp;
+	struct cfg_interrupt_param *params = &temp;
+
+	params->interrupt.kernel.x = inter_x;
+	params->interrupt.kernel.y = inter_y;
+	params->interrupt.kernel.ipi = inter_ipi;
+	params->interrupt.kernel.event = inter_event;
+
+	return hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params,
+			     sizeof(*params), GXIO_UART_OP_CFG_INTERRUPT);
+}
+
+EXPORT_SYMBOL(gxio_uart_cfg_interrupt);
+
+struct get_mmio_base_param {
+	HV_PTE base;
+};
+
+int gxio_uart_get_mmio_base(gxio_uart_context_t *context, HV_PTE *base)
+{
+	int __result;
+	struct get_mmio_base_param temp;
+	struct get_mmio_base_param *params = &temp;
+
+	__result =
+	    hv_dev_pread(context->fd, 0, (HV_VirtAddr) params, sizeof(*params),
+			 GXIO_UART_OP_GET_MMIO_BASE);
+	*base = params->base;
+
+	return __result;
+}
+
+EXPORT_SYMBOL(gxio_uart_get_mmio_base);
+
+struct check_mmio_offset_param {
+	unsigned long offset;
+	unsigned long size;
+};
+
+int gxio_uart_check_mmio_offset(gxio_uart_context_t *context,
+				unsigned long offset, unsigned long size)
+{
+	struct check_mmio_offset_param temp;
+	struct check_mmio_offset_param *params = &temp;
+
+	params->offset = offset;
+	params->size = size;
+
+	return hv_dev_pwrite(context->fd, 0, (HV_VirtAddr) params,
+			     sizeof(*params), GXIO_UART_OP_CHECK_MMIO_OFFSET);
+}
+
+EXPORT_SYMBOL(gxio_uart_check_mmio_offset);
diff --git a/arch/tile/gxio/uart.c b/arch/tile/gxio/uart.c
new file mode 100644
index 0000000..cd48a5a
--- /dev/null
+++ b/arch/tile/gxio/uart.c
@@ -0,0 +1,87 @@
+/*
+ * Copyright 2013 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/*
+ * Implementation of UART gxio calls.
+ */
+
+#include <linux/io.h>
+#include <linux/errno.h>
+#include <linux/module.h>
+
+#include <gxio/uart.h>
+#include <gxio/iorpc_globals.h>
+#include <gxio/iorpc_uart.h>
+#include <gxio/kiorpc.h>
+
+int gxio_uart_init(gxio_uart_context_t *context, int uart_index)
+{
+	char file[32];
+	int fd;
+
+	snprintf(file, sizeof(file), "uart/%d/iorpc", uart_index);
+	fd = hv_dev_open((HV_VirtAddr) file, 0);
+	if (fd < 0) {
+		if (fd >= GXIO_ERR_MIN && fd <= GXIO_ERR_MAX)
+			return fd;
+		else
+			return -ENODEV;
+	}
+
+	context->fd = fd;
+
+	/* Map in the MMIO space. */
+	context->mmio_base = (void __force *)
+		iorpc_ioremap(fd, HV_UART_MMIO_OFFSET, HV_UART_MMIO_SIZE);
+
+	if (context->mmio_base == NULL) {
+		hv_dev_close(context->fd);
+		context->fd = -1;
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+EXPORT_SYMBOL(gxio_uart_init);
+
+int gxio_uart_destroy(gxio_uart_context_t *context)
+{
+	iounmap((void __force __iomem *)(context->mmio_base));
+	hv_dev_close(context->fd);
+
+	context->mmio_base = NULL;
+	context->fd = -1;
+
+	return 0;
+}
+
+EXPORT_SYMBOL(gxio_uart_destroy);
+
+/* UART register write wrapper. */
+void gxio_uart_write(gxio_uart_context_t *context, uint64_t offset,
+		     uint64_t word)
+{
+	__gxio_mmio_write(context->mmio_base + offset, word);
+}
+
+EXPORT_SYMBOL(gxio_uart_write);
+
+/* UART register read wrapper. */
+uint64_t gxio_uart_read(gxio_uart_context_t *context, uint64_t offset)
+{
+	return __gxio_mmio_read(context->mmio_base + offset);
+}
+
+EXPORT_SYMBOL(gxio_uart_read);
diff --git a/arch/tile/include/arch/uart.h b/arch/tile/include/arch/uart.h
new file mode 100644
index 0000000..0796697
--- /dev/null
+++ b/arch/tile/include/arch/uart.h
@@ -0,0 +1,300 @@
+/*
+ * Copyright 2013 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/* Machine-generated file; do not edit. */
+
+#ifndef __ARCH_UART_H__
+#define __ARCH_UART_H__
+
+#include <arch/abi.h>
+#include <arch/uart_def.h>
+
+#ifndef __ASSEMBLER__
+
+/* Divisor. */
+
+__extension__
+typedef union
+{
+  struct
+  {
+#ifndef __BIG_ENDIAN__
+    /*
+     * Baud Rate Divisor.  Desired_baud_rate = REF_CLK frequency / (baud *
+     * 16).
+     *                       Note: REF_CLK is always 125 MHz, the default
+     * divisor = 68, baud rate = 125M/(68*16) = 115200 baud.
+     */
+    uint_reg_t divisor    : 12;
+    /* Reserved. */
+    uint_reg_t __reserved : 52;
+#else   /* __BIG_ENDIAN__ */
+    uint_reg_t __reserved : 52;
+    uint_reg_t divisor    : 12;
+#endif
+  };
+
+  uint_reg_t word;
+} UART_DIVISOR_t;
+
+/* FIFO Count. */
+
+__extension__
+typedef union
+{
+  struct
+  {
+#ifndef __BIG_ENDIAN__
+    /*
+     * n: n active entries in the receive FIFO (max is 2**8). Each entry has
+     * 8 bits.
+     * 0: no active entry in the receive FIFO (that is empty).
+     */
+    uint_reg_t rfifo_count  : 9;
+    /* Reserved. */
+    uint_reg_t __reserved_0 : 7;
+    /*
+     * n: n active entries in the transmit FIFO (max is 2**8). Each entry has
+     * 8 bits.
+     * 0: no active entry in the transmit FIFO (that is empty).
+     */
+    uint_reg_t tfifo_count  : 9;
+    /* Reserved. */
+    uint_reg_t __reserved_1 : 7;
+    /*
+     * n: n active entries in the write FIFO (max is 2**2). Each entry has 8
+     * bits.
+     * 0: no active entry in the write FIFO (that is empty).
+     */
+    uint_reg_t wfifo_count  : 3;
+    /* Reserved. */
+    uint_reg_t __reserved_2 : 29;
+#else   /* __BIG_ENDIAN__ */
+    uint_reg_t __reserved_2 : 29;
+    uint_reg_t wfifo_count  : 3;
+    uint_reg_t __reserved_1 : 7;
+    uint_reg_t tfifo_count  : 9;
+    uint_reg_t __reserved_0 : 7;
+    uint_reg_t rfifo_count  : 9;
+#endif
+  };
+
+  uint_reg_t word;
+} UART_FIFO_COUNT_t;
+
+/* FLAG. */
+
+__extension__
+typedef union
+{
+  struct
+  {
+#ifndef __BIG_ENDIAN__
+    /* Reserved. */
+    uint_reg_t __reserved_0 : 1;
+    /* 1: receive FIFO is empty */
+    uint_reg_t rfifo_empty  : 1;
+    /* 1: write FIFO is empty. */
+    uint_reg_t wfifo_empty  : 1;
+    /* 1: transmit FIFO is empty. */
+    uint_reg_t tfifo_empty  : 1;
+    /* 1: receive FIFO is full. */
+    uint_reg_t rfifo_full   : 1;
+    /* 1: write FIFO is full. */
+    uint_reg_t wfifo_full   : 1;
+    /* 1: transmit FIFO is full. */
+    uint_reg_t tfifo_full   : 1;
+    /* Reserved. */
+    uint_reg_t __reserved_1 : 57;
+#else   /* __BIG_ENDIAN__ */
+    uint_reg_t __reserved_1 : 57;
+    uint_reg_t tfifo_full   : 1;
+    uint_reg_t wfifo_full   : 1;
+    uint_reg_t rfifo_full   : 1;
+    uint_reg_t tfifo_empty  : 1;
+    uint_reg_t wfifo_empty  : 1;
+    uint_reg_t rfifo_empty  : 1;
+    uint_reg_t __reserved_0 : 1;
+#endif
+  };
+
+  uint_reg_t word;
+} UART_FLAG_t;
+
+/*
+ * Interrupt Vector Mask.
+ * Each bit in this register corresponds to a specific interrupt. When set,
+ * the associated interrupt will not be dispatched.
+ */
+
+__extension__
+typedef union
+{
+  struct
+  {
+#ifndef __BIG_ENDIAN__
+    /* Read data FIFO read and no data available */
+    uint_reg_t rdat_err       : 1;
+    /* Write FIFO was written but it was full */
+    uint_reg_t wdat_err       : 1;
+    /* Stop bit not found when current data was received */
+    uint_reg_t frame_err      : 1;
+    /* Parity error was detected when current data was received */
+    uint_reg_t parity_err     : 1;
+    /* Data was received but the receive FIFO was full */
+    uint_reg_t rfifo_overflow : 1;
+    /*
+     * An almost full event is reached when data is to be written to the
+     * receive FIFO, and the receive FIFO has more than or equal to
+     * BUFFER_THRESHOLD.RFIFO_AFULL bytes.
+     */
+    uint_reg_t rfifo_afull    : 1;
+    /* Reserved. */
+    uint_reg_t __reserved_0   : 1;
+    /* An entry in the transmit FIFO was popped */
+    uint_reg_t tfifo_re       : 1;
+    /* An entry has been pushed into the receive FIFO */
+    uint_reg_t rfifo_we       : 1;
+    /* An entry of the write FIFO has been popped */
+    uint_reg_t wfifo_re       : 1;
+    /* Rshim read receive FIFO in protocol mode */
+    uint_reg_t rfifo_err      : 1;
+    /*
+     * An almost empty event is reached when data is to be read from the
+     * transmit FIFO, and the transmit FIFO has less than or equal to
+     * BUFFER_THRESHOLD.TFIFO_AEMPTY bytes.
+     */
+    uint_reg_t tfifo_aempty   : 1;
+    /* Reserved. */
+    uint_reg_t __reserved_1   : 52;
+#else   /* __BIG_ENDIAN__ */
+    uint_reg_t __reserved_1   : 52;
+    uint_reg_t tfifo_aempty   : 1;
+    uint_reg_t rfifo_err      : 1;
+    uint_reg_t wfifo_re       : 1;
+    uint_reg_t rfifo_we       : 1;
+    uint_reg_t tfifo_re       : 1;
+    uint_reg_t __reserved_0   : 1;
+    uint_reg_t rfifo_afull    : 1;
+    uint_reg_t rfifo_overflow : 1;
+    uint_reg_t parity_err     : 1;
+    uint_reg_t frame_err      : 1;
+    uint_reg_t wdat_err       : 1;
+    uint_reg_t rdat_err       : 1;
+#endif
+  };
+
+  uint_reg_t word;
+} UART_INTERRUPT_MASK_t;
+
+/*
+ * Interrupt vector, write-one-to-clear.
+ * Each bit in this register corresponds to a specific interrupt. Hardware
+ * sets the bit when the associated condition has occurred. Writing a 1
+ * clears the status bit.
+ */
+
+__extension__
+typedef union
+{
+  struct
+  {
+#ifndef __BIG_ENDIAN__
+    /* Read data FIFO read and no data available */
+    uint_reg_t rdat_err       : 1;
+    /* Write FIFO was written but it was full */
+    uint_reg_t wdat_err       : 1;
+    /* Stop bit not found when current data was received */
+    uint_reg_t frame_err      : 1;
+    /* Parity error was detected when current data was received */
+    uint_reg_t parity_err     : 1;
+    /* Data was received but the receive FIFO was full */
+    uint_reg_t rfifo_overflow : 1;
+    /*
+     * Data was received and the receive FIFO is now almost full (more than
+     * BUFFER_THRESHOLD.RFIFO_AFULL bytes in it)
+     */
+    uint_reg_t rfifo_afull    : 1;
+    /* Reserved. */
+    uint_reg_t __reserved_0   : 1;
+    /* An entry in the transmit FIFO was popped */
+    uint_reg_t tfifo_re       : 1;
+    /* An entry has been pushed into the receive FIFO */
+    uint_reg_t rfifo_we       : 1;
+    /* An entry of the write FIFO has been popped */
+    uint_reg_t wfifo_re       : 1;
+    /* Rshim read receive FIFO in protocol mode */
+    uint_reg_t rfifo_err      : 1;
+    /*
+     * Data was read from the transmit FIFO and now it is almost empty (less
+     * than or equal to BUFFER_THRESHOLD.TFIFO_AEMPTY bytes in it).
+     */
+    uint_reg_t tfifo_aempty   : 1;
+    /* Reserved. */
+    uint_reg_t __reserved_1   : 52;
+#else   /* __BIG_ENDIAN__ */
+    uint_reg_t __reserved_1   : 52;
+    uint_reg_t tfifo_aempty   : 1;
+    uint_reg_t rfifo_err      : 1;
+    uint_reg_t wfifo_re       : 1;
+    uint_reg_t rfifo_we       : 1;
+    uint_reg_t tfifo_re       : 1;
+    uint_reg_t __reserved_0   : 1;
+    uint_reg_t rfifo_afull    : 1;
+    uint_reg_t rfifo_overflow : 1;
+    uint_reg_t parity_err     : 1;
+    uint_reg_t frame_err      : 1;
+    uint_reg_t wdat_err       : 1;
+    uint_reg_t rdat_err       : 1;
+#endif
+  };
+
+  uint_reg_t word;
+} UART_INTERRUPT_STATUS_t;
+
+/* Type. */
+
+__extension__
+typedef union
+{
+  struct
+  {
+#ifndef __BIG_ENDIAN__
+    /* Number of stop bits, rx and tx */
+    uint_reg_t sbits        : 1;
+    /* Reserved. */
+    uint_reg_t __reserved_0 : 1;
+    /* Data word size, rx and tx */
+    uint_reg_t dbits        : 1;
+    /* Reserved. */
+    uint_reg_t __reserved_1 : 1;
+    /* Parity selection, rx and tx */
+    uint_reg_t ptype        : 3;
+    /* Reserved. */
+    uint_reg_t __reserved_2 : 57;
+#else   /* __BIG_ENDIAN__ */
+    uint_reg_t __reserved_2 : 57;
+    uint_reg_t ptype        : 3;
+    uint_reg_t __reserved_1 : 1;
+    uint_reg_t dbits        : 1;
+    uint_reg_t __reserved_0 : 1;
+    uint_reg_t sbits        : 1;
+#endif
+  };
+
+  uint_reg_t word;
+} UART_TYPE_t;
+#endif /* !defined(__ASSEMBLER__) */
+
+#endif /* !defined(__ARCH_UART_H__) */
diff --git a/arch/tile/include/arch/uart_def.h b/arch/tile/include/arch/uart_def.h
new file mode 100644
index 0000000..42bcaf5
--- /dev/null
+++ b/arch/tile/include/arch/uart_def.h
@@ -0,0 +1,120 @@
+/*
+ * Copyright 2013 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/* Machine-generated file; do not edit. */
+
+#ifndef __ARCH_UART_DEF_H__
+#define __ARCH_UART_DEF_H__
+#define UART_DIVISOR 0x0158
+#define UART_FIFO_COUNT 0x0110
+#define UART_FLAG 0x0108
+#define UART_INTERRUPT_MASK 0x0208
+#define UART_INTERRUPT_MASK__RDAT_ERR_SHIFT 0
+#define UART_INTERRUPT_MASK__RDAT_ERR_WIDTH 1
+#define UART_INTERRUPT_MASK__RDAT_ERR_RESET_VAL 1
+#define UART_INTERRUPT_MASK__RDAT_ERR_RMASK 0x1
+#define UART_INTERRUPT_MASK__RDAT_ERR_MASK  0x1
+#define UART_INTERRUPT_MASK__RDAT_ERR_FIELD 0,0
+#define UART_INTERRUPT_MASK__WDAT_ERR_SHIFT 1
+#define UART_INTERRUPT_MASK__WDAT_ERR_WIDTH 1
+#define UART_INTERRUPT_MASK__WDAT_ERR_RESET_VAL 1
+#define UART_INTERRUPT_MASK__WDAT_ERR_RMASK 0x1
+#define UART_INTERRUPT_MASK__WDAT_ERR_MASK  0x2
+#define UART_INTERRUPT_MASK__WDAT_ERR_FIELD 1,1
+#define UART_INTERRUPT_MASK__FRAME_ERR_SHIFT 2
+#define UART_INTERRUPT_MASK__FRAME_ERR_WIDTH 1
+#define UART_INTERRUPT_MASK__FRAME_ERR_RESET_VAL 1
+#define UART_INTERRUPT_MASK__FRAME_ERR_RMASK 0x1
+#define UART_INTERRUPT_MASK__FRAME_ERR_MASK  0x4
+#define UART_INTERRUPT_MASK__FRAME_ERR_FIELD 2,2
+#define UART_INTERRUPT_MASK__PARITY_ERR_SHIFT 3
+#define UART_INTERRUPT_MASK__PARITY_ERR_WIDTH 1
+#define UART_INTERRUPT_MASK__PARITY_ERR_RESET_VAL 1
+#define UART_INTERRUPT_MASK__PARITY_ERR_RMASK 0x1
+#define UART_INTERRUPT_MASK__PARITY_ERR_MASK  0x8
+#define UART_INTERRUPT_MASK__PARITY_ERR_FIELD 3,3
+#define UART_INTERRUPT_MASK__RFIFO_OVERFLOW_SHIFT 4
+#define UART_INTERRUPT_MASK__RFIFO_OVERFLOW_WIDTH 1
+#define UART_INTERRUPT_MASK__RFIFO_OVERFLOW_RESET_VAL 1
+#define UART_INTERRUPT_MASK__RFIFO_OVERFLOW_RMASK 0x1
+#define UART_INTERRUPT_MASK__RFIFO_OVERFLOW_MASK  0x10
+#define UART_INTERRUPT_MASK__RFIFO_OVERFLOW_FIELD 4,4
+#define UART_INTERRUPT_MASK__RFIFO_AFULL_SHIFT 5
+#define UART_INTERRUPT_MASK__RFIFO_AFULL_WIDTH 1
+#define UART_INTERRUPT_MASK__RFIFO_AFULL_RESET_VAL 1
+#define UART_INTERRUPT_MASK__RFIFO_AFULL_RMASK 0x1
+#define UART_INTERRUPT_MASK__RFIFO_AFULL_MASK  0x20
+#define UART_INTERRUPT_MASK__RFIFO_AFULL_FIELD 5,5
+#define UART_INTERRUPT_MASK__TFIFO_RE_SHIFT 7
+#define UART_INTERRUPT_MASK__TFIFO_RE_WIDTH 1
+#define UART_INTERRUPT_MASK__TFIFO_RE_RESET_VAL 1
+#define UART_INTERRUPT_MASK__TFIFO_RE_RMASK 0x1
+#define UART_INTERRUPT_MASK__TFIFO_RE_MASK  0x80
+#define UART_INTERRUPT_MASK__TFIFO_RE_FIELD 7,7
+#define UART_INTERRUPT_MASK__RFIFO_WE_SHIFT 8
+#define UART_INTERRUPT_MASK__RFIFO_WE_WIDTH 1
+#define UART_INTERRUPT_MASK__RFIFO_WE_RESET_VAL 1
+#define UART_INTERRUPT_MASK__RFIFO_WE_RMASK 0x1
+#define UART_INTERRUPT_MASK__RFIFO_WE_MASK  0x100
+#define UART_INTERRUPT_MASK__RFIFO_WE_FIELD 8,8
+#define UART_INTERRUPT_MASK__WFIFO_RE_SHIFT 9
+#define UART_INTERRUPT_MASK__WFIFO_RE_WIDTH 1
+#define UART_INTERRUPT_MASK__WFIFO_RE_RESET_VAL 1
+#define UART_INTERRUPT_MASK__WFIFO_RE_RMASK 0x1
+#define UART_INTERRUPT_MASK__WFIFO_RE_MASK  0x200
+#define UART_INTERRUPT_MASK__WFIFO_RE_FIELD 9,9
+#define UART_INTERRUPT_MASK__RFIFO_ERR_SHIFT 10
+#define UART_INTERRUPT_MASK__RFIFO_ERR_WIDTH 1
+#define UART_INTERRUPT_MASK__RFIFO_ERR_RESET_VAL 1
+#define UART_INTERRUPT_MASK__RFIFO_ERR_RMASK 0x1
+#define UART_INTERRUPT_MASK__RFIFO_ERR_MASK  0x400
+#define UART_INTERRUPT_MASK__RFIFO_ERR_FIELD 10,10
+#define UART_INTERRUPT_MASK__TFIFO_AEMPTY_SHIFT 11
+#define UART_INTERRUPT_MASK__TFIFO_AEMPTY_WIDTH 1
+#define UART_INTERRUPT_MASK__TFIFO_AEMPTY_RESET_VAL 1
+#define UART_INTERRUPT_MASK__TFIFO_AEMPTY_RMASK 0x1
+#define UART_INTERRUPT_MASK__TFIFO_AEMPTY_MASK  0x800
+#define UART_INTERRUPT_MASK__TFIFO_AEMPTY_FIELD 11,11
+#define UART_INTERRUPT_STATUS 0x0200
+#define UART_RECEIVE_DATA 0x0148
+#define UART_TRANSMIT_DATA 0x0140
+#define UART_TYPE 0x0160
+#define UART_TYPE__SBITS_SHIFT 0
+#define UART_TYPE__SBITS_WIDTH 1
+#define UART_TYPE__SBITS_RESET_VAL 1
+#define UART_TYPE__SBITS_RMASK 0x1
+#define UART_TYPE__SBITS_MASK  0x1
+#define UART_TYPE__SBITS_FIELD 0,0
+#define UART_TYPE__SBITS_VAL_ONE_SBITS 0x0
+#define UART_TYPE__SBITS_VAL_TWO_SBITS 0x1
+#define UART_TYPE__DBITS_SHIFT 2
+#define UART_TYPE__DBITS_WIDTH 1
+#define UART_TYPE__DBITS_RESET_VAL 0
+#define UART_TYPE__DBITS_RMASK 0x1
+#define UART_TYPE__DBITS_MASK  0x4
+#define UART_TYPE__DBITS_FIELD 2,2
+#define UART_TYPE__DBITS_VAL_EIGHT_DBITS 0x0
+#define UART_TYPE__DBITS_VAL_SEVEN_DBITS 0x1
+#define UART_TYPE__PTYPE_SHIFT 4
+#define UART_TYPE__PTYPE_WIDTH 3
+#define UART_TYPE__PTYPE_RESET_VAL 3
+#define UART_TYPE__PTYPE_RMASK 0x7
+#define UART_TYPE__PTYPE_MASK  0x70
+#define UART_TYPE__PTYPE_FIELD 4,6
+#define UART_TYPE__PTYPE_VAL_NONE 0x0
+#define UART_TYPE__PTYPE_VAL_MARK 0x1
+#define UART_TYPE__PTYPE_VAL_SPACE 0x2
+#define UART_TYPE__PTYPE_VAL_EVEN 0x3
+#define UART_TYPE__PTYPE_VAL_ODD 0x4
+#endif /* !defined(__ARCH_UART_DEF_H__) */
diff --git a/arch/tile/include/gxio/iorpc_uart.h b/arch/tile/include/gxio/iorpc_uart.h
new file mode 100644
index 0000000..55429d4
--- /dev/null
+++ b/arch/tile/include/gxio/iorpc_uart.h
@@ -0,0 +1,40 @@
+/*
+ * Copyright 2013 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/* This file is machine-generated; DO NOT EDIT! */
+#ifndef __GXIO_UART_LINUX_RPC_H__
+#define __GXIO_UART_LINUX_RPC_H__
+
+#include <hv/iorpc.h>
+
+#include <hv/drv_uart_intf.h>
+#include <gxio/uart.h>
+#include <gxio/kiorpc.h>
+#include <linux/string.h>
+#include <linux/module.h>
+#include <asm/pgtable.h>
+
+#define GXIO_UART_OP_CFG_INTERRUPT     IORPC_OPCODE(IORPC_FORMAT_KERNEL_INTERRUPT, 0x1900)
+#define GXIO_UART_OP_GET_MMIO_BASE     IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x8000)
+#define GXIO_UART_OP_CHECK_MMIO_OFFSET IORPC_OPCODE(IORPC_FORMAT_NONE_NOUSER, 0x8001)
+
+int gxio_uart_cfg_interrupt(gxio_uart_context_t *context, int inter_x,
+			    int inter_y, int inter_ipi, int inter_event);
+
+int gxio_uart_get_mmio_base(gxio_uart_context_t *context, HV_PTE *base);
+
+int gxio_uart_check_mmio_offset(gxio_uart_context_t *context,
+				unsigned long offset, unsigned long size);
+
+#endif /* !__GXIO_UART_LINUX_RPC_H__ */
diff --git a/arch/tile/include/gxio/uart.h b/arch/tile/include/gxio/uart.h
new file mode 100644
index 0000000..438ee7e
--- /dev/null
+++ b/arch/tile/include/gxio/uart.h
@@ -0,0 +1,105 @@
+/*
+ * Copyright 2013 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+#ifndef _GXIO_UART_H_
+#define _GXIO_UART_H_
+
+#include "common.h"
+
+#include <hv/drv_uart_intf.h>
+#include <hv/iorpc.h>
+
+/*
+ *
+ * An API for manipulating UART interface.
+ */
+
+/*
+ *
+ * The Rshim allows access to the processor's UART interface.
+ */
+
+/* A context object used to manage UART resources. */
+typedef struct {
+
+	/* File descriptor for calling up to the hypervisor. */
+	int fd;
+
+	/* The VA at which our MMIO registers are mapped. */
+	char *mmio_base;
+
+} gxio_uart_context_t;
+
+/* Request UART interrupts.
+ *
+ *  Request that interrupts be delivered to a tile when the UART's
+ *  Receive FIFO is written, or the Write FIFO is read.
+ *
+ * @param context Pointer to a properly initialized gxio_uart_context_t.
+ * @param bind_cpu_x X coordinate of CPU to which interrupt will be delivered.
+ * @param bind_cpu_y Y coordinate of CPU to which interrupt will be delivered.
+ * @param bind_interrupt IPI interrupt number.
+ * @param bind_event Sub-interrupt event bit number; a negative value can
+ *  disable the interrupt.
+ * @return Zero if all of the requested UART events were successfully
+ *  configured to interrupt.
+ */
+extern int gxio_uart_cfg_interrupt(gxio_uart_context_t *context,
+				   int bind_cpu_x,
+				   int bind_cpu_y,
+				   int bind_interrupt, int bind_event);
+
+/* Initialize a UART context.
+ *
+ *  A properly initialized context must be obtained before any of the other
+ *  gxio_uart routines may be used.
+ *
+ * @param context Pointer to a gxio_uart_context_t, which will be initialized
+ *  by this routine, if it succeeds.
+ * @param uart_index Index of the UART to use.
+ * @return Zero if the context was successfully initialized, else a
+ *  GXIO_ERR_xxx error code.
+ */
+extern int gxio_uart_init(gxio_uart_context_t *context, int uart_index);
+
+/* Destroy a UART context.
+ *
+ *  Once destroyed, a context may not be used with any gxio_uart routines
+ *  other than gxio_uart_init().  After this routine returns, no further
+ *  interrupts requested on this context will be delivered.  The state and
+ *  configuration of the pins which had been attached to this context are
+ *  unchanged by this operation.
+ *
+ * @param context Pointer to a gxio_uart_context_t.
+ * @return Zero if the context was successfully destroyed, else a
+ *  GXIO_ERR_xxx error code.
+ */
+extern int gxio_uart_destroy(gxio_uart_context_t *context);
+
+/* Write UART register.
+ * @param context Pointer to a gxio_uart_context_t.
+ * @param offset UART register offset.
+ * @param word Data will be wrote to UART reigister.
+ */
+extern void gxio_uart_write(gxio_uart_context_t *context, uint64_t offset,
+			    uint64_t word);
+
+/* Read UART register.
+ * @param context Pointer to a gxio_uart_context_t.
+ * @param offset UART register offset.
+ * @return Data read from UART register.
+ */
+extern uint64_t gxio_uart_read(gxio_uart_context_t *context, uint64_t offset);
+
+#endif /* _GXIO_UART_H_ */
diff --git a/arch/tile/include/hv/drv_uart_intf.h b/arch/tile/include/hv/drv_uart_intf.h
new file mode 100644
index 0000000..f5379e2
--- /dev/null
+++ b/arch/tile/include/hv/drv_uart_intf.h
@@ -0,0 +1,33 @@
+/*
+ * Copyright 2013 Tilera Corporation. All Rights Reserved.
+ *
+ *   This program is free software; you can redistribute it and/or
+ *   modify it under the terms of the GNU General Public License
+ *   as published by the Free Software Foundation, version 2.
+ *
+ *   This program is distributed in the hope that it will be useful, but
+ *   WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+ *   NON INFRINGEMENT.  See the GNU General Public License for
+ *   more details.
+ */
+
+/**
+ * Interface definitions for the UART driver.
+ */
+
+#ifndef _SYS_HV_DRV_UART_INTF_H
+#define _SYS_HV_DRV_UART_INTF_H
+
+#include <arch/uart.h>
+
+/** Number of UART ports supported. */
+#define TILEGX_UART_NR        2
+
+/** The mmap file offset (PA) of the UART MMIO region. */
+#define HV_UART_MMIO_OFFSET   0
+
+/** The maximum size of the UARTs MMIO region (64K Bytes). */
+#define HV_UART_MMIO_SIZE     (1UL << 16)
+
+#endif /* _SYS_HV_DRV_UART_INTF_H */
-- 
1.8.3.1

