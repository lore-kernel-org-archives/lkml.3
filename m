Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbaLDStp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 13:49:45 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14551 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753366AbaLDStn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 13:49:43 -0500
Date: Thu, 4 Dec 2014 13:49:38 -0500
From: Chris Mason <clm@fb.com>
To: Davide Libenzi <davidel@xmailserver.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] eventfd: don't take the spinlock in eventfd_poll
Message-ID: <20141204184937.GA28571@ret.masoncoding.com>
Mail-Followup-To: Chris Mason <clm@fb.com>,
	Davide Libenzi <davidel@xmailserver.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-04_08:2014-12-04,2014-12-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.925924926977281 urlsuspect_oldscore=0.925924926977281
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.925924926977281 spamscore=0
 recipient_to_sender_domain_totalscore=12 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412040168
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The spinlock in eventfd_poll is trying to protect the count of events
so it can decide if it should return POLLIN, POLLERR, or POLLOUT.  But,
because of the way we drop the lock after calling poll_wait, and drop it
again before returning, we have the same pile of races with the lock as
we do with a single read of ctx->count().

This replaces the lock with a read barrier and single read.

eventfd_write does a single bump of ctx->count, so this should not add
new races with adding events.  eventfd_read is similar, it will do a
single decrement with the lock held, and so we're making the race with
concurrent readers slightly larger.

This spinlock is the top CPU user in kernel code during one of our workloads.
Removing it gives us a ~2% boost.

Signed-off-by: Chris Mason <clm@fb.com>
---
 fs/eventfd.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/eventfd.c b/fs/eventfd.c
index d6a88e7..cdbdb96 100644
--- a/fs/eventfd.c
+++ b/fs/eventfd.c
@@ -119,17 +119,18 @@ static unsigned int eventfd_poll(struct file *file, poll_table *wait)
 	struct eventfd_ctx *ctx = file->private_data;
 	unsigned int events = 0;
 	unsigned long flags;
+	unsigned int count;
 
 	poll_wait(file, &ctx->wqh, wait);
+	smp_rmb();
+	count = ctx->count;
 
-	spin_lock_irqsave(&ctx->wqh.lock, flags);
-	if (ctx->count > 0)
+	if (count > 0)
 		events |= POLLIN;
-	if (ctx->count == ULLONG_MAX)
+	if (count == ULLONG_MAX)
 		events |= POLLERR;
-	if (ULLONG_MAX - 1 > ctx->count)
+	if (ULLONG_MAX - 1 > count)
 		events |= POLLOUT;
-	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
 
 	return events;
 }
-- 
1.8.1

