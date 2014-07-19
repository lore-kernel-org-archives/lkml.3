Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760637AbaGSIyA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 04:54:00 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:55459 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760383AbaGSIx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 04:53:56 -0400
Date: Sat, 19 Jul 2014 10:53:38 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Thierry Reding <thierry.reding@gmail.com>, linux-arch@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v3 1/3] asm-generic/io.h: Implement generic
 {read,write}s*()
Message-ID: <20140719085338.GB31564@ravnborg.org>
References: <1405508484-18303-1-git-send-email-thierry.reding@gmail.com>
 <20140718205953.GA21964@ravnborg.org>
 <5913515.3g98ODuH6W@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5913515.3g98ODuH6W@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > A semi related question.
> > Why do we play all these macro tricks in io.h?
> > 
> > Example:
> > 
> >     #define writeb __raw_writeb
> > 
> > The consensus these days is to use static inline to have the
> > correct prototype but this file is contains a lot of these
> > macro conversions.
> > 
> > All these things are not introduced by your patch but now that
> > you show some love and care for this file maybe we could take
> > the next step and bring more order to the current semi chaos?
> 
> The macros are mainly there so we can test their presence with
> #ifdef.

There are two types of macros in io.h:

    #define __raw_writeb __raw_writeb
    #ifndef __raw_writeb

This is the one you talk about which allows an architecture to
provide a local implementation of a function.
These are prefectly OK and are required.


Then there are the other type where one IO access function
may re-use the implementation of another IO access function:

    #ifndef writeb
    #define writeb __raw_writeb
    #endif

This could have been implmented like this:

#ifndef writeb
#define writeb writeb
static inline void writeb(u8 b, volatile void __iomem *addr)
{
   __raw_writeb(b, addr);
}
#endif

In this way the prototype of the function is easy to understand and
we avoid the macro tricks were we blindly replace one function name,
with another function name.
And we also use the same pattarn all over for the various functions.

Concerning the efficiency the compiler should be smart enough to
do the same independent on the two implmentations.

The only drawback I see is that the above is 6 lines of codes,
where the macro expansion is 3 lines of code.

And when we talk about simpler expansion like ioread8()
then we replace one line with 4 lines.

	Sam
