Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbaFYNjx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 09:39:53 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:10486 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591AbaFYNiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 09:38:20 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-55-53aad0c889a8
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Daniel Drake <drake@endlessm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v2 1/6] ARM: mm: cache-l2x0: Add base address argument to
 write_sec callback
Date: Wed, 25 Jun 2014 15:37:26 +0200
Message-id: <1403703451-12233-2-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
In-reply-to: <1403703451-12233-1-git-send-email-t.figa@samsung.com>
References: <1403703451-12233-1-git-send-email-t.figa@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHLMWRmVeSWpSXmKPExsVy+t/xK7onLqwKNpj6R9ji0fzHzBa9C66y
	WWzvnMFuMeXPciaLTY+vsVpc3jWHzWL2kn4Wixnn9zFZ3L7Ma7H2yF12i9d9a5gt1s94zWKx
	atcfRov9V7wc+DxamnvYPL59ncTicbmvl8lj0fcsj52z7rJ73Lm2h81j85J6j74tqxg9jt/Y
	zuTxeZNcAFcUl01Kak5mWWqRvl0CV8bxjedZC2bJVXQ2fGJuYJwn2cXIwSEhYCLRO92ui5ET
	yBSTuHBvPVsXIxeHkMBSRolv1+8xQjh9TBKL5t5iBaliE1CT+NzwiA3EFhFQlfjctoAdpIhZ
	oIFF4krrdbCEsECcxI2lT1lAbBagovnH9oM18wo4SfRt3sAMsU5OonfbGzCbU8BZ4sK8P2A1
	QkA1854cYZzAyLuAkWEVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRkgYf9nBuPiY1SFGAQ5G
	JR7eAJ5VwUKsiWXFlbmHGCU4mJVEeN33A4V4UxIrq1KL8uOLSnNSiw8xMnFwSjUw8vwWMA2a
	cGr91hLVmLeFPwV9vz0tkdBY8N8wOvrd/6h7NzvCKlbvZX789LbR+4erI+6EHUg/fOve/K7D
	tYvK+zepbAssMMs8EqR5INPcp/7KW8dpU/33ldZu25wa0db/4JHrqd81qduFX7oK7ih87e+f
	1WH5X1f5U0vk9QxLr1nWR4/e/PhVVImlOCPRUIu5qDgRAI7b96JBAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For certain platforms (e.g. Exynos) it is necessary to read back some
values from registers before they can be written (i.e. SMC calls that
set multiple registers per call), so base address of L2C controller is
needed for .write_sec operation. This patch adds base argument to
.write_sec callback so that its implementation can also access registers
directly.

Signed-off-by: Tomasz Figa <t.figa@samsung.com>
---
 arch/arm/include/asm/mach/arch.h   | 3 ++-
 arch/arm/include/asm/outercache.h  | 2 +-
 arch/arm/mach-highbank/highbank.c  | 3 ++-
 arch/arm/mach-omap2/omap4-common.c | 3 ++-
 arch/arm/mach-ux500/cache-l2x0.c   | 3 ++-
 arch/arm/mm/cache-l2x0.c           | 2 +-
 6 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
index 060a75e..fefff4d 100644
--- a/arch/arm/include/asm/mach/arch.h
+++ b/arch/arm/include/asm/mach/arch.h
@@ -46,7 +46,8 @@ struct machine_desc {
 	enum reboot_mode	reboot_mode;	/* default restart mode	*/
 	unsigned		l2c_aux_val;	/* L2 cache aux value	*/
 	unsigned		l2c_aux_mask;	/* L2 cache aux mask	*/
-	void			(*l2c_write_sec)(unsigned long, unsigned);
+	void			(*l2c_write_sec)(unsigned long,
+						 void __iomem *, unsigned);
 	struct smp_operations	*smp;		/* SMP operations	*/
 	bool			(*smp_init)(void);
 	void			(*fixup)(struct tag *, char **);
diff --git a/arch/arm/include/asm/outercache.h b/arch/arm/include/asm/outercache.h
index 891a56b..25b70b5 100644
--- a/arch/arm/include/asm/outercache.h
+++ b/arch/arm/include/asm/outercache.h
@@ -35,7 +35,7 @@ struct outer_cache_fns {
 	void (*resume)(void);
 
 	/* This is an ARM L2C thing */
-	void (*write_sec)(unsigned long, unsigned);
+	void (*write_sec)(unsigned long, void __iomem *, unsigned);
 };
 
 extern struct outer_cache_fns outer_cache;
diff --git a/arch/arm/mach-highbank/highbank.c b/arch/arm/mach-highbank/highbank.c
index 8c35ae4..20cf160 100644
--- a/arch/arm/mach-highbank/highbank.c
+++ b/arch/arm/mach-highbank/highbank.c
@@ -51,7 +51,8 @@ static void __init highbank_scu_map_io(void)
 }
 
 
-static void highbank_l2c310_write_sec(unsigned long val, unsigned reg)
+static void highbank_l2c310_write_sec(unsigned long val, void __iomem *base,
+				      unsigned reg)
 {
 	if (reg == L2X0_CTRL)
 		highbank_smc1(0x102, val);
diff --git a/arch/arm/mach-omap2/omap4-common.c b/arch/arm/mach-omap2/omap4-common.c
index 326cd98..ce04afa 100644
--- a/arch/arm/mach-omap2/omap4-common.c
+++ b/arch/arm/mach-omap2/omap4-common.c
@@ -167,7 +167,8 @@ void __iomem *omap4_get_l2cache_base(void)
 	return l2cache_base;
 }
 
-static void omap4_l2c310_write_sec(unsigned long val, unsigned reg)
+static void omap4_l2c310_write_sec(unsigned long val, void __iomem *base,
+				   unsigned reg)
 {
 	unsigned smc_op;
 
diff --git a/arch/arm/mach-ux500/cache-l2x0.c b/arch/arm/mach-ux500/cache-l2x0.c
index 842ebed..bd87108 100644
--- a/arch/arm/mach-ux500/cache-l2x0.c
+++ b/arch/arm/mach-ux500/cache-l2x0.c
@@ -35,7 +35,8 @@ static int __init ux500_l2x0_unlock(void)
 	return 0;
 }
 
-static void ux500_l2c310_write_sec(unsigned long val, unsigned reg)
+static void ux500_l2c310_write_sec(unsigned long val, void __iomem *base,
+				   unsigned reg)
 {
 	/*
 	 * We can't write to secure registers as we are in non-secure
diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index efc5cab..478566b 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -72,7 +72,7 @@ static void l2c_write_sec(unsigned long val, void __iomem *base, unsigned reg)
 	if (val == readl_relaxed(base + reg))
 		return;
 	if (outer_cache.write_sec)
-		outer_cache.write_sec(val, reg);
+		outer_cache.write_sec(val, base, reg);
 	else
 		writel_relaxed(val, base + reg);
 }
-- 
1.9.3

