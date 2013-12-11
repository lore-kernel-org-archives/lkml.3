Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab3LKLFn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:05:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60202 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab3LKLFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:05:37 -0500
Date: Wed, 11 Dec 2013 03:05:08 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-476b3a865f8a3734f74cf659cfa510856a105b1a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
In-Reply-To: <1386632823-17539-1-git-send-email-yangds.fnst@cn.fujitsu.com>
References: <1386632823-17539-1-git-send-email-yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm: Fix bug in 'stat report'
Git-Commit-ID: 476b3a865f8a3734f74cf659cfa510856a105b1a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 11 Dec 2013 03:05:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  476b3a865f8a3734f74cf659cfa510856a105b1a
Gitweb:     http://git.kernel.org/tip/476b3a865f8a3734f74cf659cfa510856a105b1a
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Mon, 9 Dec 2013 18:47:03 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 9 Dec 2013 15:20:12 -0300

perf kvm: Fix bug in 'stat report'

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
index d9cc0e3..c2e5d56 100644
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
 
