Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbaFYUMm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 16:12:42 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:36474 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755245AbaFYUMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 16:12:41 -0400
From: Christopher Covington <cov@codeaurora.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Christopher Covington <cov@codeaurora.org>
Subject: [PATCH] RFC: perf: Make overflow signals inheritable
Date: Wed, 25 Jun 2014 16:12:09 -0400
Message-Id: <1403727129-20665-1-git-send-email-cov@codeaurora.org>
X-Mailer: git-send-email 1.8.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to get a signal from the perf events framework (use an
"event_limit"), one must not not only call perf_event_open() with the
appropriate sample_period, watermark, and wakeup_watermark values,
but also set the FASYNC flag on the resulting file descriptor with
fcntl(). If the inherit attribute is also set, one would expect child
tasks to cause signals like their parents. They don't, though,
because their FASYNC setting isn't set (and can't be by the user
since only the parent has a file descriptor). To fix this, allow the
parent's FASYNC value to be passed along to child events when the
inherit attribute is set. Overflow counts are still per process and
per CPU.

Signed-off-by: Christopher Covington <cov@codeaurora.org>
---
 kernel/events/core.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index a33d9a2b..e6c03c6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5440,11 +5440,6 @@ static int __perf_event_overflow(struct perf_event *event,
 			perf_adjust_period(event, delta, hwc->last_period, true);
 	}
 
-	/*
-	 * XXX event_limit might not quite work as expected on inherited
-	 * events
-	 */
-
 	event->pending_kill = POLL_IN;
 	if (events && atomic_dec_and_test(&event->event_limit)) {
 		ret = 1;
@@ -7688,6 +7683,13 @@ inherit_event(struct perf_event *parent_event,
 		= parent_event->overflow_handler_context;
 
 	/*
+	 * To ensure that event_limit works at least a little on inherited
+	 * events, have the child inherit the parent's fasync setting. Note
+	 * that counts are still per process, per CPU.
+	 */
+	child_event->fasync = parent_event->fasync;
+
+	/*
 	 * Precalculate sample_data sizes
 	 */
 	perf_event__header_size(child_event);
-- 
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by the Linux Foundation.

