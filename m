Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab3HVOO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 10:14:56 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:40684 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab3HVOOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 10:14:52 -0400
From: Robert Richter <rric@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org,
        Robert Richter <robert.richter@linaro.org>,
        Robert Richter <rric@kernel.org>
Subject: [PATCH v3 10/12] perf, persistent: Implement reference counter for events
Date: Thu, 22 Aug 2013 16:13:25 +0200
Message-Id: <1377180807-12758-11-git-send-email-rric@kernel.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1377180807-12758-1-git-send-email-rric@kernel.org>
References: <1377180807-12758-1-git-send-email-rric@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robert Richter <robert.richter@linaro.org>

We need this later for proper event removal.

Signed-off-by: Robert Richter <robert.richter@linaro.org>
Signed-off-by: Robert Richter <rric@kernel.org>
---
 kernel/events/persistent.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/kernel/events/persistent.c b/kernel/events/persistent.c
index f23270b..70446ae 100644
--- a/kernel/events/persistent.c
+++ b/kernel/events/persistent.c
@@ -9,6 +9,7 @@
 #define CPU_BUFFER_NR_PAGES	((512 * 1024) / PAGE_SIZE)
 
 struct pevent {
+	atomic_t	refcount;
 	struct perf_pmu_events_attr sysfs;
 	char		*name;
 	int		id;
@@ -130,6 +131,7 @@ static int persistent_event_open(int cpu, struct pevent *pevent,
 	if (ret)
 		goto fail;
 
+	atomic_inc(&pevent->refcount);
 	atomic_inc(&event->mmap_count);
 
 	/* All workie, enable event now */
@@ -144,8 +146,11 @@ static int persistent_event_open(int cpu, struct pevent *pevent,
 static void persistent_event_close(int cpu, struct pevent *pevent)
 {
 	struct perf_event *event = pevent_del(pevent, cpu);
-	if (event)
+	if (event) {
+		/* Safe, the caller holds &pevent->refcount too. */
+		atomic_dec(&pevent->refcount);
 		persistent_event_release(event);
+	}
 }
 
 static int pevent_sysfs_register(struct pevent *event);
@@ -162,6 +167,8 @@ persistent_open(char *name, struct perf_event_attr *attr, int nr_pages)
 	if (!pevent)
 		return -ENOMEM;
 
+	atomic_set(&pevent->refcount, 1);
+
 	ret = get_event_id(pevent);
 	if (ret < 0)
 		goto fail;
@@ -187,21 +194,21 @@ persistent_open(char *name, struct perf_event_attr *attr, int nr_pages)
 	}
 
 	ret = pevent_sysfs_register(pevent);
-	if (ret)
-		goto fail;
-
-	return 0;
+	if (!ret)
+		goto out;
 fail:
 	for_each_possible_cpu(cpu)
 		persistent_event_close(cpu, pevent);
 
-	if (pevent->id)
-		put_event_id(pevent->id);
-	kfree(pevent->name);
-	kfree(pevent);
-
 	pr_err("%s: Error adding persistent event: %d\n",
 		__func__, ret);
+out:
+	if (atomic_dec_and_test(&pevent->refcount)) {
+		if (pevent->id)
+			put_event_id(pevent->id);
+		kfree(pevent->name);
+		kfree(pevent);
+	}
 
 	return ret;
 }
-- 
1.8.3.2

