Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752029AbaALShM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:37:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45824 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315AbaALShJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:37:09 -0500
Date: Sun, 12 Jan 2014 10:36:45 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-ad85ace07a05062ef6b59c35a5e80b6eaee1eee6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, tglx@linutronix.de,
        yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de,
        yangds.fnst@cn.fujitsu.com
In-Reply-To: <1387564907-3045-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1387564907-3045-1-git-send-email-yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm: Fix kvm report without guestmount.
Git-Commit-ID: ad85ace07a05062ef6b59c35a5e80b6eaee1eee6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 12 Jan 2014 10:36:53 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ad85ace07a05062ef6b59c35a5e80b6eaee1eee6
Gitweb:     http://git.kernel.org/tip/ad85ace07a05062ef6b59c35a5e80b6eaee1eee6
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Fri, 20 Dec 2013 13:41:47 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 23 Dec 2013 16:49:48 -0300

perf kvm: Fix kvm report without guestmount.

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
Cc: stable@vger.kernel.org # 3.3+
Cc: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1387564907-3045-1-git-send-email-yangds.fnst@cn.fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index cbacaab..d3a857be 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -830,6 +830,7 @@ static struct machine *
 					       struct perf_sample *sample)
 {
 	const u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+	struct machine *machine;
 
 	if (perf_guest &&
 	    ((cpumode == PERF_RECORD_MISC_GUEST_KERNEL) ||
@@ -842,7 +843,11 @@ static struct machine *
 		else
 			pid = sample->pid;
 
-		return perf_session__findnew_machine(session, pid);
+		machine = perf_session__find_machine(session, pid);
+		if (!machine)
+			machine = perf_session__findnew_machine(session,
+						DEFAULT_GUEST_KERNEL_ID);
+		return machine;
 	}
 
 	return &session->machines.host;
