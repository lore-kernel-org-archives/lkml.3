Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab3LVALf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 19:11:35 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:63951 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab3LVALd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 19:11:33 -0500
MIME-Version: 1.0
In-Reply-To: <21174.7221.399380.512977@quad.stoffel.home>
References: <CA+55aFxZ2u+M72u3HSD7TVY2+WRRi27pYC=_4Wawr5y1m8DfnQ@mail.gmail.com>
	<21174.7221.399380.512977@quad.stoffel.home>
Date: Sat, 21 Dec 2013 16:11:32 -0800
X-Google-Sender-Auth: u3ihHxUMWMCgJ0MND-YCtRakw2c
Message-ID: <CA+55aFxpWpAMWC218n8czLCo=+V=ykmKWtpaBzLRJijET31QPA@mail.gmail.com>
Subject: Re: [RFC] speeding up the stat() family of system calls...
From: Linus Torvalds <torvalds@linux-foundation.org>
To: John Stoffel <john@stoffel.org>
Cc: Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 21, 2013 at 2:54 PM, John Stoffel <john@stoffel.org> wrote:
>
> Any numbers of how much better this is?  I'm travelling
> tomorrow, so I won't have time to spin up a VM and play, though it's
> tempting to do so.

On most _real_ loads, the kernel footprint is pretty small, and
obviously if you do IO or other stuff, the cost of some wasted CPU
cycles in stat() is negligible. And even if you loop doing normal
'stat()' (and everything is cached), over a filesystem, the actual
path walk itself is still dominant, although at that point the CPU
overhead of the stat data copy starts to at least show up in profiles.
Showing up in profiles is why I started looking at it.

And then, for the extreme case, my test program went from 0.92s to
0.80s. But that stupid test program just does ten million fstat(0,&st)
calls, in order to show the highest cp_new_stat() CPU overhead (with
minimal cache footprint). So at that point it's about a 13%
difference, when the only other overhead really is just the system
call itself. The profile went from

  10.42%  a.out  [k] copy_user_enhanced_fast_string
   5.91%  a.out  [k] cp_new_stat

(the "copy_user_enhanced_fast_string" is the "rep movsb" that copies
things to user space) to

   6.69%  a.out  [k] cp_new_stat

(and here there is no separate user-copy, since it's all done directly
inside the optimized cp_new_stat).

It's worth pointing out that the 5.91% -> 6.69% profile change of
cp_new_stat() is *not* because cp_new_stat() got slower: it's simply a
direct result of the 13% performance improvements - 13% of the cycles
went away, and so 5.91% becomes 6.69%.

But the above 13% is really the extreme case with hot caches etc.
Normally it's not really noticeable in any bigger picture load. For
example, on a big "git diff", the cp_new_stat() function shows up at
0.63% of the load, so making it faster isn't going to make any very
noticeable difference.

The reason I care really is that that stat overhead always does show
up on the kinds of profiles I care about, even if it's never all that
high. In other words, it's more of an annoyance over how stupid that
code was than a huge performance increase.

                Linus
