Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab3DKTsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 15:48:30 -0400
Received: from www.linutronix.de ([62.245.132.108]:48051 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753213Ab3DKTs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 15:48:29 -0400
Date: Thu, 11 Apr 2013 21:48:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Hansen <dave@sr71.net>
cc: Borislav Petkov <bp@alien8.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        dhillf@gmail.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] kthread: Prevent unpark race which puts threads on the
 wrong cpu
In-Reply-To: <5166FBFB.2030703@sr71.net>
Message-ID: <alpine.LFD.2.02.1304112146230.21884@ionos>
References: <515F457E.5050505@sr71.net> <515FCAC6.8090806@linux.vnet.ibm.com> <alpine.LFD.2.02.1304061019000.21884@ionos> <alpine.LFD.2.02.1304071119100.21884@ionos> <20130407095025.GA31307@pd.tnic> <alpine.LFD.2.02.1304081122040.21884@ionos>
 <20130408115553.GA4395@pd.tnic> <alpine.LFD.2.02.1304081415570.21884@ionos> <alpine.LFD.2.02.1304091635430.21884@ionos> <516439DF.3050901@sr71.net> <alpine.LFD.2.02.1304092036431.21884@ionos> <alpine.LFD.2.02.1304092126150.21884@ionos> <51647C30.3050109@sr71.net>
 <alpine.LFD.2.02.1304101024010.21884@ionos> <alpine.LFD.2.02.1304101250320.21884@ionos> <5165C087.4060404@sr71.net> <alpine.LFD.2.02.1304111020520.21884@ionos> <5166FBFB.2030703@sr71.net>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Apr 2013, Dave Hansen wrote:
> On 04/11/2013 03:19 AM, Thomas Gleixner wrote:
> > --- linux-2.6.orig/kernel/smpboot.c
> > +++ linux-2.6/kernel/smpboot.c
> > @@ -185,8 +185,18 @@ __smpboot_create_thread(struct smp_hotpl
> >  	}
> >  	get_task_struct(tsk);
> >  	*per_cpu_ptr(ht->store, cpu) = tsk;
> > -	if (ht->create)
> > -		ht->create(cpu);
> > +	if (ht->create) {
> > +		/*
> > +		 * Make sure that the task has actually scheduled out
> > +		 * into park position, before calling the create
> > +		 * callback. At least the migration thread callback
> > +		 * requires that the task is off the runqueue.
> > +		 */
> > +		if (!wait_task_inactive(tsk, TASK_PARKED))
> > +			WARN_ON(1);
> > +		else
> > +			ht->create(cpu);
> > +	}
> >  	return 0;
> >  }
> 
> This one appears to be doing the trick.  I'll run the cpus in an
> online/offline loop for a bit and make sure it's stable.  It's passed
> several round so far, which is way more than it's done up to this point,
> though.

I think the most critical part is bootup when the threads are
created. The online/offline one is an issue as well, which is covered
by the patches, but way harder to trigger.

Thanks,

	tglx

 
