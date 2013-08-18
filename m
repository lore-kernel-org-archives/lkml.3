Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab3HRJeu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 05:34:50 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46746 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675Ab3HRJes (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 05:34:48 -0400
Date: Sun, 18 Aug 2013 11:34:44 +0200
From: Borislav Petkov <bp@alien8.de>
To: Josh Triplett <josh@joshtriplett.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH tip/core/rcu 01/11] rcu: Expedite grace periods during
 suspend/resume
Message-ID: <20130818093444.GA26728@pd.tnic>
References: <20130818013735.GA27234@linux.vnet.ibm.com>
 <1376789876-27594-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130818031717.GL28923@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130818031717.GL28923@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 17, 2013 at 08:17:17PM -0700, Josh Triplett wrote:
> On Sat, Aug 17, 2013 at 06:37:46PM -0700, Paul E. McKenney wrote:
> > From: Borislav Petkov <bp@alien8.de>
> > 
> > CONFIG_RCU_FAST_NO_HZ can increase grace-period durations by up to
> > a factor of four, which can result in long suspend and resume times.
> > Thus, this commit temporarily switches to expedited grace periods when
> > suspending the box and return to normal settings when resuming.
> > 
> > [ paulmck: This also papers over an audio/irq bug, but hopefully that will
> >   be fixed soon. ]
> > 
> > Signed-off-by: Borislav Petkov <bp@suse.de>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> This patch still seems like a hack, and there *ought* to be a better
> general solution to avoid excessive grace-period latency.  Nonetheless,
> in the absence of such a solution,
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Yeah, I'm not happy about it either but from quickly skimming over what
context we're using rcu_expedited in, the basic requirement for a fix is
for the pm core to be able to tell rcu not to stretch grace periods.

So simply setting a variable is much simpler than switching to calling
all those *_expedited() rcu flavors from the pm notifier when going
down.

Unless Paul has a better idea, of course.

The basic problem here is, however, that you need to temporarily
reconfigure the inner workings of a subsystem because hardware is
performing a power state transition. Unless someone teaches rcu about
power state transitions... :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
