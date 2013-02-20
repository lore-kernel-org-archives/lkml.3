Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751Ab3BTWFy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:05:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40862 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832Ab3BTWFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:05:53 -0500
Date: Wed, 20 Feb 2013 14:05:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Sasha Levin <sasha.levin@oracle.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] posix-timer: don't call idr_find() w/ negative ID
Message-Id: <20130220140551.8017e795.akpm@linux-foundation.org>
In-Reply-To: <20130220213701.GE3570@htj.dyndns.org>
References: <1361385853-29010-1-git-send-email-sasha.levin@oracle.com>
	<CAOS58YMT3NS-8zvwx1tNQoLKM1WtKtT-YXBPi=4pAeAMi=rYeA@mail.gmail.com>
	<512522CF.1020901@oracle.com>
	<20130220210116.GD3570@htj.dyndns.org>
	<20130220132300.ccffde44.akpm@linux-foundation.org>
	<20130220213701.GE3570@htj.dyndns.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2013 13:37:01 -0800
Tejun Heo <tj@kernel.org> wrote:

> Hello, Andrew.
> 
> On Wed, Feb 20, 2013 at 01:23:00PM -0800, Andrew Morton wrote:
> > > @@ -637,6 +637,9 @@ static struct k_itimer *__lock_timer(timer_t timer_id, unsigned long *flags)
> > >  {
> > >  	struct k_itimer *timr;
> > >  
> > > +	if ((int)timer_id < 0)
> > > +		return NULL;
> > > +
> > >  	rcu_read_lock();
> > >  	timr = idr_find(&posix_timers_id, (int)timer_id);
> > >  	if (timr) {
> > 
> > This is a bit risky - if some arch defines timer_t to be a u64 then we
> > will incorrectly treat 0x0000 0001 ffff ffff as a negative number. 
> > (That's a lot of timers!)
> > 
> > A fancy way of avoiding this is
> > 
> > 	if (timer_id & ((typeof timer_id)1 << (sizeof(timer_id) - 1)))
> > 
> > (approximately ;))
> > 
> > But I think casting to (long) should be good enough?
> 
> Sans WARN_ON_ONCE(), the code would behave the same as before, which
> in turn, from what I can tell, is the behavior the code intended to
> implement before idr_alloc() conversion.
> 
> If timer_id is being allocated from idr, a valid id can never go over
> INT_MAX and returning NULL for any ID above that is the correct
> behavior, I think.  If timer_t is larger than int, both (int) and
> (long) castings wouldn't be useful.  Both will miss (1LU << 33) + 1
> and idr_find() will end up looking for 1.
> 
> If we want to be strict, we would have to do, I think,
> 
> 	if ((unsigned long long)timer_t > INT_MAX)
> 
> hopefully with some comments.  That said, if I'm grepping it right,
> all archs define timer_t as int, so maybe we're just being paranoid.
> 

Sure, it's unlikely to cause a problem in practice.  Maybe five years
from now, after idr has been cleaned up and switched to 64-bit, we've
left a little hand grenade for someone.  It would be good to
future-safe it in some fashion.

I wonder if we should add some generic facility to handle this:

/*
 * Query whether an unsigned type is `negative' when we don't know its size
 */
#define msb_is_set(v)	{ implementation goes here ;) }

Maybe not justified, dunno...
