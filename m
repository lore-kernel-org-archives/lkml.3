Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755861Ab3AJULM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 15:11:12 -0500
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:39522
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754495Ab3AJULK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 15:11:10 -0500
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(z551bizzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1155h)
X-WSS-ID: 0MGFEQH-01-0VW-02
X-M-MSG: 
From: Jacob Shin <jacob.shin@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <x86@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Jacob Shin <jacob.shin@amd.com>
Subject: [PATCH RESEND 3/5] perf tools: Add breakpoint address mask to the mem event parser
Date: Thu, 10 Jan 2013 14:10:57 -0600
Message-ID: <1357848659-4786-4-git-send-email-jacob.shin@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357848659-4786-1-git-send-email-jacob.shin@amd.com>
References: <1357848659-4786-1-git-send-email-jacob.shin@amd.com>
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
index 2d8d53be..2679e48 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -466,12 +466,13 @@ do {					\
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
index b7af80b..5b7905c 100644
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
index 0f9914a..e8ac05d 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -254,13 +254,23 @@ PE_NAME_CACHE_TYPE
 }
 
 event_legacy_mem:
+PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP ':' PE_VALUE sep_dc
+{
+	struct parse_events_data__events *data = _data;
+	struct list_head *list = NULL;
+
+	ABORT_ON(parse_events_add_breakpoint(&list, &data->idx,
+					     (void *) $2, $4, (void *) $6));
+	$$ = list;
+}
+|
 PE_PREFIX_MEM PE_VALUE ':' PE_MODIFIER_BP sep_dc
 {
 	struct parse_events_data__events *data = _data;
 	struct list_head *list = NULL;
 
 	ABORT_ON(parse_events_add_breakpoint(&list, &data->idx,
-					     (void *) $2, $4));
+					     (void *) $2, $4, NULL));
 	$$ = list;
 }
 |
@@ -270,7 +280,7 @@ PE_PREFIX_MEM PE_VALUE sep_dc
 	struct list_head *list = NULL;
 
 	ABORT_ON(parse_events_add_breakpoint(&list, &data->idx,
-					     (void *) $2, NULL));
+					     (void *) $2, NULL, NULL));
 	$$ = list;
 }
 
-- 
1.7.9.5


