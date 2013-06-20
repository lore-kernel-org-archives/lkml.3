Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758221Ab3FTQTo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 12:19:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48310 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758092Ab3FTQTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 12:19:41 -0400
Date: Thu, 20 Jun 2013 09:19:22 -0700
From: tip-bot for Oleg Nesterov <tipbot@zytor.com>
Message-ID: <tip-e12cbc10cb27fcbe51b5f68e2015138dc451a2eb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        fweisbec@gmail.com, vincent.weaver@maine.edu, oleg@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        vincent.weaver@maine.edu, fweisbec@gmail.com, tglx@linutronix.de,
        oleg@redhat.com
In-Reply-To: <20130620155018.GA6347@redhat.com>
References: <20130620155018.GA6347@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] hw_breakpoint:
  Simplify *register_wide_hw_breakpoint()
Git-Commit-ID: e12cbc10cb27fcbe51b5f68e2015138dc451a2eb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 20 Jun 2013 09:19:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e12cbc10cb27fcbe51b5f68e2015138dc451a2eb
Gitweb:     http://git.kernel.org/tip/e12cbc10cb27fcbe51b5f68e2015138dc451a2eb
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Thu, 20 Jun 2013 17:50:18 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 20 Jun 2013 17:58:57 +0200

hw_breakpoint: Simplify *register_wide_hw_breakpoint()

1. register_wide_hw_breakpoint() can use unregister_ if failure,
   no need to duplicate the code.

2. "struct perf_event **pevent" adds the unnecesary lever of
   indirection and complication, use per_cpu(*cpu_events, cpu).

Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/20130620155018.GA6347@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/hw_breakpoint.c | 34 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
index 9c71445..38418f7 100644
--- a/kernel/events/hw_breakpoint.c
+++ b/kernel/events/hw_breakpoint.c
@@ -497,8 +497,8 @@ register_wide_hw_breakpoint(struct perf_event_attr *attr,
 			    perf_overflow_handler_t triggered,
 			    void *context)
 {
-	struct perf_event * __percpu *cpu_events, **pevent, *bp;
-	long err;
+	struct perf_event * __percpu *cpu_events, *bp;
+	long err = 0;
 	int cpu;
 
 	cpu_events = alloc_percpu(typeof(*cpu_events));
@@ -507,31 +507,21 @@ register_wide_hw_breakpoint(struct perf_event_attr *attr,
 
 	get_online_cpus();
 	for_each_online_cpu(cpu) {
-		pevent = per_cpu_ptr(cpu_events, cpu);
 		bp = perf_event_create_kernel_counter(attr, cpu, NULL,
 						      triggered, context);
-
-		*pevent = bp;
-
 		if (IS_ERR(bp)) {
 			err = PTR_ERR(bp);
-			goto fail;
+			break;
 		}
-	}
-	put_online_cpus();
-
-	return cpu_events;
 
-fail:
-	for_each_online_cpu(cpu) {
-		pevent = per_cpu_ptr(cpu_events, cpu);
-		if (IS_ERR(*pevent))
-			break;
-		unregister_hw_breakpoint(*pevent);
+		per_cpu(*cpu_events, cpu) = bp;
 	}
 	put_online_cpus();
 
-	free_percpu(cpu_events);
+	if (likely(!err))
+		return cpu_events;
+
+	unregister_wide_hw_breakpoint(cpu_events);
 	return (void __percpu __force *)ERR_PTR(err);
 }
 EXPORT_SYMBOL_GPL(register_wide_hw_breakpoint);
@@ -543,12 +533,10 @@ EXPORT_SYMBOL_GPL(register_wide_hw_breakpoint);
 void unregister_wide_hw_breakpoint(struct perf_event * __percpu *cpu_events)
 {
 	int cpu;
-	struct perf_event **pevent;
 
-	for_each_possible_cpu(cpu) {
-		pevent = per_cpu_ptr(cpu_events, cpu);
-		unregister_hw_breakpoint(*pevent);
-	}
+	for_each_possible_cpu(cpu)
+		unregister_hw_breakpoint(per_cpu(*cpu_events, cpu));
+
 	free_percpu(cpu_events);
 }
 EXPORT_SYMBOL_GPL(unregister_wide_hw_breakpoint);
