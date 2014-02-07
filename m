Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbaBGLtb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:49:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:41742 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaBGLt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:49:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 072/233] perf kvm: Fix kvm report without guestmount.
Date: Fri,  7 Feb 2014 11:44:51 +0000
Message-Id: <1391773652-25214-73-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

commit ad85ace07a05062ef6b59c35a5e80b6eaee1eee6 upstream.

Currently, if we use perf kvm --guestkallsyms --guestmodules report, we
can not get the perf information from perf data file. All sample are
shown as unknown.

Reproducing steps:
	# perf kvm --guestkallsyms /tmp/kallsyms --guestmodules /tmp/modules record -a sleep 1
	[ perf record: Woken up 1 times to write data ]
	[ perf record: Captured and wrote 0.624 MB perf.data.guest (~27260 samples) ]
	# perf kvm --guestkallsyms /tmp/kallsyms --guestmodules /tmp/modules report |grep %
	   100.00%  [guest/6471]  [unknown]         [g] 0xffffffff8164f330

This bug was introduced by 207b57926 (perf kvm: Fix regression with guest machine creation).
In original code, it uses perf_session__find_machine(), it means we deliver symbol to machine
which has the same pid, if no machine found, deliver it to *default* guest. But if we use
perf_session__findnew_machine() here, if no machine was found, new machine with pid will be built
and added. Then the default guest which with pid == 0 will never get a symbol.

And because the new machine initialized here has no kernel map created, the symbol delivered to
it will be marked as "unknown".

This patch here is to revert commit 207b57926 and fix the SEGFAULT bug in another way.

Verification steps:
	# ./perf kvm --guestkallsyms /home/kallsyms --guestmodules /home/modules record -a sleep 1
	[ perf record: Woken up 1 times to write data ]
	[ perf record: Captured and wrote 0.651 MB perf.data.guest (~28437 samples) ]
	# ./perf kvm --guestkallsyms /home/kallsyms --guestmodules /home/modules report |grep %
	    22.64%    :6471  [guest.kernel.kallsyms]  [g] update_rq_clock.part.70
	    19.99%    :6471  [guest.kernel.kallsyms]  [g] d_free
	    18.46%    :6471  [guest.kernel.kallsyms]  [g] bio_phys_segments
	    16.25%    :6471  [guest.kernel.kallsyms]  [g] dequeue_task
	    12.78%    :6471  [guest.kernel.kallsyms]  [g] __switch_to
	     7.91%    :6471  [guest.kernel.kallsyms]  [g] scheduler_tick
	     1.75%    :6471  [guest.kernel.kallsyms]  [g] native_apic_mem_write
	     0.21%    :6471  [guest.kernel.kallsyms]  [g] apic_timer_interrupt

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Acked-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1387564907-3045-1-git-send-email-yangds.fnst@cn.fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 tools/perf/util/session.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index cf1fe01..e392202 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -811,6 +811,7 @@ static struct machine *
 					       union perf_event *event)
 {
 	const u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+	struct machine *machine;
 
 	if (perf_guest &&
 	    ((cpumode == PERF_RECORD_MISC_GUEST_KERNEL) ||
@@ -822,7 +823,11 @@ static struct machine *
 		else
 			pid = event->ip.pid;
 
-		return perf_session__findnew_machine(session, pid);
+		machine = perf_session__find_machine(session, pid);
+		if (!machine)
+			machine = perf_session__findnew_machine(session,
+						DEFAULT_GUEST_KERNEL_ID);
+		return machine;
 	}
 
 	return &session->machines.host;
-- 
1.8.3.2

