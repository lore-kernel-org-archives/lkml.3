Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab3CQWtQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 18:49:16 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:59523 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755847Ab3CQWtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 18:49:13 -0400
Date: Sun, 17 Mar 2013 15:49:10 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Stephane Eranian <eranian@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
cc: peterz@infradead.org, Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
        Andrew Morton <akpm@linux-foundation.org>, acme@redhat.com,
        jolsa@redhat.com, Andi Kleen <ak@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [patch for-] perf,x86: fix link failure for non-Intel configs
In-Reply-To: <20130315132607.GA4565@quad>
Message-ID: <alpine.DEB.2.02.1303171544030.368@chino.kir.corp.google.com>
References: <20130315132607.GA4565@quad>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1d9d8639c063 ("perf,x86: fix kernel crash with PEBS/BTS after 
suspend/resume") introduces a link failure since 
perf_restore_debug_store() is only defined for CONFIG_CPU_SUP_INTEL:

	arch/x86/power/built-in.o: In function `restore_processor_state':
	(.text+0x45c): undefined reference to `perf_restore_debug_store'

Fix it by defining the dummy function appropriately.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/perf_event.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -758,7 +758,6 @@ extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern int __perf_event_disable(void *info);
 extern void perf_event_task_tick(void);
-extern void perf_restore_debug_store(void);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *prev,
@@ -798,6 +797,11 @@ static inline void perf_event_enable(struct perf_event *event)		{ }
 static inline void perf_event_disable(struct perf_event *event)		{ }
 static inline int __perf_event_disable(void *info)			{ return -1; }
 static inline void perf_event_task_tick(void)				{ }
+#endif
+
+#if defined(CONFIG_PERF_EVENTS) && defined(CONFIG_CPU_SUP_INTEL)
+extern void perf_restore_debug_store(void);
+#else
 static inline void perf_restore_debug_store(void)			{ }
 #endif
 
