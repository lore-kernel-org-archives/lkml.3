Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580AbaLLIQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 03:16:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43044 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbaLLIQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 03:16:44 -0500
Date: Fri, 12 Dec 2014 00:16:22 -0800
From: tip-bot for Rabin Vincent <tipbot@zytor.com>
Message-ID: <tip-1182f883113483cefbc3be0178a2df2dc9ae8b77@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        acme@redhat.com, paulus@samba.org, a.p.zijlstra@chello.nl,
        mingo@kernel.org, rabin@rab.in, rabin.vincent@axis.com, hpa@zytor.com,
        rabinv@axis.com
Reply-To: paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
        mingo@redhat.com, tglx@linutronix.de, mingo@kernel.org,
        a.p.zijlstra@chello.nl, hpa@zytor.com, rabinv@axis.com,
        rabin.vincent@axis.com, rabin@rab.in
In-Reply-To: <1417535441-3965-3-git-send-email-rabin.vincent@axis.com>
References: <1417535441-3965-3-git-send-email-rabin.vincent@axis.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf bench: Fix memcpy/memset output
Git-Commit-ID: 1182f883113483cefbc3be0178a2df2dc9ae8b77
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1182f883113483cefbc3be0178a2df2dc9ae8b77
Gitweb:     http://git.kernel.org/tip/1182f883113483cefbc3be0178a2df2dc9ae8b77
Author:     Rabin Vincent <rabin.vincent@axis.com>
AuthorDate: Tue, 2 Dec 2014 16:50:41 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 9 Dec 2014 09:14:08 -0300

perf bench: Fix memcpy/memset output

The memcpy and memset benchmarks return bogus results when iterations >
0 because the iterations value is not taken into account when
calculating the final result:

 $ perf bench mem memset --only-prefault --length 1GB --iterations 1
 # Running 'mem/memset' benchmark:
 # Copying 1GB Bytes ...

       20.798669 GB/Sec (with prefault)
 $ perf bench mem memset --only-prefault --length 1GB --iterations 10
 # Running 'mem/memset' benchmark:
 # Copying 1GB Bytes ...

        2.086576 GB/Sec (with prefault)
 $ perf bench mem memset --only-prefault --length 1GB --iterations 100
 # Running 'mem/memset' benchmark:
 # Copying 1GB Bytes ...

      212.840917 MB/Sec (with prefault)

Fix this.

Signed-off-by: Rabin Vincent <rabin.vincent@axis.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rabin Vincent <rabin@rab.in>
Cc: Rabin Vincent <rabinv@axis.com>
Link: http://lkml.kernel.org/r/1417535441-3965-3-git-send-email-rabin.vincent@axis.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/mem-memcpy.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index e18be70..6c14afe 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -141,6 +141,7 @@ static int bench_mem_common(int argc, const char **argv,
 {
 	int i;
 	size_t len;
+	double totallen;
 	double result_bps[2];
 	u64 result_cycle[2];
 
@@ -156,6 +157,7 @@ static int bench_mem_common(int argc, const char **argv,
 		init_cycle();
 
 	len = (size_t)perf_atoll((char *)length_str);
+	totallen = (double)len * iterations;
 
 	result_cycle[0] = result_cycle[1] = 0ULL;
 	result_bps[0] = result_bps[1] = 0.0;
@@ -219,10 +221,10 @@ static int bench_mem_common(int argc, const char **argv,
 			if (use_cycle) {
 				printf(" %14lf Cycle/Byte\n",
 					(double)result_cycle[0]
-					/ (double)len);
+					/ totallen);
 				printf(" %14lf Cycle/Byte (with prefault)\n",
 					(double)result_cycle[1]
-					/ (double)len);
+					/ totallen);
 			} else {
 				print_bps(result_bps[0]);
 				printf("\n");
@@ -233,7 +235,7 @@ static int bench_mem_common(int argc, const char **argv,
 			if (use_cycle) {
 				printf(" %14lf Cycle/Byte",
 					(double)result_cycle[pf]
-					/ (double)len);
+					/ totallen);
 			} else
 				print_bps(result_bps[pf]);
 
@@ -244,8 +246,8 @@ static int bench_mem_common(int argc, const char **argv,
 		if (!only_prefault && !no_prefault) {
 			if (use_cycle) {
 				printf("%lf %lf\n",
-					(double)result_cycle[0] / (double)len,
-					(double)result_cycle[1] / (double)len);
+					(double)result_cycle[0] / totallen,
+					(double)result_cycle[1] / totallen);
 			} else {
 				printf("%lf %lf\n",
 					result_bps[0], result_bps[1]);
@@ -253,7 +255,7 @@ static int bench_mem_common(int argc, const char **argv,
 		} else {
 			if (use_cycle) {
 				printf("%lf\n", (double)result_cycle[pf]
-					/ (double)len);
+					/ totallen);
 			} else
 				printf("%lf\n", result_bps[pf]);
 		}
@@ -324,7 +326,7 @@ static double do_memcpy_gettimeofday(const struct routine *r, size_t len,
 
 	free(src);
 	free(dst);
-	return (double)((double)len / timeval2double(&tv_diff));
+	return (double)(((double)len * iterations) / timeval2double(&tv_diff));
 }
 
 int bench_mem_memcpy(int argc, const char **argv,
@@ -389,7 +391,7 @@ static double do_memset_gettimeofday(const struct routine *r, size_t len,
 	timersub(&tv_end, &tv_start, &tv_diff);
 
 	free(dst);
-	return (double)((double)len / timeval2double(&tv_diff));
+	return (double)(((double)len * iterations) / timeval2double(&tv_diff));
 }
 
 static const char * const bench_mem_memset_usage[] = {
