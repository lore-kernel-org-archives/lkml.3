Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933316Ab3GQRum (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 13:50:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756620Ab3GQRuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 13:50:40 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 06/23] perf doc: Add perf data file documentation
Date: Wed, 17 Jul 2013 19:49:46 +0200
Message-Id: <1374083403-14591-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
References: <1374083403-14591-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding perf data file documentation.

TODO: Finish the FEATURES section

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/Documentation/perf-data-file-v2.txt | 255 +++++++++++++++++++++++++
 1 file changed, 255 insertions(+)
 create mode 100644 tools/perf/Documentation/perf-data-file-v2.txt

diff --git a/tools/perf/Documentation/perf-data-file-v2.txt b/tools/perf/Documentation/perf-data-file-v2.txt
new file mode 100644
index 0000000..3931dca
--- /dev/null
+++ b/tools/perf/Documentation/perf-data-file-v2.txt
@@ -0,0 +1,255 @@
+perf-data-file-v2(1)
+====================
+Following text describes version 2 of the perf data file format,
+which is version that is currently used by perf tool.
+
+The perf data file format is composed of several sections
+describing monitored events and the data itself.
+
+High level view of the format:
+  FILE HEADER
+  EVENT IDS
+  EVENT ATTRIBUTES
+  EVENT TYPES
+  EVENT DATA
+  FEATURES
+
+
+COMMON PRIMITIVES
+-----------------
+Following definitions are used as primitives on multiple places
+within the perf data file.
+
+struct perf_file_section::
+  Used to determine location of data sections within the file.
+
+  struct perf_file_section {
+        u64 offset;
+        u64 size;
+  };
+
+  offset  section location (offset) within the file
+  size    section size in bytes
+
+
+FILE HEADER
+-----------
+Starting point of the data file with magic bytes and global
+section information.
+
+The section contains following data:
+  struct perf_file_header header
+
+struct perf_file_header::
+	struct perf_file_header {
+		u64                             magic;
+		u64                             size;
+		u64                             attr_size;
+		struct perf_file_section        attrs;
+		struct perf_file_section        data;
+		struct perf_file_section        event_types;
+		DECLARE_BITMAP(adds_features, HEADER_FEAT_BITS);
+	}
+
+	magic           ID 'PERFFILE|PERFILE2'
+	size            header size minus sizeof(struct perf_file_header)
+	attr_size       attribute size minus sizeof(struct perf_file_attr)
+	attrs           location of 'EVENT ATTRIBUTES'
+	data            location of 'EVENT DATA'
+	event_types     location of 'EVENT TYPES'
+	adds_features   'FEATURES' bitmask
+
+
+EVENT IDS
+---------
+This section contains CPU related IDs for each monitored event.
+It is used only if there was more than 1 events monitored. The
+reason is to be able to map event's data to event definition.
+
+The section contains following data:
+  u64  event1_ids[]
+  u64  event2_ids[]
+  ...
+  u64  eventX_ids[]
+
+eventX_ids::
+  per-cpu event X IDs array
+  this array is referenced in 'EVENT ATTRIBUTES'
+
+
+EVENT ATTRIBUTES
+----------------
+This section contains attribute information together with the
+location of the IDs array for each event.
+
+The section contains following data:
+  struct perf_file_attr  attrs[]
+
+struct perf_file_attr::
+  struct perf_file_attr {
+        struct perf_event_attr    attr;
+        struct perf_file_section  ids;
+  }
+
+  attr  perf event interface structure for each event
+  ids   IDs location for event in 'EVENT IDS' section
+
+
+EVENT TYPES
+-----------
+This section map event's config value (struct perf_event_attr::config)
+with the event name.
+
+The section contains following data:
+  struct perf_trace_event_type  types[]
+
+#define MAX_EVENT_NAME 64
+
+struct perf_trace_event_type::
+  struct perf_trace_event_type {
+        u64   event_id;
+        char  name[MAX_EVENT_NAME];
+  };
+
+  event_id  struct perf_event_attr::config value
+  name      event name
+
+NOTE This section got deprecated and its data are no longer stored.
+     The 'event_types' location in the header is zero-ed.
+
+
+EVENT DATA
+----------
+This section contains blob of all events' data - auxiliary events
+and samples.
+
+
+FEATURES
+--------
+This section contains various configuration data and its contents
+depends on the header's adds_features bitmask. Each bit in this
+bitmask represent a single feature (0 - NOT present, 1 present).
+
+The section contains following data:
+  struct perf_file_section feature_locations[nr_features];
+
+  nr_features        number of present features bitmap_weight(adds_features)
+  feature_locations  location of each feature data
+
+Available features (possible max 256):
+  enum {
+        HEADER_RESERVED         = 0,
+        HEADER_TRACING_DATA     = 1,
+        HEADER_BUILD_ID,
+        HEADER_HOSTNAME,
+        HEADER_OSRELEASE,
+        HEADER_VERSION,
+        HEADER_ARCH,
+        HEADER_NRCPUS,
+        HEADER_CPUDESC,
+        HEADER_CPUID,
+        HEADER_TOTAL_MEM,
+        HEADER_CMDLINE,
+        HEADER_EVENT_DESC,
+        HEADER_CPU_TOPOLOGY,
+        HEADER_NUMA_TOPOLOGY,
+        HEADER_BRANCH_STACK,
+        HEADER_PMU_MAPPINGS,
+        HEADER_GROUP_DESC,
+        HEADER_LAST_FEATURE,
+        HEADER_FEAT_BITS        = 256,
+  }
+
+
+TODO finish FEATURES::* sections descriptions.
+
+FEATURES::HEADER_RESERVED
+-------------------------
+allways zero bit
+
+
+FEATURES::HEADER_TRACING_DATA
+-----------------------------
+tracing data
+
+
+FEATURES::HEADER_BUILD_ID
+-------------------------
+build ids
+
+
+FEATURES::HEADER_HOSTNAME
+-------------------------
+uname hostname
+
+
+FEATURES::HEADER_OSRELEASE
+--------------------------
+uname osrelease
+
+
+FEATURES::HEADER_VERSION
+------------------------
+perf version
+
+
+FEATURES::HEADER_ARCH
+---------------------
+uname arch
+
+
+FEATURES::HEADER_NRCPUS
+-----------------------
+offset          size(B) description
+0               4       sysconf(_SC_NPROCESSORS_CONF)
+4               4       sysconf(_SC_NPROCESSORS_ONLN)
+
+
+FEATURES::HEADER_CPUDESC
+------------------------
+/proc/cpuinfo data for 'Model name'
+
+
+FEATURES::HEADER_CPUID
+----------------------
+'vendor,family,model,step'
+
+
+FEATURES::HEADER_TOTAL_MEM
+--------------------------
+/proc/meminfo data for 'MemTotal'
+
+
+FEATURES::HEADER_CMDLINE
+------------------------
+perf complete command line
+
+
+FEATURES::HEADER_EVENT_DESC
+---------------------------
+event attributes plus related info(ids)
+
+
+FEATURES::HEADER_CPU_TOPOLOGY
+-----------------------------
+cpu topology
+
+
+FEATURES::HEADER_NUMA_TOPOLOGY
+------------------------------
+numa topology
+
+
+FEATURES::HEADER_BRANCH_STACK
+-----------------------------
+nothing
+
+
+FEATURES::HEADER_PMU_MAPPINGS
+-----------------------------
+available pmus
+
+
+FEATURES::HEADER_GROUP_DESC
+---------------------------
+event groups info
-- 
1.7.11.7

