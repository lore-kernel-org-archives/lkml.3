Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbaAAW2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jan 2014 17:28:16 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:37606 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbaAAW2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jan 2014 17:28:14 -0500
Date: Wed, 1 Jan 2014 23:28:08 +0100
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, David Rientjes <rientjes@google.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        James Hogan <james.hogan@imgtec.com>, Michal Marek <mmarek@suse.cz>,
        Paul Mundt <lethal@linux-sh.org>, Shawn Guo <shawn.guo@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [patch core/stackprotector] stackprotector: Fix build when
 compiler lacks support
Message-ID: <20140101222808.GB19648@free.fr>
References: <1387481759-14535-3-git-send-email-keescook@chromium.org>
 <tip-8779657d29c0ebcc0c94ede4df2f497baf1b563f@git.kernel.org>
 <alpine.DEB.2.02.1312301331520.10482@chino.kir.corp.google.com>
 <CAGXu5jJxkD7rS0gFAS3mAhwxP05UMW8KNW00C_e2v=Keqj7k3Q@mail.gmail.com>
 <CA+55aFy65HwuqjsZhhTDBy1GYyxig8De=3XZxn8ixnGN7xWMFQ@mail.gmail.com>
 <20140101114244.GB3372@free.fr>
 <CA+55aFzS2bTXSDabNhsZXhpVWP9toqtubB3jrNVWF-FaQrmz-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFzS2bTXSDabNhsZXhpVWP9toqtubB3jrNVWF-FaQrmz-w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, All,

On 2014-01-01 11:33 -0800, Linus Torvalds spake thusly:
> On Wed, Jan 1, 2014 at 3:42 AM, Yann E. MORIN <yann.morin.1998@free.fr> wrote:
> >
> > On 2013-12-31 16:16 -0800, Linus Torvalds spake thusly:
> >>
> >> What we really really want to do is to have some way to add config
> >> options based on shell scripts and compiler support. That would also
> >> get rid of a lot of Makefile trickery etc.
> >>
> >> Then we could just make CC_STACKPROTECTOR_STRONG depend on
> >> CC_SUPPORTS_STACKPROTECTOR_STRONG or whatever.
> >
> > Sam Ravnborg suggested somethink along those lines back in July:
> >     http://marc.info/?l=linux-kbuild&m=137399785206527&w=2
> > and a tentative implementation:
> >     http://marc.info/?l=linux-kbuild&m=137409581406434&w=2
> 
> Ack. Looks good to me. I've wanted this for a long time for other
> reasons, we should finally just do it.
> 
> That said, we should make sure that the shell execution thing gets
> access to $(CC) etc variables that we have in

This requires exporting them from the Makefiles (they are, in Makefile:391
and below).

> > Basically, that would give something like:
> >
> >     config CC_SUPPORTS_STACKPROTECTOR_STRONG
> >         bool
> >         option exec="some/script/to/test-gcc -fstack-protector-strong"
> 
> For the compiler options, it would hopefully be sufficient to just do
> something like
> 
>   config CC_SUPPORTS_STACKPROTECTOR_STRONG
>       bool
>       option exec="$CC -fstack-protector-strong -c empty.c"
> 
> or something like that. No?

This is an implementation detail, but the original patch expected the
result to be 'y' or 'n' (or empty=='n') on stdout. That way, it could
also be used to fill-in config options that are strings, or ints. Hence
the use of a script.

But H. Peter suggested it should only return a boolean, which seems
entirely reasonable, given the purpose of this. In this case, using 'y'
or 'n' from stdout, or 0 or !0 from the exit code are equally easy.

Also, using a single shell script allows to fix/enhance all of those
calls in a single place, and avoids duplicating all the check logic in
every tests (eg. who is going to create empty.c in your example? Clean
up the output file?). And since kconfig is run from the top-level of the
Linux source tree (even for out-of-tree builds), we can safely use a
path relative to that to call our script(s).

I'll wait a bit until the end of the holiday season before I poke Sam
again on this.

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
