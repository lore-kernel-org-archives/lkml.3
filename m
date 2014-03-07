Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875AbaCGPRg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:17:36 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:49596 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752486AbaCGPME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:12:04 -0500
Message-Id: <20140307151202.999179448@goodmis.org>
User-Agent: quilt/0.61-1
Date: Fri, 07 Mar 2014 10:09:33 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Filipe Brandenburger <filbranden@google.com>
Subject: [for-next][PATCH 13/20] tracing: Evaluate len expression only once in __dynamic_array macro
References: <20140307150920.881849073@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline; filename=0013-tracing-Evaluate-len-expression-only-once-in-__dynam.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Filipe Brandenburger <filbranden@google.com>

Use a temporary variable to store the expansion of the len expression.
If the evaluation is expensive, this commit will ensure it is evaluated
only once inside ftrace_get_offsets_<call>.

Link: http://lkml.kernel.org/r/1393651938-16418-3-git-send-email-filbranden@google.com

Signed-off-by: Filipe Brandenburger <filbranden@google.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/ftrace.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 2125005..e15ae401 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -361,10 +361,11 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 
 #undef __dynamic_array
 #define __dynamic_array(type, item, len)				\
+	__item_length = (len) * sizeof(type);				\
 	__data_offsets->item = __data_size +				\
 			       offsetof(typeof(*entry), __data);	\
-	__data_offsets->item |= ((len) * sizeof(type)) << 16;		\
-	__data_size += (len) * sizeof(type);
+	__data_offsets->item |= __item_length << 16;			\
+	__data_size += __item_length;
 
 #undef __string
 #define __string(item, src) __dynamic_array(char, item,			\
@@ -376,6 +377,7 @@ static inline notrace int ftrace_get_offsets_##call(			\
 	struct ftrace_data_offsets_##call *__data_offsets, proto)       \
 {									\
 	int __data_size = 0;						\
+	int __maybe_unused __item_length;				\
 	struct ftrace_raw_##call __maybe_unused *entry;			\
 									\
 	tstruct;							\
-- 
1.8.5.3


