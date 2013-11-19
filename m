Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab3KSTKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 14:10:37 -0500
Received: from one.firstfloor.org ([193.170.194.197]:54764 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab3KSTKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 14:10:36 -0500
Date: Tue, 19 Nov 2013 20:10:34 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add a text_poke syscall
Message-ID: <20131119191034.GF29695@two.firstfloor.org>
References: <1384820855-27790-1-git-send-email-andi@firstfloor.org>
 <20131119064948.GA32025@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119064948.GA32025@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Design: more fundamentally, you don't explain the design: why is this 
> architecture specific and why is it a new syscall?
> 
> In particular I'm somewhat sceptical about doing this as a separate 
> syscall, because such Linux-only syscall specials tend to propagate to 
> the right tools rather slowly - especially if it's an x86-only 
> Linux-special syscall ...

Self modifying code is by definition x86 specific.

Very likely any other method to do this would be Linux specific
in some form or another, as there doesn't seem to be any
existing art.
> 
> If we want to do this then it could be shaped as a straightforward 
> ptrace() extension: ptrace already has the concept of self-tracing 
> (PTRACE_TRACEME), so adding PTRACE_POKETEXT with pid==0 (or a special 
> flag to denote 'careful text self-modification') would achieve that, 
> and would make it instantly available to tooling, without fragile 
> syscall wrappers.

Hmm, my impression was that ptrace would always stop, but yes
that TRACEME thing would be possible. Of course once you 
do TRACMEME the debugger won't work anymore. But there's no
reason for text_poke to exclude debuggers.  That would seem
like a major disadvantage to me.

My personal feeling is that ptrace is already very complicated,
hard to understand and best left alone. So I preferred to 
do it in a clean separate system call.

But if people really think ptrace is somehow better it would
be a possibility.

Is the motivation here just to limit the number of syscalls, 
or some other reason too?

> That would also allow other SMP architectures with speculative 
> execution to implement such code modification helpers as well, by 
> reusing the same new ptrace ABI.

They could always add text_poke too. But their requirements
may be different (for example they may or may not need the 
handler) and any code using it would be necessarily
architecture specific anyways.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
