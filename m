Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab3FFPX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 11:23:27 -0400
Received: from usindpps05.hds.com ([207.126.252.18]:54621 "EHLO
	usindpps05.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab3FFPXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 11:23:25 -0400
Message-ID: <51B0A942.8060301@hds.com>
Date: Thu, 06 Jun 2013 11:22:42 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, rostedt@goodmis.org, hpa@zytor.com
CC: tglx@linutronix.de, mingo@elte.hu, bp@alien8.de,
        linux-edac@vger.kernel.org, tony.luck@intel.com,
        dle-develop@lists.sourceforge.net, tomoki.sekiyama@hds.com
Subject: [PATCH v14 1/3] tracing: Add DEFINE_EVENT_FN() macro
References: <51B0A90F.7030309@hds.com>
In-Reply-To: <51B0A90F.7030309@hds.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8626,1.0.431,0.0.0000
 definitions=2013-06-06_07:2013-06-06,2013-06-06,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 ipscore=0
 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=6.0.2-1211240000
 definitions=main-1306060114
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Each TRACE_EVENT() adds several helper functions. If two or more trace events
share the same structure and print format, they can also share most of these
helper functions and save a lot of space from duplicate code. This is why the
DECLARE_EVENT_CLASS() and DEFINE_EVENT() were created.

Some events require a trigger to be called at registering and unregistering of
the event and to do so they use TRACE_EVENT_FN().

If multiple events require a trigger, they currently have no choice but to use
TRACE_EVENT_FN() as there's no DEFINE_EVENT_FN() available. This unfortunately
causes a lot of wasted duplicate code created.

By adding a DEFINE_EVENT_FN(), these events can still use a
DECLARE_EVENT_CLASS() and then define their own triggers.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>
---
 include/linux/tracepoint.h   |    2 ++
 include/trace/define_trace.h |    5 +++++
 include/trace/ftrace.h       |    4 ++++
 3 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 2f322c3..9bf59e5 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -378,6 +378,8 @@ static inline void tracepoint_synchronize_unregister(void)
 #define DECLARE_EVENT_CLASS(name, proto, args, tstruct, assign, print)
 #define DEFINE_EVENT(template, name, proto, args)		\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
+#define DEFINE_EVENT_FN(template, name, proto, args, reg, unreg)\
+	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
 	DECLARE_TRACE(name, PARAMS(proto), PARAMS(args))
 #define DEFINE_EVENT_CONDITION(template, name, proto,		\
diff --git a/include/trace/define_trace.h b/include/trace/define_trace.h
index 1905ca8..02e1003 100644
--- a/include/trace/define_trace.h
+++ b/include/trace/define_trace.h
@@ -44,6 +44,10 @@
 #define DEFINE_EVENT(template, name, proto, args) \
 	DEFINE_TRACE(name)
 
+#undef DEFINE_EVENT_FN
+#define DEFINE_EVENT_FN(template, name, proto, args, reg, unreg) \
+	DEFINE_TRACE_FN(name, reg, unreg)
+
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
 	DEFINE_TRACE(name)
@@ -91,6 +95,7 @@
 #undef TRACE_EVENT_CONDITION
 #undef DECLARE_EVENT_CLASS
 #undef DEFINE_EVENT
+#undef DEFINE_EVENT_FN
 #undef DEFINE_EVENT_PRINT
 #undef DEFINE_EVENT_CONDITION
 #undef TRACE_HEADER_MULTI_READ
diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 19edd7f..d615f78 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -71,6 +71,10 @@
 	static struct ftrace_event_call	__used		\
 	__attribute__((__aligned__(4))) event_##name
 
+#undef DEFINE_EVENT_FN
+#define DEFINE_EVENT_FN(template, name, proto, args, reg, unreg)	\
+	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
+
 #undef DEFINE_EVENT_PRINT
 #define DEFINE_EVENT_PRINT(template, name, proto, args, print)	\
 	DEFINE_EVENT(template, name, PARAMS(proto), PARAMS(args))
-- 
1.7.1


