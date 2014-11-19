Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429AbaKSQII (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:08:08 -0500
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:55275 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381AbaKSQID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:08:03 -0500
Date: Wed, 19 Nov 2014 16:07:47 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Konstantin Khlebnikov <k.khlebnikov@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH RFC] ARM: option for loading modules into vmalloc area
Message-ID: <20141119160747.GH4042@n2100.arm.linux.org.uk>
References: <20141118172146.3784.81151.stgit@buzz>
 <20141118173413.GB4042@n2100.arm.linux.org.uk>
 <546B8C64.3010904@samsung.com>
 <2041617.Kxhx5O4MMr@wuerfel>
 <CAKv+Gu-8qhHYOry+LsDzp+LDZqYxVZ5G7cj48E3G2Unp2+=_yg@mail.gmail.com>
 <CALYGNiMt2A3DP02cOtxqu4RrnmhojrDxkRG7bkHMByUnzG+PeA@mail.gmail.com>
 <CAKv+Gu-rYWutr-45MsZH6KOhhUyNCVLfkO9JQrqCm1L6ms_DUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-rYWutr-45MsZH6KOhhUyNCVLfkO9JQrqCm1L6ms_DUg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 19, 2014 at 05:02:40PM +0100, Ard Biesheuvel wrote:
> On 19 November 2014 16:52, Konstantin Khlebnikov <koct9i@gmail.com> wrote:
> > Do you mean ldr pc, =symbol ?
> >
> > In this case I get this error:
> >
> > /tmp/ccAHtONU.s: Assembler messages:
> > /tmp/ccAHtONU.s:220: Error: invalid literal constant: pool needs to be closer
> >
> > Probably constant pool doesn't work well in inline assembly.
> >
> >
> > Something like this seems work:
> >
> > add     lr, pc, #4
> > ldr       pc, [pc, #-4]
> > .long symbol
> >
> 
> You can add a '.ltorg' instruction which tells the assembler to dump
> the literal pool, but you still need to jump over it, i.e.,
> 
> adr lr, 0f
> ldr pc, =symbol
> .ltorg
> 0:

Which is not a good idea either, because the compiler needs to know how
far away its own manually generated literal pool is from the instructions
which reference it.  The .ltorg statement can end up emitting any number
of literals at that point, which makes it indeterminant how many words
are contained within the asm() statement.

Yes, it isn't desirable to waste an entire data cache line per indirect
call like the original quote above, but I don't see a practical
alternative.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
