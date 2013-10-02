Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab3JBQMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:12:43 -0400
Received: from mail-db9lp0252.outbound.messaging.microsoft.com ([213.199.154.252]:49886
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753257Ab3JBQLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:11:21 -0400
X-Forefront-Antispam-Report: CIP:165.204.84.221;KIP:(null);UIP:(null);IPV:NLI;H:atltwp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzd2iz1de098h1de097h8275bhz2dh839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h1155h)
X-WSS-ID: 0MU1U11-07-58Z-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <fweisbec@gmail.com>, <mingo@kernel.org>, <mingo@redhat.com>,
        <jacob.w.shin@gmail.com>
CC: <oleg@redhat.com>, <a.p.zijlstra@chello.nl>, <acme@ghostprotocols.net>,
        <hpa@zytor.com>, <tgl@domain.invalid>, <linux-kernel@vger.kernel.org>,
        <sherry.hurwitz@amd.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 2/3] perf tools: allow user to specify hardware breakpoint bp_len
Date: Wed, 2 Oct 2013 11:11:07 -0500
Message-ID: <1380730268-25807-3-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380730268-25807-1-git-send-email-suravee.suthikulpanit@amd.com>
References: <1380730268-25807-1-git-send-email-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jacob Shin <jacob.w.shin@gmail.com>

Currently bp_len is given a default value of 4. Allow user to override it:

  $ perf stat -e mem:0x1000/8
                            ^
                            bp_len

If no value is given, it will default to 4 as it did before.

Signed-off-by: Jacob Shin <jacob.w.shin@gmail.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 tools/perf/Documentation/perf-record.txt |  7 +++++--
 tools/perf/util/parse-events.c           | 17 +++++++----------
 tools/perf/util/parse-events.h           |  2 +-
 tools/perf/util/parse-events.l           |  1 +
 tools/perf/util/parse-events.y           | 26 ++++++++++++++++++++++++--
 5 files changed, 38 insertions(+), 15 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index e297b74..e07491f 100644
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
index 9812531..65d81ae 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -515,7 +515,7 @@ do {					\
 }
 
 int parse_events_add_breakpoint(struct list_head *list, int *idx,
-				void *ptr, char *type)
+				void *ptr, char *type, u64 len)
 {
 	struct perf_event_attr attr;
 
@@ -525,14 +525,11 @@ int parse_events_add_breakpoint(struct list_head *list, int *idx,
 	if (parse_breakpoint_type(type, &attr))
 		return -EINVAL;
 
-	/*
-	 * We should find a nice way to override the access length
-	 * Provide some defaults for now
-	 */
-	if (attr.bp_type == HW_BREAKPOINT_X)
-		attr.bp_len = sizeof(long);
-	else
-		attr.bp_len = HW_BREAKPOINT_LEN_4;
+	/* Provide some defaults if len is not specified */
+	if (!len)
+		len = attr.bp_type == HW_BREAKPOINT_X ? sizeof(long) :
+							HW_BREAKPOINT_LEN_4;
+	attr.bp_len = len;
 
 	attr.type = PERF_TYPE_BREAKPOINT;
 	attr.sample_period = 1;
@@ -1238,7 +1235,7 @@ void print_events(const char *event_glob, bool name_only)
 		printf("\n");
 
 		printf("  %-50s [%s]\n",
-		       "mem:<addr>[:access]",
+		       "mem:<addr>[/len][:access]",
 			event_type_descriptors[PERF_TYPE_BREAKPOINT]);
 		printf("\n");
 	}
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index f1cb4c4..54a20df 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -93,7 +93,7 @@ int parse_events_add_numeric(struct list_head *list, int *idx,
 int parse_events_add_cache(struct list_head *list, int *idx,
 			   char *type, char *op_result1, char *op_result2);
 int parse_events_add_breakpoint(struct list_head *list, int *idx,
-				void *ptr, char *type);
+				void *ptr, char *type, u64 len);
 int parse_events_add_pmu(struct list_head *list, int *idx,
 			 char *pmu , struct list_head *head_config);
 void parse_events__set_leader(char *name, struct list_head *list);
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 91346b7..2fde75f 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -193,6 +193,7 @@ r{num_raw_hex}		{ return raw(yyscanner); }
 <mem>{
 {modifier_bp}		{ return str(yyscanner, PE_MODIFIER_BP); }
 :			{ return ':'; }
+"/"			{ return '/'; }
 {num_dec}		{ return value(yyscanner, 10); }
 {num_hex}		{ return value(yyscanner, 16); }
 	/*
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 4eb67ec..c9adf4d 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -276,6 +276,28 @@ PE_NAME_CACHE_TYPE
 }
 
 event_legacy_mem:
+PE_PREFIX_MEM PE_VALUE '/' PE_VALUE ':' PE_MODIFIER_BP sep_dc
+{
+	struct parse_events_evlist *data = _data;
+	struct list_head *list;
+
+	ALLOC_LIST(list);
+	ABORT_ON(parse_events_add_breakpoint(list, &data->idx,
+					     (void *) $2, $6, $4));
+	$$ = list;
+}
+|
+PE_PREFIX_MEM PE_VALUE '/' PE_VALUE sep_dc
+{
+	struct parse_events_evlist *data = _data;
+	struct list_head *list;
+
+	ALLOC_LIST(list);
+	ABORT_ON(parse_events_add_breakpoint(list, &data->idx,
+					     (void *) $2, NULL, $4));
+	$$ = list;
+}
+|
 PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP sep_dc
 {
 	struct parse_events_evlist *data = _data;
@@ -283,7 +305,7 @@ PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP sep_dc
 
 	ALLOC_LIST(list);
 	ABORT_ON(parse_events_add_breakpoint(list, &data->idx,
-					     (void *) $2, $4));
+					     (void *) $2, $4, 0));
 	$$ = list;
 }
 |
@@ -294,7 +316,7 @@ PE_PREFIX_MEM PE_VALUE sep_dc
 
 	ALLOC_LIST(list);
 	ABORT_ON(parse_events_add_breakpoint(list, &data->idx,
-					     (void *) $2, NULL));
+					     (void *) $2, NULL, 0));
 	$$ = list;
 }
 
-- 
1.8.1.2


