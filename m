Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaFMQJr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 12:09:47 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:37996 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbaFMQJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 12:09:39 -0400
Date: Fri, 13 Jun 2014 18:09:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH] rcu: Only pin GP kthread when full dynticks is actually
 used
Message-ID: <20140613160933.GN6635@localhost.localdomain>
References: <1402618619-32630-1-git-send-email-fweisbec@gmail.com>
 <20140613012432.GH4581@linux.vnet.ibm.com>
 <20140613124207.GB6635@localhost.localdomain>
 <20140613155812.GO4581@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140613155812.GO4581@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 08:58:12AM -0700, Paul E. McKenney wrote:
> > Maybe what we should do instead is to have something like this on RCU kthread init:
> > 
> >           cpumask_var_t gp_kthread_mask;
> > 
> >           if (alloc_cpumask_var(gp_kthread_mask, GFP_KERNEL))
> >               return -EFAULT;
> > 
> >           cpumask_andnot(gp_kthread_mask, cpu_possible_mask, tick_nohz_full_mask);
> > 
> > 	  set_cpus_allowed_ptr(current, gp_kthread_mask);
> > 
> > 	  free_cpumask_var(gp_kthread_mask);
> 
> I was guessing that RCU's kthreads would not be the only ones that wanted
> similar binding.  But if you feel strongly about this, we could at least
> start by placing it local to RCU as above.

Hmm, I don't feel well creating mirrored cpumasks (nor solely negation cpumasks in general).
Also exposing that nohz gut is probably not a good idea either, except for RCU due to
the sysidle stuff.

Now you're right that we can expect that this non-nohz affinity stuff is going to be reused.

Could it be housekeeping_affine(struct task_struct *tsk) maybe?
