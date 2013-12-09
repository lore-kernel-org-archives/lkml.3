Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760753Ab3LIISB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 03:18:01 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:30162 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab3LIIR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 03:17:57 -0500
X-IronPort-AV: E=Sophos;i="4.93,856,1378828800"; 
   d="scan'208";a="9221165"
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
To: acme@ghostprotocols.net, dsahern@gmail.com
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Subject: [PATCH] perf tools: Fix bug of perf kvm stat report.
Date: Mon, 9 Dec 2013 16:16:03 -0500
Message-Id: <1386623763-29014-1-git-send-email-yangds.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.8.2.1
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/09 16:17:35,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/12/09 16:17:40,
	Serialize complete at 2013/12/09 16:17:40
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we use perf kvm record-report, there is a bug in report subcommand.

Example:
	# perf kvm stat record -a sleep 1
	[ perf record: Woken up 1 times to write data ]
	[ perf record: Captured and wrote 0.678 MB perf.data.guest (~29641 samples) ]
	# perf kvm stat report
	failed to open perf.data: No such file or directory  (try 'perf record' first)
	Initializing perf session failed

The reason is that path of file is an 'input_name', which is an not declared
variable.

This patch change the path to 'kvm->file_name', then it works well.

Verification:
	# ./perf kvm stat record -a sleep 1
	[ perf record: Woken up 1 times to write data ]
	[ perf record: Captured and wrote 0.807 MB perf.data.guest (~35264 samples) ]
	# ./perf kvm stat report

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
---
 tools/perf/builtin-kvm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index f8bf5f2..650154c 100644
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
1.8.2.1

