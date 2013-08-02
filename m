Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755066Ab3HBQaH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 12:30:07 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:33696 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab3HBQaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 12:30:04 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/3] perf: Rollback callchain buffer refcount under the callchain mutex
Date: Fri,  2 Aug 2013 18:29:54 +0200
Message-Id: <1375460996-16329-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1375460996-16329-1-git-send-email-fweisbec@gmail.com>
References: <1375460996-16329-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we fail to allocate the callchain buffers, we rollback the refcount
we did and return from get_callchain_buffers().

However we take the refcount and allocate under the callchain lock
but the rollback is done outside the lock.

As a result, while we rollback, some concurrent callchain user may
call get_callchain_buffers(), see the non-zero refcount and give up
because the buffers are NULL without itself retrying the allocation.

The consequences aren't that bad but that behaviour looks weird enough and
it's better to give their chances to the following callchain users where
we failed.

Reported-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
---
 kernel/events/callchain.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

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
 
-- 
1.7.5.4

