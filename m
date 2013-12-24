Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302Ab3LXUqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 15:46:31 -0500
Received: from mail-ea0-f181.google.com ([209.85.215.181]:46656 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3LXUqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 15:46:30 -0500
Date: Tue, 24 Dec 2013 21:46:25 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] speeding up the stat() family of system calls...
Message-ID: <20131224204625.GB20471@gmail.com>
References: <CA+55aFxZ2u+M72u3HSD7TVY2+WRRi27pYC=_4Wawr5y1m8DfnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxZ2u+M72u3HSD7TVY2+WRRi27pYC=_4Wawr5y1m8DfnQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Here's both x86 people and filesystem people involved, because this
> hacky RFC patch touches both.
> 
> NOTE NOTE NOTE! I've modified "cp_new_stat()" in place, in a way that
> is x86-64 specific. So the attached patch *only* works on x86-64, and
> will very actively break on anything else. That's intentional, because
> that way it's more obvious how the code changes, but a real patch
> would create a *new* cp_new_stat() for x86-64, and conditionalize the
> existing generic "cp_new_stat()" on not already having an
> architecture-optimized one.
> 
> Basically, under some filesystem loads, "stat()" and friends are the
> most common ops (think tree traversal, but also things like git
> verifying the index). And our "cp_new_stat()" function (which is the
> common interface, ignoring 32-bit legacy stuff) is generic, but
> actually pretty disgusting. It copies things to a temporary 'struct
> stat' buffer on the kernel stack, and then uses copy_to_user() to copy
> it to user space. The double copy is quite noticeable in profiles, and
> it generates a big stack frame too.
> 
> By doing an architecture-specific cp_new_stat() function, we can
> improve on that.
> 
> HOWEVER. On x86, doing an efficient field-at-a-time copy also requires
> us to use put_user_try() and put_user_catch() in order to not have
> tons of clac/stac instructions for the extended permission testing.
> And the implementation of that was actually fairly non-optimal, so to
> actually get the code I wanted, I had to change how that all worked
> too, using "asm_volatile_goto()".
> 
> Thus both x86 and FS people on the list.
> 
> Comments? This would obviously be a 3.14 issue, I'm not suggesting 
> we'd do this now. I just want to lay the ground-work..
> 
> It's tested in the sense that "it works for me", and profiles look 
> nice, but..

Looks cool - it looks rather similar to the try/catch model Richard 
Henderson came up with many eons ago when we implemented the original 
exception mechanism for Linux, which IIRC we decided wasn't safe due 
to lack of compiler support.

Now we have compiler support ... written by Richard Henderson ;-)

Thanks,

	Ingo
