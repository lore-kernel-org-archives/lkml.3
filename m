Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935403Ab3DIRWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:22:12 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:58196 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934433Ab3DIRWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:22:06 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0ML008O-02-EED-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH 3/5] perf tools: Add breakpoint address mask to the mem event parser
Date: Tue, 9 Apr 2013 12:21:51 -0500
Message-ID: <1365528113-5458-4-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365528113-5458-1-git-send-email-jacob.shin@amd.com>
References: <1365528113-5458-1-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Allow perf tool to pass in breakpoint address mask to match an address
range, i.e.:

  $ perf stat -e mem:0x1000:w:0xf a.out

Will count writes to [0x1000 ~ 0x1010)

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Jacob Shin <jacob.shin@amd.com>
---
 tools/perf/util/parse-events.c |    3 ++-
 tools/perf/util/parse-events.h |    2 +-
 tools/perf/util/parse-events.y |   14 ++++++++++++--
 3 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 6c8bb0f..0744895 100644
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
diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index afc44c1..cfb0877 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -263,13 +263,23 @@ PE_NAME_CACHE_TYPE
 }
 
 event_legacy_mem:
+PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP ':' PE_VALUE sep_dc
+{
+	struct parse_events_evlist *data = _data;
+	struct list_head *list = NULL;
+
+	ABORT_ON(parse_events_add_breakpoint(&list, &data->idx,
+					     (void *) $2, $4, (void *) $6));
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
@@ -279,7 +289,7 @@ PE_PREFIX_MEM PE_VALUE sep_dc
 	struct list_head *list = NULL;
 
 	ABORT_ON(parse_events_add_breakpoint(&list, &data->idx,
-					     (void *) $2, NULL));
+					     (void *) $2, NULL, NULL));
 	$$ = list;
 }
 
-- 
1.7.9.5


