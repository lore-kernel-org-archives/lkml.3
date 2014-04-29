Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609AbaD2NsE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:48:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752533AbaD2NsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:48:01 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 2/6] perf tools: Parse tracepoints with '-' in system name
Date: Tue, 29 Apr 2014 15:47:46 +0200
Message-Id: <1398779270-10271-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1398779270-10271-1-git-send-email-jolsa@kernel.org>
References: <1398779270-10271-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>

Trace events potentially can have a '-' in their trace system name,
e.g. kvm on s390 defines kvm-s390:* tracepoints.
We could not parse them, because there was no rule for this:
  $ sudo ./perf top -e "kvm-s390:*"
  invalid or unsupported event: 'kvm-s390:*'

This patch adds an extra rule to event_legacy_tracepoint which handles
those cases. Without the patch, perf will not accept such tracepoints in
the -e option.

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Link: http://lkml.kernel.org/r/1398440047-6641-2-git-send-email-yarygin@linux.vnet.ibm.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/parse-events.y | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 4eb67ec..ac9db9f 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -299,6 +299,18 @@ PE_PREFIX_MEM PE_VALUE sep_dc
 }
 
 event_legacy_tracepoint:
+PE_NAME '-' PE_NAME ':' PE_NAME
+{
+	struct parse_events_evlist *data = _data;
+	struct list_head *list;
+	char sys_name[128];
+	snprintf(&sys_name, 128, "%s-%s", $1, $3);
+
+	ALLOC_LIST(list);
+	ABORT_ON(parse_events_add_tracepoint(list, &data->idx, &sys_name, $5));
+	$$ = list;
+}
+|
 PE_NAME ':' PE_NAME
 {
 	struct parse_events_evlist *data = _data;
-- 
1.8.3.1

