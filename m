Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908Ab3BLXU7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 18:20:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58182 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab3BLXU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 18:20:58 -0500
Message-ID: <511ACDFB.1050707@zytor.com>
Date: Tue, 12 Feb 2013 15:19:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jamie Lokier <jamie@shareable.org>, ville.syrjala@linux.intel.com,
        Borislav Petkov <bp@alien8.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H.J. Lu" <hjl.tools@gmail.com>, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mm] x86, mm: Redesign get_user with a __builtin_choose_expr
 hack
References: <511A8922.6050908@zytor.com> <tip-3578baaed4613a9fc09bab9f79f6ce2ac682e8a3@git.kernel.org> <CA+55aFzVSY6G3ZDy7YhwGd2k+OBtpDZaobw8awCeyZsaAqHDVw@mail.gmail.com>
In-Reply-To: <CA+55aFzVSY6G3ZDy7YhwGd2k+OBtpDZaobw8awCeyZsaAqHDVw@mail.gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2013 03:06 PM, Linus Torvalds wrote:
> So this looks clean, but I noticed something (that was true even of
> the old 64-bit accesses)
> 
> On Tue, Feb 12, 2013 at 12:55 PM, tip-bot for H. Peter Anvin
> <hpa@linux.intel.com> wrote:
>> +       register __inttype(*(ptr)) __val_gu asm("%edx");                \
> 
> How does gcc even alllow this?
> 
> On x86-32, you cannot put a 64-bit value in %edx.
> 
> Where do the upper bits go? It clearly cannot be %edx:%eax, since we
> put the error value in %eax.
> 
> So is the rule for x86-32 that naming "long long" register values
> names the first register, and the high bits go into the next one (I
> forget the crazy register numbering, I assume it's %ecx). Or what?
> This should have a comment.
> 

Yes, it goes into the next register in gcc's register numbering, which
is %ecx.  This works with the register variable because the named
register is treated as a starting point, whereas using "=d" is treated
as a singleton register set.

I'll add a comment.

gcc's register numbering isn't all that crazy, incidentally: the only
difference from the standard x86 register numbering is that %ecx and
%edx is swapped, so that the standard %edx:%eax and %ebx:%ecx register
pairs end up consecutive.  It isn't really gcc's fault that the x86
register numbering doesn't match its (hard-coded!) register conventions...

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
> 
> Maybe we do not have these issues, but there are good reasons why
> we've tried very hard on x86 to avoid named register variables.

Yes, but there doesn't seem to be any other way to do this.  gcc won't
even allow "=cd" even if we know the variable is 64 bits, even though
"=A" is documented to be equivalent to "=da".

I don't think we have any additional problem here,though.  If we are
inside a scope with "%edx" as a named register variable *and* that
variable is live at the point get_user() happens, then yes, we can and
will have a problem, regardless if we use "=d" or a named register
variable.  The only solution to that is to keep the named register
variable live for as short time as possible.

If we do run into trouble, we could introduce a second copy, thus
reducing the lifespan of the named variable to the absolute minimum:

	register __inttype(*(ptr)) __val_gu asm("%edx");
	__inttype(*(ptr)) __val_gv;

	asm volatile(...);

	__val_gv = __val_gu;
	(x) = (__typeof__(*(ptr))) __val_gv;

That way if the evaluation of (x) as an lvalue somehow requires specific
registers they don't collide.

I would prefer if we could worry about that when we actually need to,
though.  It will trigger a compile error if relevant, so it shouldn't
cause any risk of silent corruption.

> (I realize that they happen, and some other architectures don't even
> have good support for naming registers any other way so they are way
> more common there, so I probably worry needlessly, but it does worry
> me).

Let me know what you think.

	-hpa

