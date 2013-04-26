Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab3DZS6f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 14:58:35 -0400
Received: from [216.32.181.185] ([216.32.181.185]:26579 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753754Ab3DZS6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 14:58:33 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1155h)
X-WSS-ID: 0MLVM0C-02-028-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>, Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 2/3] perf tools: allow user to specify hardware breakpoint bp_len
Date: Fri, 26 Apr 2013 13:57:45 -0500
Message-ID: <1367002666-6910-3-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367002666-6910-1-git-send-email-jacob.shin@amd.com>
References: <1367002666-6910-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently bp_len is given a default value of 4. Allow user to override it:

  $ perf stat -e mem:0x1000/8
                            ^
                            bp_len

If no value is given, it will default to 4 as it did before.

Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 tools/perf/Documentation/perf-record.txt |    7 +++++--
 tools/perf/util/parse-events.c           |   10 ++++------
 tools/perf/util/parse-events.h           |    2 +-
 tools/perf/util/parse-events.l           |    1 +
 tools/perf/util/parse-events.y           |   24 ++++++++++++++++++++++--
 5 files changed, 33 insertions(+), 11 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index d4da111..d05973b 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -33,12 +33,15 @@ OPTIONS
         - a raw PMU event (eventsel+umask) in the form of rNNN where NNN is a
 	  hexadecimal event descriptor.
 
-        - a hardware breakpoint event in the form of '\mem:addr[:access]'
+        - a hardware breakpoint event in the form of '\mem:addr[/len][:access]'
           where addr is the address in memory you want to break in.
           Access is the memory access type (read, write, execute) it can
-          be passed as follows: '\mem:addr[:[r][w][x]]'.
+          be passed as follows: '\mem:addr[:[r][w][x]]'. len is the range,
+          number of bytes from specified addr, which the breakpoint will cover.
           If you want to profile read-write accesses in 0x1000, just set
           'mem:0x1000:rw'.
+          If you want to profile write accesses in [0x1000~1008), just set
+          'mem:0x1000/8:w'.
 
 --filter=<filter>::
         Event filter.
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 6c8bb0f..100583e 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -508,7 +508,7 @@ do {					\
 }
 
 int parse_events_add_breakpoint(struct list_head **list, int *idx,
-				void *ptr, char *type)
+				void *ptr, char *type, u64 len)
 {
 	struct perf_event_attr attr;
 
@@ -518,12 +518,10 @@ int parse_events_add_breakpoint(struct list_head **list, int *idx,
 	if (parse_breakpoint_type(type, &attr))
 		return -EINVAL;
 
-	/*
-	 * We should find a nice way to override the access length
-	 * Provide some defaults for now
-	 */
 	if (attr.bp_type == HW_BREAKPOINT_X)
 		attr.bp_len = sizeof(long);
+	else if (len)
+		attr.bp_len = len;
 	else
 		attr.bp_len = HW_BREAKPOINT_LEN_4;
 
@@ -1147,7 +1145,7 @@ void print_events(const char *event_glob, bool name_only)
 		printf("\n");
 
 		printf("  %-50s [%s]\n",
-		       "mem:<addr>[:access]",
+		       "mem:<addr>[/len][:access]",
 			event_type_descriptors[PERF_TYPE_BREAKPOINT]);
 		printf("\n");
 	}
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 8a48593..8655b83 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -92,7 +92,7 @@ int parse_events_add_numeric(struct list_head **list, int *idx,
 int parse_events_add_cache(struct list_head **list, int *idx,
 			   char *type, char *op_result1, char *op_result2);
 int parse_events_add_breakpoint(struct list_head **list, int *idx,
-				void *ptr, char *type);
+				void *ptr, char *type, u64 len);
 int parse_events_add_pmu(struct list_head **list, int *idx,
 			 char *pmu , struct list_head *head_config);
 void parse_events__set_leader(char *name, struct list_head *list);
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index e9d1134..15b3efc 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -191,6 +191,7 @@ r{num_raw_hex}		{ return raw(yyscanner); }
 <mem>{
 {modifier_bp}		{ return str(yyscanner, PE_MODIFIER_BP); }
 :			{ return ':'; }
+"/"			{ return '/'; }
 {num_dec}		{ return value(yyscanner, 10); }
 {num_hex}		{ return value(yyscanner, 16); }
 	/*
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index afc44c1..1751fb1 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -263,13 +263,33 @@ PE_NAME_CACHE_TYPE
 }
 
 event_legacy_mem:
+PE_PREFIX_MEM PE_VALUE '/' PE_VALUE ':' PE_MODIFIER_BP sep_dc
+{
+	struct parse_events_evlist *data = _data;
+	struct list_head *list = NULL;
+
+	ABORT_ON(parse_events_add_breakpoint(&list, &data->idx,
+					     (void *) $2, $6, $4));
+	$$ = list;
+}
+|
+PE_PREFIX_MEM PE_VALUE '/' PE_VALUE sep_dc
+{
+	struct parse_events_evlist *data = _data;
+	struct list_head *list = NULL;
+
+	ABORT_ON(parse_events_add_breakpoint(&list, &data->idx,
+					     (void *) $2, NULL, $4));
+	$$ = list;
+}
+|
 PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP sep_dc
 {
 	struct parse_events_evlist *data = _data;
 	struct list_head *list = NULL;
 
 	ABORT_ON(parse_events_add_breakpoint(&list, &data->idx,
-					     (void *) $2, $4));
+					     (void *) $2, $4, 0));
 	$$ = list;
 }
 |
@@ -279,7 +299,7 @@ PE_PREFIX_MEM PE_VALUE sep_dc
 	struct list_head *list = NULL;
 
 	ABORT_ON(parse_events_add_breakpoint(&list, &data->idx,
-					     (void *) $2, NULL));
+					     (void *) $2, NULL, 0));
 	$$ = list;
 }
 
-- 
1.7.9.5


