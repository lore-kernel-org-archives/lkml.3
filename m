Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161587AbaJaA70 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 20:59:26 -0400
Received: from mail-yh0-f51.google.com ([209.85.213.51]:50262 "EHLO
	mail-yh0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161370AbaJaA7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 20:59:24 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrUpMOX-0=7Pdv_etjzOjZVH4nrtiqCdWYqtM-ECKFrsYA@mail.gmail.com>
References: <4e8f7a1abcf5e0527ef8968143b2d0fcae48f5f4.1414658968.git.e@nanocritical.com>
	<5452B241.5010603@amacapital.net>
	<CA+55aFw5xL4jk_=oJK1tTwpGG5Y_cibK3y9L=VvYx9jugqrUuQ@mail.gmail.com>
	<CA+55aFw5GqoTF3r=OK+pmdbvm_sdDvkeZMdwk_3TdSg2eyr7MQ@mail.gmail.com>
	<CALCETrUpMOX-0=7Pdv_etjzOjZVH4nrtiqCdWYqtM-ECKFrsYA@mail.gmail.com>
Date: Thu, 30 Oct 2014 17:59:23 -0700
X-Google-Sender-Auth: 7imyNrZnuq5VKpcPCoigKS9Zyy4
Message-ID: <CA+55aFyxoAtJMGhLtz9qND-k4ADexTrE9buG---=vOXTEoovyA@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow open(dir, O_TMPFILE|..., 0) with mode 0
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Eric Rannaud <e@nanocritical.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 5:01 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> Uh, because it's glibc?

Yeah. Bloated, over-engineered, and stupid.

> Or because it's trying not to screw up and on
> some system where overrunning va_arg is terrible?

No. On 99% of architectures the third argument is in a register
anyway, and traditionally it's not even va_arg, although glibc has
made it so (traditionally it's just pre-ANSI C with three arguments
and one of them might be missing - gcc has had hacks for avoiding
warnings for traditional C things like that: look at the whole
transparent union thing for another traditional "C without prototypes"
calling convention case).

But even if you make it va_arg, I can't think of a single architecture
where that makes sense. Outside of assembly trampolines, you *always*
have enough stack space that you can just access a word under the
stack anyway.

But yes, I could imagine some well-meaning - but not overly smart -
glibc developer deciding that doing the va_arg thing conditionally
would be a "feature". Despite making the code slower, bigger, and
buggier.

I guess I'll fetch the git tree and see if they document this braindamage..

[ time passes ]

Ugh. It seems to predate even the imported history (going back all the
way to 1995 - I don't know if that was SVN or CVS and whether there is
some even older historical archives that were never imported).

Anyway, since the beginning of time, the "stub/open.c" file is a True
Work of Art (TM)(also sarcasm), and has an old-style C declaration
(not ANSI) for __libc_open(), and uses a conditional va_arg() to get
the third parameter *despite* not even being a variadic function (not
varargs, not stdarg). So it's not even portable or correct *anyway*,
and it unnecessarily generates bad code and seems to have been
mindlessly copied into all the actual real non-stub implementations.
Most of them seem to have made their definitions match the declaration
in the process, so they then really do have the variadic part. Goodie,
I guess, except for this all being unnecessary crap and stupid.

Oh well. What a cock-up.

The code is insane in other ways too. The actual real Linux version of
__libc_open() ends up (for no good reason except to compete with
cat-ladies in the "crazy person of the year" award) using
"openat(AT_FDCWD)", just so you can make sure that the result doesn't
possibly work on old versions of the kernel even by mistake. I
certainly cannot possibly see any actual *advantage* to using
"openat()", but them I'm not a homeless cat-lady.  It also has some
magic "LIBC_CANCEL_ASYNC()/LIBC_CANCEL_RESET()" stuff around it, which
I'm sure is entirely sane.

I can't take it any more. That code is crazy.

                        Linus
