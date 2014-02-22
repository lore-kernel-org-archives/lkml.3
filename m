Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbaBVTQo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 14:16:44 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:57829 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbaBVTQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 14:16:42 -0500
Date: Sat, 22 Feb 2014 20:16:35 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20140222191635.GA16118@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   # HEAD: a9d3f94ec7708427b9f05a65246d3fd6e287fa51 Merge tag 'perf-urgent-for-mingo' of git://git.kernel.org/pub/scm/linux/kernel/git/acme/linux into perf/urgent

Misc fixlets from all around the place.

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (1):
      perf trace: Fix ioctl 'request' beautifier build problems on !(i386 || x86_64) arches

Ben Hutchings (1):
      perf trace: Add fallback definition of EFD_SEMAPHORE

Jiri Olsa (1):
      perf tools: Handle PERF_RECORD_HEADER_EVENT_TYPE properly

Markus Metzger (1):
      perf, nmi: Fix unknown NMI warning

Masami Hiramatsu (1):
      perf probe: Do not add offset twice to uprobe address

Peter Zijlstra (3):
      perf/x86/intel/p6: Add userspace RDPMC quirk for PPro
      perf/x86: Fix Userspace RDPMC switch
      perf/x86: Correctly use FEATURE_PDCM

Stephane Eranian (1):
      perf/x86/uncore: Fix IVT/SNB-EP uncore CBOX NID filter table

Vince Weaver (1):
      perf list: Fix checking for supported events on older kernels


 arch/x86/kernel/cpu/perf_event.c              |  8 +++--
 arch/x86/kernel/cpu/perf_event.h              |  1 +
 arch/x86/kernel/cpu/perf_event_intel.c        | 11 ++----
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 10 +++++-
 arch/x86/kernel/cpu/perf_event_p6.c           | 48 ++++++++++++++++++---------
 tools/perf/builtin-trace.c                    | 22 ++++++++++++
 tools/perf/util/parse-events.c                | 17 ++++++++--
 tools/perf/util/probe-event.c                 |  2 +-
 tools/perf/util/session.c                     |  6 ++++
 9 files changed, 96 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index b886451..895604f 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1521,6 +1521,8 @@ static int __init init_hw_perf_events(void)
 
 	pr_cont("%s PMU driver.\n", x86_pmu.name);
 
+	x86_pmu.attr_rdpmc = 1; /* enable userspace RDPMC usage by default */
+
 	for (quirk = x86_pmu.quirks; quirk; quirk = quirk->next)
 		quirk->func();
 
@@ -1534,7 +1536,6 @@ static int __init init_hw_perf_events(void)
 		__EVENT_CONSTRAINT(0, (1ULL << x86_pmu.num_counters) - 1,
 				   0, x86_pmu.num_counters, 0, 0);
 
-	x86_pmu.attr_rdpmc = 1; /* enable userspace RDPMC usage by default */
 	x86_pmu_format_group.attrs = x86_pmu.format_attrs;
 
 	if (x86_pmu.event_attrs)
@@ -1820,9 +1821,12 @@ static ssize_t set_attr_rdpmc(struct device *cdev,
 	if (ret)
 		return ret;
 
+	if (x86_pmu.attr_rdpmc_broken)
+		return -ENOTSUPP;
+
 	if (!!val != !!x86_pmu.attr_rdpmc) {
 		x86_pmu.attr_rdpmc = !!val;
-		smp_call_function(change_rdpmc, (void *)val, 1);
+		on_each_cpu(change_rdpmc, (void *)val, 1);
 	}
 
 	return count;
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index c1a8618..4972c24 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -409,6 +409,7 @@ struct x86_pmu {
 	/*
 	 * sysfs attrs
 	 */
+	int		attr_rdpmc_broken;
 	int		attr_rdpmc;
 	struct attribute **format_attrs;
 	struct attribute **event_attrs;
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 0fa4f24..aa333d9 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1361,10 +1361,8 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	intel_pmu_disable_all();
 	handled = intel_pmu_drain_bts_buffer();
 	status = intel_pmu_get_status();
-	if (!status) {
-		intel_pmu_enable_all(0);
-		return handled;
-	}
+	if (!status)
+		goto done;
 
 	loops = 0;
 again:
@@ -2310,10 +2308,7 @@ __init int intel_pmu_init(void)
 	if (version > 1)
 		x86_pmu.num_counters_fixed = max((int)edx.split.num_counters_fixed, 3);
 
-	/*
-	 * v2 and above have a perf capabilities MSR
-	 */
-	if (version > 1) {
+	if (boot_cpu_has(X86_FEATURE_PDCM)) {
 		u64 capabilities;
 
 		rdmsrl(MSR_IA32_PERF_CAPABILITIES, capabilities);
diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 29c2487..c88f7f4 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -501,8 +501,11 @@ static struct extra_reg snbep_uncore_cbox_extra_regs[] = {
 	SNBEP_CBO_EVENT_EXTRA_REG(SNBEP_CBO_PMON_CTL_TID_EN,
 				  SNBEP_CBO_PMON_CTL_TID_EN, 0x1),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0334, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4334, 0xffff, 0x6),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0534, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4534, 0xffff, 0x6),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0934, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4934, 0xffff, 0x6),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x4134, 0xffff, 0x6),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0135, 0xffff, 0x8),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0335, 0xffff, 0x8),
