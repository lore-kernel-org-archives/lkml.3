Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab3IITsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 15:48:51 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:65421 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab3IITsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 15:48:50 -0400
Date: Mon, 9 Sep 2013 16:48:44 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
        ak@linux.intel.com, jolsa@redhat.com, namhyung.kim@lge.com,
        dsahern@gmail.com
Subject: Re: [PATCH v2 2/2] perf tools: add attr->mmap2 support
Message-ID: <20130909194844.GB28428@ghostprotocols.net>
References: <1377079825-19057-3-git-send-email-eranian@google.com>
 <20130909192810.GA3825@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130909192810.GA3825@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Sep 09, 2013 at 04:47:45PM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Wed, Aug 21, 2013 at 12:10:25PM +0200, Stephane Eranian escreveu:
> > This patch adds support for the new PERF_RECORD_MMAP2
> > record type exposed by the kernel. This is an extended
> > PERF_RECORD_MMAP record. It adds for each file-backed
> > mapping the device major, minor number and the inode
> > number and generation. This triplet uniquely identifies
> > the source of a file-backed mapping. It can be used to
> > detect identical virtual mappings between processes, for
> > instance.
> > 
> > The patch will prefer MMAP2 over MMAP.
> 
> I noticed the kernel part is in, and I'm going to use MMAP2 on that new
> tool, so tried merging it, but:
> 
> I fixed it up wrt another patch that makes machine__find_thread receive pid/tid
> but then 'perf test' complains about it, see below, trying to fix...

Following patch makes it progress a bit, still checking why it is not
enough...

- Arnaldo

diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index 72d8881..b8a7056 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -50,7 +50,7 @@ int test__PERF_RECORD(void)
 	struct perf_sample sample;
 	const char *cmd = "sleep";
 	const char *argv[] = { cmd, "1", NULL, };
-	char *bname;
+	char *bname, *mmap_filename;
 	u64 prev_time = 0;
 	bool found_cmd_mmap = false,
 	     found_libc_mmap = false,
@@ -212,6 +212,7 @@ int test__PERF_RECORD(void)
 
 				if ((type == PERF_RECORD_COMM ||
 				     type == PERF_RECORD_MMAP ||
+				     type == PERF_RECORD_MMAP2 ||
 				     type == PERF_RECORD_FORK ||
 				     type == PERF_RECORD_EXIT) &&
 				     (pid_t)event->comm.pid != evlist->workload.pid) {
@@ -220,7 +221,8 @@ int test__PERF_RECORD(void)
 				}
 
 				if ((type == PERF_RECORD_COMM ||
-				     type == PERF_RECORD_MMAP) &&
+				     type == PERF_RECORD_MMAP ||
+				     type == PERF_RECORD_MMAP2) &&
 				     event->comm.pid != event->comm.tid) {
 					pr_debug("%s with different pid/tid!\n", name);
 					++errs;
@@ -236,7 +238,12 @@ int test__PERF_RECORD(void)
 				case PERF_RECORD_EXIT:
 					goto found_exit;
 				case PERF_RECORD_MMAP:
-					bname = strrchr(event->mmap.filename, '/');
+					mmap_filename = event->mmap.filename;
+					goto check_bname;
+				case PERF_RECORD_MMAP2:
+					mmap_filename = event->mmap2.filename;
+				check_bname:
+					bname = strrchr(mmap_filename, '/');
 					if (bname != NULL) {
 						if (!found_cmd_mmap)
 							found_cmd_mmap = !strcmp(bname + 1, cmd);
@@ -245,7 +252,7 @@ int test__PERF_RECORD(void)
 						if (!found_ld_mmap)
 							found_ld_mmap = !strncmp(bname + 1, "ld", 2);
 					} else if (!found_vdso_mmap)
-						found_vdso_mmap = !strcmp(event->mmap.filename, "[vdso]");
+						found_vdso_mmap = !strcmp(mmap_filename, "[vdso]");
 					break;
 
 				case PERF_RECORD_SAMPLE:
