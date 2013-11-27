Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab3K0T6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 14:58:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51816 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab3K0T63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 14:58:29 -0500
Message-ID: <52964EC7.9000504@zytor.com>
Date: Wed, 27 Nov 2013 11:57:59 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>
CC: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] Add a text_poke syscall v2
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org>	<5294F10C.8060901@amacapital.net> <CA+55aFzBXzQS90XYZKHRr0N66uBrDmS=o_U9u=e4qq2CzTg8ww@mail.gmail.com>
In-Reply-To: <CA+55aFzBXzQS90XYZKHRr0N66uBrDmS=o_U9u=e4qq2CzTg8ww@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 12:03 PM, Linus Torvalds wrote:
> On Tue, Nov 26, 2013 at 11:05 AM, Andy Lutomirski <luto@amacapital.net> wrote:
>>
>> IIRC someone proposed that, rather than specifying a "handler", that any
>> user thread that traps just wait until the poke completes.  This would
>> complicate the kernel implementation a bit, but it would make the user
>> code a good deal simpler.  Is there any reason that this is a bad idea?
> 
> Please do it this way instead, because user space will get the
> callback version wrong and then - because it never actually triggers
> in practice in normal situations - it will cause very *very* subtle
> bugs that we can't fix.
> 
> Making the kernel serialize the accesses is the right thing to do.
> Just a new per-mm mutex should trivially do it, then you don't even
> have to check the "current->mm == bp_target_mm" thing at all, you just
> make the bp handler do a simple
> 
>     if (mutex_lock_interruptible(&mm->text_poke_mutex) >= 0)
>         mutex_unlock(&mm->text_poke_mutex);
> 
> and return. All done.
> 
> Plus the callback thing is pointless if we can do the instruction
> switch atomically (which would be true for UP, for single-thread, and
> potentially for certain sizes/alignments coupled with known rules for
> particular micro-architectures). So it's not a particularly good
> interface anyway.
> 
> Btw, I also think that there's a separate problem wrt shared pages.
> Should we perhaps only allow this in private mappings? Because right
> now it has that "current->mm == bp_target_mm" thing, and generally it
> only works on one particular mm, but by using "get_user_pages_fast(,
> 1,..)" it really only requires write permissions on the page. So it
> could be shared mapping, and I could easily see people doing that on
> purpose ("open executable file, then use text_poke() to change it for
> this architecture") and THAT DOES NOT WORK with the current patch if
> somebody else is also running that app..
> 

I have already said I don't think this is a good interface as it doesn't
provide sane semantics for batching changes -- the whole handler and
timeout mechanism (which isn't even implemented yet, and as a result
probably will never be used by userspace) is basically a hack for that.

The other alternative is that we only expose the "synchronize all cores"
operation as a system call, and let user space do the rest of the work.
 Anything else can be done in user space, and a lot of the subtleties
with locking pages, user space access and so on simply go away... user
space will be responsible or will get protection faults.

	-hpa