@@ -1178,10 +1181,15 @@ static struct extra_reg ivt_uncore_cbox_extra_regs[] = {
 	SNBEP_CBO_EVENT_EXTRA_REG(SNBEP_CBO_PMON_CTL_TID_EN,
 				  SNBEP_CBO_PMON_CTL_TID_EN, 0x1),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x1031, 0x10ff, 0x2),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x1134, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4134, 0xffff, 0xc),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x5134, 0xffff, 0xc),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0334, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4334, 0xffff, 0xc),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0534, 0xffff, 0x4),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4534, 0xffff, 0xc),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0934, 0xffff, 0x4),
-	SNBEP_CBO_EVENT_EXTRA_REG(0x4134, 0xffff, 0xc),
+	SNBEP_CBO_EVENT_EXTRA_REG(0x4934, 0xffff, 0xc),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0135, 0xffff, 0x10),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x0335, 0xffff, 0x10),
 	SNBEP_CBO_EVENT_EXTRA_REG(0x2135, 0xffff, 0x10),
diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index b1e2fe1..7c1a0c0 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -231,31 +231,49 @@ static __initconst const struct x86_pmu p6_pmu = {
 
 };
 
+static __init void p6_pmu_rdpmc_quirk(void)
+{
+	if (boot_cpu_data.x86_mask < 9) {
+		/*
+		 * PPro erratum 26; fixed in stepping 9 and above.
+		 */
+		pr_warn("Userspace RDPMC support disabled due to a CPU erratum\n");
+		x86_pmu.attr_rdpmc_broken = 1;
+		x86_pmu.attr_rdpmc = 0;
+	}
+}
+
 __init int p6_pmu_init(void)
 {
+	x86_pmu = p6_pmu;
+
 	switch (boot_cpu_data.x86_model) {
-	case 1:
-	case 3:  /* Pentium Pro */
-	case 5:
-	case 6:  /* Pentium II */
-	case 7:
-	case 8:
-	case 11: /* Pentium III */
-	case 9:
-	case 13:
-		/* Pentium M */
+	case  1: /* Pentium Pro */
+		x86_add_quirk(p6_pmu_rdpmc_quirk);
+		break;
+
+	case  3: /* Pentium II - Klamath */
+	case  5: /* Pentium II - Deschutes */
+	case  6: /* Pentium II - Mendocino */
 		break;
+
+	case  7: /* Pentium III - Katmai */
+	case  8: /* Pentium III - Coppermine */
+	case 10: /* Pentium III Xeon */
+	case 11: /* Pentium III - Tualatin */
+		break;
+
+	case  9: /* Pentium M - Banias */
+	case 13: /* Pentium M - Dothan */
+		break;
+
 	default:
-		pr_cont("unsupported p6 CPU model %d ",
-			boot_cpu_data.x86_model);
+		pr_cont("unsupported p6 CPU model %d ", boot_cpu_data.x86_model);
 		return -ENODEV;
 	}
 
-	x86_pmu = p6_pmu;
-
 	memcpy(hw_cache_event_ids, p6_hw_cache_event_ids,
 		sizeof(hw_cache_event_ids));
 
-
 	return 0;
 }
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 896f270..6aa6fb6 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -37,6 +37,10 @@
 # define MADV_UNMERGEABLE	13
 #endif
 
