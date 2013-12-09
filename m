Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932988Ab3LIThf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:37:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54947 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760467Ab3LIThU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:37:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 11/21] perf kvm: Fix bug in 'stat report'
Date: Mon,  9 Dec 2013 16:37:00 -0300
Message-Id: <1386617830-18926-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386617830-18926-1-git-send-email-acme@infradead.org>
References: <1386617830-18926-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

When we use perf kvm record-report, there is a bug in report subcommand.

Example:
	# perf kvm stat record -a sleep 1
	[ perf record: Woken up 1 times to write data ]
	[ perf record: Captured and wrote 0.678 MB perf.data.guest (~29641 samples) ]
	# perf kvm stat report
	failed to open perf.data: No such file or directory  (try 'perf record' first)
	Initializing perf session failed

This bug was introduced by f5fc14124.

+       struct perf_data_file file = {
+               .path = input_name,
+               .mode = PERF_DATA_MODE_READ,
+       };

        kvm->tool = eops;
-       kvm->session = perf_session__new(kvm->file_name, O_RDONLY, 0, false,
-                                        &kvm->tool);
+       kvm->session = perf_session__new(&file, false, &kvm->tool);

It changed the path from kvm->file_name to input_name, this patch change the path back to
'kvm->file_name', then it works well.

Verification:
	# perf kvm stat record -a sleep 1
	[ perf record: Woken up 1 times to write data ]
	[ perf record: Captured and wrote 0.807 MB perf.data.guest (~35264 samples) ]
	# perf kvm stat report

	Analyze events for all VCPUs:

		     VM-EXIT    Samples  Samples%     Time%   Min Time   Max Time         Avg time

	       EPT_VIOLATION        200    32.79%     1.25%        0us    12064us     62.35us ( +-  96.74% )
	       EPT_MISCONFIG        134    21.97%     0.21%        0us       35us     15.25us ( +-   4.14% )
	       EXCEPTION_NMI         96    15.74%     0.02%        0us       11us      1.95us ( +-   9.81% )
		 APIC_ACCESS         79    12.95%     0.02%        0us       13us      2.94us ( +-  11.20% )
			 HLT         65    10.66%    98.47%        0us    16706us  15084.86us ( +-   1.89% )
	      IO_INSTRUCTION         27     4.43%     0.02%        0us       29us      6.42us ( +-  15.53% )
	  EXTERNAL_INTERRUPT          5     0.82%     0.01%        0us       77us     23.65us ( +-  57.90% )
	 TPR_BELOW_THRESHOLD          4     0.66%     0.00%        0us        1us      1.22us ( +-   4.36% )

	Total Samples:610, Total events handled time:995745.54us.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Link: http://lkml.kernel.org/r/1386632823-17539-1-git-send-email-yangds.fnst@cn.fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index d9cc0e3f284f..c2e5d56a291d 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1232,7 +1232,7 @@ static int read_events(struct perf_kvm_stat *kvm)
 		.ordered_samples	= true,
 	};
 	struct perf_data_file file = {
-		.path = input_name,
+		.path = kvm->file_name,
 		.mode = PERF_DATA_MODE_READ,
 	};
 
-- 
1.8.1.4

