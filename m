Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbbAHHxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 02:53:32 -0500
Received: from lgeamrelo04.lge.com ([156.147.1.127]:51812 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbbAHHxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 02:53:31 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
Date: Thu, 8 Jan 2015 16:51:25 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Cc: acme@redhat.com, peterz@infradead.org, jolsa@kernel.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        bp@suse.de, linux-arch@vger.kernel.org, Alexey.Brodkin@synopsys.com
Subject: Re: [PATCH 4/5] perf tools: [uclibc] don't rely on glibc malloc
 working for sz 0
Message-ID: <20150108075125.GF7268@sejong>
References: <1420552335-26886-1-git-send-email-vgupta@synopsys.com>
 <1420552335-26886-5-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1420552335-26886-5-git-send-email-vgupta@synopsys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vineet,

On Tue, Jan 06, 2015 at 07:22:14PM +0530, Vineet Gupta wrote:
> When running perf on ARC (uClibc based userspace), ran into this issue
> ------------->8----------------
> 	[ARCLinux]$ ./perf record ls
> 	bin             etc             perf            sys
> 	debug           init            perf.data       tmp
> 	[ perf record: Woken up 1 times to write data ]
> 	[ perf record: Captured and wrote 0.001 MB perf.data (~24 samples) ]
> 
> 	[ARCLinux]$ ./perf report
> 	incompatible file format (rerun with -v to learn more)
> ------------->8----------------
> 
> The problem happens in the following call stack when zalloc is called
> with size zero
> 
> glibc default / uClibc with MALLOC_GLIBC_COMPAT are OK, but not if that
> config option is not enabled.
> 
>   cmd_report
>      perf_session__new
> 	perf_session__open
> 	    perf_session__read_header
> 		read_attr(fd, header, &f_attr)
> 		nr_ids = f_attr.ids.size / sizeof(u64); <-- 0
> 		perf_evsel__alloc_id(vsel, 1, nr_ids)
> 			zalloc(ncpus * nthreads * sizeof(u64)) <-- 0
> 
> header.c: read_attr()
> 
> (gdb) p *f_attr
> $17 = {
>   attr = {
>     type = 0,
>     size = 96,
>     config = 0,
>     {
>       sample_period = 4000,
>       sample_freq = 4000
>     },
> ...
>   ids = {
>     offset = 104,
>     size = 0      <------
>   }
> }

Hmm.. okay.  I think we don't need to allocate the id arrays when size
is 0.  So perf_event__process_attr() will have the same problem IMHO.
How about this?


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
 
