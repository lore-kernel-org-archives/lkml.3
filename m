Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab3EOTq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 15:46:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3440 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab3EOTq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 15:46:26 -0400
X-Authority-Analysis: v=2.0 cv=DKcNElxb c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=K9uRuNqwL0EA:10 a=9XYc-_wl3QCBv40Oh14A:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=aPDdahmHGf2K0-wd:21 a=Dj1KtT7P59hvLjI8:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1368647183.6828.77.camel@gandalf.local.home>
Subject: Re: V3.10-rc1 memory leak
From: Steven Rostedt <rostedt@goodmis.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Date: Wed, 15 May 2013 15:46:23 -0400
In-Reply-To: <1368646381.6828.74.camel@gandalf.local.home>
References: <51912567.6090507@lwfinger.net>
	 <1368558586.6828.53.camel@gandalf.local.home>
	 <20130514203028.GA2997@MacBook-Pro.local> <5192A847.1000100@lwfinger.net>
	 <1368566427.6828.58.camel@gandalf.local.home>
	 <1368579423.6828.63.camel@gandalf.local.home>
	 <20130515143719.GB1096@darko.cambridge.arm.com>
	 <1368646381.6828.74.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-15 at 15:33 -0400, Steven Rostedt wrote:

> Instead of just picking data sections by name (names that start
> with .data, .bss or .ref.data), use the section flags and scan all
> sections that are allocated, writable and not executable. Which should
> cover all sections of a module that might reference data.

After this patch is applied, you can add this one too:

kmemleak: No need for scanning specific module sections

As kmemleak now scans all module sections that are allocated, writable
and non executable, there's no need to scan individual sections that
might reference data.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-trace.git/kernel/module.c
===================================================================
--- linux-trace.git.orig/kernel/module.c
+++ linux-trace.git/kernel/module.c
@@ -2772,24 +2772,11 @@ static void find_module_sections(struct 
 	mod->trace_events = section_objs(info, "_ftrace_events",
 					 sizeof(*mod->trace_events),
 					 &mod->num_trace_events);
-	/*
-	 * This section contains pointers to allocated objects in the trace
-	 * code and not scanning it leads to false positives.
-	 */
-	kmemleak_scan_area(mod->trace_events, sizeof(*mod->trace_events) *
-			   mod->num_trace_events, GFP_KERNEL);
 #endif
 #ifdef CONFIG_TRACING
 	mod->trace_bprintk_fmt_start = section_objs(info, "__trace_printk_fmt",
 					 sizeof(*mod->trace_bprintk_fmt_start),
 					 &mod->num_trace_bprintk_fmt);
-	/*
-	 * This section contains pointers to allocated objects in the trace
-	 * code and not scanning it leads to false positives.
-	 */
-	kmemleak_scan_area(mod->trace_bprintk_fmt_start,
-			   sizeof(*mod->trace_bprintk_fmt_start) *
-			   mod->num_trace_bprintk_fmt, GFP_KERNEL);
 #endif
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 	/* sechdrs[0].sh_size is always zero */


