Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753796AbaCGPQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:16:05 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:47773 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752858AbaCGPMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:12:05 -0500
Message-Id: <20140307151202.837358428@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 07 Mar 2014 10:09:32 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Filipe Brandenburger <filbranden@google.com>
Subject: [for-next][PATCH 12/20] tracing: Correctly expand len expressions from __dynamic_array macro
References: <20140307150920.881849073@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0012-tracing-Correctly-expand-len-expressions-from-__dyna.patch
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Filipe Brandenburger <filbranden@google.com>

This fixes expansion of the len argument in __dynamic_array macros.
The previous code from commit 7d536cb3f would not fully evaluate the
expression before multiplying its result by the size of the type.

This went unnoticed because the length stored in the high 16 bits of the
offset (which is the one that was broken here) is only used by
filter_pred_strloc which only acts on strings for which the size of the
type is 1.

Link: http://lkml.kernel.org/r/1393651938-16418-2-git-send-email-filbranden@google.com

Signed-off-by: Filipe Brandenburger <filbranden@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/ftrace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 1cc2265..2125005 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -363,7 +363,7 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 #define __dynamic_array(type, item, len)				\
 	__data_offsets->item = __data_size +				\
 			       offsetof(typeof(*entry), __data);	\
-	__data_offsets->item |= (len * sizeof(type)) << 16;		\
+	__data_offsets->item |= ((len) * sizeof(type)) << 16;		\
 	__data_size += (len) * sizeof(type);
 
 #undef __string
-- 
1.8.5.3


