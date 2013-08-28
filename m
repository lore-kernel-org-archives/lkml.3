Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab3H1Td4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 15:33:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51141 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab3H1Tdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 15:33:55 -0400
Date: Wed, 28 Aug 2013 12:33:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Lior Amsalem <alior@marvell.com>, Baruch Siach <baruch@tkos.co.il>,
        Will Deacon <will.deacon@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v4 1/4] lib: Introduce atomic MMIO modify
Message-Id: <20130828123352.b9beff5237dfde2571a5779e@linux-foundation.org>
In-Reply-To: <20130828102422.GA2348@localhost>
References: <1377358532-23802-1-git-send-email-ezequiel.garcia@free-electrons.com>
	<1377358532-23802-2-git-send-email-ezequiel.garcia@free-electrons.com>
	<20130827133709.64b4743950b911d6dfe7fab8@linux-foundation.org>
	<20130828102422.GA2348@localhost>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Aug 2013 07:24:23 -0300 Ezequiel Garcia <ezequiel.garcia@free-electrons.com> wrote:

> On Tue, Aug 27, 2013 at 01:37:09PM -0700, Andrew Morton wrote:
> > On Sat, 24 Aug 2013 12:35:29 -0300 Ezequiel Garcia <ezequiel.garcia@free-electrons.com> wrote:
> > 
> > > Some platforms have MMIO regions that are shared across orthogonal
> > > subsystems. This commit implements a possible solution for the
> > > thread-safe access of such regions through a spinlock-protected API.
> > 
> > Seem sensible.  Perhaps.
> > 
> > It only works if both subsystems agree to use atomic_io_modify().  And
> > if they're both capable of doing that, they are both capable of
> > implementing an agreed-upon internal locking scheme, so why bother?
> > 
> 
> One of the scenarios where this could be helpful and an agreed-upon
> lock seemed difficult to design is this: a watchdog driver that shares
> some control register with *two* different clocksource drivers.
> 
> So, one first solution is to have a function in the two clocksource
> drivers (with matching prototype) and have the watchdog access
> the register through it.
> 
> However, because of multiplatform builds, both these clocksource drivers
> could be built at the same time. Therefore we would have a symbol
> collision, doubly-defined, in each driver.
> 
> How would that work? What other internal locking scheme could we
> implement?

I guess the locking would need to be in a standalone module which the
various driver modules would then depend upon.  I'm not really
advocating doing this - I'm just making noise.

> [..]
> > 
> > I disagree with the presence of the ifndef.  If
> > __HAVE_ARCH_ATOMIC_IO_MODIFY is undefined, the architecture must still
> > implement the identical function signature.  The best way to ensure that
> > is to use the same prototype in both cases.
> > 
> 
> I agree, but how can this be done?

Just remove the ifndefs.  Then remove the identical function prototype
from the arm header.


