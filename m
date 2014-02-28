Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167AbaB1UeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 15:34:15 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:36315 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752125AbaB1UeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 15:34:10 -0500
Date: Fri, 28 Feb 2014 12:34:05 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
Message-ID: <20140228203405.GH11910@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <dde99a03-9f97-4cd9-aeef-cb0dcc62a7dc@email.android.com>
 <20140225094352.73e0e28c@gandalf.local.home>
 <alpine.DEB.2.10.1402251032230.23234@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402261003390.18730@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402271621000.2571@vincent-weaver-1.um.maine.edu>
 <20140227173150.4e5ed747@gandalf.local.home>
 <530FC1C6.5040209@zytor.com>
 <20140227183008.6be081b7@gandalf.local.home>
 <530FCE6C.4080808@zytor.com>
 <alpine.DEB.2.10.1402271957380.6210@vincent-weaver-1.um.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1402271957380.6210@vincent-weaver-1.um.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14022820-9332-0000-0000-000003427E1F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 08:00:04PM -0500, Vince Weaver wrote:
> On Thu, 27 Feb 2014, H. Peter Anvin wrote:
> 
> > On 02/27/2014 03:30 PM, Steven Rostedt wrote:
> > > On Thu, 27 Feb 2014 14:52:54 -0800
> > > "H. Peter Anvin" <hpa@zytor.com> wrote:
> > > 
> > >> On 02/27/2014 02:31 PM, Steven Rostedt wrote:
> > >>>
> > >>> Yeah, something is getting mesed up.
> > >>>
> > >>
> > >> What it *looks* like to me is that we try to nest the cr2 save/restore,
> > >> which doesn't nest because it is a percpu variable.
> > >>
> > >> ... except in the x86-64 case, we *ALSO* save/restore cr2 inside
> > >> entry_64.S, which makes the stuff in do_nmi completely redundant and
> > >> there for no good reason.
> > > 
> > > Peter, look at the code. That percpu cr2 is in a #ifdef CONFIG_X86_32
> > > section. That is, it isn't even executed. That's i386 code. The only
> > > place the cr2 is saved for x86_64 is in entry_64.S.
> > > 
> > 
> > Right, egg on my face.  However, I still think it would make more sense
> > for it to nest the way entry_64.S does if at all possible.
> > 
> > That makes this even more confusing, though.  I would still like to see
> > what happens with the patch I sent Vince.
> 
> I'll try your patch momentarily, first I had some other changes I started 
> running before I left work (for some reason it recompiled the whole 
> kernel).
> 
> 8: function:             perf_output_begin
> 8: bprint:               perf_output_begin: VMW: event type 2 config 2a st: 2c3e
> 8: bputs:                perf_output_begin: VMW: before rcu_dereference
> 9: function:             __do_page_fault
> 9: function:                down_read_trylock
> 9: function:                _cond_resched
> 9: function:                find_vma
> 
> so it looks like the fault happens 
> 
> rcu_read_lock();
> 
> 116         /*
> 117          * For inherited events we send all the output towards the parent.
> 118          */
> 119         if (event->parent)
> 120                 event = event->parent;
> 121 
> 
> somewhere between here
> 
> 122         rb = rcu_dereference(event->rb);
> 123         if (unlikely(!rb))
> 124                 goto out;
> 
> and here
> 
> 125 
> 126         if (unlikely(!rb->nr_pages))
> 127                 goto out;
> 
> although if rcu locks do anything to turn off tracing then this could be 
> suspect.

The most likely suspect is of course event->rb in the rcu_dereference.
I have to defer to Steven on how rcu_read_lock() and rcu_read_unlock()
currently interact with tracing.  ;-)

							Thanx, Paul

