Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab3IINgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:36:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11424 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab3IIN0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:26:47 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=keZ67_62a1oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=I5-oX6zSL1kA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=0fVzeBSKrqlw0MCzi0QA:9 a=jeBq3FmKZ4MA:10 a=jEp0ucaQiEUA:10 a=Zh68SRI7RUMA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130909124800.838829922@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 09 Sep 2013 08:47:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        John Kacur <jkacur@redhat.com>, <stable-rt@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>
Subject: [PATCH RT 11/16] hwlat-detector: Update hwlat_detector to add outer loop detection
References: <20130909124745.590777496@goodmis.org>
Content-Disposition: inline; filename=0011-hwlat-detector-Update-hwlat_detector-to-add-outer-lo.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

The hwlat_detector reads two timestamps in a row, then reports any
gap between those calls. The problem is, it misses everything between
the second reading of the time stamp to the first reading of the time stamp
in the next loop. That's were most of the time is spent, which means,
chances are likely that it will miss all hardware latencies. This
defeats the purpose.

By also testing the first time stamp from the previous loop second
time stamp (the outer loop), we are more likely to find a latency.

Setting the threshold to 1, here's what the report now looks like:

1347415723.0232202770	0	2
1347415725.0234202822	0	2
1347415727.0236202875	0	2
1347415729.0238202928	0	2
1347415731.0240202980	0	2
1347415734.0243203061	0	2
1347415736.0245203113	0	2
1347415738.0247203166	2	0
1347415740.0249203219	0	3
1347415742.0251203272	0	3
1347415743.0252203299	0	3
1347415745.0254203351	0	2
1347415747.0256203404	0	2
1347415749.0258203457	0	2
1347415751.0260203510	0	2
1347415754.0263203589	0	2
1347415756.0265203642	0	2
1347415758.0267203695	0	2
1347415760.0269203748	0	2
1347415762.0271203801	0	2
1347415764.0273203853	2	0

There's some hardware latency that takes 2 microseconds to run.

Cc: stable-rt@vger.kernel.org
Signed-off-by: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/misc/hwlat_detector.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff --git a/drivers/misc/hwlat_detector.c b/drivers/misc/hwlat_detector.c
index b7b7c90..f93b8ef 100644
--- a/drivers/misc/hwlat_detector.c
+++ b/drivers/misc/hwlat_detector.c
@@ -143,6 +143,7 @@ static void detector_exit(void);
 struct sample {
 	u64		seqnum;		/* unique sequence */
 	u64		duration;	/* ktime delta */
+	u64		outer_duration;	/* ktime delta (outer loop) */
 	struct timespec	timestamp;	/* wall time */
 	unsigned long   lost;
 };
@@ -219,11 +220,13 @@ static struct sample *buffer_get_sample(struct sample *sample)
  */
 static int get_sample(void *unused)
 {
-	ktime_t start, t1, t2;
+	ktime_t start, t1, t2, last_t2;
 	s64 diff, total = 0;
 	u64 sample = 0;
+	u64 outer_sample = 0;
 	int ret = 1;
 
+	last_t2.tv64 = 0;
 	start = ktime_get(); /* start timestamp */
 
 	do {
@@ -231,7 +234,22 @@ static int get_sample(void *unused)
 		t1 = ktime_get();	/* we'll look for a discontinuity */
 		t2 = ktime_get();
 
+		if (last_t2.tv64) {
+			/* Check the delta from the outer loop (t2 to next t1) */
+			diff = ktime_to_us(ktime_sub(t1, last_t2));
+			/* This shouldn't happen */
+			if (diff < 0) {
+				printk(KERN_ERR BANNER "time running backwards\n");
+				goto out;
+			}
+			if (diff > outer_sample)
+				outer_sample = diff;
+		}
+		last_t2 = t2;
+
 		total = ktime_to_us(ktime_sub(t2, start)); /* sample width */
+
+		/* This checks the inner loop (t1 to t2) */
 		diff = ktime_to_us(ktime_sub(t2, t1));     /* current diff */
 
 		/* This shouldn't happen */
@@ -246,12 +264,13 @@ static int get_sample(void *unused)
 	} while (total <= data.sample_width);
 
 	/* If we exceed the threshold value, we have found a hardware latency */
-	if (sample > data.threshold) {
+	if (sample > data.threshold || outer_sample > data.threshold) {
 		struct sample s;
 
 		data.count++;
 		s.seqnum = data.count;
 		s.duration = sample;
+		s.outer_duration = outer_sample;
 		s.timestamp = CURRENT_TIME;
 		__buffer_add_sample(&s);
 
@@ -738,10 +757,11 @@ static ssize_t debug_sample_fread(struct file *filp, char __user *ubuf,
 		}
 	}
 
-	len = snprintf(buf, sizeof(buf), "%010lu.%010lu\t%llu\n",
-		      sample->timestamp.tv_sec,
-		      sample->timestamp.tv_nsec,
-		      sample->duration);
+	len = snprintf(buf, sizeof(buf), "%010lu.%010lu\t%llu\t%llu\n",
+		       sample->timestamp.tv_sec,
+		       sample->timestamp.tv_nsec,
+		       sample->duration,
+		       sample->outer_duration);
 
 
 	/* handling partial reads is more trouble than it's worth */
-- 
1.7.10.4


