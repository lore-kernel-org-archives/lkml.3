Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab3LDEj7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 23:39:59 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:39405 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753821Ab3LDEj4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 23:39:56 -0500
MIME-Version: 1.0
Date: Tue, 3 Dec 2013 23:39:56 -0500
Message-ID: <CANsc=4V59fsPDQZm_eaDwX30+cxvd7u2AbEmAk+LC1G1AXs_aA@mail.gmail.com>
Subject: [PATCH 1/3] ARM Coresight: Rename 'comparator' to 'address
From: =?UTF-8?Q?Adrien_Verg=C3=A9?= <adrienverge@gmail.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Russell King <linux@arm.linux.org.uk>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Will Deacon <will.deacon@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Randy Dunlap <rdunlap@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there are different types of comparators, and other kinds will
be used (such as Context ID comparators), rename them properly.

Signed-off-by: Adrien Vergé <adrienverge@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
---
 arch/arm/include/asm/hardware/coresight.h |  4 ++--
 arch/arm/kernel/etm.c                     | 19 ++++++++++---------
 2 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/arch/arm/include/asm/hardware/coresight.h
b/arch/arm/include/asm/hardware/coresight.h
index ad774f3..8c50cf6 100644
--- a/arch/arm/include/asm/hardware/coresight.h
+++ b/arch/arm/include/asm/hardware/coresight.h
@@ -95,8 +95,8 @@
 #define ETMAAT_NSONLY (1 << 10)
 #define ETMAAT_SONLY (2 << 10)

-#define ETMR_COMP_VAL(x) (0x40 + (x) * 4)
-#define ETMR_COMP_ACC_TYPE(x) (0x80 + (x) * 4)
+#define ETMR_ADDRCOMP_VAL(x) (0x40 + (x) * 4)
+#define ETMR_ADDRCOMP_ACC_TYPE(x) (0x80 + (x) * 4)

 /* ETM status register, "ETM Architecture", 3.3.2 */
 #define ETMR_STATUS (0x10)
diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 8ff0ecd..bd7e8e4 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -39,7 +39,7 @@ struct tracectx {
  void __iomem *etb_regs;
  void __iomem *etm_regs;
  unsigned long flags;
- int ncmppairs;
+ int naddrcmppairs;
  int etm_portsz;
  struct device *dev;
  struct clk *emu_clk;
@@ -59,7 +59,7 @@ static int etm_setup_address_range(struct tracectx *t, int n,
  u32 flags = ETMAAT_ARM | ETMAAT_IGNCONTEXTID | ETMAAT_NSONLY | \
     ETMAAT_NOVALCMP;

- if (n < 1 || n > t->ncmppairs)
+ if (n < 1 || n > t->naddrcmppairs)
  return -EINVAL;

  /* comparators and ranges are numbered starting with 1 as opposed
@@ -72,12 +72,12 @@ static int etm_setup_address_range(struct tracectx
*t, int n,
  flags |= ETMAAT_IEXEC;

  /* first comparator for the range */
- etm_writel(t, flags, ETMR_COMP_ACC_TYPE(n * 2));
- etm_writel(t, start, ETMR_COMP_VAL(n * 2));
+ etm_writel(t, flags, ETMR_ADDRCOMP_ACC_TYPE(n * 2));
+ etm_writel(t, start, ETMR_ADDRCOMP_VAL(n * 2));

  /* second comparator is right next to it */
- etm_writel(t, flags, ETMR_COMP_ACC_TYPE(n * 2 + 1));
- etm_writel(t, end, ETMR_COMP_VAL(n * 2 + 1));
+ etm_writel(t, flags, ETMR_ADDRCOMP_ACC_TYPE(n * 2 + 1));
+ etm_writel(t, end, ETMR_ADDRCOMP_VAL(n * 2 + 1));

  flags = exclude ? ETMTE_INCLEXCL : 0;
  etm_writel(t, flags | (1 << n), ETMR_TRACEENCTRL);
@@ -477,7 +477,8 @@ static ssize_t trace_info_show(struct kobject *kobj,
  etm_st = etm_readl(&tracer, ETMR_STATUS);
  etm_lock(&tracer);

- return sprintf(buf, "Trace buffer len: %d\nComparator pairs: %d\n"
+ return sprintf(buf, "Trace buffer len: %d\n"
+ "Addr comparator pairs: %d\n"
  "ETBR_WRITEADDR:\t%08x\n"
  "ETBR_READADDR:\t%08x\n"
  "ETBR_STATUS:\t%08x\n"
@@ -485,7 +486,7 @@ static ssize_t trace_info_show(struct kobject *kobj,
  "ETMR_CTRL:\t%08x\n"
  "ETMR_STATUS:\t%08x\n",
  datalen,
- tracer.ncmppairs,
+ tracer.naddrcmppairs,
  etb_wa,
  etb_ra,
  etb_st,
@@ -564,7 +565,7 @@ static int etm_probe(struct amba_device *dev,
const struct amba_id *id)
  /* dummy first read */
  (void)etm_readl(&tracer, ETMMR_OSSRR);

- t->ncmppairs = etm_readl(t, ETMR_CONFCODE) & 0xf;
+ t->naddrcmppairs = etm_readl(t, ETMR_CONFCODE) & 0xf;
  etm_writel(t, 0x440, ETMR_CTRL);
  etm_lock(t);

-- 
1.8.3.1
