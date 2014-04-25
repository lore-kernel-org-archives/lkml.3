Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaDYPbt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 11:31:49 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:40843 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbaDYPbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 11:31:45 -0400
From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        KVM <kvm@vger.kernel.org>, linux-s390 <linux-s390@vger.kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Subject: [PATCH 1/3] perf tools: parse tracepooints with '-' in system name
Date: Fri, 25 Apr 2014 17:34:05 +0200
Message-Id: <1398440047-6641-2-git-send-email-yarygin@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1398440047-6641-1-git-send-email-yarygin@linux.vnet.ibm.com>
References: <1398440047-6641-1-git-send-email-yarygin@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14042515-1948-0000-0000-000008959FD6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trace events potentially can have a '-' in their trace system name,
e.g. kvm on s390 defines kvm-s390:* tracepoints.
tools/perf could not parse them, because there was no rule for this:
$ sudo ./perf top -e "kvm-s390:*"
invalid or unsupported event: 'kvm-s390:*'

This patch adds an extra rule to event_legacy_tracepoint which handles
those cases. Without the patch, perf will not accept such tracepoints in
the -e option.

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
---
 tools/perf/util/parse-events.y |   12 ++++++++++++
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
1.7.9.5

