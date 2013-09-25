Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602Ab3IYMv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:51:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755522Ab3IYMvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:51:25 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 09/21] perf: Account toggle masters for toggled event
Date: Wed, 25 Sep 2013 14:50:35 +0200
Message-Id: <1380113447-17144-10-git-send-email-jolsa@redhat.com>
In-Reply-To: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Keep track of toggle events within the toggled event.
It'll be handy for toggle inherit support.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 include/linux/perf_event.h | 1 +
 kernel/events/core.c       | 9 ++++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 6ede25c..801ff22 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -423,6 +423,7 @@ struct perf_event {
 	struct perf_event		*toggled_event;
 	enum perf_event_toggle_flag	toggle_flag;
 	int				paused;
+	atomic_t			toggled_cnt;
 #endif /* CONFIG_PERF_EVENTS */
 };
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index f5f00a6..7df7a21 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1372,6 +1372,7 @@ static void __perf_event_toggle_detach(struct perf_event *event)
 	event->overflow_handler = NULL;
 	event->toggled_event    = NULL;
 
+	atomic_dec(&toggled_event->toggled_cnt);
 	put_event(toggled_event);
 }
 
@@ -7064,6 +7065,8 @@ static int perf_event_set_toggle_fd(struct perf_event *event, u64 __user *arg)
 	err = perf_event_set_toggle(event, toggled_event, event->ctx, flag);
 	if (err)
 		put_event(toggled_event);
+	else
+		atomic_inc(&toggled_event->toggled_cnt);
 
 	fdput(toggled_fd);
 	return err;
@@ -7251,6 +7254,8 @@ SYSCALL_DEFINE5(perf_event_open,
 		if (!atomic_long_inc_not_zero(&toggled_event->refcount))
 			goto err_context;
 
+		atomic_inc(&toggled_event->toggled_cnt);
+
 		err = perf_event_set_toggle(event, toggled_event, ctx, flags);
 		if (err)
 			goto err_toggle;
@@ -7328,8 +7333,10 @@ SYSCALL_DEFINE5(perf_event_open,
 	return event_fd;
 
 err_toggle:
-	if (toggled_event)
+	if (toggled_event) {
+		atomic_dec(&toggled_event->toggled_cnt);
 		put_event(toggled_event);
+	}
 err_context:
 	perf_unpin_context(ctx);
 	put_ctx(ctx);
-- 
1.7.11.7

