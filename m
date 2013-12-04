Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab3LDEk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 23:40:29 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:38524 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786Ab3LDEk0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 23:40:26 -0500
MIME-Version: 1.0
Date: Tue, 3 Dec 2013 23:40:25 -0500
Message-ID: <CANsc=4WgVs413LmWh6Ms_eb_GGNbuiRZUkBeGiS_VtG2VwLpaQ@mail.gmail.com>
Subject: [PATCH 2/3] ARM Coresight: Add address control support for ETM
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

In the same manner as for enabling tracing, an entry is created
in sysfs to set the address range that triggers tracing.

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
 arch/arm/kernel/etm.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 50 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index bd7e8e4..a72382b 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -44,6 +44,8 @@ struct tracectx {
  struct device *dev;
  struct clk *emu_clk;
  struct mutex mutex;
+ unsigned long addrrange_start;
+ unsigned long addrrange_end;
 };

 static struct tracectx tracer;
@@ -53,6 +55,13 @@ static inline bool trace_isrunning(struct tracectx *t)
  return !!(t->flags & TRACER_RUNNING);
 }

+/*
+ * Setups ETM to trace only when:
+ *   - address between start and end
+ *     or address not between start and end (if exclude)
+ *   - trace executed instructions
+ *     or trace loads and stores (if data)
+ */
 static int etm_setup_address_range(struct tracectx *t, int n,
  unsigned long start, unsigned long end, int exclude, int data)
 {
@@ -115,8 +124,8 @@ static int trace_start(struct tracectx *t)
  return -EFAULT;
  }

- etm_setup_address_range(t, 1, (unsigned long)_stext,
- (unsigned long)_etext, 0, 0);
+ etm_setup_address_range(t, 1, t->addrrange_start, t->addrrange_end,
+ 0, 0);
  etm_writel(t, 0, ETMR_TRACEENCTRL2);
  etm_writel(t, 0, ETMR_TRACESSCTRL);
  etm_writel(t, 0x6f, ETMR_TRACEENEVT);
@@ -532,6 +541,37 @@ static ssize_t trace_mode_store(struct kobject *kobj,
 static struct kobj_attribute trace_mode_attr =
  __ATTR(trace_mode, 0644, trace_mode_show, trace_mode_store);

+static ssize_t trace_addrrange_show(struct kobject *kobj,
+    struct kobj_attribute *attr,
+    char *buf)
+{
+ return sprintf(buf, "%08lx - %08lx\n", tracer.addrrange_start,
+       tracer.addrrange_end);
+}
+
+static ssize_t trace_addrrange_store(struct kobject *kobj,
+     struct kobj_attribute *attr,
+     const char *buf, size_t n)
+{
+ unsigned long start, end;
+
+ if (tracer.flags & TRACER_RUNNING)
+ return -EBUSY;
+
+ if (sscanf(buf, "%08lx - %08lx", &start, &end) != 2)
+ return -EINVAL;
+
+ mutex_lock(&tracer.mutex);
+ tracer.addrrange_start = start;
+ tracer.addrrange_end = end;
+ mutex_unlock(&tracer.mutex);
+
+ return n;
+}
+
+static struct kobj_attribute trace_addrrange_attr =
+ __ATTR(trace_addrrange, 0644, trace_addrrange_show, trace_addrrange_store);
+
 static int etm_probe(struct amba_device *dev, const struct amba_id *id)
 {
  struct tracectx *t = &tracer;
@@ -559,6 +599,8 @@ static int etm_probe(struct amba_device *dev,
const struct amba_id *id)
  t->dev = &dev->dev;
  t->flags = TRACER_CYCLE_ACC;
  t->etm_portsz = 1;
+ t->addrrange_start = (unsigned long) _stext;
+ t->addrrange_end = (unsigned long) _etext;

  etm_unlock(t);
  (void)etm_readl(t, ETMMR_PDSR);
@@ -574,7 +616,7 @@ static int etm_probe(struct amba_device *dev,
const struct amba_id *id)
  if (ret)
  goto out_unmap;

- /* failing to create any of these two is not fatal */
+ /* failing to create any of these three is not fatal */
  ret = sysfs_create_file(&dev->dev.kobj, &trace_info_attr.attr);
  if (ret)
  dev_dbg(&dev->dev, "Failed to create trace_info in sysfs\n");
@@ -583,6 +625,10 @@ static int etm_probe(struct amba_device *dev,
const struct amba_id *id)
  if (ret)
  dev_dbg(&dev->dev, "Failed to create trace_mode in sysfs\n");

+ ret = sysfs_create_file(&dev->dev.kobj, &trace_addrrange_attr.attr);
+ if (ret)
+ dev_dbg(&dev->dev, "Failed to create trace_addrrange in sysfs\n");
+
  dev_dbg(t->dev, "ETM AMBA driver initialized.\n");

 out:
@@ -612,6 +658,7 @@ static int etm_remove(struct amba_device *dev)
  sysfs_remove_file(&dev->dev.kobj, &trace_running_attr.attr);
  sysfs_remove_file(&dev->dev.kobj, &trace_info_attr.attr);
  sysfs_remove_file(&dev->dev.kobj, &trace_mode_attr.attr);
+ sysfs_remove_file(&dev->dev.kobj, &trace_addrrange_attr.attr);

  return 0;
 }
-- 
1.8.3.1
