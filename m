Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab3KZM7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 07:59:06 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:19048 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752889Ab3KZM7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 07:59:01 -0500
Date: Tue, 26 Nov 2013 07:58:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jovi Zhangwei <jovi.zhangwei@gmail.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 3.13-rc1 kernel crash when enable all tracepoints
Message-ID: <20131126075859.2060f6fd@gandalf.local.home>
In-Reply-To: <CAGdX0WFeEuy+DtpsJzyzn0343qEEjLX97+o1VREFkUEhndC+5Q@mail.gmail.com>
References: <CAGdX0WFeEuy+DtpsJzyzn0343qEEjLX97+o1VREFkUEhndC+5Q@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Nov 2013 12:38:53 +0800
Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:

> Hi,
> 
> I'm not sure this issue already be fixed or not, it can be reproduced
> permanently.
> 
> (I didn't use git-bisect yet, you guys might can understand it quickly)
> 
> #echo 1 > /sys/kernel/debug/tracing/events/enable
> 
> [  160.472176] BUG: unable to handle kernel NULL pointer dereference
> at           (null)
> [  160.472176] IP: [<ffffffff8132ae40>] strlen+0x0/0x30

I hit this bug last night when testing a fix for another bug. I have a
patch for this too, and will send it out after I put it through my
tests.

You can try it out.

-- Steve

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 52594b2..bdac88c 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -372,7 +372,8 @@ ftrace_define_fields_##call(struct ftrace_event_call *event_call)	\
 	__data_size += (len) * sizeof(type);
 
 #undef __string
-#define __string(item, src) __dynamic_array(char, item, strlen(src) + 1)
+#define __string(item, src) __dynamic_array(char, item,			\
+				    strlen((src) ? (src) : "(null)") + 1)
 
 #undef DECLARE_EVENT_CLASS
 #define DECLARE_EVENT_CLASS(call, proto, args, tstruct, assign, print)	\
@@ -501,7 +502,7 @@ static inline notrace int ftrace_get_offsets_##call(			\
 
 #undef __assign_str
 #define __assign_str(dst, src)						\
-	strcpy(__get_str(dst), src);
+	strcpy(__get_str(dst), (src) ? (src) : "(null)");
 
 #undef TP_fast_assign
 #define TP_fast_assign(args...) args

