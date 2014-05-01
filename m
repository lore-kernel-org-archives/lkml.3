Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754274AbaEAGbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 02:31:07 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58138 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbaEAGbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 02:31:03 -0400
Date: Wed, 30 Apr 2014 23:30:48 -0700
From: tip-bot for Alexander Yarygin <tipbot@zytor.com>
Message-ID: <tip-2b9032e0ecb57de819bcf40b440e7cbd2d8f3a8c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, yarygin@linux.vnet.ibm.com, tglx@linutronix.de,
        borntraeger@de.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yarygin@linux.vnet.ibm.com, jolsa@kernel.org, tglx@linutronix.de,
        borntraeger@de.ibm.com
In-Reply-To: <1398440047-6641-2-git-send-email-yarygin@linux.vnet.ibm.com>
References: <1398440047-6641-2-git-send-email-yarygin@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Parse tracepoints with '-'
  in system name
Git-Commit-ID: 2b9032e0ecb57de819bcf40b440e7cbd2d8f3a8c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b9032e0ecb57de819bcf40b440e7cbd2d8f3a8c
Gitweb:     http://git.kernel.org/tip/2b9032e0ecb57de819bcf40b440e7cbd2d8f3a8c
Author:     Alexander Yarygin <yarygin@linux.vnet.ibm.com>
AuthorDate: Fri, 25 Apr 2014 17:34:05 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Tue, 29 Apr 2014 14:27:23 +0200

perf tools: Parse tracepoints with '-' in system name

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
