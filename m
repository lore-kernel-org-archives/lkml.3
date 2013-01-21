Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3AUVMm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:12:42 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:51607 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3AUVMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:12:41 -0500
Date: Mon, 21 Jan 2013 21:12:18 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: John Stultz <john.stultz@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Matt Sealey <matt@genesi-usa.com>,
        Linux ARM Kernel ML <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Ben Dooks <ben@simtec.co.uk>
Subject: Re: One of these things (CONFIG_HZ) is not like the others..
Message-ID: <20130121211218.GX23505@n2100.arm.linux.org.uk>
References: <CAKGA1bkiowcO7OPSfPmaB6eRj_3FNr+4ONnaQHEZkpxB2XfduQ@mail.gmail.com> <201301212041.17951.arnd@arndb.de> <50FDAC5F.4040605@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FDAC5F.4040605@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 01:00:15PM -0800, John Stultz wrote:
> So if you can not get actual timer ticks any faster then 200 HZ on that  
> hardware, setting HZ higher could cause some jiffies related timer  
> trouble

Err, no John.  It's the other way around - especially on some platforms
which are incapable of being converted to the clock source support.

EBSA110 has _one_ counter.  It counts down at a certain rate, and when
it rolls over from 0 to FFFF, it produces an interrupt and continues
counting down from FFFF.

To produce anything close to a reasonable regular tick rate from that,
the only way to do it is - with interrupts disabled - read the current
value to find out how far the timer has rolled over, and set it so that
the next event will expire as close as possible to the desired HZ rate.

So, none of the clcokevent stuff can be used; and we rely _purely_ on
counting interrupts in jiffy based increments to provide any reference
of time.

Moreover, because the counter is only 16-bit, and it's clocked from
something around 7MHz, well, maths will tell you why 200Hz had to be
chosen rather than 100Hz.
