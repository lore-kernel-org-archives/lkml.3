Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326Ab3LEHVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 02:21:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab3LEHVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 02:21:52 -0500
Date: Wed, 4 Dec 2013 23:22:51 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Brian Norris <computersforpeace@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: BUG: sleeping function called from invalid context at
 kernel/locking/mutex.c:616
Message-Id: <20131204232251.73cc62c6.akpm@linux-foundation.org>
In-Reply-To: <1386227524.4806.7.camel@phoenix>
References: <1385895217.3994.2.camel@phoenix>
	<1386144811.16763.2.camel@phoenix>
	<20131204003147.454534da.akpm@linux-foundation.org>
	<1386147578.20621.4.camel@phoenix>
	<20131204133220.a7f38e748ce2c57f90483111@linux-foundation.org>
	<1386227524.4806.7.camel@phoenix>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Dec 2013 15:12:04 +0800 Axel Lin <axel.lin@ingics.com> wrote:

> > 
> > blam.  spin_unlock_irq(&mapping->tree_lock) failed to decrement
> > preempt_count().  What the heck.
> > 
> > What architecture is this?  Please send the full .config.
> > 
> > And exactly which kernel version is in use?
> 
> It's a arm7tdmi SoC (GeneralPlus gpl32700 SoC).
> The code is: current Linus' tree + patches for this SoC.
> The patches for this SoC includes:
> irqchip, clocksource, pinctrl, gpio, uart, spi, sd/mmc host drivers.
> I also apply a out-of-tree sdio wifi driver for mt5931 wifi module.

Beats me, sorry - I don't see anything which could cause this in the
arm spinlock implementation, even if the spinlock's storage got
corrupted.

> I can successfully boot and running busybox if using ext2 as root.
> Thus I don't hit "spin_unlock_irq decrement preempt_count failure" if using ext2 as root.
> The storage is a spi nor flash, so I prefer to use jffs2 but then I got
> the hangup.
> 
> BTW, I got below panic today:
> 
> 467: 0
> 470: 0
> 475: 1
> 485: 1
> 487: 2
> 489: 2
> 491: 1
> 494: 1
> 496: 1
> 498: 1
> BUG: spinlock bad magic on CPU#0, spi0/30

Which is what appears to have happened here.

I assume earlier kernels worked OK with this config?

If so, all I can suggest is a git bisection search :(
