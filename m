Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab3EaLuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:50:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56969 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab3EaLub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:50:31 -0400
Date: Fri, 31 May 2013 04:49:54 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-6ca5f3081f903e2b25e58a061ddad486f846561e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        runzhen@linux.vnet.ibm.com, jolsa@redhat.com, fweisbec@gmail.com,
        xiaoguangrong@linux.vnet.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, runzhen@linux.vnet.ibm.com, fweisbec@gmail.com,
        xiaoguangrong@linux.vnet.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1369527896-3650-7-git-send-email-dsahern@gmail.com>
References: <1369527896-3650-7-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm: Handle realloc failures
Git-Commit-ID: 6ca5f3081f903e2b25e58a061ddad486f846561e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6ca5f3081f903e2b25e58a061ddad486f846561e
Gitweb:     http://git.kernel.org/tip/6ca5f3081f903e2b25e58a061ddad486f846561e
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sat, 25 May 2013 18:24:46 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 28 May 2013 16:24:04 +0300

perf kvm: Handle realloc failures

Save previous pointer and free on failure.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1369527896-3650-7-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 533501e..24b78ae 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -328,6 +328,7 @@ static int kvm_events_hash_fn(u64 key)
 static bool kvm_event_expand(struct kvm_event *event, int vcpu_id)
 {
 	int old_max_vcpu = event->max_vcpu;
+	void *prev;
 
 	if (vcpu_id < event->max_vcpu)
 		return true;
@@ -335,9 +336,11 @@ static bool kvm_event_expand(struct kvm_event *event, int vcpu_id)
 	while (event->max_vcpu <= vcpu_id)
 		event->max_vcpu += DEFAULT_VCPU_NUM;
 
+	prev = event->vcpu;
 	event->vcpu = realloc(event->vcpu,
 			      event->max_vcpu * sizeof(*event->vcpu));
 	if (!event->vcpu) {
+		free(prev);
 		pr_err("Not enough memory\n");
 		return false;
 	}
