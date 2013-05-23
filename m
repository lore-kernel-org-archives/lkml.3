Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869Ab3EWTy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 15:54:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15701 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758071Ab3EWTyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 15:54:54 -0400
X-Authority-Analysis: v=2.0 cv=UO1f7Vjy c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=-G-aGZAAbeUA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=PU5ldj0W8K0A:10 a=x30EXVXcAAAA:8 a=t3WOL901IaKVnUsT674A:9 a=QEXdDO2ut3YA:10 a=2F0HLYTCHDIA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369338892.6828.214.camel@gandalf.local.home>
Subject: Re: [PATCH v12 3/3] trace,x86: code-sharing between non-trace and
 trace irq handlers
From: Steven Rostedt <rostedt@goodmis.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "Thomas Gleixner (tglx@linutronix.de)" <tglx@linutronix.de>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "Borislav Petkov (bp@alien8.de)" <bp@alien8.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Tomoki Sekiyama <tomoki.sekiyama@hds.com>
Date: Thu, 23 May 2013 15:54:52 -0400
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D41AF86286@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D41AF86286@USINDEM103.corp.hds.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-05 at 19:21 +0000, Seiji Aguchi wrote:
> [Issue]
> 
> Currently, irq vector handlers for tracing are just
> copied non-trace handlers by simply inserting tracepoints.
> 
> It is difficult to manage the codes.
> 
> [Solution]


This as a separate patch actually makes things more confusing to review.
It should be merged into the previous patch. If you want to break up the
changes, I would first add the entering_irq(), and exiting_irq() as
patch 1, and then do the rest of the changes in patch 2.

-- Steve

> This patch shares common codes between non-trace and trace handlers
> as follows to make them manageable and readable.
> 
> Non-trace irq handler:
> smp_irq_handler()
> {
> 	entering_irq(); /* pre-processing of this handler */
> 	__smp_irq_handler(); /*
>                           * common logic between non-trace and trace handlers
>                           * in a vector.
>                           */
> 	exiting_irq(); /* post-processing of this handler */
> 
> }
> 
> Trace irq_handler:
> smp_trace_irq_handler()
> {
> 	entering_irq(); /* pre-processing of this handler */
> 	trace_irq_entry(); /* tracepoint for irq entry */
> 	__smp_irq_handler(); /*
>                           * common logic between non-trace and trace handlers
>                           * in a vector.
>                           */
> 	trace_irq_exit(); /* tracepoint for irq exit */
> 	exiting_irq(); /* post-processing of this handler */
> 
> }
> 
> If tracepoints can place outside entering_irq()/exiting_irq() as follows, it looks \
> cleaner.
> 
> smp_trace_irq_handler()
> {
> 	trace_irq_entry();
> 	smp_irq_handler();
> 	trace_irq_exit();
> }
> 
> But it doesn't work.
> The problem is with irq_enter/exit() being called. They must be called before \
> trace_irq_enter/exit(),  because of the rcu_irq_enter() must be called before any \
> tracepoints are used, as tracepoints use  rcu to synchronize.
> 
> As a possible alternative, we may be able to call irq_enter() first as follows if \
> irq_enter() can nest.
> 
> smp_trace_irq_hander()
> {
> 	irq_entry();
> 	trace_irq_entry();
> 	smp_irq_handler();
> 	trace_irq_exit();
> 	irq_exit();
> }
> 
> But it doesn't work, either.
> If irq_enter() is nested, it may have a time penalty because it has to check if it \
> was already called or not. The time penalty is not desired in performance sensitive \
> paths even if it is tiny.
> 
> Signed-off-by: Seiji Aguchi <seiji.aguchi@hds.com>


