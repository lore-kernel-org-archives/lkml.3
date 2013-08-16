Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755538Ab3HPSsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 14:48:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40413 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510Ab3HPSsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 14:48:10 -0400
Date: Fri, 16 Aug 2013 11:47:36 -0700
From: tip-bot for Frederic Weisbecker <tipbot@zytor.com>
Message-ID: <tip-fc3b86d673e41ac66b4ba5b75a90c2fcafb90089@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1375460996-16329-2-git-send-email-fweisbec@gmail.com>
References: <1375460996-16329-2-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Roll back callchain buffer refcount under the callchain mutex
Git-Commit-ID: fc3b86d673e41ac66b4ba5b75a90c2fcafb90089
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 16 Aug 2013 11:47:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc3b86d673e41ac66b4ba5b75a90c2fcafb90089
Gitweb:     http://git.kernel.org/tip/fc3b86d673e41ac66b4ba5b75a90c2fcafb90089
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Fri, 2 Aug 2013 18:29:54 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 16 Aug 2013 17:55:50 +0200

perf: Roll back callchain buffer refcount under the callchain mutex

When we fail to allocate the callchain buffers, we roll back the refcount
we did and return from get_callchain_buffers().

However we take the refcount and allocate under the callchain lock
but the rollback is done outside the lock.

As a result, while we roll back, some concurrent callchain user may
call get_callchain_buffers(), see the non-zero refcount and give up
because the buffers are NULL without itself retrying the allocation.

The consequences aren't that bad but that behaviour looks weird enough and
it's better to give their chances to the following callchain users where
we failed.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1375460996-16329-2-git-send-email-fweisbec@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/callchain.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index 76a8bc5..97b67df 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -116,10 +116,11 @@ int get_callchain_buffers(void)
 
 	err = alloc_callchain_buffers();
 exit:
-	mutex_unlock(&callchain_mutex);
 	if (err)
 		atomic_dec(&nr_callchain_events);
 
+	mutex_unlock(&callchain_mutex);
+
 	return err;
 }
 
