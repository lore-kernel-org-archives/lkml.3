Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695AbaLBSmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 13:42:09 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:34232 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbaLBSmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 13:42:07 -0500
Date: Tue, 2 Dec 2014 10:42:02 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141202184202.GM25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
 <547b8a45.6e608c0a.20f9.1002@mx.google.com>
 <CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
 <547bbe36.48548c0a.105c.779c@mx.google.com>
 <20141201191431.GA17385@linux.vnet.ibm.com>
 <547ccf74.a5198c0a.25de.26d9@mx.google.com>
 <20141201230813.GE25340@linux.vnet.ibm.com>
 <547dec29.c71f8c0a.33d1.11d9@mx.google.com>
 <20141202170407.GK25340@linux.vnet.ibm.com>
 <547df364.236a8c0a.7b2d.ffffac67@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <547df364.236a8c0a.7b2d.ffffac67@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120218-0005-0000-0000-000006CCE837
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 03:14:08PM -0200, Dâniel Fraga wrote:
> On Tue, 2 Dec 2014 09:04:07 -0800
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Is it harder to reproduce with CONFIG_PREEMPT=y and CONFIG_TREE_PREEMPT_RCU=n?
> 
> 	Yes, it's much harder! :)
> 
> > If it is a -lot- harder to reproduce, it might be worth bisecting among
> > the RCU read-side critical sections.  If making a few of them be
> > non-preemptible greatly reduces the probability of the bug occuring,
> > that might provide a clue about root cause.
> > 
> > On the other hand, if it is just a little harder to reproduce, this
> > RCU read-side bisection would likely be an exercise in futility.
> 
> 	Ok, I want to bisect it. Since it could be painful to bisect,
> could you suggest 2 commits between 3.16.0 and 3.17.0 so we can narrow
> the bisect? I could just bisect between 3.16.0 and 3.17.0 but it would
> take many days :).
> 
> 	Ps: if you prefer I bisect between 3.16.0 and 3.17.0, no
> problem, but you'll have to be patient ;).

I was actually suggesting something a bit different.  Instead of bisecting
by release, bisect by code.  The procedure is as follows:

1.	I figure out some reliable way of making RCU allow preemption to
	be disabled for some RCU read-side critical sections, but not for
	others.  I send you the patch, which has rcu_read_lock_test()
	as well as rcu_read_lock().

2.	You build a kernel without my Kconfig hack, with my patch from
	#1 above, and build a kernel with CONFIG_PREEMPT=y (which of
	course implies CONFIG_TREE_PREEMPT_RCU=y, given that you are
	building without my Kconfig hack).

3.	You make a list of all the rcu_read_lock() uses in the kernel
	(or ask me to provide it).  You change the rcu_read_lock()
	calls in the first half of this list to rcu_read_lock_test().

	If the kernel locks up as easily with this change as it did
	in a stock CONFIG_PREEMPT=y CONFIG_TREE_PREEMPT_RCU=y kernel,
	change half of the remaining rcu_read_lock() calls to
	rcu_read_lock_test().  If the kernel is much more resistant
	to lockup, change half of the rcu_read_lock_test() calls
	back to rcu_read_lock().

4.	It is quite possible that several of the RCU read-side critical
	sections contribute to the unreliability, in which case the
	bisection will get a bit more complicated.

Other thoughts on how to attack this?

							Thanx, Paul

