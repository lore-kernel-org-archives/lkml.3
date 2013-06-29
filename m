Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262Ab3F2UX1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 16:23:27 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:13749 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab3F2UXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 16:23:23 -0400
Message-ID: <51CF422E.7030803@hp.com>
Date: Sat, 29 Jun 2013 16:23:10 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2 1/2] spinlock: New spinlock_refcount.h for lockless
 update of refcount
References: <1372268603-46748-1-git-send-email-Waiman.Long@hp.com> <1372268603-46748-2-git-send-email-Waiman.Long@hp.com> <CA+55aFzo5Jy064pbvEZh5cg_RJiSxe1R+tSgByQTs4rc=4SN3Q@mail.gmail.com>
In-Reply-To: <CA+55aFzo5Jy064pbvEZh5cg_RJiSxe1R+tSgByQTs4rc=4SN3Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2013 01:45 PM, Linus Torvalds wrote:
> Sorry for not commenting earlier, I was traveling and keeping email to
> a minimum..
>
> On Wed, Jun 26, 2013 at 10:43 AM, Waiman Long<Waiman.Long@hp.com>  wrote:
>> This patch introduces a new spinlock_refcount.h header file to be
>> included by kernel code that want to do a lockless update of reference
>> count protected by a spinlock.
> So I really like the concept, but the implementation is a mess, and
> tries to do too much, while actually achieving too little.
>
> I do not believe you should care about debug spinlocks at all, and
> just leave them be. Have a simple fallback code that defaults to
> regular counts and spinlocks, and have any debug cases just use that.

I was concern that people might want to have the same behavior even when 
spinlock debugging was  on. Apparently, this is not really needed. Now I 
can just disable the optimization and fall back to the old path when 
spinlock debugging is on.

> But more importantly, I think this needs to be architecture-specific,
> and using<linux/spinlock_refcount.h>  to try to do some generic 64-bit
> cmpxchg() version is a bad bad idea.

Yes, I can put the current implementation into 
asm-generic/spinlock_refcount.h. Now I need to put an 
asm/spinlock_refcount.h into every arch's include/asm directory. Right? 
I don't think there is a mechanism in the build script to create a 
symlink from asm to generic-asm when a header file is missing. Is it the 
general rule that we should have a linux/spinlock_refcount.h that 
include asm/spinlock_refcount.h instead of including 
asm/spinlock_refcount.h directly?

> We have several architectures coming up that have memory transaction
> support, and the "spinlock with refcount" is a perfect candidate for a
> transactional memory implementation. So when introducing a new atomic
> like this that is very performance-critical and used for some very
> core code, I really think architectures would want to make their own
> optimized versions.
>
> These things should also not be inlined, I think.
>
> So I think the concept is good, but I think the implementation needs
> more thought.
>
>                         Linus

Thank for the comment. I will try to come up with a version that is 
acceptable to all stakeholders.

Regards,
Longman

