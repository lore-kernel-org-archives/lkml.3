Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742Ab3DUUv4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 16:51:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41974 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264Ab3DUUvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 16:51:55 -0400
Date: Sun, 21 Apr 2013 22:51:39 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: x86-ml <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        tiwai@suse.de
Subject: Re: irq 16: nobody cared
Message-ID: <20130421205139.GC5807@pd.tnic>
References: <20130420185330.GA4654@pd.tnic>
 <20130420235206.GA3509@linux.vnet.ibm.com>
 <20130421103403.GA4594@pd.tnic>
 <20130421163002.GB3509@linux.vnet.ibm.com>
 <20130421165653.GA4623@pd.tnic>
 <20130421181035.GC4559@pd.tnic>
 <20130421185609.GD3509@linux.vnet.ibm.com>
 <20130421190655.GA5807@pd.tnic>
 <20130421203447.GE3509@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130421203447.GE3509@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 21, 2013 at 01:34:47PM -0700, Paul E. McKenney wrote:
> > No warning, no delay, 2 suspend/resume cycles back-to-back. So, a
> > probable fix could be to force-enable the expedited grace periods during
> > suspend...?
> 
> Fix for the slowness, for sure!
> 
> For the irq warning, it is most likely simply hiding the problem.

Hmm, they seem somehow related. The warning doesn't appear when
rcu_expedited is set which means, RCU grace periods are shorter, leading
up to less IRQ 16 interrupts piling up and not hitting the magic 99900
irq count.

At least this is how I primitively imagine it...

Btw this magic number is pretty old:

commit e40419dbdb3b5c912d35f8736c51687bf4e0deb0
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Oct 18 08:55:37 2004 -0700

    [PATCH] generic irq subsystem: core

Probably Ingo and tglx know why it was chosen. :)

> Still, speeding up suspend sounds valuable.  The connection between
> suspending and expediting grace periods probably needs to be in
> the kernel -- people will undoubtedly want to expedite them for short
> periods of time at runtime, like when starting wireshark, and it would
> be good to minimize unnecessary dependency on scripting.
> 
> It would not be hard to provide an in-kernel primitive for expediting.

Well, this should be trivial, no? A one-liner setting rcu_expedited
to 1 somewhere at the beginning of suspend. When we go further down,
synchronize_sched() et al will pick up the change.

> Hmmm... When you resume, is the expediting still set? (Can't see why
> it would not be.)

Sure.

> If so, it would be good to have some way of disabling
> it after boot completes.  Which, as noted in another thread, requires
> that RCU be informed of when boot completes.  ;-)

A similar oneliner at the end of the resume path.

Maybe have rcu suspend/resume callbacks where you can do this stuff and
maybe more in the future.

Btw, I have no idea how the suspend and resume paths look like, will
have to dig a bit. Rafael would know though :-)

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
