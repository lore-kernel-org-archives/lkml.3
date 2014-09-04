Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbaIDPyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:54:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29643 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbaIDPyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:54:40 -0400
Date: Thu, 4 Sep 2014 16:52:00 +0100
From: Aaron Tomlin <atomlin@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: peterz@infradead.org, mingo@redhat.com, dzickus@redhat.com, bmr@redhat.com,
        jcastillo@redhat.com, pzijlstr@redhat.com, riel@redhat.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, x86@kernel.org,
        rostedt@goodmis.org, hannes@cmpxchg.org,
        aneesh.kumar@linux.vnet.ibm.com, akpm@linux-foundation.org,
        linuxppc-dev@lists.ozlabs.org, minchan@kernel.org
Subject: Re: [PATCH 1/2] sched: Add helper for task stack page overrun
 checking
Message-ID: <20140904155200.GC1436@atomlin.usersys.redhat.com>
References: <1409842224-11847-1-git-send-email-atomlin@redhat.com>
 <1409842224-11847-2-git-send-email-atomlin@redhat.com>
 <20140904150234.GA6480@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140904150234.GA6480@redhat.com>
X-PGP-Key: http://pgp.mit.edu/pks/lookup?search=atomlin%40redhat.com
X-PGP-Fingerprint: 7906 84EB FA8A 9638 8D1E  6E9B E2DE 9658 19CC 77D6
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 04, 2014 at 05:02:34PM +0200, Oleg Nesterov wrote:
> On 09/04, Aaron Tomlin wrote:
> >
> > +#define task_stack_end_corrupted(task) \
> > +		(*(end_of_stack(task)) != STACK_END_MAGIC)
> 
> and it is always used along with "tsk != init_task".
> 
> But why we exclude swapper/0? Can't we add
> 
> 	end_of_stack(current) = STACK_END_MAGIC;
> 
> somewhere at the start of start_kernel() ?

Good point. I can look into it.

> If not, perhaps this new helper should check "task != &init_task"
> itself so that we can simplify its users?
> 
> Oleg.
> 
> >  
> >  static inline int object_is_on_stack(void *obj)
> >  {
> > diff --git a/kernel/trace/trace_stack.c b/kernel/trace/trace_stack.c
> > index 8a4e5cb..06c7390 100644
> > --- a/kernel/trace/trace_stack.c
> > +++ b/kernel/trace/trace_stack.c
> > @@ -13,7 +13,6 @@
> >  #include <linux/sysctl.h>
> >  #include <linux/init.h>
> >  #include <linux/fs.h>
> > -#include <linux/magic.h>
> >  
> >  #include <asm/setup.h>
> >  
> > @@ -171,8 +170,8 @@ check_stack(unsigned long ip, unsigned long *stack)
> >  			i++;
> >  	}
> >  
> > -	if ((current != &init_task &&
> > -		*(end_of_stack(current)) != STACK_END_MAGIC)) {
> > +	if (current != &init_task &&
> > +		task_stack_end_corrupted(current)) {
> >  		print_max_stack();
> >  		BUG();
> >  	}
> > -- 
> > 1.9.3
> > 
> 

-- 
Aaron Tomlin
