Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbaCDX1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 18:27:24 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:25722 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753797AbaCDX1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 18:27:23 -0500
Date: Tue, 4 Mar 2014 18:27:18 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        akpm@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 05/48] percpu: Add preemption checks to __this_cpu ops
Message-ID: <20140304182718.4e166306@gandalf.local.home>
In-Reply-To: <20140304142727.3e6d260c752c2e2ebd49260e@linux-foundation.org>
References: <20140214201841.826179349@linux.com>
	<20140214201904.443470635@linux.com>
	<20140304142727.3e6d260c752c2e2ebd49260e@linux-foundation.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Mar 2014 14:27:27 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 14 Feb 2014 14:18:46 -0600 Christoph Lameter <cl@linux.com> wrote:
> 
> > [Patch depends on another patch in this series that introduces raw_cpu_ops]
> > 
> > We define a check function in order to avoid trouble with the
> > include files. Then the higher level __this_cpu macros are
> > modified to invoke the preemption check.
> > 
> > --- linux.orig/lib/smp_processor_id.c	2014-01-30 14:40:50.936519233 -0600
> > +++ linux/lib/smp_processor_id.c	2014-01-30 14:40:50.936519233 -0600
> > @@ -7,7 +7,7 @@
> >  #include <linux/kallsyms.h>
> >  #include <linux/sched.h>
> >  
> > -notrace unsigned int debug_smp_processor_id(void)
> > +notrace static unsigned int check_preemption_disabled(char *what)
> >  {
> >  	int this_cpu = raw_smp_processor_id();
> >  
> > @@ -38,9 +38,9 @@
> >  	if (!printk_ratelimit())
> >  		goto out_enable;
> >  
> > -	printk(KERN_ERR "BUG: using smp_processor_id() in preemptible [%08x] "
> > -			"code: %s/%d\n",
> > -			preempt_count() - 1, current->comm, current->pid);
> > +	printk(KERN_ERR "BUG: using %s in preemptible [%08x] code: %s/%d\n",
> > +		what, preempt_count() - 1, current->comm, current->pid);
> > +
> >  	print_symbol("caller is %s\n", (long)__builtin_return_address(0));
> >  	dump_stack();
> 
> I wonder if there's any point in printing __builtin_return_address. 
> Doesn't dump_stack() tell us the same thing?

When frame pointers are enabled, sure. But without frame pointers, I'm
not so sure.

-- Steve
