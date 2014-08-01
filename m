Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbaHAPsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 11:48:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1126 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751008AbaHAPse (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 11:48:34 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        William Cohen <wcohen@redhat.com>,
        Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCH] perf tools: Show better error message in case we fail to open counters due to EBUSY error
Date: Fri,  1 Aug 2014 17:46:54 +0200
Message-Id: <1406908014-8312-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Showing better error message in case we fail to open
counters due to the EBUSY error. If we detect oprofile
daemon process running, we now display following message
for EBUSY error:

  $ perf record ls
  Error:
  The PMU counters are busy/taken by another profiler.
  We found oprofile daemon running, please stop it and try again.

In case oprofiled was not detected the current error
message stays:

  $ perf record ls
  Error:
  The sys_perf_event_open() syscall returned with 16 (Device or resource busy) for event (cycles).
  /bin/dmesg may provide additional information.
  No CONFIG_PERF_EVENTS=y kernel support configured?

Also changing PERF_FLAG_FD_CLOEXEC detection code not to display
error in case of EBUSY error, as it currently does:

  $ perf record ls
  Error:
  perf_event_open(..., PERF_FLAG_FD_CLOEXEC) failed with unexpected error 16 (Device or resource busy)
  perf_event_open(..., 0) failed unexpectedly with error 16 (Device or resource busy)
  The PMU counters are busy/taken by another profiler.
  We found oprofile daemon running, please stop it and try again.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: William Cohen <wcohen@redhat.com>
Cc: Yann Droneaud <ydroneaud@opteya.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/cloexec.c |  4 ++--
 tools/perf/util/evsel.c   |  6 ++++++
 tools/perf/util/util.c    | 36 ++++++++++++++++++++++++++++++++++++
 tools/perf/util/util.h    |  1 +
 4 files changed, 45 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/cloexec.c b/tools/perf/util/cloexec.c
index c5d05ec17220..dede0c388ed4 100644
--- a/tools/perf/util/cloexec.c
+++ b/tools/perf/util/cloexec.c
@@ -25,7 +25,7 @@ static int perf_flag_probe(void)
 		return 1;
 	}
 
-	WARN_ONCE(err != EINVAL,
+	WARN_ONCE(err != EINVAL && err != EBUSY,
 		  "perf_event_open(..., PERF_FLAG_FD_CLOEXEC) failed with unexpected error %d (%s)\n",
 		  err, strerror(err));
 
@@ -33,7 +33,7 @@ static int perf_flag_probe(void)
 	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
 	err = errno;
 
-	if (WARN_ONCE(fd < 0,
+	if (WARN_ONCE(fd < 0 && err != EBUSY,
 		      "perf_event_open(..., 0) failed unexpectedly with error %d (%s)\n",
 		      err, strerror(err)))
 		return -1;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 21a373ebea22..180ce82d79ea 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -2036,6 +2036,12 @@ int perf_evsel__open_strerror(struct perf_evsel *evsel, struct target *target,
 	"No APIC? If so then you can boot the kernel with the \"lapic\" boot parameter to force-enable it.");
 #endif
 		break;
+	case EBUSY:
+		if (find_process("oprofiled"))
+			return scnprintf(msg, size,
+	"The PMU counters are busy/taken by another profiler.\n"
+	"We found oprofile daemon running, please stop it and try again.");
+		break;
 	default:
 		break;
 	}
diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index e52e7461911b..b82a93cb1694 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -536,3 +536,39 @@ void mem_bswap_64(void *src, int byte_size)
 		++m;
 	}
 }
+
+bool find_process(const char *name)
+{
+	size_t len = strlen(name);
+	DIR *dir;
+	struct dirent *d;
+	int ret = -1;
+
+	dir = opendir(procfs__mountpoint());
+	if (!dir)
+		return -1;
+
+	/* Walk through the directory. */
+	while (ret && (d = readdir(dir)) != NULL) {
+		char path[PATH_MAX];
+		char *data;
+		size_t size;
+
+		if ((d->d_type != DT_DIR) ||
+		     !strcmp(".", d->d_name) ||
+		     !strcmp("..", d->d_name))
+			continue;
+
+		scnprintf(path, sizeof(path), "%s/%s/comm",
+			  procfs__mountpoint(), d->d_name);
+
+		if (filename__read_str(path, &data, &size))
+			continue;
+
+		ret = strncmp(name, data, len);
+		free(data);
+	}
+
+	closedir(dir);
+	return ret ? false : true;
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 66864364ccb4..11d977db58a7 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -330,4 +330,5 @@ void mem_bswap_64(void *src, int byte_size);
 void mem_bswap_32(void *src, int byte_size);
 
 const char *get_filename_for_perf_kvm(void);
+bool find_process(const char *name);
 #endif /* GIT_COMPAT_UTIL_H */
-- 
1.8.3.1

