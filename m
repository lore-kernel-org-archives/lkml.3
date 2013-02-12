Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758832Ab3BLXHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 18:07:16 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:56861 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757856Ab3BLXHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 18:07:13 -0500
MIME-Version: 1.0
In-Reply-To: <tip-3578baaed4613a9fc09bab9f79f6ce2ac682e8a3@git.kernel.org>
References: <511A8922.6050908@zytor.com> <tip-3578baaed4613a9fc09bab9f79f6ce2ac682e8a3@git.kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 12 Feb 2013 15:06:51 -0800
X-Google-Sender-Auth: n2ILII7-9CeTp5w-t_bXdwqqybc
Message-ID: <CA+55aFzVSY6G3ZDy7YhwGd2k+OBtpDZaobw8awCeyZsaAqHDVw@mail.gmail.com>
Subject: Re: [tip:x86/mm] x86, mm: Redesign get_user with a
 __builtin_choose_expr hack
To: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jamie Lokier <jamie@shareable.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ville.syrjala@linux.intel.com, Borislav Petkov <bp@alien8.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H.J. Lu" <hjl.tools@gmail.com>
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So this looks clean, but I noticed something (that was true even of
the old 64-bit accesses)

On Tue, Feb 12, 2013 at 12:55 PM, tip-bot for H. Peter Anvin
<hpa@linux.intel.com> wrote:
> +       register __inttype(*(ptr)) __val_gu asm("%edx");                \

How does gcc even alllow this?

On x86-32, you cannot put a 64-bit value in %edx.

Where do the upper bits go? It clearly cannot be %edx:%eax, since we
put the error value in %eax.

So is the rule for x86-32 that naming "long long" register values
names the first register, and the high bits go into the next one (I
forget the crazy register numbering, I assume it's %ecx). Or what?
This should have a comment.

Also, come to think of it, we have tried the "named register
variables" thing before, and it has resulted in problems with scope.
In particular, two variables within the same scope and the same
register have been problematic. And it *does* happen, when you have
things like

   /* copy_user */
   put_user(get_user(.., addr), addr2);

and then things go downhill.

Maybe we do not have these issues, but there are good reasons why
we've tried very hard on x86 to avoid named register variables.

(I realize that they happen, and some other architectures don't even
have good support for naming registers any other way so they are way
more common there, so I probably worry needlessly, but it does worry
me).

             Linus
