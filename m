Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752265AbbAMKj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 05:39:27 -0500
Received: from down.free-electrons.com ([37.187.137.238]:32769 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751823AbbAMKj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 05:39:26 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH] ARM: fix DEBUG_UART_PHYS/VIRT issue when modifying DEBUG_LL output
Date: Tue, 13 Jan 2015 11:37:48 +0100
Message-Id: <1421145468-4144-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The DEBUG_UART_PHYS/VIRT value can only be automatically set once
(automatically means set from the DEBUG_<SOC_ID>_<UART_ID> option), which
prevents re-configuring the earlyprintk output for another platform once
the DEBUG_LL output has been selected.

Add a new boolean option (DEBUG_CUSTOM_UART_ADDR) enabling custom phys and
virt address setting (configured through DEBUG_CUSTOM_UART_PHYS/VIRT
options), and make DEBUG_UART_PHYS/VIRT hidden so that they will always be
set from one of the 'default' definitions, and thus will be overwritten
each time you change the DEBUG_LL output.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
Hello,

I know there is some WIP on DEBUG_LL and multi-platform [1], but from my
understanding (tell me if I'm wrong), it does not address this "select once
keep forever" issue.

Best Regards,

Boris


[1]https://lkml.org/lkml/2015/1/5/275

 arch/arm/Kconfig.debug | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 5ddd490..54ee0f3 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -1227,8 +1227,22 @@ config DEBUG_UART_8250
 config DEBUG_UART_BCM63XX
 	def_bool ARCH_BCM_63XX
 
-config DEBUG_UART_PHYS
+config DEBUG_CUSTOM_UART_ADDR
+	bool "Custom phys and virt address for debug uart"
+
+config DEBUG_CUSTOM_UART_PHYS
 	hex "Physical base address of debug UART"
+	depends on DEBUG_CUSTOM_UART_ADDR
+	default 0x0
+
+config DEBUG_CUSTOM_UART_VIRT
+	hex "Virtual base address of debug UART"
+	depends on DEBUG_CUSTOM_UART_ADDR
+	default 0x0
+
+config DEBUG_UART_PHYS
+	hex
+	default DEBUG_CUSTOM_UART_PHYS if DEBUG_CUSTOM_UART_ADDR
 	default 0x01c20000 if DEBUG_DAVINCI_DMx_UART0
 	default 0x01c28000 if DEBUG_SUNXI_UART0
 	default 0x01c28400 if DEBUG_SUNXI_UART1
@@ -1323,7 +1337,8 @@ config DEBUG_UART_PHYS
 		DEBUG_UART_BCM63XX || DEBUG_ASM9260_UART
 
 config DEBUG_UART_VIRT
-	hex "Virtual base address of debug UART"
+	hex
+	default DEBUG_CUSTOM_UART_VIRT if MMU && DEBUG_CUSTOM_UART_ADDR
 	default 0xe0010fe0 if ARCH_RPC
 	default 0xe1000000 if DEBUG_MSM_UART
 	default 0xf0000be0 if ARCH_EBSA110
-- 
1.9.1

