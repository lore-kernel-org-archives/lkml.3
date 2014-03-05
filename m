Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956AbaCEMU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 07:20:28 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:21502 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752064AbaCEMU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 07:20:26 -0500
Date: Wed, 5 Mar 2014 07:20:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@ghostprotocols.net,
        seiji.aguchi@hds.com, jolsa@redhat.com, vincent.weaver@maine.edu,
        tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, trace: Fix CR2 corruption when tracing
 page faults
Message-ID: <20140305072022.6f69f699@gandalf.local.home>
In-Reply-To: <20140305111415.GU9987@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1402211701380.6395@vincent-weaver-1.um.maine.edu>
	<20140228160526.GD1133@krava.brq.redhat.com>
	<tip-0ac09f9f8cd1fb028a48330edba6023d347d3cea@git.kernel.org>
	<20140305111415.GU9987@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2014 12:14:15 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Tue, Mar 04, 2014 at 04:03:25PM -0800, tip-bot for Jiri Olsa wrote:
> 
> FWIW I also prefer this patch.
> 
> > @@ -1252,9 +1249,11 @@ dotraplinkage void __kprobes
> >  do_page_fault(struct pt_regs *regs, unsigned long error_code)
> >  {
> >  	enum ctx_state prev_state;
> > +	/* Get the faulting address: */
> > +	unsigned long address = read_cr2();
> >  
> >  	prev_state = exception_enter();
> > -	__do_page_fault(regs, error_code);
> > +	__do_page_fault(regs, error_code, address);
> >  	exception_exit(prev_state);
> >  }
> >  
> > @@ -1271,9 +1270,16 @@ dotraplinkage void __kprobes
> >  trace_do_page_fault(struct pt_regs *regs, unsigned long error_code)
> >  {
> >  	enum ctx_state prev_state;
> > +	/*
> > +	 * The exception_enter and tracepoint processing could
> > +	 * trigger another page faults (user space callchain
> > +	 * reading) and destroy the original cr2 value, so read
> > +	 * the faulting address now.
> > +	 */
> > +	unsigned long address = read_cr2();
> >  
> >  	prev_state = exception_enter();
> >  	trace_page_fault_entries(regs, error_code);
> > -	__do_page_fault(regs, error_code);
> > +	__do_page_fault(regs, error_code, address);
> >  	exception_exit(prev_state);
> >  }
> 
> How about also marking these two functions as notrace? That would also
> avoid getting __mcount calls from before we read CR2.

Please no! I used tracing of the do_page_fault function all the time.
It is very useful.

Call backs from function tracing are to be very limited. They are more
restrictive than NMI contexts. One thing you shouldn't do is to have
page faults. Thus, fix the callback.

-- Steve
