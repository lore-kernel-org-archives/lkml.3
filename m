Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbaA3QMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 11:12:10 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:33553 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbaA3QL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 11:11:59 -0500
From: =?UTF-8?q?Adrien=20Verg=C3=A9?= <adrienverge@gmail.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: =?UTF-8?q?Adrien=20Verg=C3=A9?= <adrienverge@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Christopher Covington <cov@codeaurora.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Michel Dagenais <michel.dagenais@polymtl.ca>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 5/5] ARM CoreSight: ETM: Add PID control support
Date: Thu, 30 Jan 2014 11:11:10 -0500
Message-Id: <1391098270-8867-6-git-send-email-adrienverge@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1391098270-8867-1-git-send-email-adrienverge@gmail.com>
References: <1391098270-8867-1-git-send-email-adrienverge@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the same manner as for enabling tracing, an entry is created in
sysfs to set the PID that triggers tracing. This change is effective
only if CONFIG_PID_IN_CONTEXTIDR is set.

When using PID namespaces, the virtual PID given by the user is
converted to the globally unique ID (task_pid_nr) that is present
in the Context ID register.

Signed-off-by: Adrien Vergé <adrienverge@gmail.com>
---
 arch/arm/include/asm/hardware/coresight.h |   5 ++
 arch/arm/kernel/etm.c                     | 131 ++++++++++++++++++++++++++++--
 2 files changed, 129 insertions(+), 7 deletions(-)

diff --git a/arch/arm/include/asm/hardware/coresight.h b/arch/arm/include/asm/hardware/coresight.h
index 8c50cf6..2051af0 100644
--- a/arch/arm/include/asm/hardware/coresight.h
+++ b/arch/arm/include/asm/hardware/coresight.h
@@ -98,6 +98,11 @@
 #define ETMR_ADDRCOMP_VAL(x)	(0x40 + (x) * 4)
 #define ETMR_ADDRCOMP_ACC_TYPE(x)	(0x80 + (x) * 4)
 
+#ifdef CONFIG_PID_IN_CONTEXTIDR
+#define ETMR_CTXIDCOMP_VAL(x)	(0x1b0 + (x) * 4)
+#define ETMR_CTXIDCOMP_MASK	(0x1bc)
+#endif
+
 /* ETM status register, "ETM Architecture", 3.3.2 */
 #define ETMR_STATUS		(0x10)
 #define ETMST_OVERFLOW		BIT(0)
diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index fa42e32..e8db9e2 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -25,6 +25,7 @@
 #include <linux/vmalloc.h>
 #include <linux/mutex.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 #include <asm/hardware/coresight.h>
 #include <asm/sections.h>
 
@@ -40,12 +41,17 @@ struct tracectx {
 	void __iomem	*etm_regs;
 	unsigned long	flags;
 	int		naddrcmppairs;
+	int		nctxidcmp;
 	int		etm_portsz;
 	struct device	*dev;
 	struct clk	*emu_clk;
 	struct mutex	mutex;
 	unsigned long	addrrange_start;
 	unsigned long	addrrange_end;
+	pid_t		pid;	/* globally unique PID */
+#ifdef CONFIG_PID_NS
+	pid_t		vpid;	/* virtual PID as seen in namespace */
+#endif
 };
 
 static struct tracectx tracer;
@@ -55,18 +61,42 @@ static inline bool trace_isrunning(struct tracectx *t)
 	return !!(t->flags & TRACER_RUNNING);
 }
 
+#if defined(CONFIG_PID_IN_CONTEXTIDR) && defined(CONFIG_PID_NS)
+/*
+ * Returns the globally unique ID of a task referenced
+ * with its virtual namespace PID
+ */
+static inline pid_t pid_vnr_to_pid_nr(pid_t vpid)
+{
+	struct task_struct *task = find_task_by_vpid(vpid);
+
+	if (!task) {
+		printk(KERN_WARNING "CoreSight ETM: cannot track PID %d: "
+				    "no such PID in current namespace\n",
+		       vpid);
+		return -EINVAL;
+	}
+
+	return task_pid_nr(task);
+}
+#endif
+
 /*
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
-		unsigned long start, unsigned long end, int exclude, int data)
+static int etm_setup(struct tracectx *t, int n,
+		     unsigned long start, unsigned long end, int exclude,
+		     pid_t pid,
+		     int data)
 {
-	u32 flags = ETMAAT_ARM | ETMAAT_IGNCONTEXTID | ETMAAT_NSONLY | \
-		    ETMAAT_NOVALCMP;
+	u32 flags = ETMAAT_ARM | ETMAAT_NSONLY | ETMAAT_NOVALCMP;
 
 	if (n < 1 || n > t->naddrcmppairs)
 		return -EINVAL;
@@ -75,6 +105,23 @@ static int etm_setup_address_range(struct tracectx *t, int n,
 	 * to bits in a word */
 	n--;
 
+#ifdef CONFIG_PID_IN_CONTEXTIDR
+	if (pid < 0) {
+		/* ignore Context ID */
+		flags |= ETMAAT_IGNCONTEXTID;
+	} else {
+		flags |= ETMAAT_VALUE1;
+
+		/* Set up the first Context ID comparator.
+		   Process ID is found in the 24 first bits of Context ID
+		   (provided by CONFIG_PID_IN_CONTEXTIDR) */
+		etm_writel(t, pid << 8, ETMR_CTXIDCOMP_VAL(0));
+		etm_writel(t, 0xff, ETMR_CTXIDCOMP_MASK);
+	}
+#else
+	flags |= ETMAAT_IGNCONTEXTID;
+#endif
+
 	if (data)
 		flags |= ETMAAT_DLOADSTORE;
 	else
