Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab3LDElF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 23:41:05 -0500
Received: from mail-vc0-f179.google.com ([209.85.220.179]:49200 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928Ab3LDElA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 23:41:00 -0500
MIME-Version: 1.0
Date: Tue, 3 Dec 2013 23:40:59 -0500
Message-ID: <CANsc=4Vy911xcf7fYEjyeV_CNGp8POje9BZrLSP8xrk4YAfSNA@mail.gmail.com>
Subject: [PATCH 3/3] ARM Coresight: Add PID control support for ETM tracing
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

In the same manner as for enabling tracing, an entry is created in
sysfs to set the PID that triggers tracing. This change requires
CONFIG_PID_IN_CONTEXTIDR to be set when using on-chip ETM.

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
 arch/arm/Kconfig.debug                    |  1 +
 arch/arm/include/asm/hardware/coresight.h |  3 ++
 arch/arm/kernel/etm.c                     | 73 ++++++++++++++++++++++++++++---
 3 files changed, 70 insertions(+), 7 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 5765abf..fef32e15 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -1130,6 +1130,7 @@ config EARLY_PRINTK
 config OC_ETM
  bool "On-chip ETM and ETB"
  depends on ARM_AMBA
+ select PID_IN_CONTEXTIDR
  help
   Enables the on-chip embedded trace macrocell and embedded trace
   buffer driver that will allow you to collect traces of the
diff --git a/arch/arm/include/asm/hardware/coresight.h
b/arch/arm/include/asm/hardware/coresight.h
index 8c50cf6..009cdf9 100644
--- a/arch/arm/include/asm/hardware/coresight.h
+++ b/arch/arm/include/asm/hardware/coresight.h
@@ -98,6 +98,9 @@
 #define ETMR_ADDRCOMP_VAL(x) (0x40 + (x) * 4)
 #define ETMR_ADDRCOMP_ACC_TYPE(x) (0x80 + (x) * 4)

+#define ETMR_CTXIDCOMP_VAL(x) (0x1b0 + (x) * 4)
+#define ETMR_CTXIDCOMP_MASK (0x1bc)
+
 /* ETM status register, "ETM Architecture", 3.3.2 */
 #define ETMR_STATUS (0x10)
 #define ETMST_OVERFLOW BIT(0)
diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index a72382b..18afed1 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -40,12 +40,14 @@ struct tracectx {
  void __iomem *etm_regs;
  unsigned long flags;
  int naddrcmppairs;
+ int nctxidcmp;
  int etm_portsz;
  struct device *dev;
  struct clk *emu_clk;
  struct mutex mutex;
  unsigned long addrrange_start;
  unsigned long addrrange_end;
+ long pid;
 };

 static struct tracectx tracer;
@@ -59,14 +61,18 @@ static inline bool trace_isrunning(struct tracectx *t)
  * Setups ETM to trace only when:
  *   - address between start and end
  *     or address not between start and end (if exclude)
+ *   - in user-space when process id equals pid,
+ *     in kernel-space (if pid == 0),
+ *     always (if pid == -1)
  *   - trace executed instructions
  *     or trace loads and stores (if data)
  */
-static int etm_setup_address_range(struct tracectx *t, int n,
- unsigned long start, unsigned long end, int exclude, int data)
+static int etm_setup(struct tracectx *t, int n,
+     unsigned long start, unsigned long end, int exclude,
+     long pid,
+     int data)
 {
- u32 flags = ETMAAT_ARM | ETMAAT_IGNCONTEXTID | ETMAAT_NSONLY | \
-    ETMAAT_NOVALCMP;
+ u32 flags = ETMAAT_ARM | ETMAAT_NSONLY | ETMAAT_NOVALCMP;

  if (n < 1 || n > t->naddrcmppairs)
  return -EINVAL;
@@ -75,6 +81,19 @@ static int etm_setup_address_range(struct tracectx *t, int n,
  * to bits in a word */
  n--;

+ if (pid < 0) {
+ /* ignore Context ID */
+ flags |= ETMAAT_IGNCONTEXTID;
+ } else {
+ flags |= ETMAAT_VALUE1;
+
+ /* Set up the first Context ID comparator.
+   Process ID is found in the 24 first bits of Context ID
+   (provided by CONFIG_PID_IN_CONTEXTIDR) */
+ etm_writel(t, pid << 8, ETMR_CTXIDCOMP_VAL(0));
+ etm_writel(t, 0xff, ETMR_CTXIDCOMP_MASK);
+ }
+
  if (data)
  flags |= ETMAAT_DLOADSTORE;
  else
@@ -124,8 +143,10 @@ static int trace_start(struct tracectx *t)
  return -EFAULT;
  }

- etm_setup_address_range(t, 1, t->addrrange_start, t->addrrange_end,
- 0, 0);
+ etm_setup(t, 1,
+  t->addrrange_start, t->addrrange_end, 0,
+  t->pid,
+  0);
  etm_writel(t, 0, ETMR_TRACEENCTRL2);
  etm_writel(t, 0, ETMR_TRACESSCTRL);
  etm_writel(t, 0x6f, ETMR_TRACEENEVT);
@@ -488,6 +509,7 @@ static ssize_t trace_info_show(struct kobject *kobj,

  return sprintf(buf, "Trace buffer len: %d\n"
  "Addr comparator pairs: %d\n"
+ "Ctx ID comparators: %d\n"
  "ETBR_WRITEADDR:\t%08x\n"
  "ETBR_READADDR:\t%08x\n"
  "ETBR_STATUS:\t%08x\n"
@@ -496,6 +518,7 @@ static ssize_t trace_info_show(struct kobject *kobj,
  "ETMR_STATUS:\t%08x\n",
  datalen,
  tracer.naddrcmppairs,
+ tracer.nctxidcmp,
  etb_wa,
  etb_ra,
  etb_st,
@@ -572,6 +595,35 @@ static ssize_t trace_addrrange_store(struct kobject *kobj,
 static struct kobj_attribute trace_addrrange_attr =
  __ATTR(trace_addrrange, 0644, trace_addrrange_show, trace_addrrange_store);

+static ssize_t trace_pid_show(struct kobject *kobj,
+      struct kobj_attribute *attr,
+      char *buf)
+{
+ return sprintf(buf, "%ld\n", tracer.pid);
+}
+
+static ssize_t trace_pid_store(struct kobject *kobj,
+       struct kobj_attribute *attr,
+       const char *buf, size_t n)
+{
+ long pid;
+
+ if (tracer.flags & TRACER_RUNNING)
+ return -EBUSY;
+
+ if (sscanf(buf, "%li", &pid) != 1)
+ return -EINVAL;
+
+ mutex_lock(&tracer.mutex);
+ tracer.pid = pid;
+ mutex_unlock(&tracer.mutex);
+
+ return n;
+}
+
+static struct kobj_attribute trace_pid_attr =
+ __ATTR(trace_pid, 0644, trace_pid_show, trace_pid_store);
+
 static int etm_probe(struct amba_device *dev, const struct amba_id *id)
 {
  struct tracectx *t = &tracer;
@@ -601,6 +653,7 @@ static int etm_probe(struct amba_device *dev,
const struct amba_id *id)
  t->etm_portsz = 1;
  t->addrrange_start = (unsigned long) _stext;
  t->addrrange_end = (unsigned long) _etext;
+ t->pid = -1; /* trace everything */

  etm_unlock(t);
  (void)etm_readl(t, ETMMR_PDSR);
@@ -608,6 +661,7 @@ static int etm_probe(struct amba_device *dev,
const struct amba_id *id)
  (void)etm_readl(&tracer, ETMMR_OSSRR);

  t->naddrcmppairs = etm_readl(t, ETMR_CONFCODE) & 0xf;
+ t->nctxidcmp = (etm_readl(t, ETMR_CONFCODE) >> 24) & 0x3;
  etm_writel(t, 0x440, ETMR_CTRL);
  etm_lock(t);

@@ -616,7 +670,7 @@ static int etm_probe(struct amba_device *dev,
const struct amba_id *id)
  if (ret)
  goto out_unmap;

- /* failing to create any of these three is not fatal */
+ /* failing to create any of these four is not fatal */
  ret = sysfs_create_file(&dev->dev.kobj, &trace_info_attr.attr);
  if (ret)
  dev_dbg(&dev->dev, "Failed to create trace_info in sysfs\n");
@@ -629,6 +683,10 @@ static int etm_probe(struct amba_device *dev,
const struct amba_id *id)
  if (ret)
  dev_dbg(&dev->dev, "Failed to create trace_addrrange in sysfs\n");

+ ret = sysfs_create_file(&dev->dev.kobj, &trace_pid_attr.attr);
+ if (ret)
+ dev_dbg(&dev->dev, "Failed to create trace_pid in sysfs\n");
+
  dev_dbg(t->dev, "ETM AMBA driver initialized.\n");

 out:
@@ -659,6 +717,7 @@ static int etm_remove(struct amba_device *dev)
  sysfs_remove_file(&dev->dev.kobj, &trace_info_attr.attr);
  sysfs_remove_file(&dev->dev.kobj, &trace_mode_attr.attr);
  sysfs_remove_file(&dev->dev.kobj, &trace_addrrange_attr.attr);
+ sysfs_remove_file(&dev->dev.kobj, &trace_pid_attr.attr);

  return 0;
 }
-- 
1.8.3.1
