Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab3LSJ4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 04:56:53 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:6358 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752165Ab3LSJ4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 04:56:51 -0500
X-IronPort-AV: E=Sophos;i="4.95,512,1384272000"; 
   d="scan'208";a="9291078"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org, eranian@google.com, dsahern@gmail.com,
        adrian.hunter@intel.com, acme@ghostprotocols.net
Cc: mingo@redhat.com, paulus@samba.org, a.p.zijlstra@chello.nl,
        Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH 4/4] perf tools: Add support of user space symbols for guest in perf kvm record.
Date: Thu, 19 Dec 2013 17:54:54 -0500
Message-Id: <b046ea7233e8aa18918c5601a1eff32d17c975ae.1387493396.git.yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <cover.1387493396.git.yangds.fnst@cn.fujitsu.com>
References: <cover.1387493396.git.yangds.fnst@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/19 17:56:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/19 17:56:17,
	Serialize complete at 2013/12/19 17:56:17
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	# perf kvm --guestmount /tmp/guestmount/ record -a sleep 1
	[ perf record: Woken up 1 times to write data ]
	[ perf record: Captured and wrote 0.828 MB perf.data.guest (~36163 samples) ]

	# perf kvm --guestmount /tmp/guestmount/ report
	Samples: 4K of event 'cycles', Event count (approx.): 2662750816
	  8.67%  [guest/9217]  dd                            [u] 0x0000000000004e90
	  6.62%  [guest/9217]  [guest.kernel.kallsyms.9217]  [g] fget_light
	  6.17%  [guest/9217]  [guest.kernel.kallsyms.9217]  [g] system_call
	  5.97%  [guest/9217]  [guest.kernel.kallsyms.9217]  [g] __srcu_read_lock
	  5.53%  [guest/9217]  [guest.kernel.kallsyms.9217]  [g] __srcu_read_unlock
	  5.47%  [guest/9217]  [guest.kernel.kallsyms.9217]  [g] __audit_syscall_exit
	  5.38%  [guest/9217]  [guest.kernel.kallsyms.9217]  [g] fsnotify
	  5.32%  [guest/9217]  [guest.kernel.kallsyms.9217]  [g] system_call_after_swapgs
	  4.45%  [guest/9217]  libc-2.17.so                  [u] __GI___libc_write
	  4.15%  [guest/9217]  [guest.kernel.kallsyms.9217]  [g] sys_write
	  3.97%  [guest/9217]  [guest.kernel.kallsyms.9217]  [g] vfs_read
	  3.78%  [guest/9217]  libc-2.17.so                  [u] __GI___libc_read

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
---
 tools/perf/builtin-record.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index c1c1200..ac1e540 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -279,6 +279,9 @@ static void perf_event__synthesize_guest_os(struct machine *machine, void *data)
 {
 	int err;
 	struct perf_tool *tool = data;
+	struct perf_record *rec = container_of(tool, struct perf_record, tool);
+	struct perf_record_opts *opts = &rec->opts;
+	struct perf_evlist *evsel_list = rec->evlist;
 	/*
 	 *As for guest kernel when processing subcommand record&report,
 	 *we arrange module mmap prior to guest kernel mmap and trigger
@@ -305,6 +308,13 @@ static void perf_event__synthesize_guest_os(struct machine *machine, void *data)
 	if (err < 0)
 		pr_err("Couldn't record guest kernel [%d]'s reference"
 		       " relocation symbol.\n", machine->pid);
+
+	err = __machine__synthesize_threads(machine, tool, &opts->target, evsel_list->threads,
+					    process_synthesized_event, opts->sample_address);
+
+	if (err < 0)
+		pr_err("Couldn't record guest userspace [%d]'s reference"
+		       " relocation symbol.\n", machine->pid);
 }
 
 static struct perf_event_header finished_round_event = {
-- 
1.8.2.1

