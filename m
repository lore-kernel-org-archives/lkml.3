Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934355AbaGXHsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 03:48:47 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:54357 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934276AbaGXHsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 03:48:46 -0400
Date: Thu, 24 Jul 2014 00:47:49 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: andi@firstfloor.org
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Michael Ellerman <michaele@au1.ibm.com>, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 2/2] powerpc/perf: Implement get_cpu_str()
Message-ID: <20140724074749.GC18829@us.ibm.com>
References: <20140724074645.GA18829@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140724074645.GA18829@us.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072407-0320-0000-0000-00000011B88A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[RFC PATCH 2/2] powerpc/perf: Implement get_cpu_str()

get_cpu_str() returns a string identifying the CPU type on the system.
This string is then used to locate a cached JSON file which defines
the list of PMU events supported by the CPU.

Eg: if get_cpu_str() returns "power8", the perf tool would refer to the
PMU events defined in ~/.cache/pmu-events/power8.json.

Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 tools/perf/arch/powerpc/util/header.c |   69 +++++++++++++++++++++++++++++++++
 tools/perf/perf.c                     |   11 ++++++
 tools/perf/perf.h                     |    2 +
 3 files changed, 82 insertions(+)

diff --git a/tools/perf/arch/powerpc/util/header.c b/tools/perf/arch/powerpc/util/header.c
index 6c1b8a7..4d82593 100644
--- a/tools/perf/arch/powerpc/util/header.c
+++ b/tools/perf/arch/powerpc/util/header.c
@@ -3,9 +3,12 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <elf.h>
+#include <link.h>
 
 #include "../../util/header.h"
 #include "../../util/util.h"
+#include "../../util/jevents.h"
 
 #define mfspr(rn)       ({unsigned long rval; \
 			 asm volatile("mfspr %0," __stringify(rn) \
@@ -15,6 +18,8 @@
 #define PVR_VER(pvr)    (((pvr) >>  16) & 0xFFFF) /* Version field */
 #define PVR_REV(pvr)    (((pvr) >>   0) & 0xFFFF) /* Revison field */
 
+static char *cached_cpu_str;
+
 int
 get_cpuid(char *buffer, size_t sz)
 {
@@ -32,3 +37,67 @@ get_cpuid(char *buffer, size_t sz)
 	}
 	return -1;
 }
+
+static void dup_platform(char *platform)
+{
+	char *bp;
+
+	bp = cached_cpu_str = malloc(128);
+	if (!bp)
+		return;
+
+	/*
+	 * Platform could be POWER8 or POWER8E. Exclude any suffixes
+	 * after the digit(s)
+	 */
+	while (isalpha(*platform))
+		*bp++ = tolower(*platform++);
+
+	while (isdigit(*platform))
+		*bp++ = *platform++;
+	*bp = '\0';
+}
+
+static void *find_auxv(void)
+{
+	char **envp;
+
+	/*
+	 * Exec() copies the AUX Variables after the environment variables.
+	 */
+	envp = environ;
+	while (*envp)
+		envp++;
+	envp++;
+
+	return envp;
+}
+
+void cache_cpu_str(void)
+{
+	ElfW(auxv_t) * auxv;
+
+	auxv = (ElfW(auxv_t)*)find_auxv();
+
+	while (auxv->a_type != AT_NULL) {
+		if (auxv->a_type == AT_BASE_PLATFORM) {
+			dup_platform((char *)auxv->a_un.a_val);
+			return;
+		}
+		auxv++;
+	}
+}
+
+/*
+ * Return an identier string for the CPU on this system.
+ *
+ * On Non-NULL return, assume that the caller will free the
+ * returned string buffer.
+ */
+char *get_cpu_str(void)
+{
+	if (cached_cpu_str)
+		return strdup(cached_cpu_str);
+
+	return NULL;
+}
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 95c58fc..fb9beb0 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -452,6 +452,10 @@ void pthread__unblock_sigwinch(void)
 	pthread_sigmask(SIG_UNBLOCK, &set, NULL);
 }
 
+__attribute__((weak)) void cache_cpu_str(void)
+{
+}
+
 int main(int argc, const char **argv)
 {
 	const char *cmd;
@@ -460,6 +464,13 @@ int main(int argc, const char **argv)
 	page_size = sysconf(_SC_PAGE_SIZE);
 	cacheline_size = sysconf(_SC_LEVEL1_DCACHE_LINESIZE);
 
+	/*
+	 * Architectures that rely on AUXV variables to determine
+	 * CPU type must cache the cpu type before setenv() calls
+	 * So do that early.
+	 */
+	cache_cpu_str();
+
 	cmd = perf_extract_argv0_path(argv[0]);
 	if (!cmd)
 		cmd = "perf-help";
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 510c65f..406fd5c 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -65,4 +65,6 @@ struct record_opts {
 	unsigned     initial_delay;
 };
 
+extern void cache_cpu_str(void);
+
 #endif
-- 
1.7.9.5

