Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab3HUAUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:20:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:41929 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056Ab3HUAUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:20:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,923,1367996400"; 
   d="scan'208";a="390573824"
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>,
        Mark Asselstine <mark.asselstine@windriver.com>,
        Mike Frysinger <vapier@chromium.org>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH v2 7/8] turbostat: Clean up error handling; disambiguate error messages; use err and errx
Date: Tue, 20 Aug 2013 17:20:18 -0700
Message-Id: <1377044419-15045-8-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377044419-15045-1-git-send-email-josh@joshtriplett.org>
References: <1377044419-15045-1-git-send-email-josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of turbostat's error handling consists of printing an error (often
including an errno) and exiting.  Since perror doesn't support a format
string, those error messages are often ambiguous, such as just showing a
file path, which doesn't uniquely identify which call failed.

turbostat already uses _GNU_SOURCE, so switch to the err and errx
functions from err.h, which take a format string.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 tools/power/x86/turbostat/turbostat.c | 107 ++++++++++++----------------------
 1 file changed, 38 insertions(+), 69 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index aa80db9..8ceba8f 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -23,6 +23,7 @@
 #include MSRHEADER
 #include <stdarg.h>
 #include <stdio.h>
+#include <err.h>
 #include <unistd.h>
 #include <sys/types.h>
 #include <sys/wait.h>
@@ -620,12 +621,10 @@ delta_thread(struct thread_data *new, struct thread_data *old,
 	old->tsc = new->tsc - old->tsc;
 
 	/* check for TSC < 1 Mcycles over interval */
-	if (old->tsc < (1000 * 1000)) {
-		fprintf(stderr, "Insanely slow TSC rate, TSC stops in idle?\n");
-		fprintf(stderr, "You can disable all c-states by booting with \"idle=poll\"\n");
-		fprintf(stderr, "or just the deep ones with \"processor.max_cstate=1\"\n");
-		exit(-3);
-	}
+	if (old->tsc < (1000 * 1000))
+		errx(-3, "Insanely slow TSC rate, TSC stops in idle?\n"
+		     "You can disable all c-states by booting with \"idle=poll\"\n"
+		     "or just the deep ones with \"processor.max_cstate=1\"");
 
 	old->c1 = new->c1 - old->c1;
 
@@ -1158,10 +1157,8 @@ void free_all_buffers(void)
 FILE *fopen_or_die(const char *path, const char *mode)
 {
 	FILE *filep = fopen(path, "r");
-	if (!filep) {
-		perror(path);
-		exit(1);
-	}
+	if (!filep)
+		err(1, "%s: open failed", path);
 	return filep;
 }
 
@@ -1179,10 +1176,8 @@ int parse_int_file(const char *fmt, ...)
 	vsnprintf(path, sizeof(path), fmt, args);
 	va_end(args);
 	filep = fopen_or_die(path, "r");
-	if (fscanf(filep, "%d", &value) != 1) {
-		perror(path);
-		exit(1);
-	}
+	if (fscanf(filep, "%d", &value) != 1)
+		err(1, "%s: failed to parse number from file", path);
 	fclose(filep);
 	return value;
 }
@@ -1297,10 +1292,8 @@ int for_all_proc_cpus(int (func)(int))
 	fp = fopen_or_die(proc_stat, "r");
 
 	retval = fscanf(fp, "cpu %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d\n");
