Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965987Ab3HJQ1f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 12:27:35 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:54761 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965078Ab3HJQ1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 12:27:34 -0400
MIME-Version: 1.0
In-Reply-To: <20130810161031.GK19750@two.firstfloor.org>
References: <1376089460-5459-1-git-send-email-andi@firstfloor.org>
	<1376089460-5459-11-git-send-email-andi@firstfloor.org>
	<CA+55aFyN2Cnt=uQOnXszwDA971o=xEwO=yFSgL-RH9vRjMsBbg@mail.gmail.com>
	<20130810161031.GK19750@two.firstfloor.org>
Date: Sat, 10 Aug 2013 09:27:33 -0700
X-Google-Sender-Auth: 1QN88a96-RNHO55-DCTKo3yDeaw
Message-ID: <CA+55aFw94ow=aYF-y9kJu+2ZsA=YLob5wFe01H+ooQmP6EbJvQ@mail.gmail.com>
Subject: Re: [PATCH 10/13] x86: Move cond resched for copy_{from,to}_user into
 low level code 64bit
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 10, 2013 at 9:10 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
> Hmm. I can do that, but wouldn't that make CONFIG_PREEMPT_VOLUNTARY
> mostly equivalent to CONFIG_PREEMPT_NONE?

According the the Kconfig help, PREEMPT_VOLUNTARY is about the
*explicit* preemption points. And we do have a lot of them in
"might_sleep()".

And personally, I think it makes a *lot* more sense to have a
"might_sleep()" in the MM allocators than it does to have it in
copy_from_user().

But yes, it's obviously a gray area on exactly where you'd want to put
them. But for a "get_user()" that can literally be just a few
instructions? Why would we make that a preemption point? Or even a
copy of few tens of bytes?

I'd *much* rather have preemption points in places that actually loop,
and that have real work associated with them.

Now, the *debug* logic is entirely different, of course. Maybe the
problem is that we have mixed up the two so badly, and we have
"might_sleep()" that implies more of a debug issue than a preemption
issue, and then people add those because they want the debug coverage
(and then you *absolutely* want it even for a single-byte user mode
access). And then because the concept is tied together with
preemption, we end up doing preemption even for that single-byte
access despite the fact that it makes no sense what-so-ever.

So I think your patches are fine,  but I do think we should take a
deeper look at this.

                Linus
