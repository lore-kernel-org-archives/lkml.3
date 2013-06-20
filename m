Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030461Ab3FTSdk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 14:33:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:12528 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161087Ab3FTSbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 14:31:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,906,1363158000"; 
   d="scan'208";a="356936092"
From: Tom Zanussi <tom.zanussi@linux.intel.com>
To: rostedt@goodmis.org
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [PATCH 04/11] tracing: fix disabling of soft disable
Date: Thu, 20 Jun 2013 13:31:28 -0500
Message-Id: <f369f565dc440f40f027de0387c99dda4d36154e.1371751701.git.tom.zanussi@linux.intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <cover.1371751701.git.tom.zanussi@linux.intel.com>
References: <cover.1371751701.git.tom.zanussi@linux.intel.com>
In-Reply-To: <cover.1371751701.git.tom.zanussi@linux.intel.com>
References: <cover.1371751701.git.tom.zanussi@linux.intel.com>
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
 kernel/trace/trace_events.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index ecb2609..f9738dc 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -282,6 +282,8 @@ static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
 		/* If in SOFT_MODE, just set the SOFT_DISABLE_BIT */
 		if (file->flags & FTRACE_EVENT_FL_SOFT_MODE)
 			set_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &file->flags);
+		else
+			clear_bit(FTRACE_EVENT_FL_SOFT_DISABLED_BIT, &file->flags);
 		break;
 	case 1:
 		/*
-- 
1.7.11.4

