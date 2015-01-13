Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbbAMNoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 08:44:23 -0500
Received: from smtprelay2.synopsys.com ([198.182.60.111]:52360 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbbAMNoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 08:44:19 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <acme@redhat.com>, <namhyung@kernel.org>, <jolsa@kernel.org>
CC: <peterz@infradead.org>, <mingo@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-perf-users@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        <Alexey.Brodkin@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH v3 4/5] perf tools: [uclibc] don't rely on glibc malloc working for sz 0
Date: Tue, 13 Jan 2015 19:13:23 +0530
Message-ID: <1421156604-30603-5-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421156604-30603-1-git-send-email-vgupta@synopsys.com>
References: <1421156604-30603-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.196.223]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running perf on ARC (uClibc based userspace), ran into this issue
   ------------->8----------------
	[ARCLinux]$ ./perf record ls
	bin             etc             perf            sys
	debug           init            perf.data       tmp
	[ perf record: Woken up 1 times to write data ]
	[ perf record: Captured and wrote 0.001 MB perf.data (~24 samples) ]

	[ARCLinux]$ ./perf report
	incompatible file format (rerun with -v to learn more)
   ------------->8----------------

The problem happens in the following call stack when zalloc is called
with size zero

glibc default / uClibc with MALLOC_GLIBC_COMPAT are OK, but not if that
config option is not enabled.

  cmd_report
     perf_session__new
	perf_session__open
	    perf_session__read_header
		read_attr(fd, header, &f_attr)
		nr_ids = f_attr.ids.size / sizeof(u64); <-- 0
		perf_evsel__alloc_id(vsel, 1, nr_ids)
			zalloc(ncpus * nthreads * sizeof(u64)) <-- 0

header.c: read_attr()

(gdb) p *f_attr
$17 = {
  attr = {
    type = 0,
    size = 96,
    config = 0,
    {
      sample_period = 4000,
      sample_freq = 4000
    },
...
  ids = {
    offset = 104,
    size = 0      <------
  }
}

Suggested-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 tools/perf/util/evsel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 1e90c8557ede..1d826d63bc20 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -797,6 +797,9 @@ int perf_evsel__enable(struct perf_evsel *evsel, int ncpus, int nthreads)
 
 int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads)
 {
+	if (ncpus == 0 || nthreads == 0)
+		return 0;
+
 	if (evsel->system_wide)
 		nthreads = 1;
 
-- 
1.9.1

