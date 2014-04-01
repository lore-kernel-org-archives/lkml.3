Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702AbaDADVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 23:21:01 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:27263 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751032AbaDADVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 23:21:00 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: <akpm@linux-foundation.org>
CC: <john.stultz@linaro.org>, <linux-kernel@vger.kernel.org>,
        Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH V2] printk: add sleep time into timestamp
Date: Tue, 1 Apr 2014 11:20:56 +0800
Message-ID: <1396322456-5195-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-04-01_02:2014-03-31,2014-04-01,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=1
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1403310169
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sleep time into timestamp to reflect the actual time since
sched_clock will be stopped during suspend.

Thanks John Stultz for suggestion to use monotonic_to_bootbased.

Signed-off-by: Neil Zhang <zhangwm@marvell.com>
---
 kernel/printk/printk.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 4dae9cb..121f792 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -250,6 +250,18 @@ static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
 
+static u64 print_clock(void)
+{
+	struct timespec	ts;
+	u64 ts_nsec = local_clock();
+
+	ts = ns_to_timespec(ts_nsec);
+	monotonic_to_bootbased(&ts);
+	ts_nsec = timespec_to_ns(&ts);
+
+	return ts_nsec;
+}
+
 /* cpu currently holding logbuf_lock */
 static volatile unsigned int logbuf_cpu = UINT_MAX;
 
@@ -349,7 +361,7 @@ static void log_store(int facility, int level,
 	if (ts_nsec > 0)
 		msg->ts_nsec = ts_nsec;
 	else
-		msg->ts_nsec = local_clock();
+		msg->ts_nsec = print_clock();
 	memset(log_dict(msg) + dict_len, 0, pad_len);
 	msg->len = sizeof(struct printk_log) + text_len + dict_len + pad_len;
 
@@ -1440,7 +1452,7 @@ static bool cont_add(int facility, int level, const char *text, size_t len)
 		cont.facility = facility;
 		cont.level = level;
 		cont.owner = current;
-		cont.ts_nsec = local_clock();
+		cont.ts_nsec = print_clock();
 		cont.flags = 0;
 		cont.cons = 0;
 		cont.flushed = false;
-- 
1.7.9.5

