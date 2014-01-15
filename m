Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaAOTXP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 14:23:15 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:16093 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752345AbaAOTXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 14:23:08 -0500
Message-ID: <1389813781.2944.77.camel@j-VirtualBox>
Subject: Re: [RFC 2/3] mutex: Modify the way optimistic spinners are queued
From: Jason Low <jason.low2@hp.com>
To: Waiman Long <waiman.long@hp.com>
Cc: mingo@redhat.com, peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, riel@redhat.com,
        akpm@linux-foundation.org, davidlohr@hp.com, hpa@zytor.com,
        aswin@hp.com, scott.norton@hp.com
Date: Wed, 15 Jan 2014 11:23:01 -0800
In-Reply-To: <52D6A4FB.7060305@hp.com>
References: <1389745990-7069-1-git-send-email-jason.low2@hp.com>
	 <1389745990-7069-3-git-send-email-jason.low2@hp.com>
	 <52D6A4FB.7060305@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-15 at 10:10 -0500, Waiman Long wrote:
> On 01/14/2014 07:33 PM, Jason Low wrote:
> >   		 * When there's no owner, we might have preempted between the
> > @@ -503,8 +504,10 @@ __mutex_lock_common(struct mutex *lock, long state, unsigned int subclass,
> >   		 * we're an RT task that will live-lock because we won't let
> >   		 * the owner complete.
> >   		 */
> > -		if (!owner&&  (need_resched() || rt_task(task)))
> > +		if (!owner&&  (need_resched() || rt_task(task))) {
> > +			mspin_unlock(MLOCK(lock),&node);
> >   			goto slowpath;
> > +		}
> >
> >   		/*
> >   		 * The cpu_relax() call is a compiler barrier which forces
> 
> Maybe you can consider restructure the code as follows to reduce the 
> number of mspin_unlock() call sites:

Yeah, I would prefer your method of using break and having the
mspin_unlock() at the end of the loop, now that it would result in less
# of mspin_unlock().

Commit ec83f425dbca47e19c6737e8e7db0d0924a5de1b changed break to
slowpath to make it more intuitive to read, but with this patch, there
are benefits to using break.

