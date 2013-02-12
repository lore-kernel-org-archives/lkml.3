Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021Ab3BLXV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 18:21:59 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41538 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab3BLXV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 18:21:58 -0500
Date: Tue, 12 Feb 2013 23:21:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jamie Lokier <jamie@shareable.org>, ville.syrjala@linux.intel.com,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H.J. Lu" <hjl.tools@gmail.com>, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mm] x86, mm: Redesign get_user with a
	__builtin_choose_expr hack
Message-ID: <20130212232136.GX17833@n2100.arm.linux.org.uk>
References: <511A8922.6050908@zytor.com> <tip-3578baaed4613a9fc09bab9f79f6ce2ac682e8a3@git.kernel.org> <CA+55aFzVSY6G3ZDy7YhwGd2k+OBtpDZaobw8awCeyZsaAqHDVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzVSY6G3ZDy7YhwGd2k+OBtpDZaobw8awCeyZsaAqHDVw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2013 at 03:06:51PM -0800, Linus Torvalds wrote:
> So this looks clean, but I noticed something (that was true even of
> the old 64-bit accesses)
> 
> On Tue, Feb 12, 2013 at 12:55 PM, tip-bot for H. Peter Anvin
> <hpa@linux.intel.com> wrote:
> > +       register __inttype(*(ptr)) __val_gu asm("%edx");                \
> 
> How does gcc even alllow this?
> 
> On x86-32, you cannot put a 64-bit value in %edx.
> 
> Where do the upper bits go? It clearly cannot be %edx:%eax, since we
> put the error value in %eax.

I can't talk for x86, but the ARM version is this:

                register __inttype(*p) __r2 asm("r2");

r2 is only 32-bit, so you can ask the same question there.  The answer
is, it ends up in r3, the next register, as required by the compiler
ABI.  (64-bit values are always contained in a consecutive even, odd
register pair.)

> Also, come to think of it, we have tried the "named register
> variables" thing before, and it has resulted in problems with scope.
> In particular, two variables within the same scope and the same
> register have been problematic. And it *does* happen, when you have
> things like
> 
>    /* copy_user */
>    put_user(get_user(.., addr), addr2);
> 
> and then things go downhill.

Umm.  Why would you want to put_user() the error code from get_user() ?
That's just weird, don't we normally want to return the error code?

But yes, I can see that kind of thing causing problems - I'll check
what the behaviour is on ARM.  What we _do_ have is a bit of assembly
level checking which verifies that the arguments are passed in the
correct registers, so at least we get build errors should things go
wrong.  We haven't seen that though.

> Maybe we do not have these issues, but there are good reasons why
> we've tried very hard on x86 to avoid named register variables.

Unfortunately on ARM there's no other way to get close to specifying
registers for asm code. :(
