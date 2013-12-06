Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab3LFIfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 03:35:20 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53760 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753065Ab3LFIfR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 03:35:17 -0500
X-IronPort-AV: E=Sophos;i="4.93,839,1378828800"; 
   d="scan'208";a="9205455"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH] perf tools: Fix bug for perf kvm report without guestmount.
Date: Fri, 6 Dec 2013 16:33:08 -0500
Message-Id: <1386365588-13046-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/06 16:34:40,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/06 16:34:41,
	Serialize complete at 2013/12/06 16:34:41
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, if we use perf kvm --guestkallsyms --guestmodules report,
we can not get the perf information from perf data file. The all sample
are shown as unknown.

Reproducing steps:
	# perf kvm --guestkallsyms /tmp/kallsyms --guestmodules /tmp/modules record -a sleep 1
	[ perf record: Woken up 1 times to write data ]
	[ perf record: Captured and wrote 0.624 MB perf.data.guest (~27260 samples) ]
	# perf kvm --guestkallsyms /tmp/kallsyms --guestmodules /tmp/modules report |grep %
	   100.00%  [guest/6471]  [unknown]         [g] 0xffffffff8164f330

This bug is caused when delivery sample. We use perf_session__find_machine_for_cpumode() to find
the machine, and it call perf_session__findnew_machine(). Then we will delivery the sample to a
new machine without kernel mapped.

This patch changes perf_session__findnew_machine() to perf_session__find_machine(), so the sample
will be deliveried to default guest machine if there is no machine specified for it.

Verify steps:
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
---
 tools/perf/util/session.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 8a7da6f..1770f2f 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -851,6 +851,7 @@ static struct machine *
 					       struct perf_sample *sample)
 {
 	const u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+	struct machine *machine;
 
 	if (perf_guest &&
 	    ((cpumode == PERF_RECORD_MISC_GUEST_KERNEL) ||
@@ -863,7 +864,11 @@ static struct machine *
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
-- 
1.8.2.1

