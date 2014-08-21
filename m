Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbaHUDZX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 23:25:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12564 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753676AbaHUDZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 23:25:19 -0400
From: Don Zickus <dzickus@redhat.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, eranian@google.com, jmario@redhat.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH] perf: Fallback to MAP__FUNCTION if daddr maps are NULL
Date: Wed, 20 Aug 2014 23:25:11 -0400
Message-Id: <1408591511-57884-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we run "perf c2c" on more applications, we noticed we're missing significant
samples from a common customer's application.  Looking at the
/proc/<pid>/maps file for the app, we see "rwxs" and "rwxp" permissions on many
of the shared memory & heap regions, and on all the thread stacks.

Because those regions have the "x" bit set, perf marks them with a MAP_FUNCTION
type.  Hence ip_resolve_data() never finds load or store events coming from
them.

We fixed this by re-calling thread__find_addr_location with MAP__FUNCTION in
the case where map is NULL as a last ditch effort to map the sample before
giving up and dropping it.

Reported-by: Joe Mario <jmario@redhat.com>
Tested-by: Joe Mario <jmario@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/util/machine.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 0e5fea9..e62bd87 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -1241,6 +1241,16 @@ static void ip__resolve_data(struct machine *machine, struct thread *thread,
 
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
1.7.1

