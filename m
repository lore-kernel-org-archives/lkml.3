Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab3HSVgg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 17:36:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24484 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab3HSVfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 17:35:47 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=PTAMXsjR3mwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5jOM9dmJ99oA:10 a=20KFwNOVAAAA:8 a=O3HAJVgSP7dV9RbNiDoA:9 a=jEp0ucaQiEUA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130819213545.142146472@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 19 Aug 2013 17:33:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>,
        Clark Williams <clark.williams@gmail.com>,
        Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH RT 2/3] hwlat-detector: Use trace_clock_local if available
References: <20130819213324.405942342@goodmis.org>
Content-Disposition: inline; filename=hwlat-use-trace-clock-3.10.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As ktime_get() calls into the timing code which does a read_seq(), it
may be affected by other CPUS that touch that lock. To remove this
dependency, use the trace_clock_local() which is already exported
for module use. If CONFIG_TRACING is enabled, use that as the clock,
otherwise use ktime_get().

Signed-off-by: Steven Rostedt <srostedt@redhat.com>

Index: linux-rt.git/drivers/misc/hwlat_detector.c
===================================================================
--- linux-rt.git.orig/drivers/misc/hwlat_detector.c
+++ linux-rt.git/drivers/misc/hwlat_detector.c
@@ -51,6 +51,7 @@
 #include <linux/version.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/trace_clock.h>
 
 #define BUF_SIZE_DEFAULT	262144UL		/* 8K*(sizeof(entry)) */
 #define BUF_FLAGS		(RB_FL_OVERWRITE)	/* no block on full */
@@ -211,6 +212,21 @@ static struct sample *buffer_get_sample(
 	return sample;
 }
 
+#ifndef CONFIG_TRACING
+#define time_type	ktime_t
+#define time_get()	ktime_get()
+#define time_to_us(x)	ktime_to_us(x)
+#define time_sub(a, b)	ktime_sub(a, b)
+#define init_time(a, b)	(a).tv64 = b
+#define time_u64(a)	(a).tv64
+#else
+#define time_type	u64
+#define time_get()	trace_clock_local()
+#define time_to_us(x)	((x) / 1000)
+#define time_sub(a, b)	((a) - (b))
+#define init_time(a, b)	a = b
+#define time_u64(a)	a
+#endif
 /**
  * get_sample - sample the CPU TSC and look for likely hardware latencies
  * @unused: This is not used but is a part of the stop_machine API
@@ -220,23 +236,23 @@ static struct sample *buffer_get_sample(
  */
 static int get_sample(void *unused)
 {
-	ktime_t start, t1, t2, last_t2;
+	time_type start, t1, t2, last_t2;
 	s64 diff, total = 0;
 	u64 sample = 0;
 	u64 outer_sample = 0;
 	int ret = 1;
 
-	last_t2.tv64 = 0;
-	start = ktime_get(); /* start timestamp */
+	init_time(last_t2, 0);
+	start = time_get(); /* start timestamp */
 
 	do {
 
-		t1 = ktime_get();	/* we'll look for a discontinuity */
-		t2 = ktime_get();
+		t1 = time_get();	/* we'll look for a discontinuity */
+		t2 = time_get();
 
-		if (last_t2.tv64) {
+		if (time_u64(last_t2)) {
 			/* Check the delta from the outer loop (t2 to next t1) */
-			diff = ktime_to_us(ktime_sub(t1, last_t2));
+			diff = time_to_us(time_sub(t1, last_t2));
 			/* This shouldn't happen */
 			if (diff < 0) {
 				printk(KERN_ERR BANNER "time running backwards\n");
@@ -247,10 +263,10 @@ static int get_sample(void *unused)
 		}
 		last_t2 = t2;
 
-		total = ktime_to_us(ktime_sub(t2, start)); /* sample width */
+		total = time_to_us(time_sub(t2, start)); /* sample width */
 
 		/* This checks the inner loop (t1 to t2) */
-		diff = ktime_to_us(ktime_sub(t2, t1));     /* current diff */
+		diff = time_to_us(time_sub(t2, t1));     /* current diff */
 
 		/* This shouldn't happen */
 		if (diff < 0) {

