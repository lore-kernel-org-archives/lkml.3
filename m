Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbaA0WRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 17:17:25 -0500
Received: from mail-ve0-f179.google.com ([209.85.128.179]:46215 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbaA0WRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 17:17:24 -0500
MIME-Version: 1.0
In-Reply-To: <52E6D866.604@amacapital.net>
References: <CA+55aFzNxTtvNX7zqBELHs489e5mEx1sM=i=red=aQAGviXrNw@mail.gmail.com>
	<20140127002255.GA10323@ZenIV.linux.org.uk>
	<CA+55aFzCtJ5gfw__3A=zkjJdv9Ag2CAmtHG5MnrRnCZYqz7EQA@mail.gmail.com>
	<20140127074208.GB10323@ZenIV.linux.org.uk>
	<52E6D866.604@amacapital.net>
Date: Mon, 27 Jan 2014 14:17:23 -0800
X-Google-Sender-Auth: 7att80goV9P56mLsJktG20ja8tA
Message-ID: <CA+55aFzWRjNC4kPeVad3isOOW+vZhnzX0Gk5_8QzD16GZEw5Kg@mail.gmail.com>
Subject: Re: [RFC] de-asmify the x86-64 system call slowpath
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Peter Anvin <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 27, 2014 at 2:06 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> It's not just ip and sp -- cs matters here, too, I think.

For signal *delivery*, CS will always be __USER_CS, and %rcx can be
crap, so sysret should be fine. We could easily check that %rip is
valid in the whole slow-path instead of saying "return 1 if we did
do_signal()".

Now, it's a different thing wrt signal handler *return*, because at
that point we really cannot return with some random value in %rcx. We
absolutely do need to use 'iretq' in that whole [rt_]sigreturn() path,
but on x86-64 that is all handled by the system call itself (see the
stub_*_sigreturn stuff in entry_64.S) and it very much uses iret
explicitly (the 32-bit case also does that, by forcing the sigreturn
to be done with an "int 0x80" instruction - we could change that to
use syscall+iret, but frankly, I'm not all that inclined to care,
although it might be worth trying to do just to unify the models a
bit).

                   Linus
