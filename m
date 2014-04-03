Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715AbaDCUrI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 16:47:08 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:41443 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaDCUrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 16:47:01 -0400
Date: Thu, 3 Apr 2014 13:46:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: rcu_prempt stalls / lockup
Message-ID: <20140403204656.GI4284@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140401004801.GQ4284@linux.vnet.ibm.com>
 <20140401150849.GA14757@redhat.com>
 <20140401153032.GT4284@linux.vnet.ibm.com>
 <20140401172244.GA10363@redhat.com>
 <20140401175545.GV4284@linux.vnet.ibm.com>
 <20140401180414.GA12326@redhat.com>
 <20140401183245.GA12473@linux.vnet.ibm.com>
 <20140402162043.GA11090@linux.vnet.ibm.com>
 <20140402224840.GA5385@redhat.com>
 <20140403200143.GA8119@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140403200143.GA8119@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040320-1344-0000-0000-000000B40455
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 03, 2014 at 04:01:43PM -0400, Dave Jones wrote:
> On Wed, Apr 02, 2014 at 06:48:40PM -0400, Dave Jones wrote:
> 
>  >  > > >  > Waiting uninterruptibly.  Presumably blocked on mutex_lock().  But
>  >  > > >  > you have CONFIG_PROVE_LOCKING(), so any deadlocks should have been
>  >  > > >  > reported.
>  >  > > > 
>  >  > > > Lockdep had reported something a little earlier (timestamped at 1108.xxxxxx)
>  >  > > > but that's a known false-positive in xfs.
>  >  > > 
>  >  > > Yep, I would be very surprised if that was related to the grace-period hang.
>  >  > 
>  >  > Ah, but it could be suppressing later lockdep splats.  So if this can be
>  >  > reproduced without xfs, we might get additional information from lockdep.
>  > 
>  > Hrmph.
>  > 
>  > $ git bisect bad
>  > The merge base 5cb480f6b488128140c940abff3c36f524a334a8 is bad.
>  > This means the bug has been fixed between 5cb480f6b488128140c940abff3c36f524a334a8 and [455c6fdbd219161bd09b1165f11699d6d73de11c 62c206bd514600d4d73751ade00dca8e488390a3 e086481baf9d0436bdd6e9b739bfa4a83fb89ef5].
>  > 
>  > Not sure where to go from here..
>  > 
>  > The 'good' news is I can reproduce it pretty reliably now.
>  > I start my fuzz tester, and immediately do a git diff in my working tree,
>  > and then boom..
> 
> Even better, now I realise I don't even need my fuzzer in the mix. Just doing
> a fair amount of disk io (like a git diff on a dirty tree) will trigger it.
> 
> I've tried adding a show_state() call when the stall happens, but another stall
> seems to occur before it gets a chance to even dump everything over the usb-serial console.
> And of course nothing ever makes it to disk, even though I can sysrq-sync, on the
> next reboot systemd has stuffed a bunch of ^@ in the log where the interesting
> stuff should be.
> 
> Any other ideas ?

This bug does seem to be doing an effective job of defending itself,
doesn't it?  I guess producing additional debug output just isn't going
to cut it in this case.

So, how about reverting each commit in the RCU series, and then bisecting
through the reverts?  Something like the following:

	wherever=linus/master # or substitute whatever point you wish.
	# Create a revert branch for the rcu.2014.02.26a branch
	git checkout -b anti-fixes $wherever
	git revert 5cb5c6e18f822b19bd41a2c0f9930c82b3ec0bc9
	git revert 7a754743185a4b05818e10058fa2fbe4e6969085
	git revert 8857563b819b140aa8c9be920cfe44d5d3f808b7
	git revert add1f0995454374d90c9d6b2c420d2fba3d0a4e3
	git revert ae1670339c95c3ff96ab10582506cf827c5fecc8
	git revert 52e2bb958ac4f9b3c4bdd78606d279852fd72922
	git revert 88c1863066ccfa456797e12c5d8b4631aa1ad0d0
	git revert 0adab9b9aa18d7e90337d43567f1eec3d5401b81
	git revert 41f4abd92a34f9c5110bbb870c04f8854604e28d
	git revert cb1e78cfa267453bb19e7edafd214c03834b664c
	git revert 87de1cfdc55b16b794e245b07322340725149d62
	git revert 3660c2813fb6d0ba48ee44bcbf9feddf7218c11d
	# Create a revert branch for the rt.2014.02.17b branch
	git checkout -b anti-rt $wherever
	git revert f1f399d1281ea339a08469f7e58193624992f620
	git revert ffa83fb565fbc397cbafb4b71fd1cce276d4c3b6
	git revert 2f33b512a5460578f6cf11d7b7867bed53157c7c
	git merge anti-fixes

Then bisect through these reverts.

I am assuming, perhaps naively, that changes under Documentation and
to torture testing should not be affecting you.

Does this make sense?

							Thanx, Paul

