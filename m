Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab3AUVRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:17:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23974 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab3AUVR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:17:29 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Kiw974fKNy8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=CcEbnNnFbiYA:10 a=20KFwNOVAAAA:8 a=IpekacLhIKQ0iGG4xqEA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130121211727.461496092@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 21 Jan 2013 16:14:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: [PATCH 01/13 -next] tracing: Fix sparse warning with is_signed_type() macro
References: <20130121211403.337052956@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Fix-sparse-warning-with-is_signed_type-macro.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Sparse complains when is_signed_type() is used on a pointer.
This macro is needed for the format output used for ftrace
and perf, to know if a binary field is a signed type or not.
The is_signed_type() macro is used against all fields that are
recorded by events to automate the operation.

The problem sparse has is with the current way is_signed_type()
works:

  ((type)-1 < 0)

If "type" is a poiner, than sparse does not like it being compared
to an integer (zero). The simple fix is to just give zero the
same type. The runtime result stays the same.

Reported-by: Robert Jarzmik <robert.jarzmik@free.fr>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/ftrace_event.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index a3d4895..43ef8b6 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -272,7 +272,7 @@ extern int trace_define_field(struct ftrace_event_call *call, const char *type,
 extern int trace_add_event_call(struct ftrace_event_call *call);
 extern void trace_remove_event_call(struct ftrace_event_call *call);
 
-#define is_signed_type(type)	(((type)(-1)) < 0)
+#define is_signed_type(type)	(((type)(-1)) < (type)0)
 
 int trace_set_clr_event(const char *system, const char *event, int set);
 
-- 
1.7.10.4


