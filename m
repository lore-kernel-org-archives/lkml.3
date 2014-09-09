Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbaIIGMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 02:12:00 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:54672 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbaIIGL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 02:11:59 -0400
From: Mike Turquette <mturquette@linaro.org>
To: s.nawrocki@samsung.com, tomeu.vizoso@collabora.com
Cc: linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH 2/2] asm-generic: COMMON_CLK defines __clk_{get,put}
Date: Mon,  8 Sep 2014 23:11:26 -0700
Message-Id: <1410243086-14925-1-git-send-email-mturquette@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1410242868-14750-1-git-send-email-mturquette@linaro.org>
References: <1410242868-14750-1-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_COMMON_CLK is selected then __clk_get and __clk_put are
defined in drivers/clk/clk.c and declared in include/linux/clkdev.h.

Sylwester's series[0] to properly support clk_{get,put} in the common
clock framework made changes to the asm-specific clkdev.h headers, but
not the asm-generic version. Tomeu's recent changes[1] to introduce a
provider/consumer split in the clock framework uncovered this problem,
causing the following build error on any architecture using the
asm-generic clkdev.h (e.g. x86 architecture and the ACPI LPSS driver):

In file included from drivers/acpi/acpi_lpss.c:15:0:
include/linux/clkdev.h:59:5: error: conflicting types for ‘__clk_get’
 int __clk_get(struct clk_core *clk);
     ^
In file included from arch/x86/include/generated/asm/clkdev.h:1:0,
                 from include/linux/clkdev.h:15,
                 from drivers/acpi/acpi_lpss.c:15:
include/asm-generic/clkdev.h:20:19: note: previous definition of ‘__clk_get’ was here
 static inline int __clk_get(struct clk *clk) { return 1; }
                   ^

Fixed by only declarating  __clk_get and __clk_put when
CONFIG_COMMON_CLK is set.

[0] http://lkml.kernel.org/r/<1386177127-2894-5-git-send-email-s.nawrocki@samsung.com>
[1] http://lkml.kernel.org/r/<1409758148-20104-1-git-send-email-tomeu.vizoso@collabora.com>

Signed-off-by: Mike Turquette <mturquette@linaro.org>
---
 include/asm-generic/clkdev.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/asm-generic/clkdev.h b/include/asm-generic/clkdev.h
index 90a32a6..4ff33474 100644
--- a/include/asm-generic/clkdev.h
+++ b/include/asm-generic/clkdev.h
@@ -15,10 +15,12 @@
 
 #include <linux/slab.h>
 
+#ifndef CONFIG_COMMON_CLK
 struct clk;
 
 static inline int __clk_get(struct clk *clk) { return 1; }
 static inline void __clk_put(struct clk *clk) { }
+#endif
 
 static inline struct clk_lookup_alloc *__clkdev_alloc(size_t size)
 {
-- 
1.8.3.2

