Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaB1NiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:38:10 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:16074 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752653AbaB1Nha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:37:30 -0500
Date: Fri, 28 Feb 2014 08:37:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
Message-ID: <20140228083728.6645d63c@gandalf.local.home>
In-Reply-To: <20140228111111.GI27965@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1402250904400.23234@vincent-weaver-1.um.maine.edu>
	<dde99a03-9f97-4cd9-aeef-cb0dcc62a7dc@email.android.com>
	<20140225094352.73e0e28c@gandalf.local.home>
	<alpine.DEB.2.10.1402251032230.23234@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402261003390.18730@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402271621000.2571@vincent-weaver-1.um.maine.edu>
	<20140227173150.4e5ed747@gandalf.local.home>
	<530FC1C6.5040209@zytor.com>
	<alpine.DEB.2.10.1402272032140.6271@vincent-weaver-1.um.maine.edu>
	<20140227215726.7018c861@gandalf.local.home>
	<20140228111111.GI27965@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Feb 2014 12:11:11 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Feb 27, 2014 at 09:57:26PM -0500, Steven Rostedt wrote:
> > @@ -512,8 +508,21 @@ static inline void nmi_nesting_postprocess(void)
> >  dotraplinkage notrace __kprobes void
> >  do_nmi(struct pt_regs *regs, long error_code)
> >  {
> > +	unsigned long cr2;
> > +	
> >  	nmi_nesting_preprocess(regs);
> >  
> > +	/*
> > +	 * Save off the CR2 register. If we take a page fault in the NMI then
> > +	 * it could corrupt the CR2 value. If the NMI preempts a page fault
> > +	 * handler before it was able to read the CR2 register, and then the
> > +	 * NMI itself takes a page fault, the page fault that was preempted
> > +	 * will read the information from the NMI page fault and not the
> > +	 * origin fault. Save it off and restore it if it changes.
> 
> > +	 * Use the r12 callee-saved register.
> 
> You might want to make that line go away :-)
> 

Gah! I noticed that before sending and deleted the line, recreated the
patch and sent that out. The one step I forgot to do was to save the
file after deleting it :-p

-- Steve
