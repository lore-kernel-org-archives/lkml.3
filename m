Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab3F2FI0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 01:08:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:59103 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752151Ab3F2FIY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 01:08:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,963,1363158000"; 
   d="scan'208";a="362388473"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, jovi.zhangwei@huawei.com,
        linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH v2 04/11] tracing: fix disabling of soft disable
Date: Sat, 29 Jun 2013 00:08:07 -0500
Message-Id: <b9c68dd50bc07019e6c67d3f9b29be4ef1b2badb.1372479499.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1372479499.git.tom.zanussi@linux.intel.com>
References: <cover.1372479499.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1372479499.git.tom.zanussi@linux.intel.com>
References: <cover.1372479499.git.tom.zanussi@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment on the soft disable 'disable' case of
__ftrace_event_enable_disable() states that the soft disable bit
should be cleared in that case, but currently only the soft mode bit
is actually cleared.

This essentially leaves the standard non-soft-enable enable/disable
paths as the only way to clear the soft disable flag, but the soft
disable bit should also be cleared when removing a trigger with '!'.

Also, the SOFT_DISABLED bit should never be set if SOFT_MODE is
cleared.

This fixes the above discrepancies.

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
---
 kernel/trace/trace_events.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index ecb2609..51d4390 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -279,9 +279,11 @@ static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
 			}
 			call->class->reg(call, TRACE_REG_UNREGISTER, file);
 		}
-		/* If in SOFT_MODE, just set the SOFT_DISABLE_BIT */
+		/* If in SOFT_MODE, just set the SOFT_DISABLE_BIT, else clear it */
 		if (file->flags & FTRACE_EVENT_FL_SOFT_MODE)
 			set_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &file->flags);
+		else
+			clear_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &file->flags);
 		break;
 	case 1:
 		/*
-- 
1.7.11.4

