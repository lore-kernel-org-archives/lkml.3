Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265AbaHZOKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 10:10:49 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:38330 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357AbaHZOKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:10:46 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-7a-53fc9563e71c
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        swarren@nvidia.com, acourbot@nvidia.com,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        drake@endlessm.com, tomeu@tomeuvizoso.net,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v3 1/5] ARM: firmware: Introduce suspend and resume operations
Date: Tue, 26 Aug 2014 16:10:24 +0200
Message-id: <1409062228-14690-2-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 2.0.4
In-reply-to: <1409062228-14690-1-git-send-email-t.figa@samsung.com>
References: <1409062228-14690-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsVy+t/xq7rJU/8EG2x5ymvx/eEpVou/k46x
	Wzya/5jZonfBVTaLTY+vsVpc3jWHzWLG+X1MFrcv81qsPXKX3eLU9c9sFjemt7BarJ/xmsVi
	1a4/jBaXG80c+DxamnvYPH7/msToseh7lsfOWXfZPTYvqfe4cqKJ1aO3+R2bR9+WVYweR/+y
	eXzeJBfAFcVlk5Kak1mWWqRvl8CVcXreBfaC/WIVJ9ZsZ2lg3CzUxcjJISFgIvH7x3cmCFtM
	4sK99WxdjFwcQgJLGSUW3P7ICuH0MUmc6XzCClLFJqAm8bnhERuILSKgKvG5bQE7SBGzwEZm
	iR9/JwA5HBzCAn4Sp774gpgsQDUz7geDlPMKOEnMvLaPFWKZnMSqjfvAFnMKOEv8fLIVLC4E
	VLP34WrWCYy8CxgZVjGKppYmFxQnpeca6RUn5haX5qXrJefnbmKEhPDXHYxLj1kdYhTgYFTi
	4X2Q9jtYiDWxrLgy9xCjBAezkgjvj6Q/wUK8KYmVValF+fFFpTmpxYcYmTg4pRoYo/xjzRSr
	WLec2bFafbHT4Xr/ENVfOvlH7NU6drQdUKvfvd9ClUfq8UupM1Mu3Xy6RXzfsZrZ07X9ZRby
	n+7pErl3+8EdNfnZX9k+d+guD+Yu+9T0ZNZv9m8/vr59v/+w0Q3jnHMHvn8q/VMcdmfbDvU/
	x43PZh4Tq54z4dAMocww3+hFxkJS+UosxRmJhlrMRcWJALkI+jE/AgAA
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
2.0.4

