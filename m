Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbaIVDa4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 23:30:56 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:10418 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751893AbaIVDaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 23:30:55 -0400
From: Yifan Zhang <zhangyf@marvell.com>
To: Yifan Zhang <zhangyf@marvell.com>, Tejun Heo <tj@kernel.org>,
        Jing Xiang <jxiang@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sun, 21 Sep 2014 20:30:32 -0700
Subject: RE: [PATCH] workqueue: fix a workqueue kernel panic issue.
Thread-Topic: [PATCH] workqueue: fix a workqueue kernel panic issue.
Thread-Index: Ac/SUVXUgv9WYXxTSbWGdimo3SCSngDxBw6w
Message-ID: <4737A960563B524DA805CA602BE04B307EEE6C2694@SC-VEXCH2.marvell.com>
References: <1410941884-26034-1-git-send-email-zhangyf@marvell.com>
In-Reply-To: <1410941884-26034-1-git-send-email-zhangyf@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-09-22_01:2014-09-19,2014-09-21,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1409220039
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8M3V24s025934

Hi Tejun,

What's do you think of this patch ? Any concern ?

BR,
Yifan

-----Original Message-----
From: Yifan Zhang [mailto:zhangyf@marvell.com] 
Sent: 2014Äê9ÔÂ17ÈÕ 16:18
To: Tejun Heo; Jing Xiang; linux-kernel@vger.kernel.org
Cc: Yifan Zhang
Subject: [PATCH] workqueue: fix a workqueue kernel panic issue.

if created workqueue in multi-thread unsynchronized,
get_work_pwq() may return NULL, which cause kernel panic. Judge get_work_pwq() return value before use
pwq->wq->flags.

Signed-off-by: Yifan Zhang <zhangyf@marvell.com>
---
 kernel/workqueue.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c index 5dbe22a..d3ac87f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1947,9 +1947,19 @@ __acquires(&pool->lock)  {
 	struct pool_workqueue *pwq = get_work_pwq(work);
 	struct worker_pool *pool = worker->pool;
-	bool cpu_intensive = pwq->wq->flags & WQ_CPU_INTENSIVE;
+	bool cpu_intensive;
 	int work_color;
 	struct worker *collision;
+
+	if (pwq == NULL) {
+		pr_err("BUG: invalid struct work_struct.data %lu\n",
+				atomic_long_read(&work->data));
+		dump_stack();
+		return;
+	}
+
+	cpu_intensive = pwq->wq->flags & WQ_CPU_INTENSIVE;
+
 #ifdef CONFIG_LOCKDEP
 	/*
 	 * It is permissible to free the struct work_struct from
--
1.7.9.5

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