+#ifndef EFD_SEMAPHORE
+# define EFD_SEMAPHORE		1
+#endif
+
 struct tp_field {
 	int offset;
 	union {
@@ -279,6 +283,11 @@ static size_t syscall_arg__scnprintf_strarray(char *bf, size_t size,
 
 #define SCA_STRARRAY syscall_arg__scnprintf_strarray
 
+#if defined(__i386__) || defined(__x86_64__)
+/*
+ * FIXME: Make this available to all arches as soon as the ioctl beautifier
+ * 	  gets rewritten to support all arches.
+ */
 static size_t syscall_arg__scnprintf_strhexarray(char *bf, size_t size,
 						 struct syscall_arg *arg)
 {
@@ -286,6 +295,7 @@ static size_t syscall_arg__scnprintf_strhexarray(char *bf, size_t size,
 }
 
 #define SCA_STRHEXARRAY syscall_arg__scnprintf_strhexarray
+#endif /* defined(__i386__) || defined(__x86_64__) */
 
 static size_t syscall_arg__scnprintf_fd(char *bf, size_t size,
 					struct syscall_arg *arg);
@@ -839,6 +849,10 @@ static size_t syscall_arg__scnprintf_signum(char *bf, size_t size, struct syscal
 
 #define SCA_SIGNUM syscall_arg__scnprintf_signum
 
+#if defined(__i386__) || defined(__x86_64__)
+/*
+ * FIXME: Make this available to all arches.
+ */
 #define TCGETS		0x5401
 
 static const char *tioctls[] = {
@@ -860,6 +874,7 @@ static const char *tioctls[] = {
 };
 
 static DEFINE_STRARRAY_OFFSET(tioctls, 0x5401);
+#endif /* defined(__i386__) || defined(__x86_64__) */
 
 #define STRARRAY(arg, name, array) \
 	  .arg_scnprintf = { [arg] = SCA_STRARRAY, }, \
@@ -941,9 +956,16 @@ static struct syscall_fmt {
 	{ .name	    = "getrlimit",  .errmsg = true, STRARRAY(0, resource, rlimit_resources), },
 	{ .name	    = "ioctl",	    .errmsg = true,
 	  .arg_scnprintf = { [0] = SCA_FD, /* fd */ 
+#if defined(__i386__) || defined(__x86_64__)
+/*
+ * FIXME: Make this available to all arches.
+ */
 			     [1] = SCA_STRHEXARRAY, /* cmd */
 			     [2] = SCA_HEX, /* arg */ },
 	  .arg_parm	 = { [1] = &strarray__tioctls, /* cmd */ }, },
+#else
+			     [2] = SCA_HEX, /* arg */ }, },
+#endif
 	{ .name	    = "kill",	    .errmsg = true,
 	  .arg_scnprintf = { [1] = SCA_SIGNUM, /* sig */ }, },
 	{ .name	    = "linkat",	    .errmsg = true,
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index d248fca..1e15df1 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1091,12 +1091,12 @@ int is_valid_tracepoint(const char *event_string)
 static bool is_event_supported(u8 type, unsigned config)
 {
 	bool ret = true;
+	int open_return;
 	struct perf_evsel *evsel;
 	struct perf_event_attr attr = {
 		.type = type,
 		.config = config,
 		.disabled = 1,
-		.exclude_kernel = 1,
 	};
 	struct {
 		struct thread_map map;
@@ -1108,7 +1108,20 @@ static bool is_event_supported(u8 type, unsigned config)
 
 	evsel = perf_evsel__new(&attr);
 	if (evsel) {
-		ret = perf_evsel__open(evsel, NULL, &tmap.map) >= 0;
+		open_return = perf_evsel__open(evsel, NULL, &tmap.map);
+		ret = open_return >= 0;
+
+		if (open_return == -EACCES) {
+			/*
+			 * This happens if the paranoid value
+			 * /proc/sys/kernel/perf_event_paranoid is set to 2
+			 * Re-run with exclude_kernel set; we don't do that
+			 * by default as some ARM machines do not support it.
+			 *
+			 */
+			evsel->attr.exclude_kernel = 1;
+			ret = perf_evsel__open(evsel, NULL, &tmap.map) >= 0;
+		}
 		perf_evsel__delete(evsel);
 	}
 
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index a8a9b6c..d8b048c 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -336,8 +336,8 @@ static int add_exec_to_probe_trace_events(struct probe_trace_event *tevs,
 		return ret;
 
 	for (i = 0; i < ntevs && ret >= 0; i++) {
+		/* point.address is the addres of point.symbol + point.offset */
 		offset = tevs[i].point.address - stext;
-		offset += tevs[i].point.offset;
 		tevs[i].point.offset = 0;
 		zfree(&tevs[i].point.symbol);
 		ret = e_snprintf(buf, 32, "0x%lx", offset);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 0b39a48..5da6ce7 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1008,6 +1008,12 @@ static int perf_session__process_user_event(struct perf_session *session, union
 		if (err == 0)
 			perf_session__set_id_hdr_size(session);
 		return err;
+	case PERF_RECORD_HEADER_EVENT_TYPE:
+		/*
+		 * Depreceated, but we need to handle it for sake
+		 * of old data files create in pipe mode.
+		 */
+		return 0;
 	case PERF_RECORD_HEADER_TRACING_DATA:
 		/* setup for reading amidst mmap */
 		lseek(fd, file_offset, SEEK_SET);
