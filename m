Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933916Ab3GWSok (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:44:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7609 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933754Ab3GWSoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:44:39 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=XTo4PusNXBwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=wMU4Dyf1DsIA:10 a=pavbcaaB_vBMbL1aejYA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374605077.3356.128.camel@gandalf.local.home>
Subject: Re: regression 3.11-rc1: rmmod hangs after tracing module
From: Steven Rostedt <rostedt@goodmis.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Tue, 23 Jul 2013 14:44:37 -0400
In-Reply-To: <51EEC646.7070306@broadcom.com>
References: <51EEC646.7070306@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-23 at 20:07 +0200, Arend van Spriel wrote:
> Hi Steven,
> 
> During testing of our brcmfmac wireless driver I had a trace-cmd running 
> along (trace-cmd record -e brcmfmac:*). After the test I stopped the 
> trace, unplugged my usb device and did a rmmod resulting in the attached 
> lockdep splat. Hope you have an idea what is going wrong here.

Thanks for the report!

Does this fix you bug?

-- Steve

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 69cba47..882ec1d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1224,18 +1224,17 @@ void tracing_reset_current(int cpu)
 	tracing_reset(&global_trace.trace_buffer, cpu);
 }
 
+/* Must have trace_types_lock held */
 void tracing_reset_all_online_cpus(void)
 {
 	struct trace_array *tr;
 
-	mutex_lock(&trace_types_lock);
 	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
 		tracing_reset_online_cpus(&tr->trace_buffer);
 #ifdef CONFIG_TRACER_MAX_TRACE
 		tracing_reset_online_cpus(&tr->max_buffer);
 #endif
 	}
-	mutex_unlock(&trace_types_lock);
 }
 
 #define SAVED_CMDLINES 128


