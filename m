Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756537AbaEPMtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:49:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49636 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754550AbaEPMsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:48:24 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alex Wu" <wuquanming@huawei.com>,
        "Xiangyu Lu" <luxiangyu@huawei.com>,
        "Dave Martin" <Dave.Martin@arm.com>, "Nicolas Pitre" <nico@linaro.org>,
        "Russell King" <rmk+kernel@arm.linux.org.uk>
Date: Fri, 16 May 2014 13:47:21 +0100
Message-ID: <lsq.1400244441.696163662@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 20/34] ARM: 8027/1: fix do_div() bug in big-endian systems
In-Reply-To: <lsq.1400244440.390103756@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:3db0:c181:6526:5597
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.59-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/include/asm/div64.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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

