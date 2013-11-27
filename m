Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760094Ab3K0Bj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:39:58 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:6392 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754902Ab3K0Bjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:39:52 -0500
Message-Id: <20131127013950.554666913@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Nov 2013 20:38:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>
Subject: [PATCH 1/2] tracing: Allow events to have NULL strings
References: <20131127013841.321519823@goodmis.org>
Content-Disposition: inline; filename=0001-tracing-Allow-events-to-have-NULL-strings.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

If an TRACE_EVENT() uses __assign_str() or __get_str on a NULL pointer
then the following oops will happen:

BUG: unable to handle kernel NULL pointer dereference at   (null)
IP: [<c127a17b>] strlen+0x10/0x1a
*pde = 00000000 ^M
Oops: 0000 [#1] PREEMPT SMP
Modules linked in:
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.13.0-rc1-test+ #2
Hardware name:                  /DG965MQ, BIOS MQ96510J.86A.0372.2006.0605.1717 06/05/2006^M
task: f5cde9f0 ti: f5e5e000 task.ti: f5e5e000
EIP: 0060:[<c127a17b>] EFLAGS: 00210046 CPU: 1
EIP is at strlen+0x10/0x1a
EAX: 00000000 EBX: c2472da8 ECX: ffffffff EDX: c2472da8
ESI: c1c5e5fc EDI: 00000000 EBP: f5e5fe84 ESP: f5e5fe80
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
CR0: 8005003b CR2: 00000000 CR3: 01f32000 CR4: 000007d0
Stack:
 f5f18b90 f5e5feb8 c10687a8 0759004f 00000005 00000005 00000005 00200046
 00000002 00000000 c1082a93 f56c7e28 c2472da8 c1082a93 f5e5fee4 c106bc61^M
 00000000 c1082a93 00000000 00000000 00000001 00200046 00200082 00000000
Call Trace:
 [<c10687a8>] ftrace_raw_event_lock+0x39/0xc0
 [<c1082a93>] ? ktime_get+0x29/0x69
 [<c1082a93>] ? ktime_get+0x29/0x69
 [<c106bc61>] lock_release+0x57/0x1a5
 [<c1082a93>] ? ktime_get+0x29/0x69
 [<c10824dd>] read_seqcount_begin.constprop.7+0x4d/0x75
 [<c1082a93>] ? ktime_get+0x29/0x69^M
 [<c1082a93>] ktime_get+0x29/0x69
 [<c108a46a>] __tick_nohz_idle_enter+0x1e/0x426
 [<c10690e8>] ? lock_release_holdtime.part.19+0x48/0x4d
 [<c10bc184>] ? time_hardirqs_off+0xe/0x28
 [<c1068c82>] ? trace_hardirqs_off_caller+0x3f/0xaf
 [<c108a8cb>] tick_nohz_idle_enter+0x59/0x62
 [<c1079242>] cpu_startup_entry+0x64/0x192
 [<c102299c>] start_secondary+0x277/0x27c
Code: 90 89 c6 89 d0 88 c4 ac 38 e0 74 09 84 c0 75 f7 be 01 00 00 00 89 f0 48 5e 5d c3 55 89 e5 57 66 66 66 66 90 83 c9 ff 89 c7 31 c0 <f2> ae f7 d1 8d 41 ff 5f 5d c3 55 89 e5 57 66 66 66 66 90 31 ff
EIP: [<c127a17b>] strlen+0x10/0x1a SS:ESP 0068:f5e5fe80
CR2: 0000000000000000
---[ end trace 01bc47bf519ec1b2 ]---

New tracepoints have been added that have allowed for NULL pointers
being assigned to strings. To fix this, change the TRACE_EVENT() code
to check for NULL and if it is, it will assign "(null)" to it instead
(similar to what glibc printf does).

Reported-by: Shuah Khan <shuah.kh@samsung.com>
Reported-by: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Link: http://lkml.kernel.org/r/CAGdX0WFeEuy+DtpsJzyzn0343qEEjLX97+o1VREFkUEhndC+5Q@mail.gmail.com
Link: http://lkml.kernel.org/r/528D6972.9010702@samsung.com
Fixes: 9cbf117662e2 ("tracing/events: provide string with undefined size support")
Cc: stable@vger.kernel.org # 2.6.31+
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/ftrace.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 52594b2..d17a35c 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -372,7 +372,8 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 	__data_size += (len) * sizeof(type);
 
 #undef __string
-#define __string(item, src) __dynamic_array(char, item, strlen(src) + 1)
+#define __string(item, src) __dynamic_array(char, item,			\
+		    strlen((src) ? (const char *)(src) : "(null)") + 1)
 
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
@@ -501,7 +502,7 @@ static inline notrace int ftrace_get_offsets_##call(			\
 
 #undef __assign_str
 #define __assign_str(dst, src)						\
-	strcpy(__get_str(dst), src);
+	strcpy(__get_str(dst), (src) ? (const char *)(src) : "(null)");
 
 #undef TP_fast_assign
 #define TP_fast_assign(args...) args
-- 
1.8.4.rc3


