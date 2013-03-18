Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756972Ab3CRV3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:29:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45882 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab3CRVH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:07:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 26/48] perf,x86: fix link failure for non-Intel configs
Date: Mon, 18 Mar 2013 14:08:34 -0700
Message-Id: <20130318210812.104886359@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210810.247845918@linuxfoundation.org>
References: <20130318210810.247845918@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/perf_event.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1290,7 +1290,6 @@ extern void perf_swevent_put_recursion_c
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern void perf_event_task_tick(void);
-extern void perf_restore_debug_store(void);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *prev,
@@ -1329,6 +1328,11 @@ static inline void perf_swevent_put_recu
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
 


