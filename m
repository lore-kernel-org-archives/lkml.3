Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259Ab3ELS3j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 14:29:39 -0400
Received: from 8bytes.org ([85.214.48.195]:49147 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009Ab3ELS3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 14:29:38 -0400
Date: Sun, 12 May 2013 20:29:35 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Bisected post-3.9 regression: Resume takes 5 times as much time
 as with v3.9
Message-ID: <20130512182935.GD24440@8bytes.org>
References: <87r4hdjsu5.fsf@nemi.mork.no>
 <20130512113157.GG3648@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130512113157.GG3648@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Sun May 12 20:29:36 2013
X-DSPAM-Confidence: 0.9986
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 518fdf9023671995510992
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Sun, May 12, 2013 at 04:31:57AM -0700, Paul E. McKenney wrote:
> On Sat, May 11, 2013 at 08:04:50PM +0200, Bjørn Mork wrote:
> > Bisecting it ended up pointing to
> > 
> > commit c0f4dfd4f90f1667d234d21f15153ea09a2eaa66
> > Author: Paul E. McKenney <paul.mckenney@linaro.org>
> > Date:   Fri Dec 28 11:30:36 2012 -0800
> > 
> >     rcu: Make RCU_FAST_NO_HZ take advantage of numbered callbacks
> >     
> >     Because RCU callbacks are now associated with the number of the grace
> >     period that they must wait for, CPUs can now take advance callbacks
> >     corresponding to grace periods that ended while a given CPU was in
> >     dyntick-idle mode.  This eliminates the need to try forcing the RCU
> >     state machine while entering idle, thus reducing the CPU intensiveness
> >     of RCU_FAST_NO_HZ, which should increase its energy efficiency.
> >     
> >     Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> >     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > 
> > 
> > Being a big patch, I'm pretty sure that the problem is some minor
> > issue. But rather than trying to userstand this, just tried reverting
> > it on top of the current mainline and can confirm that this fixes the
> > regression.  I'll leave the understanding to you :)
> > 
> > I'm attaching the revert patch as I had to fix a conflict, and may have
> > done something wrong there.  I'm also attaching my .config.
> > 
> > Let me know if you need more information, or want me to try out proposed
> > fixes.
> 
> We don't want to back out the RCU_FAST_NO_HZ changes due to their
> energy-efficiency benefits.  So could you please try out Borislav's
> patch below?  He ran into the same issue a few weeks ago, and this
> one fixed it for him.

I get a ~10min boot delay with this patch:

[    1.149676] system 00:01: [mem 0xf6000000-0xf6003fff] could not be reserved
[    1.149724] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[  603.957670] pnp 00:02: [dma 4]
[  603.957735] pnp 00:02: Plug and Play ACPI device, IDs PNP0200 (active)

This happens on my AMD FX-6100 system. I bisected the problem down to the same
commit and reverting it fixes the problem. Any ideas?


	Joerg


