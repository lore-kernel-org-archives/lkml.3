Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756842Ab3CRVQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:16:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46100 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932338Ab3CRVKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:10:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 24/40] perf,x86: fix link failure for non-Intel configs
Date: Mon, 18 Mar 2013 14:11:02 -0700
Message-Id: <20130318211017.988312050@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318211016.254453918@linuxfoundation.org>
References: <20130318211016.254453918@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1153,7 +1153,6 @@ extern void perf_swevent_put_recursion_c
 extern void perf_event_enable(struct perf_event *event);
 extern void perf_event_disable(struct perf_event *event);
 extern void perf_event_task_tick(void);
-extern void perf_restore_debug_store(void);
 #else
 static inline void
 perf_event_task_sched_in(struct task_struct *task)			{ }
@@ -1188,6 +1187,11 @@ static inline void perf_swevent_put_recu
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
 


