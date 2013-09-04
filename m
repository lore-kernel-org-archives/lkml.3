Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762828Ab3IDOxW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:53:22 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:45064 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762628Ab3IDOxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:53:20 -0400
Message-ID: <52274943.1040005@hp.com>
Date: Wed, 04 Sep 2013 10:52:51 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
References: <5220F090.5050908@hp.com> <20130830194059.GC13318@ZenIV.linux.org.uk> <5220F811.9060902@hp.com> <20130830202608.GD13318@ZenIV.linux.org.uk> <52210225.60805@hp.com> <20130830204852.GE13318@ZenIV.linux.org.uk> <52214EBC.90100@hp.com> <20130831023516.GI13318@ZenIV.linux.org.uk> <20130831024233.GJ13318@ZenIV.linux.org.uk> <5224E647.80303@hp.com> <20130903060130.GD16261@gmail.com> <5225FCEE.7030901@hp.com> <CA+55aFyNmLt9GeR5XyxOs7aGLwH3EBCB+K9D6uGBef3FziP2-A@mail.gmail.com> <CA+55aFw0jme+qK5b_VJVqoVD6cZuSjVsm-Sgjf_YkPXgMToqUA@mail.gmail.com>
In-Reply-To: <CA+55aFw0jme+qK5b_VJVqoVD6cZuSjVsm-Sgjf_YkPXgMToqUA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 03:09 PM, Linus Torvalds wrote:
> On Tue, Sep 3, 2013 at 8:34 AM, Linus Torvalds
> <torvalds@linux-foundation.org>  wrote:
>> I suspect the tty_ldisc_lock() could be made to go away if we care.
> Heh. I just pulled the tty patches from Greg, and the locking has
> changed completely.
>
> It may actually fix your AIM7 test-case, because while the global
> spinlock remains (it got renamed to "tty_ldiscs_lock" - there's an
> added "s"), the common operations now take the per-tty lock to get the
> ldisc for that tty, rather than that global spinlock (which just
> protects the actual ldisk array now).
>
> That said, I don't know what AIM7 really ends up doing, but your
> profile seems to have every access through tty_ldisc_[de]ref() that
> now uses only the per-tty lock. Of course, how much that helps ends up
> depending on whether AIM7 uses lots of tty's or just one shared one.
>
> Anyway, it might be worth testing my current -git tree.
>
>                    Linus

The latest tty patches did work. The tty related spinlock contention is 
now completely gone. The short workload can now reach over 8M JPM which 
is the highest I have ever seen.

The perf profile was:

5.85%     reaim  reaim                 [.] mul_short
4.87%     reaim  [kernel.kallsyms]     [k] ebitmap_get_bit
4.72%     reaim  reaim                 [.] mul_int
4.71%     reaim  reaim                 [.] mul_long
2.67%     reaim  libc-2.12.so          [.] __random_r
2.64%     reaim  [kernel.kallsyms]     [k] lockref_get_not_zero
1.58%     reaim  [kernel.kallsyms]     [k] copy_user_generic_string
1.48%     reaim  [kernel.kallsyms]     [k] mls_level_isvalid
1.35%     reaim  [kernel.kallsyms]     [k] find_next_bit
1.23%     reaim  [kernel.kallsyms]     [k] system_call
1.21%     reaim  libc-2.12.so          [.] memcpy
1.19%     reaim  [kernel.kallsyms]     [k] _raw_spin_lock
1.06%     reaim  [kernel.kallsyms]     [k] avc_has_perm_flags
1.04%     reaim  libc-2.12.so          [.] __srandom_r
1.02%     reaim  reaim                 [.] newton_raphson
1.01%     reaim  [kernel.kallsyms]     [k] update_cfs_rq_blocked_load
0.98%     reaim  [kernel.kallsyms]     [k] fsnotify
0.94%     reaim  [kernel.kallsyms]     [k] avtab_search_node
0.91%     reaim  libm-2.12.so          [.] __sincos

I have a patch in linux-next that should eliminate ebitmap_get_bit, 
mls_leve_isvalid and find_next_bit from the list top once it is merged.

Regards,
Longman
