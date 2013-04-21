Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751224Ab3DUUfH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 16:35:07 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:57995 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab3DUUfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 16:35:05 -0400
Date: Sun, 21 Apr 2013 13:34:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Borislav Petkov <bp@alien8.de>
Cc: x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        tiwai@suse.de
Subject: Re: irq 16: nobody cared
Message-ID: <20130421203447.GE3509@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130420185330.GA4654@pd.tnic>
 <20130420235206.GA3509@linux.vnet.ibm.com>
 <20130421103403.GA4594@pd.tnic>
 <20130421163002.GB3509@linux.vnet.ibm.com>
 <20130421165653.GA4623@pd.tnic>
 <20130421181035.GC4559@pd.tnic>
 <20130421185609.GD3509@linux.vnet.ibm.com>
 <20130421190655.GA5807@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130421190655.GA5807@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13042120-2876-0000-0000-000007BC6CBB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 09:06:55PM +0200, Borislav Petkov wrote:
> On Sun, Apr 21, 2013 at 11:56:09AM -0700, Paul E. McKenney wrote:
> > CONFIG_RCU_FAST_NO_HZ will definitely change the timing, for example,
> > increasing grace-period durations by up to a factor of four.
> >
> > One way to figure out if this is the problem would be to either (1)
> > apply the following patch (assuming you have no more than a few tens
> > of CPUs)
> 
> Only 8 - I'm modest that way :)

;-) ;-) ;-)

> > or (2) setting the sysfs rcutree.rcu_expedited variable to 1 just before
> > suspending the system.
> > 
> > Either approach will force RCU to always use the faster expedited
> > grace periods for synchronize_rcu() and friends.  They will -not- help
> > if someone has open-coded synchronize_rcu() in terms of call_rcu(),
> > though.
> 
> Right,
> 
> # echo 1 > /sys/kernel/rcu_expedited
> 
> helped.
> 
> No warning, no delay, 2 suspend/resume cycles back-to-back. So, a
> probable fix could be to force-enable the expedited grace periods during
> suspend...?

Fix for the slowness, for sure!

For the irq warning, it is most likely simply hiding the problem.

Still, speeding up suspend sounds valuable.  The connection between
suspending and expediting grace periods probably needs to be in
the kernel -- people will undoubtedly want to expedite them for short
periods of time at runtime, like when starting wireshark, and it would
be good to minimize unnecessary dependency on scripting.

It would not be hard to provide an in-kernel primitive for expediting.

Hmmm...  When you resume, is the expediting still set?  (Can't see why
it would not be.)  If so, it would be good to have some way of disabling
it after boot completes.  Which, as noted in another thread, requires
that RCU be informed of when boot completes.  ;-)

							Thanx, Paul

> Hmmm.
> 
> Thanks.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Sent from a fat crate under my desk. Formatting is fine.
> --
> 

