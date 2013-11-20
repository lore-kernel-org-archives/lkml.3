Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab3KTNzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 08:55:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35873 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab3KTNza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 08:55:30 -0500
Date: Wed, 20 Nov 2013 05:55:12 -0800
From: tip-bot for Frederic Weisbecker <tipbot@zytor.com>
Message-ID: <tip-a5285ad9e30fd90b88a11adcab97bd4c3ffe44eb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <20131116010207.GA18855@localhost.localdomain>
References: <20131116010207.GA18855@localhost.localdomain>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools: Tag thread comm as overriden
Git-Commit-ID: a5285ad9e30fd90b88a11adcab97bd4c3ffe44eb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 20 Nov 2013 05:55:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5285ad9e30fd90b88a11adcab97bd4c3ffe44eb
Gitweb:     http://git.kernel.org/tip/a5285ad9e30fd90b88a11adcab97bd4c3ffe44eb
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Sat, 16 Nov 2013 02:02:09 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 19 Nov 2013 10:33:29 -0300

perf tools: Tag thread comm as overriden

The problem is that when a thread overrides its default ":%pid" comm, we
forget to tag the thread comm as overriden. Hence, this overriden comm
is not inherited on future forks. Fix it.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Tested-by: David Ahern <dsahern@gmail.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/20131116010207.GA18855@localhost.localdomain
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/thread.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index cd8e2f5..49eaf1d 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -70,14 +70,13 @@ int thread__set_comm(struct thread *thread, const char *str, u64 timestamp)
 	/* Override latest entry if it had no specific time coverage */
 	if (!curr->start) {
 		comm__override(curr, str, timestamp);
-		return 0;
+	} else {
+		new = comm__new(str, timestamp);
+		if (!new)
+			return -ENOMEM;
+		list_add(&new->list, &thread->comm_list);
 	}
 
-	new = comm__new(str, timestamp);
-	if (!new)
-		return -ENOMEM;
-
-	list_add(&new->list, &thread->comm_list);
 	thread->comm_set = true;
 
 	return 0;
