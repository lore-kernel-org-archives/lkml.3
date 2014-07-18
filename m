Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965170AbaGRE2U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 00:28:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33403 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933369AbaGRE2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 00:28:13 -0400
Date: Thu, 17 Jul 2014 21:27:20 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-418029b7324f8b90ac1dfbc8a44555d6905be761@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1405495184-20441-3-git-send-email-adrian.hunter@intel.com>
References: <1405495184-20441-3-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf machine: Fix leak of 'struct thread'
  on error path
Git-Commit-ID: 418029b7324f8b90ac1dfbc8a44555d6905be761
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

Commit-ID:  418029b7324f8b90ac1dfbc8a44555d6905be761
Gitweb:     http://git.kernel.org/tip/418029b7324f8b90ac1dfbc8a44555d6905be761
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Wed, 16 Jul 2014 10:19:44 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 17 Jul 2014 10:34:07 -0300

perf machine: Fix leak of 'struct thread' on error path

__machine__findnew_thread() creates a 'struct thread' but does not free
it on the error path. Fix it.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1405495184-20441-3-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 5484fa4..93c8b6f 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -370,8 +370,10 @@ static struct thread *__machine__findnew_thread(struct machine *machine,
 		 * within thread__init_map_groups to find the thread
 		 * leader and that would screwed the rb tree.
 		 */
-		if (thread__init_map_groups(th, machine))
+		if (thread__init_map_groups(th, machine)) {
+			thread__delete(th);
 			return NULL;
+		}
 	}
 
 	return th;
