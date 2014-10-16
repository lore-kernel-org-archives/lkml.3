Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829AbaJPFZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 01:25:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33616 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaJPFZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 01:25:38 -0400
Date: Wed, 15 Oct 2014 22:25:12 -0700
From: tip-bot for Alexander Yarygin <tipbot@zytor.com>
Message-ID: <tip-673d659f5c5918b7ddbafebf1f129c9eb82973b4@git.kernel.org>
Cc: a.p.zijlstra@chello.nl, efault@gmx.de, jolsa@redhat.com, dsahern@gmail.com,
        yarygin@linux.vnet.ibm.com, eranian@google.com, mingo@kernel.org,
        namhyung.kim@lge.com, acme@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        tglx@linutronix.de, hpa@zytor.com, fweisbec@gmail.com
Reply-To: borntraeger@de.ibm.com, linux-kernel@vger.kernel.org,
        paulus@samba.org, acme@redhat.com, eranian@google.com,
        mingo@kernel.org, namhyung.kim@lge.com, efault@gmx.de,
        dsahern@gmail.com, a.p.zijlstra@chello.nl, jolsa@redhat.com,
        yarygin@linux.vnet.ibm.com, fweisbec@gmail.com, hpa@zytor.com,
        tglx@linutronix.de
In-Reply-To: <1412347212-28237-3-git-send-email-yarygin@linux.vnet.ibm.com>
References: <1412347212-28237-3-git-send-email-yarygin@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf kvm stat live: Enable events copying
Git-Commit-ID: 673d659f5c5918b7ddbafebf1f129c9eb82973b4
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

Commit-ID:  673d659f5c5918b7ddbafebf1f129c9eb82973b4
Gitweb:     http://git.kernel.org/tip/673d659f5c5918b7ddbafebf1f129c9eb82973b4
Author:     Alexander Yarygin <yarygin@linux.vnet.ibm.com>
AuthorDate: Fri, 3 Oct 2014 18:40:12 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 15 Oct 2014 17:39:03 -0300

perf kvm stat live: Enable events copying

Process of analyzing events caused by 2 functions: mmap_read() and
finished_round().

During mmap_read(), perf receives events from shared memory, queues
their pointers for further processing in finished_round() and notifies
the kernel that the events have been processed.

By the time when finished_round() is invoked, queued events can be
overwritten by the kernel, so the finished_round() occurs on potentially
corrupted memory.

Since there is no place where the event can be safely consumed, let's
copy events when queueing.

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1412347212-28237-3-git-send-email-yarygin@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index ef9fc15..b65eb050 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1358,6 +1358,7 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
 	}
 	kvm->session->evlist = kvm->evlist;
 	perf_session__set_id_hdr_size(kvm->session);
+	ordered_events__set_copy_on_queue(&kvm->session->ordered_events, true);
 	machine__synthesize_threads(&kvm->session->machines.host, &kvm->opts.target,
 				    kvm->evlist->threads, false);
 	err = kvm_live_open_events(kvm);
