Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab3F2VeW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 17:34:22 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:40448 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3F2VeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 17:34:20 -0400
Message-ID: <51CF52D1.1080406@hp.com>
Date: Sat, 29 Jun 2013 17:34:09 -0400
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
References: <1372268603-46748-1-git-send-email-Waiman.Long@hp.com> <1372268603-46748-2-git-send-email-Waiman.Long@hp.com> <CA+55aFzo5Jy064pbvEZh5cg_RJiSxe1R+tSgByQTs4rc=4SN3Q@mail.gmail.com> <51CF422E.7030803@hp.com>
In-Reply-To: <51CF422E.7030803@hp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/29/2013 04:23 PM, Waiman Long wrote:
> On 06/29/2013 01:45 PM, Linus Torvalds wrote:
>
>> But more importantly, I think this needs to be architecture-specific,
>> and using<linux/spinlock_refcount.h>  to try to do some generic 64-bit
>> cmpxchg() version is a bad bad idea.
>
> Yes, I can put the current implementation into 
> asm-generic/spinlock_refcount.h. Now I need to put an 
> asm/spinlock_refcount.h into every arch's include/asm directory. 
> Right? I don't think there is a mechanism in the build script to 
> create a symlink from asm to generic-asm when a header file is 
> missing. Is it the general rule that we should have a 
> linux/spinlock_refcount.h that include asm/spinlock_refcount.h instead 
> of including asm/spinlock_refcount.h directly?
>
>> We have several architectures coming up that have memory transaction
>> support, and the "spinlock with refcount" is a perfect candidate for a
>> transactional memory implementation. So when introducing a new atomic
>> like this that is very performance-critical and used for some very
>> core code, I really think architectures would want to make their own
>> optimized versions.
>>
>> These things should also not be inlined, I think.
>>

I think I got it now. For architecture with transactional memory support 
to use an alternative implementation, we will need to use some kind of 
dynamic patching at kernel boot up time as not all CPUs in that 
architecture will have that support. In that case the helper functions 
have to be real functions and cannot be inlined. That means I need to 
put the implementation into a spinlock_refcount.c file with the header 
file contains structure definitions and function prototypes only. Is 
that what you are looking for?

Regards,
Longman
