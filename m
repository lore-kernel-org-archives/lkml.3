Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151AbaEMJ3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:29:00 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60722 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759367AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Xiangyu Lu <luxiangyu@huawei.com>,
        Alex Wu <wuquanming@huawei.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 019/182] ARM: 8027/1: fix do_div() bug in big-endian systems
Date: Tue, 13 May 2014 11:26:11 +0200
Message-Id: <71131cc9c942add602881c9990ad4380bd24fc54.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiangyu Lu <luxiangyu@huawei.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/arm/include/asm/div64.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/div64.h b/arch/arm/include/asm/div64.h
index 191ada6e4d2d..662c7bd06108 100644
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
1.9.3

