Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab3CYBO6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:14:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33755 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755017Ab3CYBO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:14:56 -0400
Message-Id: <20130325010524.703221727@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:05:28 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 004/104] perf,x86: fix link failure for non-Intel configs
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rientjes <rientjes@google.com>

commit 6c4d3bc99b3341067775efd4d9d13cc8e655fd7c upstream.

Commit 1d9d8639c063 ("perf,x86: fix kernel crash with PEBS/BTS after
suspend/resume") introduces a link failure since
perf_restore_debug_store() is only defined for CONFIG_CPU_SUP_INTEL:

	arch/x86/power/built-in.o: In function `restore_processor_state':
	(.text+0x45c): undefined reference to `perf_restore_debug_store'

Fix it by defining the dummy function appropriately.

Signed-off-by: David Rientjes <rientjes@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/perf_event.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1146,7 +1146,6 @@ extern void perf_swevent_put_recursion_c
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern void perf_event_task_tick(void);
-extern void perf_restore_debug_store(void);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *prev,
@@ -1185,6 +1184,11 @@ static inline void perf_swevent_put_recu
 static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }
 static inline void perf_event_task_tick(void)				{ }
+#endif
+
+#if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
+extern void perf_restore_debug_store(void);
+#else
 static inline void perf_restore_debug_store(void)			{ }
 #endif
 


