Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab3DWH5V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 03:57:21 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:2570 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755251Ab3DWH5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 03:57:18 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MLP7FD-01-BE4-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH V2 3/4] perf tools: Add hardware breakpoint address mask event parser
Date: Tue, 23 Apr 2013 02:57:04 -0500
Message-ID: <1366703825-19373-4-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1366703825-19373-1-git-send-email-jacob.shin@amd.com>
References: <1366703825-19373-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Allow perf tool to pass in breakpoint address mask to match an address
range, i.e.:

  $ perf stat -e mem:0x1000/0xf:w a.out

Will count writes to [0x1000 ~ 0x1010)

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 tools/perf/Documentation/perf-record.txt |   14 ++++++++++----
 tools/perf/util/parse-events.c           |    5 +++--
 tools/perf/util/parse-events.h           |    2 +-
 tools/perf/util/parse-events.l           |    1 +
 tools/perf/util/parse-events.y           |   24 ++++++++++++++++++++++--
 5 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index d4da111..c516320 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -33,13 +33,19 @@ OPTIONS
         - a raw PMU event (eventsel+umask) in the form of rNNN where NNN is a
 	  hexadecimal event descriptor.
 
-        - a hardware breakpoint event in the form of '\mem:addr[:access]'
-          where addr is the address in memory you want to break in.
-          Access is the memory access type (read, write, execute) it can
-          be passed as follows: '\mem:addr[:[r][w][x]]'.
+        - a hardware breakpoint event in the form of
+          '\mem:addr[/addr_mask][:access]' where addr is the address in
+          memory you want to break in. Access is the memory access type (read,
+          write, execute) it can be passed as follows: '\mem:addr[:[r][w][x]]'.
+          addr_mask is the "don't care" bit mask to further qualify the given
+          addr, to break in on accesses to an address range.
+
           If you want to profile read-write accesses in 0x1000, just set
           'mem:0x1000:rw'.
 
+          If you want to profile write accesses in [0x1000 ~ 0x1010), just set
+          'mem:0x1000/0xf:w'. (Only supported on some hardware)
+
 --filter=<filter>::
         Event filter.
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 6c8bb0f..0ca518f 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -508,12 +508,13 @@ do {					\
 }
 
 int parse_events_add_breakpoint(struct list_head **list, int *idx,
-				void *ptr, char *type)
+				void *ptr, char *type, void *msk)
 {
 	struct perf_event_attr attr;
 
 	memset(&attr, 0, sizeof(attr));
 	attr.bp_addr = (unsigned long) ptr;
+	attr.bp_addr_mask = (unsigned long) msk;
 
 	if (parse_breakpoint_type(type, &attr))
 		return -EINVAL;
@@ -1147,7 +1148,7 @@ void print_events(const char *event_glob, bool name_only)
 		printf("\n");
 
 		printf("  %-50s [%s]\n",
-		       "mem:<addr>[:access]",
+		       "mem:<addr>[/addr_mask][:access]",
 			event_type_descriptors[PERF_TYPE_BREAKPOINT]);
 		printf("\n");
 	}
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 8a48593..83920cc 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -92,7 +92,7 @@ int parse_events_add_numeric(struct list_head **list, int *idx,
 int parse_events_add_cache(struct list_head **list, int *idx,
 			   char *type, char *op_result1, char *op_result2);
 int parse_events_add_breakpoint(struct list_head **list, int *idx,
-				void *ptr, char *type);
+				void *ptr, char *type, void *msk);
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
index afc44c1..8b17979 100644
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
+					     (void *) $2, $6, (void *) $4));
+	$$ = list;
+}
+|
+PE_PREFIX_MEM PE_VALUE '/' PE_VALUE sep_dc
+{
+	struct parse_events_evlist *data = _data;
+	struct list_head *list = NULL;
+
+	ABORT_ON(parse_events_add_breakpoint(&list, &data->idx,
+					     (void *) $2, NULL, (void *) $4));
+	$$ = list;
+}
+|
 PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP sep_dc
 {
 	struct parse_events_evlist *data = _data;
 	struct list_head *list = NULL;
 
 	ABORT_ON(parse_events_add_breakpoint(&list, &data->idx,
-					     (void *) $2, $4));
+					     (void *) $2, $4, NULL));
 	$$ = list;
 }
 |
@@ -279,7 +299,7 @@ PE_PREFIX_MEM PE_VALUE sep_dc
 	struct list_head *list = NULL;
 
 	ABORT_ON(parse_events_add_breakpoint(&list, &data->idx,
-					     (void *) $2, NULL));
+					     (void *) $2, NULL, NULL));
 	$$ = list;
 }
 
-- 
1.7.9.5


