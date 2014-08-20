Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbaHTMmL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:42:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:49091 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbaHTMmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:42:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,902,1400050800"; 
   d="scan'208";a="561070485"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [PATCH v4 06/22] perf: Redirect output from inherited events to parents
Date: Wed, 20 Aug 2014 15:36:03 +0300
Message-Id: <1408538179-792-7-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to collect AUX data from an inherited event, we can redirect its
output to parent's ring buffer if possible (they must be cpu affine). This
patch adds set_output() to the inheritance path.

Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
---
 kernel/events/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 67f857ab56..e36478564c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7962,6 +7962,12 @@ inherit_event(struct perf_event *parent_event,
 		= parent_event->overflow_handler_context;
 
 	/*
+	 * Direct child's output to parent's ring buffer (if any)
+	 */
+	if (parent_event->cpu != -1)
+		(void)perf_event_set_output(child_event, parent_event);
+
+	/*
 	 * Precalculate sample_data sizes
 	 */
 	perf_event__header_size(child_event);
-- 
2.1.0

