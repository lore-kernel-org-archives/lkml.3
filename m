Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932189Ab3AXUTj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:19:39 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50161 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755879Ab3AXUIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:43 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 44/74] perf sort: Fix --sort pid output
Date: Thu, 24 Jan 2013 17:07:53 -0300
Message-Id: <1359058103-31645-45-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The "pid" sort key prints "Command: Pid" output but it's misaligned.
It's because of the offset of 6 was added to the column length during
the calculation in order to reserve an space for Pid part but it isn't
honored when printed.  The output before this patch was like this:

  # Overhead  Command:  Pid      Shared Object
  # ........  .............  .................
  #
      99.70%        noploop:17814  noploop
       0.29%        noploop:17814  [kernel.kallsyms]
       0.01%        noploop:17814  ld-2.15.so

Fix it by subtracting 6 for printing comm part.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1356599507-14226-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 3c2836e..8b6d70b 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -60,7 +60,7 @@ sort__thread_cmp(struct hist_entry *left, struct hist_entry *right)
 static int hist_entry__thread_snprintf(struct hist_entry *self, char *bf,
 				       size_t size, unsigned int width)
 {
-	return repsep_snprintf(bf, size, "%*s:%5d", width,
+	return repsep_snprintf(bf, size, "%*s:%5d", width - 6,
 			      self->thread->comm ?: "", self->thread->pid);
 }
 
-- 
1.8.1.1.361.gec3ae6e

