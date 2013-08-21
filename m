Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143Ab3HUQCT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 12:02:19 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42330 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab3HUQCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 12:02:17 -0400
Date: Wed, 21 Aug 2013 16:56:32 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dave Jones <davej@redhat.com>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Kees Cook <keescook@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ARM ATTEND] catching up on exploit
	mitigations
Message-ID: <20130821155632.GO17845@n2100.arm.linux.org.uk>
References: <CAGXu5jKv9Vt+Hu0mFYaxggLLDZ46U3KR9MKegUoHH8StXCkBtQ@mail.gmail.com> <20130730221435.GA22240@redhat.com> <20130730231120.GC30725@blackmetal.musicnaut.iki.fi> <20130730231533.GA26824@redhat.com> <20130730235834.GD30725@blackmetal.musicnaut.iki.fi> <20130731000444.GC1281@redhat.com> <20130731094012.GU24642@n2100.arm.linux.org.uk> <20130731142430.GA4545@redhat.com> <20130821152614.GN17845@n2100.arm.linux.org.uk> <20130821154355.GA20784@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821154355.GA20784@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 11:43:55AM -0400, Dave Jones wrote:
> On Wed, Aug 21, 2013 at 04:26:14PM +0100, Russell King - ARM Linux wrote:
>  > I've been running several iterations of it for a while (== up to 10 minutes
>  > run time - which is normally about how long it takes to find the rather-too-
>  > exposed kmalloc in sys_oabi_epoll_wait) and so far have seen no sign of any
>  > page table corruption.
> 
> awesome. Guess it was a google specific issue then.
> (Or something that got fixed post 3.4)

It's been running on this run for 38 minutes so far (having put a
__GFP_NOWARN stopper in that kmalloc - which I think there needs to be
a better solution.)

What I have noticed is during the initialisation of the fd[] array, it
sometimes hangs on a futex.  Killing trinity, removing all the files
and restarting it seems to sort the problem out.  I'm not sure what's
doing that - any ideas?  I couldn't find any evidence of another trinity
thread doing anything with futexes.

>  > Were there any nonstandard platform
>  > specific devices in /dev which that user could access - such as graphics
>  > or video decoder devices which could be exposing big holes?
> 
> I'm not sure what google patched into that kernel altogether, so who knows..

Unfortunately, it seems to be rather common if there's hardware GPU or
video codecs to expose physical addresses to userspace which get passed
around in closed source libraries and ultimately to GPU/video hardware.
I would not be surprised if trinity was finding that and finding some
way to get something to poke randomly in kernel memory.

It seems also that the normal approach is to expose the device nodes in
/dev to the world, effectively handing any userspace program the ability
to:

(a) a way to allocate from a pool of memory, and get its physical address
(b) to be able to pass a physical address to hardware for DMA type operations
(c) to initiate DMA on that hardware

This is why closed source GPU/video stuff is Bad News(tm) for security.
I'd strongly suggest keeping such platforms well away from any data
anyone cares about keeping private and keeping them well isolated. :)
