Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932457Ab3GBUYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 16:24:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4154 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569Ab3GBUY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 16:24:28 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=fUn4yX_rMIUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=PAeOUu9xePkA:10 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=J9qbYULwuoSPCMvwlroA:9 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130702202426.151542980@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 02 Jul 2013 16:22:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>
Subject: [for-next][PATCH 06/14] tracing: Fix disabling of soft disable
References: <20130702202216.623562799@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-Fix-disabling-of-soft-disable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Zanussi <tom.zanussi@linux.intel.com>

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

Link: http://lkml.kernel.org/r/b9c68dd50bc07019e6c67d3f9b29be4ef1b2badb.1372479499.git.tom.zanussi@linux.intel.com

Signed-off-by: Tom Zanussi <tom.zanussi@linux.intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 7ee08b9..5892470 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -291,9 +291,11 @@ static int __ftrace_event_enable_disable(struct ftrace_event_file *file,
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
1.7.10.4


