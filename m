Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbaAXQl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 11:41:28 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:47310 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641AbaAXQl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 11:41:26 -0500
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
Subject: [PATCH V2 3/6] ARM CoreSight: ETM: Add address control support
Date: Fri, 24 Jan 2014 11:40:53 -0500
Message-Id: <1390581656-16372-4-git-send-email-adrienverge@gmail.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1390581656-16372-1-git-send-email-adrienverge@gmail.com>
References: <1390581656-16372-1-git-send-email-adrienverge@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the same manner as for enabling tracing, an entry is created
in sysfs to set the address range that triggers tracing.

Signed-off-by: Adrien Vergé <adrienverge@gmail.com>
---
 arch/arm/kernel/etm.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 49 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/etm.c b/arch/arm/kernel/etm.c
index 7f7a0ee..4442e5c 100644
--- a/arch/arm/kernel/etm.c
+++ b/arch/arm/kernel/etm.c
@@ -44,6 +44,8 @@ struct tracectx {
 	struct device	*dev;
 	struct clk	*emu_clk;
 	struct mutex	mutex;
+	unsigned long	addrrange_start;
+	unsigned long	addrrange_end;
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
 
-	etm_setup_address_range(t, 1, (unsigned long)_stext,
-			(unsigned long)_etext, 0, 0);
+	etm_setup_address_range(t, 1, t->addrrange_start, t->addrrange_end,
+				0, 0);
 	etm_writel(t, 0, ETMR_TRACEENCTRL2);
 	etm_writel(t, 0, ETMR_TRACESSCTRL);
 	etm_writel(t, 0x6f, ETMR_TRACEENEVT);
@@ -527,6 +536,36 @@ static ssize_t trace_mode_store(struct device *dev,
 
 DEVICE_ATTR(trace_mode, S_IRUGO|S_IWUSR, trace_mode_show, trace_mode_store);
 
+static ssize_t trace_addrrange_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%08lx - %08lx\n", tracer.addrrange_start,
+		       tracer.addrrange_end);
+}
+
+static ssize_t trace_addrrange_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t n)
+{
+	unsigned long start, end;
+
+	if (tracer.flags & TRACER_RUNNING)
+		return -EBUSY;
+
+	if (sscanf(buf, "%08lx - %08lx", &start, &end) != 2)
+		return -EINVAL;
+
+	mutex_lock(&tracer.mutex);
+	tracer.addrrange_start = start;
+	tracer.addrrange_end = end;
+	mutex_unlock(&tracer.mutex);
+
+	return n;
+}
+
+DEVICE_ATTR(trace_addrrange, S_IRUGO|S_IWUSR,
+	    trace_addrrange_show, trace_addrrange_store);
+
 static int etm_probe(struct amba_device *dev, const struct amba_id *id)
 {
 	struct tracectx *t = &tracer;
@@ -554,6 +593,8 @@ static int etm_probe(struct amba_device *dev, const struct amba_id *id)
 	t->dev = &dev->dev;
 	t->flags = TRACER_CYCLE_ACC;
 	t->etm_portsz = 1;
+	t->addrrange_start = (unsigned long) _stext;
+	t->addrrange_end = (unsigned long) _etext;
 
 	etm_unlock(t);
 	(void)etm_readl(t, ETMMR_PDSR);
@@ -568,7 +609,7 @@ static int etm_probe(struct amba_device *dev, const struct amba_id *id)
 	if (ret)
 		goto out_unmap;
 
-	/* failing to create any of these two is not fatal */
+	/* failing to create any of these three is not fatal */
 	ret = device_create_file(&dev->dev, &dev_attr_trace_info);
 	if (ret)
 		dev_dbg(&dev->dev, "Failed to create trace_info in sysfs\n");
@@ -577,6 +618,10 @@ static int etm_probe(struct amba_device *dev, const struct amba_id *id)
 	if (ret)
 		dev_dbg(&dev->dev, "Failed to create trace_mode in sysfs\n");
 
+	ret = device_create_file(&dev->dev, &dev_attr_trace_addrrange);
+	if (ret)
+		dev_dbg(&dev->dev, "Failed to create trace_addrrange in sysfs\n");
+
 	dev_dbg(t->dev, "ETM AMBA driver initialized.\n");
 
 out:
@@ -606,6 +651,7 @@ static int etm_remove(struct amba_device *dev)
 	device_remove_file(&dev->dev, &dev_attr_trace_running);
 	device_remove_file(&dev->dev, &dev_attr_trace_info);
 	device_remove_file(&dev->dev, &dev_attr_trace_mode);
+	device_remove_file(&dev->dev, &dev_attr_trace_addrrange);
 
 	return 0;
 }
-- 
1.8.5.2

