Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbaBSVnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 16:43:00 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:33516 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbaBSVm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 16:42:58 -0500
Date: Wed, 19 Feb 2014 21:42:42 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Grant Edwards <grant.b.edwards@gmail.com>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: locking changes in tty broke low latency feature
Message-ID: <20140219214242.406e705b@alan.etchedpixels.co.uk>
In-Reply-To: <53051276.2070601@hurleysoftware.com>
References: <20140218093829.GC1741@redhat.com>
	<5303DABD.9000302@hurleysoftware.com>
	<20140219130308.GC1851@redhat.com>
	<le2nmd$p1$1@ger.gmane.org>
	<5304EC33.5040502@hurleysoftware.com>
	<20140219191717.486ac4d0@alan.etchedpixels.co.uk>
	<53051276.2070601@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Because low latency is about *turn around* time. There are plenty of
> > protocols that can flow control, do flow control and want low latency
> > because they are not windowed. It's not mutually exclusive by any means.
> 
> But if it's all about turn around time, how can the situation devolve to
> needing throttling in the first place?  For N_TTY, throttling only happens
> when the read queue is close to overflow (only 128 bytes left in 4k buffer).

Because if we are on the uplink end of a dumb protocol then our flow ends
up as

< 4K in
		read
rest of block
		read
		block complete
		write Y

until at some point sods law decrees that we do a big load of disk
writes, an SMM event steals the processor, firefox garbage collects or
somesuch and we go

4K in
		throttle
		flow control


It only has to happen *once*, not every time to screw stuff up.

> If the reader isn't pulling _all_ the data out the instant it's woken,
> trying to trim off one worker wakeup (by processing input at interrupt time)
> is pointless.

No - because of the statistical corner cases. The standard Linux is not
remotely hard real time, and even if it were most of the tools involved
are not.

> > Low latency goes back to the days of flip buffers, bottom halves an a
> > 100Hz clock. There are certainly better ways to do it now if its needed.
> 
> Still, as you've pointed out a couple of times, maybe there's a limited
> fastpath that's easy and simple. That's why I was asking about throttling
> because it's evaluated even for raw mode.

Even if there isn't the goal of low latency was always 'get stuff to
happen soon' not 'get stuff to happen in the IRQ handler' If you have the
tty processing happening immediately after the IRQ returns when
low_latency is set I'm sure the numbers will be just fine and as good as
historically.

Whether you can always do that I guess depends what happens on really
slow boxes if you don't do any deferral - eg on Geert's Amiga.

Flow control even in raw mode is expected Unix behaviour. However do we
ever need to evaluate it if the tty termios has IXON and CRTSCTS clear ?

Alan
