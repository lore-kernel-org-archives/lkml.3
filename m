Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366AbaIRRIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 13:08:31 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:60700 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161AbaIRRI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 13:08:28 -0400
From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/2] perf kvm stat live: Enable events copying
Date: Thu, 18 Sep 2014 21:07:39 +0400
Message-Id: <1411060059-23589-3-git-send-email-yarygin@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1411060059-23589-1-git-send-email-yarygin@linux.vnet.ibm.com>
References: <1411060059-23589-1-git-send-email-yarygin@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091817-5024-0000-0000-00000159B2A7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Process of analyzing events caused by 2 functions: mmap_read() and
finished_round().
During mmap_read(), perf receives events from shared memory, queues
their pointers for further processing in finished_round() and notifies
the kernel that the events have been processed.
By the time when finished_round() is invoked, queued events can be
overwritten by the kernel, so the finished_round() occurs on potentially
corrupted memory.

Let's copy events when queueing.

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 tools/perf/builtin-kvm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index f5d3ae4..c5b6d1d 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1369,6 +1369,7 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
 		goto out;
 	}
 	kvm->session->evlist = kvm->evlist;
+	kvm->session->copy_on_queue = true;
 	perf_session__set_id_hdr_size(kvm->session);
 	machine__synthesize_threads(&kvm->session->machines.host, &kvm->opts.target,
 				    kvm->evlist->threads, false);
-- 
1.9.1

