Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757587AbaFYQTd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 12:19:33 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:65029 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757479AbaFYQTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 12:19:16 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-7d-53aaf67c46c1
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH 1/2] ARM: firmware: Introduce suspend and resume operations
Date: Wed, 25 Jun 2014 18:18:33 +0200
Message-id: <1403713114-18923-2-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1403713114-18923-1-git-send-email-t.figa@samsung.com>
References: <1403713114-18923-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDLMWRmVeSWpSXmKPExsVy+t/xq7o131YFG0ybqmfx/eEpVou/k46x
	W/QuuMpmsenxNVaLy7vmsFnMOL+PyeL2ZV6LtUfuslucuv6ZzeLG9BZWi/UzXrNYrNr1h9GB
	x6OluYfN4/evSYweO2fdZffYvKTe48qJJlaP3uZ3bB59W1YxenzeJBfAEcVlk5Kak1mWWqRv
	l8CV0dT0mq2gR6xi5vMWxgbGVqEuRk4OCQETiStnLjFD2GISF+6tZ+ti5OIQEljKKPH8/lRm
	CKePSeLN7aksIFVsAmoSnxsesYHYIgKqEp/bFrCDFDELrGaWOPW1mR0kISzgLfGteSeYzQJU
	tHHZWSCbg4NXwEnizfsciG1yEr3b3oBt5hRwltj3ZzNYuRBQyeK+30wTGHkXMDKsYhRNLU0u
	KE5KzzXSK07MLS7NS9dLzs/dxAgJ0a87GJceszrEKMDBqMTDG8CzKliINbGsuDL3EKMEB7OS
	CG/Uc6AQb0piZVVqUX58UWlOavEhRiYOTqkGxuOHNKSqMtYviVqWNvvj+zvmxfP/LSsMvbrX
	db+2xsLb+2xr7wX/CVu7eudhF8aV8b/5L6wPmCRU5ZMQtyo+vetdkqTwk+OdN04kOMaVL+1e
	0NF5Of3ldbWLCmEnJubc75w07V7Vn0g263Max7h5tZtVNDvYtoiueMQxZeuJA8F/UhLLj505
	8l2JpTgj0VCLuag4EQDRL1B6LwIAAA==
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

