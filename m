Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab3FVORH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 10:17:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:30289 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab3FVORF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 10:17:05 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=BUyC4VmaGVwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=5V7bKCsQ6TsA:10 a=WOpjIBOU2AokXzUOCpsA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1371910622.18733.154.camel@gandalf.local.home>
Subject: Re: [PATCH][GIT PULL] trace,x86: Move creation of irq tracepoints
 from apic.c to irq.c
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Date: Sat, 22 Jun 2013 10:17:02 -0400
In-Reply-To: <1371849967.18733.134.camel@gandalf.local.home>
References: <1371835898.18733.122.camel@gandalf.local.home>
	 <1371848976.18733.130.camel@gandalf.local.home>
	 <1371849967.18733.134.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-21 at 17:26 -0400, Steven Rostedt wrote:
> On Fri, 2013-06-21 at 17:09 -0400, Steven Rostedt wrote:
> > On Fri, 2013-06-21 at 13:31 -0400, Steven Rostedt wrote:
> > 
> > > My testing also triggered another bug, but I'm not sure it's related to
> > > these patches or something that already existed. I'm currently
> > > investigating it now.
> > 
> > 
> > I haven't been able to reproduce it.
> 
> Correction, I am able to reproduce it. The trick is I need to kick off
> the test as soon as I+
+/*
+ * the load_current_idt() is called with interrupt disabled by
local_irq_save()
+ * to avoid races. That way the IDT will always be set back to the
expected
+ * descriptor.
+ */
+static inline void load_current_idt(void)
+{
+       unsigned long flags;
+
+       local_irq_save(flags);
+       if (is_debug_idt_enabled())
+               load_debug_idt();
+       else
+               load_idt((const struct desc_ptr *)&idt_descr);
+       local_irq_restore(flags);
+}

>  get a login prompt, as the gui is still coming up
> (this time the crash happened on pulseaudio). The test suite runs the
> test when it detects the login. I was trying to reproduce it manually,
> which was well after login was set up.
> 
> I'll try to make sure I can reproduce it consistently, or at least in a
> short number of tries. And then remove all the patches and see if I can
> still trigger it.

OK, I can easily reproduce it when applying this commit:

629f4f9d59a27d8e58aa612e886e6a9a63ea7aeb
"x86: Rename variables for debugging"

Which doesn't just rename a variable but changes the way we update the
IDT for debugging.

After removing this commit, I can not reproduce the dump. I'm thinking
that the IDT switch did something that caused this to happen. Could be,
as lockdep (which is what is having issues here) is where things are
going wrong.

Oh, I think the issue is with this...

+
+/*
+ * the load_current_idt() is called with interrupt disabled by local_irq_save()
+ * to avoid races. That way the IDT will always be set back to the expected
+ * descriptor.
+ */
+static inline void load_current_idt(void)
+{
+       unsigned long flags;
+
+       local_irq_save(flags);
+       if (is_debug_idt_enabled())
+               load_debug_idt();
+       else
+               load_idt((const struct desc_ptr *)&idt_descr);
+       local_irq_restore(flags);
+}

It's not safe to call local_irq_save() here. From entry_64.S:

.macro TRACE_IRQS_OFF_DEBUG
	call debug_stack_set_zero
	TRACE_IRQS_OFF
	call debug_stack_reset
.endm

We must change the idt before we can trace irqs being disabled. The
local_irq_save() here is going to be traced by lockdep. Why do we need
to disable interrupts? It's pretty pointless since this same code can be
called by NMIs.

-- Steve


