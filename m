Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab3GKTDD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 15:03:03 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:53693 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755885Ab3GKTDA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 15:03:00 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, dhowells@redhat.com
Subject: Re: Hard lockups using 3.10.0
Date: Thu, 11 Jul 2013 21:02:51 +0200
Message-ID: <5775248.AWi0TF0buA@eto>
User-Agent: KMail/4.10.5 (Linux/3.10.0-16.g3dcd746-desktop; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130711175015.GZ16780@linux.vnet.ibm.com>
References: <8484013.LsABBJRIOx@devpool02> <20130711105207.GE25631@dyad.programming.kicks-ass.net> <20130711175015.GZ16780@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5542535.dpZXmAXpnk"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart5542535.dpZXmAXpnk
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Paul E. McKenney wrote:
> On Thu, Jul 11, 2013 at 12:52:07PM +0200, Peter Zijlstra wrote:
> > On Thu, Jul 11, 2013 at 12:07:21PM +0200, Borislav Petkov wrote:
> > > On Thu, Jul 11, 2013 at 11:38:37AM +0200, Rolf Eike Beer wrote:
> > > > Hi,
> > > > 
> > > > I'm running 3.10.0 (from openSUSE packages) on an "Intel(R) Core(TM)
> > > > i7-2600 CPU @ 3.40GHz". I got a hard lockup on one of my CPUs twice,
> > > > once with backtrace (see attached image). Graphics is the builtin
> > > > Intel, used with X 7.6 and KDE 4.10beta2 (basically current openSUSE
> > > > 12.3+KDE).
> > > > 
> > > > I'm not aware that I had done anything special, just "normal" desktop
> > > > and
> > > > development usage, but no heavy compile work at the moment the lockups
> > > > happened.
> > > 
> > > Hmm, I can see commit_creds() doing some rcu pointers assignment and rcu
> > > calling into the scheduler which screams about a cpu runqueue of the
> > > task we're about to reschedule not being locked. Let's add some more
> > > people who should know better.
> > 
> > Ok, for the other people too lazy to bother finding the picture:
> >   http://marc.info/?l=linux-kernel&m=137353587012001&q=p3
> > 
> > So we bug at:
> > 
> > kernel/sched/core.c:519 assert_raw_spin_locked(&task_rq(p)->lock);
> > 
> > and get there through:
> >   resched_task()
> >   check_preempt_wakeup()
> >   check_preempt_curr()
> >   try_to_wake_up()
> >   autoremove_wake_function()
> >   __call_rcu_nocb_enqueue()
> >   __call_rcu()
> >   commit_creds()
> >   ____call_usermodehelper()
> >   ret_from_fork()
> > 
> > That don't make much sense though. Since:
> >   try_to_wake_up()
> >   
> >     ttwu_queue()
> >     
> >       raw_spin_lock(&rq->lock)
> >       ttwu_do_activate()
> >       
> >         ttwu_do_wakeup()
> >         
> >           check_preempt_curr()
> >           
> >             check_preempt_wakeup()
> >             
> >               resched_task(rq->curr)
> >               
> >                 assert_raw_spin_locked(task_rq(p)->lock)
> > 
> > It would somehow mean that 'task_rq(rq->curr) != rq', that's completely
> > bonkers, we do after all have rq->lock locked.
> > 
> > I must also say that I've _never_ seen this bug before.
> 
> New one on me as well.  Is this reproducible?  If so, does it happen
> when CONFIG_RCU_NOCB_CPU=n?  (Given the call to call_rcu_nocb_enqueue(),
> I expect that you built with CONFIG_RCU_NOCB_CPU=y.)  Can't say that I
> see how call_rcu_nocb_enqueue() would have caused this, but...
> 
> Well, I supposed that if RCU's callback lists got corrupted, this
> (and much else besides) could in fact happen.  Does your build have
> CONFIG_DEBUG_OBJECTS_RCU_HEAD=y?  If not, could you please try it?

I will look tomorrow. This is a "standard" openSUSE kernel RPM, dunno right 
now which repository. It is not really reproducible, it suddenly happened 
again today but this time without backtrace.

Eike
--nextPart5542535.dpZXmAXpnk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEABECAAYFAlHfAWIACgkQXKSJPmm5/E7PdgCfTg8u8Gm9PmzsMABQ2JHw/e7d
bQUAn0Bg77YcM1JdVkpH6SGkvPldhfMG
=mqw+
-----END PGP SIGNATURE-----

--nextPart5542535.dpZXmAXpnk--

