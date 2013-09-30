Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab3I3UaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:30:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:8648 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756539Ab3I3U3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:29:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1010,1371106800"; 
   d="scan'208";a="412029776"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, mingo@kernel.org, eranian@google.com,
        peterz@infradead.org
Subject: [PATCH 11/11] perf: Avoid uninitialized sample type reference in __perf_event__output_id_sample
Date: Mon, 30 Sep 2013 13:29:12 -0700
Message-Id: <1380572952-30729-12-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

__perf_event__output_id_sample looks at data->type to decide
what to output.

A lot of of the custom output functions, for example perf_log_throttle
start with perf_event_header__init_id, which only initializes
the header when event->attr.sample_id_all is true.

But when this is false the output function is still called,
and will look at an uninitialized header.

I changed all the callers to perf_event_header__init_id
to __perf_event_header__init_id which unconditionally
initializes the header.

FWIW I'm not fully sure this is the correct fix and what the
exact semantics of sample_id_all are supposed to be.
Should it disable all throttling etc. messages?
Please review carefully.

Cc: mingo@kernel.org
Cc: eranian@google.com
Cc: peterz@infradead.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/events/core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index cb4238e..0b15209 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4732,7 +4732,7 @@ perf_event_read_event(struct perf_event *event,
 	};
 	int ret;
 
-	perf_event_header__init_id(&read_event.header, &sample, event);
+	__perf_event_header__init_id(&read_event.header, &sample, event);
 	ret = perf_output_begin(&handle, event, read_event.header.size);
 	if (ret)
 		return;
@@ -4837,7 +4837,7 @@ static void perf_event_task_output(struct perf_event *event,
 	if (!perf_event_task_match(event))
 		return;
 
-	perf_event_header__init_id(&task_event->event_id.header, &sample, event);
+	__perf_event_header__init_id(&task_event->event_id.header, &sample, event);
 
 	ret = perf_output_begin(&handle, event,
 				task_event->event_id.header.size);
@@ -4931,7 +4931,7 @@ static void perf_event_comm_output(struct perf_event *event,
 	if (!perf_event_comm_match(event))
 		return;
 
-	perf_event_header__init_id(&comm_event->event_id.header, &sample, event);
+	__perf_event_header__init_id(&comm_event->event_id.header, &sample, event);
 	ret = perf_output_begin(&handle, event,
 				comm_event->event_id.header.size);
 
@@ -5063,7 +5063,7 @@ static void perf_event_mmap_output(struct perf_event *event,
 		mmap_event->event_id.header.size += sizeof(mmap_event->ino_generation);
 	}
 
-	perf_event_header__init_id(&mmap_event->event_id.header, &sample, event);
+	__perf_event_header__init_id(&mmap_event->event_id.header, &sample, event);
 	ret = perf_output_begin(&handle, event,
 				mmap_event->event_id.header.size);
 	if (ret)
@@ -5237,7 +5237,7 @@ static void perf_log_throttle(struct perf_event *event, int enable)
 	if (enable)
 		throttle_event.header.type = PERF_RECORD_UNTHROTTLE;
 
-	perf_event_header__init_id(&throttle_event.header, &sample, event);
+	__perf_event_header__init_id(&throttle_event.header, &sample, event);
 
 	ret = perf_output_begin(&handle, event,
 				throttle_event.header.size);
-- 
1.8.3.1

