Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152Ab3ILLNF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 07:13:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34442 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab3ILLLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 07:11:43 -0400
Date: Thu, 12 Sep 2013 04:11:06 -0700
From: tip-bot for Arnaldo Carvalho de Melo <tipbot@zytor.com>
Message-ID: <tip-heeuv986b8ha7whqg4o3he7c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, eranian@google.com,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, efault@gmx.de,
        peterz@infradead.org, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        paulus@samba.org, linux-kernel@vger.kernel.org, peterz@infradead.org,
        efault@gmx.de, jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix up MMAP2 buffer space reservation
Git-Commit-ID: d008d5258e9c1a1b7ee6547b8d444323aef331b3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 12 Sep 2013 04:11:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d008d5258e9c1a1b7ee6547b8d444323aef331b3
Gitweb:     http://git.kernel.org/tip/d008d5258e9c1a1b7ee6547b8d444323aef331b3
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 10 Sep 2013 10:24:05 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 11 Sep 2013 10:11:46 -0300

perf: Fix up MMAP2 buffer space reservation

The ino_generation field was added in the PERF_RECORD_MMAP2 record in
the 13d7a24 cset but no space for it was allocated, corrupting the
PERF_FORMAT_{TIME,CPU,TID,etc} area (sample_type/sample_id_all), fix it.

Detected with one of the regression tests done by 'perf test':

  [root@sandy ~]# perf test -v 7
   7: Validate PERF_RECORD_* events & perf_sample fields     :
  --- start ---
  61315294449606 0 PERF_RECORD_SAMPLE
  61315294453161 0 PERF_RECORD_SAMPLE
  61315294454441 0 PERF_RECORD_SAMPLE
  61315294455709 0 PERF_RECORD_SAMPLE
  61315295600899 0 PERF_RECORD_COMM: sleep:6500
  27917287430500 342521613 PERF_RECORD_MMAP2 6500/6500: [0x400000(0x7000) @ 0 00:1d 311442 9016]: /usr/bin/sleep
  MMAP2 going backwards in time, prev=61315295600899, curr=27917287430500
  MMAP2 with unexpected cpu, expected 0, got 342521613
  MMAP2 with unexpected pid, expected 6500, got 1701606191
  MMAP2 with unexpected tid, expected 6500, got 28773
  27917287430500 342561333 PERF_RECORD_MMAP2 6500/6500: [0x3b7e000000(0x223000) @ 0 00:1d 309186 9016]: /usr/lib64/ld-2.16.so
  MMAP2 with unexpected cpu, expected 0, got 342561333
  MMAP2 with unexpected pid, expected 6500, got 1932408369
  MMAP2 with unexpected tid, expected 6500, got 111
  27917287430500 342600095 PERF_RECORD_MMAP2 6500/6500: [0x7fffbd7dc000(0x1000) @ 0x7fffbd7dc000 00:00 0 0]: [vdso]
  MMAP2 with unexpected cpu, expected 0, got 342600095
  MMAP2 with unexpected pid, expected 6500, got 1935963739
  MMAP2 with unexpected tid, expected 6500, got 23919
  27917287430500 342882834 PERF_RECORD_MMAP2 6500/6500: [0x3b7e400000(0x3b8000) @ 0 00:1d 309187 9016]: /usr/lib64/libc-2.16.so
  MMAP2 with unexpected cpu, expected 0, got 342882834
  MMAP2 with unexpected pid, expected 6500, got 909192754
  MMAP2 with unexpected tid, expected 6500, got 7303982
  61316297195411 0 PERF_RECORD_EXIT(6500:6500):(6500:6500)
  ---- end ----
  Validate PERF_RECORD_* events & perf_sample fields: FAILED!
  [root@sandy ~]#

After this patch:

  [root@sandy ~]# perf test 7
   7: Validate PERF_RECORD_* events & perf_sample fields     : Ok
  [root@sandy ~]#

Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Stephane Eranian <eranian@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-heeuv986b8ha7whqg4o3he7c@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 kernel/events/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2207efc..dd236b6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5039,6 +5039,7 @@ static void perf_event_mmap_output(struct perf_event *event,
 		mmap_event->event_id.header.size += sizeof(mmap_event->maj);
 		mmap_event->event_id.header.size += sizeof(mmap_event->min);
 		mmap_event->event_id.header.size += sizeof(mmap_event->ino);
+		mmap_event->event_id.header.size += sizeof(mmap_event->ino_generation);
 	}
 
 	perf_event_header__init_id(&mmap_event->event_id.header, &sample, event);
