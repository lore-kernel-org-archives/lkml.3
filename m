Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932721AbaHVQa3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:30:29 -0400
Received: from mail.kernel.org ([198.145.19.201]:33799 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932149AbaHVQaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:30:25 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Joe Mario <jmario@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/16] perf machine: Fallback to MAP__FUNCTION if daddr maps are NULL
Date: Fri, 22 Aug 2014 13:29:23 -0300
Message-Id: <1408724968-3441-12-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1408724968-3441-1-git-send-email-acme@kernel.org>
References: <1408724968-3441-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Don Zickus <dzickus@redhat.com>

As we run "perf c2c" on more applications, we noticed we're missing
significant samples from a common customer's application.  Looking at
the /proc/<pid>/maps file for the app, we see "rwxs" and "rwxp"
permissions on many of the shared memory & heap regions, and on all the
thread stacks.

Because those regions have the "x" bit set, perf marks them with a
MAP_FUNCTION type.  Hence ip_resolve_data() never finds load or store
events coming from them.

We fixed this by re-calling thread__find_addr_location with
MAP__FUNCTION in the case where map is NULL as a last ditch effort to
map the sample before giving up and dropping it.

Reported-by: Joe Mario <jmario@redhat.com>
Tested-by: Joe Mario <jmario@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Joe Mario <jmario@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1408591511-57884-1-git-send-email-dzickus@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index e00daf0d2bde..b2ec38bf211e 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1314,6 +1314,16 @@ static void ip__resolve_data(struct machine *machine, struct thread *thread,
 
 	thread__find_addr_location(thread, machine, m, MAP__VARIABLE, addr,
 				   &al);
+	if (al.map == NULL) {
+		/*
+		 * some shared data regions have execute bit set which puts
+		 * their mapping in the MAP__FUNCTION type array.
+		 * Check there as a fallback option before dropping the sample.
+		 */
+		thread__find_addr_location(thread, machine, m, MAP__FUNCTION, addr,
+					   &al);
+	}
+
 	ams->addr = addr;
 	ams->al_addr = al.addr;
 	ams->sym = al.sym;
-- 
1.9.3

