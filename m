Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaAXQl4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 11:41:56 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:52502 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbaAXQla (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 11:41:30 -0500
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
Subject: [PATCH V2 5/6] ARM CoreSight: ETM: Add PID control support
Date: Fri, 24 Jan 2014 11:40:55 -0500
Message-Id: <1390581656-16372-6-git-send-email-adrienverge@gmail.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1390581656-16372-1-git-send-email-adrienverge@gmail.com>
References: <1390581656-16372-1-git-send-email-adrienverge@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the same manner as for enabling tracing, an entry is created in
sysfs to set the PID that triggers tracing. This change is effective
only if CONFIG_PID_IN_CONTEXTIDR is set, and thus is not compatible
with PID namespaces.

Signed-off-by: Adrien Vergé <adrienverge@gmail.com>
---
 arch/arm/include/asm/hardware/coresight.h |  5 ++
 arch/arm/kernel/etm.c                     | 82 ++++++++++++++++++++++++++++---
 2 files changed, 80 insertions(+), 7 deletions(-)

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
index 4442e5c..54b5128 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -40,12 +40,14 @@ struct tracectx {
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
+	int		pid;
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
-		unsigned long start, unsigned long end, int exclude, int data)
+static int etm_setup(struct tracectx *t, int n,
+		     unsigned long start, unsigned long end, int exclude,
+		     int pid,
+		     int data)
 {
-	u32 flags = ETMAAT_ARM | ETMAAT_IGNCONTEXTID | ETMAAT_NSONLY | \
-		    ETMAAT_NOVALCMP;
+	u32 flags = ETMAAT_ARM | ETMAAT_NSONLY | ETMAAT_NOVALCMP;
 
 	if (n < 1 || n > t->naddrcmppairs)
 		return -EINVAL;
@@ -75,6 +81,23 @@ static int etm_setup_address_range(struct tracectx *t, int n,
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
@@ -124,8 +147,10 @@ static int trace_start(struct tracectx *t)
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
@@ -486,6 +511,7 @@ static ssize_t trace_info_show(struct device *dev,
 
 	return sprintf(buf, "Trace buffer len: %d\n"
 			"Addr comparator pairs: %d\n"
+			"Ctx ID comparators: %d\n"
 			"ETBR_WRITEADDR:\t%08x\n"
 			"ETBR_READADDR:\t%08x\n"
 			"ETBR_STATUS:\t%08x\n"
@@ -494,6 +520,7 @@ static ssize_t trace_info_show(struct device *dev,
 			"ETMR_STATUS:\t%08x\n",
 			datalen,
 			tracer.naddrcmppairs,
+			tracer.nctxidcmp,
 			etb_wa,
 			etb_ra,
 			etb_st,
@@ -566,6 +593,36 @@ static ssize_t trace_addrrange_store(struct device *dev,
 DEVICE_ATTR(trace_addrrange, S_IRUGO|S_IWUSR,
 	    trace_addrrange_show, trace_addrrange_store);
 
+#ifdef CONFIG_PID_IN_CONTEXTIDR
+static ssize_t trace_pid_show(struct device *dev,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	return sprintf(buf, "%d\n", tracer.pid);
+}
+
+static ssize_t trace_pid_store(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t n)
+{
+	int pid;
+
+	if (tracer.flags & TRACER_RUNNING)
+		return -EBUSY;
+
+	if (sscanf(buf, "%i", &pid) != 1)
+		return -EINVAL;
+
+	mutex_lock(&tracer.mutex);
+	tracer.pid = pid;
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
@@ -595,6 +652,7 @@ static int etm_probe(struct amba_device *dev, const struct amba_id *id)
 	t->etm_portsz = 1;
 	t->addrrange_start = (unsigned long) _stext;
 	t->addrrange_end = (unsigned long) _etext;
+	t->pid = -1; /* trace everything */
 
 	etm_unlock(t);
 	(void)etm_readl(t, ETMMR_PDSR);
@@ -602,6 +660,7 @@ static int etm_probe(struct amba_device *dev, const struct amba_id *id)
 	(void)etm_readl(&tracer, ETMMR_OSSRR);
 
 	t->naddrcmppairs = etm_readl(t, ETMR_CONFCODE) & 0xf;
+	t->nctxidcmp = (etm_readl(t, ETMR_CONFCODE) >> 24) & 0x3;
 	etm_writel(t, 0x440, ETMR_CTRL);
 	etm_lock(t);
 
@@ -609,7 +668,7 @@ static int etm_probe(struct amba_device *dev, const struct amba_id *id)
 	if (ret)
 		goto out_unmap;
 
-	/* failing to create any of these three is not fatal */
+	/* failing to create any of these four is not fatal */
 	ret = device_create_file(&dev->dev, &dev_attr_trace_info);
 	if (ret)
 		dev_dbg(&dev->dev, "Failed to create trace_info in sysfs\n");
@@ -622,6 +681,12 @@ static int etm_probe(struct amba_device *dev, const struct amba_id *id)
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
@@ -652,6 +717,9 @@ static int etm_remove(struct amba_device *dev)
 	device_remove_file(&dev->dev, &dev_attr_trace_info);
 	device_remove_file(&dev->dev, &dev_attr_trace_mode);
 	device_remove_file(&dev->dev, &dev_attr_trace_addrrange);
+#ifdef CONFIG_PID_IN_CONTEXTIDR
+	device_remove_file(&dev->dev, &dev_attr_trace_pid);
+#endif
 
 	return 0;
 }
-- 
1.8.5.2