@@ -124,8 +171,10 @@ static int trace_start(struct tracectx *t)
 		return -EFAULT;
 	}
 
-	etm_setup_address_range(t, 1, t->addrrange_start, t->addrrange_end,
-				0, 0);
+	etm_setup(t, 1,
+		  t->addrrange_start, t->addrrange_end, 0,
+		  t->pid,
+		  0);
 	etm_writel(t, 0, ETMR_TRACEENCTRL2);
 	etm_writel(t, 0, ETMR_TRACESSCTRL);
 	etm_writel(t, 0x6f, ETMR_TRACEENEVT);
@@ -489,6 +538,7 @@ static ssize_t trace_info_show(struct device *dev,
 
 	return sprintf(buf, "Trace buffer len: %d\n"
 			"Addr comparator pairs: %d\n"
+			"Ctx ID comparators: %d\n"
 			"ETBR_WRITEADDR:\t%08x\n"
 			"ETBR_READADDR:\t%08x\n"
 			"ETBR_STATUS:\t%08x\n"
@@ -497,6 +547,7 @@ static ssize_t trace_info_show(struct device *dev,
 			"ETMR_STATUS:\t%08x\n",
 			datalen,
 			tracer.naddrcmppairs,
+			tracer.nctxidcmp,
 			etb_wa,
 			etb_ra,
 			etb_st,
@@ -569,6 +620,61 @@ static ssize_t trace_addrrange_store(struct device *dev,
 DEVICE_ATTR(trace_addrrange, S_IRUGO|S_IWUSR,
 	    trace_addrrange_show, trace_addrrange_store);
 
+#ifdef CONFIG_PID_IN_CONTEXTIDR
+static ssize_t trace_pid_show(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+#ifdef CONFIG_PID_NS
+	return sprintf(buf, "%d\n", tracer.vpid);
+#else
+	return sprintf(buf, "%d\n", tracer.pid);
+#endif
+}
+
+static ssize_t trace_pid_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t n)
+{
+	pid_t pid;
+#ifdef CONFIG_PID_NS
+	pid_t vpid;
+#endif
+
+	if (tracer.flags & TRACER_RUNNING)
+		return -EBUSY;
+
+	if (sscanf(buf, "%i", &pid) != 1)
+		return -EINVAL;
+
+#ifdef CONFIG_PID_NS
+	/* the value written to the Context ID register is the global PID */
+	vpid = pid;
+
+	/* -1 means trace everything,
+	   0 means kernel tracing,
+	   > 0 process tracing */
+	if (pid > 0) {
+		pid = pid_vnr_to_pid_nr(vpid);
+
+		if (pid < 0)
+			return pid;
+	}
+#endif
+
+	mutex_lock(&tracer.mutex);
+	tracer.pid = pid;
+#ifdef CONFIG_PID_NS
+	tracer.vpid = vpid;
+#endif
+	mutex_unlock(&tracer.mutex);
+
+	return n;
+}
+
+DEVICE_ATTR(trace_pid, S_IRUGO|S_IWUSR, trace_pid_show, trace_pid_store);
+#endif
+
 static int etm_probe(struct amba_device *dev, const struct amba_id *id)
 {
 	struct tracectx *t = &tracer;
@@ -598,6 +704,7 @@ static int etm_probe(struct amba_device *dev, const struct amba_id *id)
 	t->etm_portsz = 1;
 	t->addrrange_start = (unsigned long) _stext;
 	t->addrrange_end = (unsigned long) _etext;
+	t->pid = -1; /* trace everything */
 
 	etm_unlock(t);
 	(void)etm_readl(t, ETMMR_PDSR);
@@ -605,6 +712,7 @@ static int etm_probe(struct amba_device *dev, const struct amba_id *id)
 	(void)etm_readl(&tracer, ETMMR_OSSRR);
 
 	t->naddrcmppairs = etm_readl(t, ETMR_CONFCODE) & 0xf;
+	t->nctxidcmp = (etm_readl(t, ETMR_CONFCODE) >> 24) & 0x3;
 	etm_writel(t, 0x440, ETMR_CTRL);
 	etm_lock(t);
 
@@ -612,7 +720,7 @@ static int etm_probe(struct amba_device *dev, const struct amba_id *id)
 	if (ret)
 		goto out_unmap;
 
-	/* failing to create any of these three is not fatal */
+	/* failing to create any of these four is not fatal */
 	ret = device_create_file(&dev->dev, &dev_attr_trace_info);
 	if (ret)
 		dev_dbg(&dev->dev, "Failed to create trace_info in sysfs\n");
@@ -625,6 +733,12 @@ static int etm_probe(struct amba_device *dev, const struct amba_id *id)
 	if (ret)
 		dev_dbg(&dev->dev, "Failed to create trace_addrrange in sysfs\n");
 
+#ifdef CONFIG_PID_IN_CONTEXTIDR
+	ret = device_create_file(&dev->dev, &dev_attr_trace_pid);
+	if (ret)
+		dev_dbg(&dev->dev, "Failed to create trace_pid in sysfs\n");
+#endif
+
 	dev_dbg(t->dev, "ETM AMBA driver initialized.\n");
 
 out:
@@ -655,6 +769,9 @@ static int etm_remove(struct amba_device *dev)
 	device_remove_file(&dev->dev, &dev_attr_trace_info);
 	device_remove_file(&dev->dev, &dev_attr_trace_mode);
 	device_remove_file(&dev->dev, &dev_attr_trace_addrrange);
+#ifdef CONFIG_PID_IN_CONTEXTIDR
+	device_remove_file(&dev->dev, &dev_attr_trace_pid);
+#endif
 
 	return 0;
 }
-- 
1.8.5.3

