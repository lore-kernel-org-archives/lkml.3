Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab3FVSqo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 14:46:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16543 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903Ab3FVSqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 14:46:40 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=BUyC4VmaGVwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5V7bKCsQ6TsA:10 a=qs7Ygty1FOSeg5Y4aIIA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371926797.18733.155.camel@gandalf.local.home>
Subject: Re: [PATCH][GIT PULL] trace,x86: Move creation of irq tracepoints
 from apic.c to irq.c
From: Steven Rostedt <rostedt@goodmis.org>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 22 Jun 2013 14:46:37 -0400
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D443E06842@USINDEM103.corp.hds.com>
References: <1371835898.18733.122.camel@gandalf.local.home>
	 <1371848976.18733.130.camel@gandalf.local.home>
	 <1371849967.18733.134.camel@gandalf.local.home>
	 <1371910622.18733.154.camel@gandalf.local.home>
	 <A5ED84D3BB3A384992CBB9C77DEDA4D443E06842@USINDEM103.corp.hds.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-06-22 at 17:42 +0000, Seiji Aguchi wrote:
> > +static inline void load_current_idt(void)
> > +{
> > +       unsigned long flags;
> > +
> > +       local_irq_save(flags);
> > +       if (is_debug_idt_enabled())
> > +               load_debug_idt();
> > +       else
> > +               load_idt((const struct desc_ptr *)&idt_descr);
> > +       local_irq_restore(flags);
> > +}
> > 
> > It's not safe to call local_irq_save() here. From entry_64.S:
> > 
> > .macro TRACE_IRQS_OFF_DEBUG
> > 	call debug_stack_set_zero
> > 	TRACE_IRQS_OFF
> > 	call debug_stack_reset
> > .endm
> > 
> > We must change the idt before we can trace irqs being disabled. The
> > local_irq_save() here is going to be traced by lockdep. Why do we need
> > to disable interrupts? It's pretty pointless since this same code can be
> > called by NMIs.
> 
> OK, I agree to remove the local_irq_save().
> 
> I thought it is safe to disable interrupt to avoid potential races, 
> because the load_current_id() is a common function and someone else may use it near future.

It should not be that common of a function. Not many should use it.

I'm testing a patch now and should post it in a few hours.

-- Steve


