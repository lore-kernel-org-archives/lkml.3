Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025AbbAVVKA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 16:10:00 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18827 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753313AbbAVVJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 16:09:58 -0500
From: Shaohua Li <shli@fb.com>
To: <linux-kernel@vger.kernel.org>
CC: <Kernel-team@fb.com>, Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>
Subject: [RFC 1/2] perf: update shadow timestamp before add event
Date: Thu, 22 Jan 2015 13:09:01 -0800
Message-ID: <119aa7d433860f568136ab623fb4a510c28e9e6f.1421906750.git.shli@fb.com>
X-Mailer: git-send-email 1.8.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2015-01-22_08:2015-01-22,2015-01-22,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=2.92412122293584e-09 kscore.compositescore=0
 circleOfTrustscore=514.84 compositescore=0.98609165920913
 urlsuspect_oldscore=0.98609165920913 suspectscore=1
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.98609165920913 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1501220194
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the shadow timestamp before start event. .add might use the
timestamp.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 kernel/events/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 882f835..4edde3e 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1769,6 +1769,10 @@ event_sched_in(struct perf_event *event,
 
 	perf_pmu_disable(event->pmu);
 
+	event->tstamp_running += tstamp - event->tstamp_stopped;
+
+	perf_set_shadow_time(event, ctx, tstamp);
+
 	if (event->pmu->add(event, PERF_EF_START)) {
 		event->state = PERF_EVENT_STATE_INACTIVE;
 		event->oncpu = -1;
@@ -1776,10 +1780,6 @@ event_sched_in(struct perf_event *event,
 		goto out;
 	}
 
-	event->tstamp_running += tstamp - event->tstamp_stopped;
-
-	perf_set_shadow_time(event, ctx, tstamp);
-
 	if (!is_software_event(event))
 		cpuctx->active_oncpu++;
 	ctx->nr_active++;
-- 
1.8.1

