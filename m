Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab3AXSkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:40:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60911 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab3AXSkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:40:23 -0500
Date: Thu, 24 Jan 2013 10:39:36 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-03cd20949964f5cda600a56e12ffac39dfec4cb0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, andi@firstfloor.org, peterz@infradead.org,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de,
        feng.tang@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, andi@firstfloor.org, peterz@infradead.org,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de,
        feng.tang@intel.com
In-Reply-To: <1353472999-23042-1-git-send-email-namhyung@kernel.org>
References: <1353472999-23042-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf session:
  Free environment information when deleting session
Git-Commit-ID: 03cd20949964f5cda600a56e12ffac39dfec4cb0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 24 Jan 2013 10:39:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  03cd20949964f5cda600a56e12ffac39dfec4cb0
Gitweb:     http://git.kernel.org/tip/03cd20949964f5cda600a56e12ffac39dfec4cb0
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 21 Nov 2012 13:43:19 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 9 Dec 2012 08:46:05 -0300

perf session: Free environment information when deleting session

The perf session environment information was saved (so allocated) during
perf_session__open, but was not freed.  As free(3) handles NULL pointer
input properly it won't cause a issue for writing modes - e.g. perf
record

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Feng Tang <feng.tang@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1353472999-23042-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index ce6f511..d5fb607 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -204,11 +204,28 @@ static void perf_session__delete_threads(struct perf_session *session)
 	machine__delete_threads(&session->host_machine);
 }
 
+static void perf_session_env__delete(struct perf_session_env *env)
+{
+	free(env->hostname);
+	free(env->os_release);
+	free(env->version);
+	free(env->arch);
+	free(env->cpu_desc);
+	free(env->cpuid);
+
+	free(env->cmdline);
+	free(env->sibling_cores);
+	free(env->sibling_threads);
+	free(env->numa_nodes);
+	free(env->pmu_mappings);
+}
+
 void perf_session__delete(struct perf_session *self)
 {
 	perf_session__destroy_kernel_maps(self);
 	perf_session__delete_dead_threads(self);
 	perf_session__delete_threads(self);
+	perf_session_env__delete(&self->header.env);
 	machine__exit(&self->host_machine);
 	close(self->fd);
 	free(self);
