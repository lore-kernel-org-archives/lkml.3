Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbaDWK2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 06:28:16 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:45621 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752854AbaDWK2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 06:28:13 -0400
Date: Wed, 23 Apr 2014 11:27:18 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>,
        Wade Farnsworth <wade_farnsworth@mentor.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-arch <linux-arch@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [PATCH 02/15] arm: __NR_syscalls fix
Message-ID: <20140423102718.GA6434@n2100.arm.linux.org.uk>
References: <1397211951-20549-1-git-send-email-miklos@szeredi.hu> <1397211951-20549-3-git-send-email-miklos@szeredi.hu> <20140411103351.GJ16119@n2100.arm.linux.org.uk> <CAJfpegvZ-n4sT0ojj9iUg_R5gMZHT0caad6TpOdcmF=pdiXkqg@mail.gmail.com> <20140411115421.GL16119@n2100.arm.linux.org.uk> <CAJfpegtenNUCEAJ3SZpQ8NYcdbCeS8pVxaT767szkR1PF8YPNA@mail.gmail.com> <20140411124502.GO16119@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140411124502.GO16119@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 01:45:02PM +0100, Russell King - ARM Linux wrote:
> On Fri, Apr 11, 2014 at 02:02:32PM +0200, Miklos Szeredi wrote:
> > On Fri, Apr 11, 2014 at 1:54 PM, Russell King - ARM Linux
> > <linux@arm.linux.org.uk> wrote:
> > > On Fri, Apr 11, 2014 at 01:50:50PM +0200, Miklos Szeredi wrote:
> > >> Yes, and the padding will be of wrong length if NR_syscalls is
> > >> incorrect (which may be Oopsable?).  At least that is my impression
> > >> from a casual glance.
> > >
> > > Please explain.
> > 
> > Look at ending lines of arch/arm/kernel/calls.S: if  NR_syscalls is a
> > multiple of 4, then syscalls_padding will be zero.  I.e. no padding
> > despite the fact that there is in fact only 382 system calls in table
> > and there should be 2 sys_ni_syscall pads.
> 
> Hmm, it looks like you're right... this used to work fine until...
> 
> commit 1f66e06fb6414732bef7bf4a071ef76a837badec
> Author: Wade Farnsworth <wade_farnsworth@mentor.com>
> Date:   Fri Sep 7 18:18:25 2012 +0100
> 
>     ARM: 7524/1: support syscall tracing
> 
> because the tracing code wanted to know the number of syscalls.  I don't
> know what the answer is here, because the current solution is IMHO far
> to fragile.

Actually, no, you're wrong.  Look closely at the definitions. __NR_syscalls
is not the same as NR_syscalls.

__NR_syscalls is the statically defined size of the syscall table for
*probes purposes.

NR_syscalls is the assembly-counted number of CALL() macros in
arch/arm/kernel/calls.S.

So, patch 2 isn't required, and patch 3 needs to be fixed up to take
this into account...

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
