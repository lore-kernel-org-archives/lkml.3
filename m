Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbaCXUsu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 16:48:50 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:55962 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753813AbaCXUsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 16:48:47 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH] perf/tool: Fix usage of trace events with '-' in trace system name.
Date: Mon, 24 Mar 2014 21:49:00 +0100
Message-Id: <1395694140-43447-1-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.8.4.2
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032420-6892-0000-0000-0000083BDC93
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Yarygin <yarygin@linux.vnet.ibm.com>

Trace events potentially can have a '-' in their trace system name,
e.g. kvm on s390 defines kvm-s390:* tracepoints.
tools/perf could not parse them, because there was no rule for this:
$ sudo ./perf top -e "kvm-s390:*"
invalid or unsupported event: 'kvm-s390:*'

This patch adds an extra rule to event_legacy_tracepoint which handles
those cases. Without the patch, perf will not accept such tracepoints in
the -e option.

Signed-off-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 tools/perf/util/parse-events.y | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/perf/util/parse-events.y b/tools/perf/util/parse-events.y
index 4eb67ec..dbbb01c 100644
--- a/tools/perf/util/parse-events.y
+++ b/tools/perf/util/parse-events.y
@@ -299,6 +299,18 @@ PE_PREFIX_MEM PE_VALUE sep_dc
 }
 
 event_legacy_tracepoint:
+PE_NAME '-' PE_NAME ':' PE_NAME
+{
+	struct parse_events_evlist *data = _data;
+	struct list_head *list;
+	char sys_name[strlen($1) + strlen($3) + 2];
+	sprintf(&sys_name, "%s-%s", $1, $3);
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
1.8.4.2

