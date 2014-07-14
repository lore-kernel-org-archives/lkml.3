Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbaGNP5n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:57:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755901AbaGNP5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:57:36 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] perf: Add vm_ops->name call for mmap event name retrieval
Date: Mon, 14 Jul 2014 17:57:19 +0200
Message-Id: <1405353439-14211-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch added another way to get mmap name:
  78d683e mm, fs: Add vm_ops->name as an alternative to arch_vma_name

The vdso vma mapping already switch to this and we no longer
get vdso name via arch_vma_name function. Adding this way to
the perf mmap event name retrieval code.

Caught this via perf test:

  $ sudo ./perf test -v 7
   7: Validate PERF_RECORD_* events & perf_sample fields     :
  --- start ---

SNIP

  PERF_RECORD_MMAP for [vdso] missing!
  test child finished with 255
  ---- end ----
  Validate PERF_RECORD_* events & perf_sample fields: FAILED!

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/events/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 67e3b9c..4799676 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5266,6 +5266,12 @@ static void perf_event_mmap_event(struct perf_mmap_event *mmap_event)
 
 		goto got_name;
 	} else {
+		if (vma->vm_ops && vma->vm_ops->name) {
+			name = (char *) vma->vm_ops->name(vma);
+			if (name)
+				goto cpy_name;
+		}
+
 		name = (char *)arch_vma_name(vma);
 		if (name)
 			goto cpy_name;
-- 
1.8.3.1

