Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaKLKzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 05:55:31 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:43235 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751564AbaKLKz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 05:55:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 1/1] tty: bfin, define inlined structures
Date: Wed, 12 Nov 2014 11:55:25 +0100
Message-Id: <1415789725-857-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct bfin_serial_port contains structs circ_buf, timer_list, and
work_struct directly (not pointers). This means that these structures
have to be defined completely to be inlined in struct
bfin_serial_port.

So instead of struct declarations, define the structures by including
proper headers. They were pulled in by linux/serial_core.h or others
until now. But experimenting with circ_buf removal from serial_core,
struct circ_buf becomes undefined in bfin_serial:

In file included from arch/blackfin/kernel/debug-mmrs.c:21:0:
arch/blackfin/include/asm/bfin_serial.h:44:18: error: field 'rx_dma_buf' has incomplete type

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/blackfin/include/asm/bfin_serial.h | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/blackfin/include/asm/bfin_serial.h b/arch/blackfin/include/asm/bfin_serial.h
index 2d90d62edc97..d00d732784b1 100644
--- a/arch/blackfin/include/asm/bfin_serial.h
+++ b/arch/blackfin/include/asm/bfin_serial.h
@@ -9,8 +9,11 @@
 #ifndef __BFIN_ASM_SERIAL_H__
 #define __BFIN_ASM_SERIAL_H__
 
+#include <linux/circ_buf.h>
 #include <linux/serial_core.h>
 #include <linux/spinlock.h>
+#include <linux/timer.h>
+#include <linux/workqueue.h>
 #include <mach/anomaly.h>
 #include <mach/bfin_serial.h>
 
@@ -25,10 +28,6 @@
 # endif
 #endif
 
-struct circ_buf;
-struct timer_list;
-struct work_struct;
-
 struct bfin_serial_port {
 	struct uart_port port;
 	unsigned int old_status;
-- 
2.1.3

