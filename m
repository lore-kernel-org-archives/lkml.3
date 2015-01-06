Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbbAFNxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:53:14 -0500
Received: from us01smtprelay-2.synopsys.com ([198.182.60.111]:52859 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268AbbAFNxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:53:10 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: <acme@redhat.com>, <peterz@infradead.org>
CC: <jolsa@kernel.org>, <mingo@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-perf-users@vger.kernel.org>, <bp@suse.de>,
        <linux-arch@vger.kernel.org>, <Alexey.Brodkin@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 4/5] perf tools: [uclibc] don't rely on glibc malloc working for sz 0
Date: Tue, 6 Jan 2015 19:22:14 +0530
Message-ID: <1420552335-26886-5-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1420552335-26886-1-git-send-email-vgupta@synopsys.com>
References: <1420552335-26886-1-git-send-email-vgupta@synopsys.com>
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

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 tools/perf/util/header.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index b20e40c74468..43671068ce75 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2532,7 +2532,7 @@ int perf_session__read_header(struct perf_session *session)
 		 */
 		perf_evlist__add(session->evlist, evsel);
 
-		nr_ids = f_attr.ids.size / sizeof(u64);
+		nr_ids = f_attr.ids.size / sizeof(u64) ? : 1;
 		/*
 		 * We don't have the cpu and thread maps on the header, so
 		 * for allocating the perf_sample_id table we fake 1 cpu and
-- 
1.9.1

