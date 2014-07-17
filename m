Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934489AbaGQP5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:57:32 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:63136 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbaGQP45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:56:57 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-6b-53c7f2455395
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        swarren@nvidia.com, acourbot@nvidia.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        drake@endlessm.com, Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v2 1/2] ARM: firmware: Introduce suspend and resume operations
Date: Thu, 17 Jul 2014 17:56:10 +0200
Message-id: <1405612571-32598-2-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1405612571-32598-1-git-send-email-t.figa@samsung.com>
References: <1405612571-32598-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCLMWRmVeSWpSXmKPExsVy+t/xK7qun44HGxy7o27x/eEpVou/k46x
	Wzya/5jZonfBVTaLTY+vsVpc3jWHzWLG+X1MFrcv81qsPXKX3eLU9c9sFjemt7BarJ/xmsVi
	1a4/jA68Hi3NPWwev39NYvRY9D3LY+esu+wem5fUe1w50cTq0dv8js2jb8sqRo/Pm+QCOKO4
	bFJSczLLUov07RK4Mva//8xWsF+s4vLM1AbGzUJdjJwcEgImEtPnXWCBsMUkLtxbz9bFyMUh
	JLCUUeLOxm0sEE4fk8StwzsZQarYBNQkPjc8YgOxRQRUJT63LWAHKWIWmMUs8W3OBrCEsICf
	RHfvdqAGDg4WoKK1M/1AwrwCThJnjy1gg9gmJ9G77Q0ziM0p4Cxx6VYrE4gtBFRz9dQN9gmM
	vAsYGVYxiqaWJhcUJ6XnGukVJ+YWl+al6yXn525ihITs1x2MS49ZHWIU4GBU4uH9wXU8WIg1
	say4MvcQowQHs5IIb/Z9oBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbG6yz7viS6JFh/7Dh5/q02
	64ItL1YGBe5wNEmuKlWb8/3j2Q0LPb1qdO05tLn26Jnt2SjO38yxarvlST7Dlz23+LeEyLTP
	38T9euuq+I7rxifndi9adbFcliFp5VnGZyHrbgTLdmyZLzqpcq9OUEbKi4D77P94C+bwHymU
	e1iZfWwaR2z7lmQtJZbijERDLeai4kQAozzCljcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends the firmware_ops structure with two new callbacks:
.suspend() and .resume(). The former is intended to ask the firmware to
save all its volatile state and suspend the system, without returning
back to the kernel in between. The latter is to be called early by
very low level platform suspend code after waking up to restore low
level hardware state, which can't be restored in non-secure mode.

While at it, outdated version of the structure is removed from the
documentation and replaced with a reference to the header file.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
Acked-by: Alexandre Courbot <acourbot@nvidia.com>
---
 Documentation/arm/firmware.txt  | 28 +++++-----------------------
 arch/arm/include/asm/firmware.h |  8 ++++++++
 2 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/Documentation/arm/firmware.txt b/Documentation/arm/firmware.txt
index c2e468f..da6713a 100644
--- a/Documentation/arm/firmware.txt
+++ b/Documentation/arm/firmware.txt
@@ -7,32 +7,14 @@ world, which changes the way some things have to be initialized. This makes
 a need to provide an interface for such platforms to specify available firmware
 operations and call them when needed.
 
-Firmware operations can be specified using struct firmware_ops
-
-	struct firmware_ops {
-		/*
-		* Enters CPU idle mode
-		*/
-		int (*do_idle)(void);
-		/*
-		* Sets boot address of specified physical CPU
-		*/
-		int (*set_cpu_boot_addr)(int cpu, unsigned long boot_addr);
-		/*
-		* Boots specified physical CPU
-		*/
-		int (*cpu_boot)(int cpu);
-		/*
-		* Initializes L2 cache
-		*/
-		int (*l2x0_init)(void);
-	};
-
-and then registered with register_firmware_ops function
+Firmware operations can be specified by filling in a struct firmware_ops
+with appropriate callbacks and then registering it with register_firmware_ops()
+function.
 
 	void register_firmware_ops(const struct firmware_ops *ops)
 
-the ops pointer must be non-NULL.
+The ops pointer must be non-NULL. More information about struct firmware_ops
+and its members can be found in arch/arm/include/asm/firmware.h header.
 
 There is a default, empty set of operations provided, so there is no need to
 set anything if platform does not require firmware operations.
diff --git a/arch/arm/include/asm/firmware.h b/arch/arm/include/asm/firmware.h
index 2c9f10d..5904f59 100644
--- a/arch/arm/include/asm/firmware.h
+++ b/arch/arm/include/asm/firmware.h
@@ -41,6 +41,14 @@ struct firmware_ops {
 	 * Initializes L2 cache
 	 */
 	int (*l2x0_init)(void);
+	/*
+	 * Enter system-wide suspend.
+	 */
+	int (*suspend)(void);
+	/*
+	 * Restore state of privileged hardware after system-wide suspend.
+	 */
+	int (*resume)(void);
 };
 
 /* Global pointer for current firmware_ops structure, can't be NULL. */
-- 
1.9.3

