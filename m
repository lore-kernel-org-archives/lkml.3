Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaEGX4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 19:56:41 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:48678 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaEGX4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 19:56:39 -0400
Date: Wed, 7 May 2014 16:56:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: josh@joshtriplett.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 06/45] torture: Intensify locking test
Message-ID: <20140507235633.GR8754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1398731133-18925-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140507212015.GB27924@cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507212015.GB27924@cloud>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050723-7164-0000-0000-0000019786CF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 02:20:15PM -0700, josh@joshtriplett.org wrote:
> On Mon, Apr 28, 2014 at 05:24:54PM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > The current lock_torture_writer() spends too much time sleeping and not
> > enough time hammering locks, as in an eight-CPU test will often only be
> > utilizing a CPU or two.  This commit therefore makes lock_torture_writer()
> > sleep less and hammer more.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/locking/locktorture.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/locking/locktorture.c b/kernel/locking/locktorture.c
> > index f26b1a18e34e..b0d3e3c50672 100644
> > --- a/kernel/locking/locktorture.c
> > +++ b/kernel/locking/locktorture.c
> > @@ -219,7 +219,8 @@ static int lock_torture_writer(void *arg)
> >  	set_user_nice(current, 19);
> >  
> >  	do {
> > -		schedule_timeout_uninterruptible(1);
> > +		if ((torture_random(&rand) & 0xfffff) == 0)
> > +			schedule_timeout_uninterruptible(1);
> 
> That's a one-in-1048576 chance of sleeping for a jiffy; is that frequent
> enough to even bother sleeping at all?

On large systems, maybe not.  Smallish systems should be able to get
through that loop a million times in a few hundreds of milliseconds,
though.  So longer term a smarter approach might be needed, but this
should be a good start.

							Thanx, Paul

> >  		cur_ops->writelock();
> >  		if (WARN_ON_ONCE(lock_is_write_held))
> >  			lwsp->n_write_lock_fail++;
> > -- 
> > 1.8.1.5
> > 
> 