-	if (retval != 0) {
-		perror("/proc/stat format");
-		exit(1);
-	}
+	if (retval != 0)
+		err(1, "%s: failed to parse format", proc_stat);
 
 	while (1) {
 		retval = fscanf(fp, "cpu%u %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d\n", &cpu_num);
@@ -1404,19 +1397,15 @@ void check_dev_msr()
 {
 	struct stat sb;
 
-	if (stat("/dev/cpu/0/msr", &sb)) {
-		fprintf(stderr, "no /dev/cpu/0/msr\n");
-		fprintf(stderr, "Try \"# modprobe msr\"\n");
-		exit(-5);
-	}
+	if (stat("/dev/cpu/0/msr", &sb))
+		err(-5, "no /dev/cpu/0/msr\n"
+		    "Try \"# modprobe msr\"");
 }
 
 void check_super_user()
 {
-	if (getuid() != 0) {
-		fprintf(stderr, "must be root\n");
-		exit(-6);
-	}
+	if (getuid() != 0)
+		errx(-6, "must be root");
 }
 
 int has_nehalem_turbo_ratio_limit(unsigned int family, unsigned int model)
@@ -1895,10 +1884,8 @@ void check_cpuid()
 		fprintf(stderr, "%d CPUID levels; family:model:stepping 0x%x:%x:%x (%d:%d:%d)\n",
 			max_level, family, model, stepping, family, model, stepping);
 
-	if (!(edx & (1 << 5))) {
-		fprintf(stderr, "CPUID: no MSR\n");
-		exit(1);
-	}
+	if (!(edx & (1 << 5)))
+		errx(1, "CPUID: no MSR");
 
 	/*
 	 * check max extended function levels of CPUID.
@@ -1908,10 +1895,8 @@ void check_cpuid()
 	ebx = ecx = edx = 0;
 	__get_cpuid(0x80000000, &max_level, &ebx, &ecx, &edx);
 
-	if (max_level < 0x80000007) {
-		fprintf(stderr, "CPUID: no invariant TSC (max_level 0x%x)\n", max_level);
-		exit(1);
-	}
+	if (max_level < 0x80000007)
+		errx(1, "CPUID: no invariant TSC (max_level 0x%x)", max_level);
 
 	/*
 	 * Non-Stop TSC is advertised by CPUID.EAX=0x80000007: EDX.bit8
@@ -1920,10 +1905,8 @@ void check_cpuid()
 	__get_cpuid(0x80000007, &eax, &ebx, &ecx, &edx);
 	has_invariant_tsc = edx & (1 << 8);
 
-	if (!has_invariant_tsc) {
-		fprintf(stderr, "No invariant TSC\n");
-		exit(1);
-	}
+	if (!has_invariant_tsc)
+		errx(1, "No invariant TSC");
 
 	/*
 	 * APERF/MPERF is advertised by CPUID.EAX=0x6: ECX.bit0
@@ -1944,7 +1927,7 @@ void check_cpuid()
 			has_epb ? ", EPB": "");
 
 	if (!has_aperf)
-		exit(-1);
+		errx(-1, "No APERF");
 
 	do_nehalem_platform_info = genuine_intel && has_invariant_tsc;
 	do_nhm_cstates = genuine_intel;	/* all Intel w/ non-stop TSC have NHM counters */
@@ -1963,9 +1946,8 @@ void check_cpuid()
 
 void usage()
 {
-	fprintf(stderr, "%s: [-v][-R][-T][-p|-P|-S][-c MSR# | -s]][-C MSR#][-m MSR#][-M MSR#][-i interval_sec | command ...]\n",
-		progname);
-	exit(1);
+	errx(1, "%s: [-v][-R][-T][-p|-P|-S][-c MSR# | -s]][-C MSR#][-m MSR#][-M MSR#][-i interval_sec | command ...]\n",
+	     progname);
 }
 
 
@@ -2008,19 +1990,15 @@ void topology_probe()
 		fprintf(stderr, "num_cpus %d max_cpu_num %d\n", topo.num_cpus, topo.max_cpu_num);
 
 	cpus = calloc(1, (topo.max_cpu_num  + 1) * sizeof(struct cpu_topology));
-	if (cpus == NULL) {
-		perror("calloc cpus");
-		exit(1);
-	}
+	if (cpus == NULL)
+		err(1, "calloc cpus");
 
 	/*
 	 * Allocate and initialize cpu_present_set
 	 */
 	cpu_present_set = CPU_ALLOC((topo.max_cpu_num + 1));
-	if (cpu_present_set == NULL) {
-		perror("CPU_ALLOC");
-		exit(3);
-	}
+	if (cpu_present_set == NULL)
+		err(3, "CPU_ALLOC");
 	cpu_present_setsize = CPU_ALLOC_SIZE((topo.max_cpu_num + 1));
 	CPU_ZERO_S(cpu_present_setsize, cpu_present_set);
 	for_all_proc_cpus(mark_cpu_present);
@@ -2029,10 +2007,8 @@ void topology_probe()
 	 * Allocate and initialize cpu_affinity_set
 	 */
 	cpu_affinity_set = CPU_ALLOC((topo.max_cpu_num + 1));
-	if (cpu_affinity_set == NULL) {
-		perror("CPU_ALLOC");
-		exit(3);
-	}
+	if (cpu_affinity_set == NULL)
+		err(3, "CPU_ALLOC");
 	cpu_affinity_setsize = CPU_ALLOC_SIZE((topo.max_cpu_num + 1));
 	CPU_ZERO_S(cpu_affinity_setsize, cpu_affinity_set);
 
@@ -2116,8 +2092,7 @@ allocate_counters(struct thread_data **t, struct core_data **c, struct pkg_data
 
 	return;
 error:
-	perror("calloc counters");
-	exit(1);
+	err(1, "calloc counters");
 }
 /*
  * init_counter()
@@ -2174,10 +2149,8 @@ void allocate_output_buffer()
 {
 	output_buffer = calloc(1, (1 + topo.num_cpus) * 256);
 	outp = output_buffer;
-	if (outp == NULL) {
-		perror("calloc");
-		exit(-1);
-	}
+	if (outp == NULL)
+		err(-1, "calloc output buffer");
 }
 
 void setup_all_buffers(void)
@@ -2231,17 +2204,13 @@ int fork_it(char **argv)
 	} else {
 
 		/* parent */
-		if (child_pid == -1) {
-			perror("fork");
-			exit(1);
-		}
+		if (child_pid == -1)
+			err(1, "fork");
 
 		signal(SIGINT, SIG_IGN);
 		signal(SIGQUIT, SIG_IGN);
-		if (waitpid(child_pid, &status, 0) == -1) {
-			perror("wait");
-			exit(status);
-		}
+		if (waitpid(child_pid, &status, 0) == -1)
+			err(status, "waitpid");
 	}
 	/*
 	 * n.b. fork_it() does not check for errors from for_all_cpus()
-- 
1.8.4.rc3

