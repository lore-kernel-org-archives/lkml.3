Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751596AbaFDScO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 14:32:14 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:50573 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751286AbaFDScM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 14:32:12 -0400
Date: Wed, 4 Jun 2014 14:32:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Chen, Gong" <gong.chen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>,
        "m.chehab@samsung.com" <m.chehab@samsung.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7 v6] trace, RAS: Add eMCA trace event interface
Message-ID: <20140604143209.28ccc4e3@gandalf.local.home>
In-Reply-To: <20140603103544.207eaa6e@gandalf.local.home>
References: <1401247938-22125-2-git-send-email-gong.chen@linux.intel.com>
	<20140528112832.5f83c66b@gandalf.local.home>
	<20140528163452.GF17196@pd.tnic>
	<20140528125625.6f6dcf7f@gandalf.local.home>
	<20140530092232.GA13495@gchen.bj.intel.com>
	<20140530100716.GE28131@pd.tnic>
	<3908561D78D1C84285E8C5FCA982C28F32823D2B@ORSMSX114.amr.corp.intel.com>
	<20140530210759.267a854e@gandalf.local.home>
	<3908561D78D1C84285E8C5FCA982C28F3282545B@ORSMSX114.amr.corp.intel.com>
	<20140602125748.7093ced8@gandalf.local.home>
	<20140603083606.GA15476@gchen.bj.intel.com>
	<20140603103544.207eaa6e@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2014 10:35:44 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:


> I'll still need to add that __get_dynamic_array_len() helper. I'll send
> you something tonight.
> 

I got caught up in other work, but I wrote it this morning and I'm
adding it to my 3.16 queue. Thus, you can use this:

-- Steve

>From beba4bb096201ceec0e8cfb7ce3172a53015bdaf Mon Sep 17 00:00:00 2001
From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Date: Wed, 4 Jun 2014 14:29:33 -0400
Subject: [PATCH] tracing: Add __get_dynamic_array_len() macro for trace events

If a trace event uses a dynamic array for something other than a string
then there's currently no way the TP_printk() can figure out what size
it is. A __get_dynamic_array_len() is required to know the length.

This also simplifies the __get_bitmask() macro which required it as well,
but instead just hardcoded it.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/trace/ftrace.h | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/trace/ftrace.h b/include/trace/ftrace.h
index 9b7a989..0fd06fe 100644
--- a/include/trace/ftrace.h
+++ b/include/trace/ftrace.h
@@ -203,6 +203,10 @@
 #define __get_dynamic_array(field)	\
 		((void *)__entry + (__entry->__data_loc_##field & 0xffff))
 
+#undef __get_dynamic_array_len
+#define __get_dynamic_array_len(field)	\
+		((__entry->__data_loc_##field >> 16) & 0xffff)
+
 #undef __get_str
 #define __get_str(field) (char *)__get_dynamic_array(field)
 
@@ -211,7 +215,7 @@
 	({								\
 		void *__bitmask = __get_dynamic_array(field);		\
 		unsigned int __bitmask_size;				\
-		__bitmask_size = (__entry->__data_loc_##field >> 16) & 0xffff; \
+		__bitmask_size = __get_dynamic_array_len(field);	\
 		ftrace_print_bitmask_seq(p, __bitmask, __bitmask_size);	\
 	})
 
@@ -636,6 +640,7 @@ static inline void ftrace_test_probe_##call(void)			\
 #undef __print_symbolic
 #undef __print_hex
 #undef __get_dynamic_array
+#undef __get_dynamic_array_len
 #undef __get_str
 #undef __get_bitmask
 
@@ -700,6 +705,10 @@ __attribute__((section("_ftrace_events"))) *__event_##call = &event_##call
 #define __get_dynamic_array(field)	\
 		((void *)__entry + (__entry->__data_loc_##field & 0xffff))
 
+#undef __get_dynamic_array_len
+#define __get_dynamic_array_len(field)	\
+		((__entry->__data_loc_##field >> 16) & 0xffff)
+
 #undef __get_str
 #define __get_str(field) (char *)__get_dynamic_array(field)
 
-- 
1.8.1.4

