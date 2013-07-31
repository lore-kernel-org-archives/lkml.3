Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416Ab3GaI52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 04:57:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41781 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759282Ab3GaI5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 04:57:22 -0400
Date: Wed, 31 Jul 2013 01:56:48 -0700
From: tip-bot for Frederic Weisbecker <tipbot@zytor.com>
Message-ID: <tip-ba8a75c16e292c0a3a87406a77508cbbc6cf4ee2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1374539466-4799-7-git-send-email-fweisbec@gmail.com>
References: <1374539466-4799-7-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Account freq events per cpu
Git-Commit-ID: ba8a75c16e292c0a3a87406a77508cbbc6cf4ee2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 31 Jul 2013 01:56:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ba8a75c16e292c0a3a87406a77508cbbc6cf4ee2
Gitweb:     http://git.kernel.org/tip/ba8a75c16e292c0a3a87406a77508cbbc6cf4ee2
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 23 Jul 2013 02:31:04 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Jul 2013 22:29:14 +0200

perf: Account freq events per cpu

This is going to be used by the full dynticks subsystem
as a finer-grained information to know when to keep and
when to stop the tick.

Original-patch-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1374539466-4799-7-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 63bdec9..3fe385a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -141,6 +141,7 @@ enum event_type_t {
 struct static_key_deferred perf_sched_events __read_mostly;
 static DEFINE_PER_CPU(atomic_t, perf_cgroup_events);
 static DEFINE_PER_CPU(atomic_t, perf_branch_stack_events);
+static DEFINE_PER_CPU(atomic_t, perf_freq_events);
 
 static atomic_t nr_mmap_events __read_mostly;
 static atomic_t nr_comm_events __read_mostly;
@@ -3139,6 +3140,9 @@ static void unaccount_event_cpu(struct perf_event *event, int cpu)
 	}
 	if (is_cgroup_event(event))
 		atomic_dec(&per_cpu(perf_cgroup_events, cpu));
+
+	if (event->attr.freq)
+		atomic_dec(&per_cpu(perf_freq_events, cpu));
 }
 
 static void unaccount_event(struct perf_event *event)
@@ -6474,6 +6478,9 @@ static void account_event_cpu(struct perf_event *event, int cpu)
 	}
 	if (is_cgroup_event(event))
 		atomic_inc(&per_cpu(perf_cgroup_events, cpu));
+
+	if (event->attr.freq)
+		atomic_inc(&per_cpu(perf_freq_events, cpu));
 }
 
 static void account_event(struct perf_event *event)
