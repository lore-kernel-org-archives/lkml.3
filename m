Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933003AbaEGNOU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 09:14:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45450 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932893AbaEGNOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 09:14:16 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Wu <wuquanming@huawei.com>, Xiangyu Lu <luxiangyu@huawei.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 22/70] ARM: 8027/1: fix do_div() bug in big-endian systems
Date: Wed,  7 May 2014 14:12:25 +0100
Message-Id: <1399468393-10140-23-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
References: <1399468393-10140-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiangyu Lu <luxiangyu@huawei.com>

commit 80bb3ef109ff40a7593d9481c17de9bbc4d7c0e2 upstream.

In big-endian systems, "%1" get the most significant part of the value, cause the instruction to get the wrong result.

When viewing ftrace record in big-endian ARM systems, we found that
the timestamp errors:

swapper-0   [001] 1325.970000:   0:120:R ==> [001]    16:120:R events/1
events/1-16 [001] 1325.970000:   16:120:S ==> [001]    0:120:R swapper
swapper-0   [000] 1325.1000000:  0:120:R   + [000]    15:120:R events/0
swapper-0   [000] 1325.1000000:  0:120:R ==> [000]    15:120:R events/0
swapper-0   [000] 1326.030000:   0:120:R   + [000]  1150:120:R sshd
swapper-0   [000] 1326.030000:   0:120:R ==> [000]  1150:120:R sshd

When viewed ftrace records, it will call the do_div(n, base) function, which achieved arch/arm/include/asm/div64.h in. When n = 10000000, base = 1000000, in do_div(n, base) will execute "umull %Q0, %R0, %1, %Q2".

Reviewed-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Alex Wu <wuquanming@huawei.com>
Signed-off-by: Xiangyu Lu <luxiangyu@huawei.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm/include/asm/div64.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/div64.h b/arch/arm/include/asm/div64.h
index 191ada6..662c7bd 100644
--- a/arch/arm/include/asm/div64.h
+++ b/arch/arm/include/asm/div64.h
@@ -156,7 +156,7 @@
 		/* Select the best insn combination to perform the   */	\
 		/* actual __m * __n / (__p << 64) operation.         */	\
 		if (!__c) {						\
-			asm (	"umull	%Q0, %R0, %1, %Q2\n\t"		\
+			asm (	"umull	%Q0, %R0, %Q1, %Q2\n\t"		\
 				"mov	%Q0, #0"			\
 				: "=&r" (__res)				\
 				: "r" (__m), "r" (__n)			\
-- 
1.9.1

