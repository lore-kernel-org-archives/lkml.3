Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751051AbaEGRS3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 13:18:29 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:35530 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaEGRS1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 13:18:27 -0400
Date: Wed, 7 May 2014 19:18:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Richard Yao <ryao@gentoo.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, Jiri Slaby <jslaby@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel@gentoo.org, Brian Behlendorf <behlendorf1@llnl.gov>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] x86/dumpstack: Walk frames when built with frame pointers
Message-ID: <20140507171821.GA16671@gmail.com>
References: <1398535818-14217-1-git-send-email-ryao@gentoo.org>
 <20140427120820.GC22116@gmail.com>
 <CA+55aFw39HcWMYsPXb=PMK6--bHCSWwrjucGK+4VswEZrWLbGA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <CA+55aFw39HcWMYsPXb=PMK6--bHCSWwrjucGK+4VswEZrWLbGA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So to take your example, it might be something like this
> 
> arch_trigger_all_cpu_backtrace+0x3c -> do_raw_spin_lock+0xb7
>  -> _raw_spin_lock_irqsave+0x35 -> ? prepare_to_wait+0x18
>  -> prepare_to_wait+0x18 -> ? generic_make_request+0x80
>  -> ? unmap_underlying_metadata+0x2e -> __wait_on_bit+0x20
>  -> ? submit_bio+0xd2 -> out_of_line_wait_on_bit+0x54
>  -> ? unmap_underlying_metadata+0x2e -> ? autoremove_wake_function+0x31
>  -> __wait_on_buffer+0x1b -> __ext3_get_inode_loc+0x1ef -> ext3_iget+0x45
>  -> ext3_lookup+0x97 -> lookup_real+0x20 -> __lookup_hash+0x2a
>  -> lookup_slow+0x36 -> path_lookupat+0xf9 -> filename_lookup+0x1f
>  -> user_path_at_empty+0x3f -> user_path_at+0xd -> vfs_fstatat+0x40
>  -> ? lg_local_unlock+0x31 -> vfs_stat+0x13 -> sys_stat64+0x11
>  -> ? __fput+0x187 -> ? restore_all+0xf -> ? trace_hardirqs_on_thunk+0xc
>  -> syscall_call+0x7
> 
> which is admittedly complete line noise, but is just 13 lines rather 
> than 31. That can sometimes be a really big deal.

Let me try to offer a few more mockups with different typographical 
variants:

1) 'intelligently skip offsets':

 arch_trigger_all_cpu_backtrace -> do_raw_spin_lock
  -> _raw_spin_lock_irqsave -> ? prepare_to_wait
  -> prepare_to_wait -> ? generic_make_request
  -> ? unmap_underlying_metadata -> __wait_on_bit
  -> ? submit_bio+0xd2 -> out_of_line_wait_on_bit
  -> ? unmap_underlying_metadata -> ? autoremove_wake_function
  -> __wait_on_buffer -> __ext3_get_inode_loc -> ext3_iget
  -> ext3_lookup -> lookup_real -> __lookup_hash
  -> lookup_slow -> path_lookupat -> filename_lookup
  -> user_path_at_empty -> user_path_at -> vfs_fstatat
  -> ? lg_local_unlock -> vfs_stat -> sys_stat64
  -> ? __fput -> ? restore_all -> ? trace_hardirqs_on_thunk
  -> syscall_call+0x7

Note how the offset is skipped intelligently, by adding an attribute 
to kallsyms entries: the number of callouts in that function. For 
functions that only have a single call, no offset information is 
needed.

For functions that have multiple call instructions, the offset is 
printed - such as the 'submit_bio+0xd2' case shows it in the mockup 
above.

2) +'vertically aligned, screen split in two'

       arch_trigger_all_cpu_backtrace    -> do_raw_spin_lock
    -> _raw_spin_lock_irqsave            -> ? prepare_to_wait
    -> prepare_to_wait                   -> ? generic_make_request
    -> ? unmap_underlying_metadata       -> __wait_on_bit
    -> ? submit_bio+0xd2                 -> out_of_line_wait_on_bit
    -> ? unmap_underlying_metadata       -> ? autoremove_wake_function
    -> __wait_on_buffer                  -> __ext3_get_inode_loc
    -> ext3_iget                         -> ext3_lookup
    -> lookup_real                       -> __lookup_hash
    -> lookup_slow                       -> path_lookupat
    -> filename_lookup                   -> user_path_at_empty
    -> user_path_at                      -> vfs_fstatat
    -> ? lg_local_unlock                 -> vfs_stat
    -> sys_stat64                        -> ? __fput
    -> ? restore_all                     -> ? trace_hardirqs_on_thunk
    -> syscall_call

This is pretty readable, and if you only look at the left side column, 
it still gives a shortened 'pattern' that gives an impression as to 
what rough call context this is.

The first and last entry would always be printed on the left hand 
side, to make the 'left column' unconditionally readable.

This mockup fits on 80col screens.

3) +'function parentheses'

       arch_trigger_all_cpu_backtrace()    -> do_raw_spin_lock()
    -> _raw_spin_lock_irqsave()            -> ? prepare_to_wait
    -> prepare_to_wait()                   -> ? generic_make_request
    -> ? unmap_underlying_metadata         -> __wait_on_bit()
    -> ? submit_bio+0xd2                   -> out_of_line_wait_on_bit()
    -> ? unmap_underlying_metadata         -> ? autoremove_wake_function
    -> __wait_on_buffer()                  -> __ext3_get_inode_loc()
    -> ext3_iget()                         -> ext3_lookup()
    -> lookup_real()                       -> __lookup_hash()
    -> lookup_slow()                       -> path_lookupat()
    -> filename_lookup()                   -> user_path_at_empty()
    -> user_path_at()                      -> vfs_fstatat()
    -> ? lg_local_unlock                   -> vfs_stat()
    -> sys_stat64()                        -> ? __fput
    -> ? restore_all                       -> ? trace_hardirqs_on_thunk
    -> syscall_call()+0x7

This is more readable to me personally, as it's more C-alike. Note how 
only 'real' FP entries without question marks get the parentheses. 
This gives more visual separation between 'real' and 'noise' entries.

4) +'square brackets for unknown entries'

       arch_trigger_all_cpu_backtrace()    -> do_raw_spin_lock()
    -> _raw_spin_lock_irqsave()            -> ? [prepare_to_wait]
    -> prepare_to_wait()                   -> ? [generic_make_request]
    -> ? [unmap_underlying_metadata]       -> __wait_on_bit()
    -> ? [submit_bio+0xd2]                 -> out_of_line_wait_on_bit()
    -> ? [unmap_underlying_metadata]       -> ? [autoremove_wake_function]
    -> __wait_on_buffer()                  -> __ext3_get_inode_loc()
    -> ext3_iget()                         -> ext3_lookup()
    -> lookup_real()                       -> __lookup_hash()
    -> lookup_slow()                       -> path_lookupat()
    -> filename_lookup()                   -> user_path_at_empty()
    -> user_path_at()                      -> vfs_fstatat()
    -> ? [lg_local_unlock]                 -> vfs_stat()
    -> sys_stat64()                        -> ? [__fput]
    -> ? [restore_all]                     -> ? [trace_hardirqs_on_thunk]
    -> syscall_call()+0x7

To my eyes this further de-emphasises 'unknown' entries that are 
uninteresting noise in most cases. Makes it a bit more easy for me to 
ignore them.

YMMV: the brackets might increase emphasis for you ...

5) #3+'vertically aligned, screen split in three'

       arch_trigger_all_cpu_backtrace()    -> do_raw_spin_lock()                  -> _raw_spin_lock_irqsave()
    -> ? prepare_to_wait()                 -> prepare_to_wait()                   -> ? generic_make_request()
    -> ? unmap_underlying_metadata()       -> __wait_on_bit()                     -> ? submit_bio()+0xd2
    -> out_of_line_wait_on_bit()           -> ? unmap_underlying_metadata()       -> ? autoremove_wake_function()
    -> __wait_on_buffer()                  -> __ext3_get_inode_loc()              -> ext3_iget()
    -> ext3_lookup()                       -> lookup_real()                       -> __lookup_hash()
    -> lookup_slow()                       -> path_lookupat()                     -> filename_lookup()
    -> user_path_at_empty()                -> user_path_at()                      -> vfs_fstatat()
    -> ? lg_local_unlock()                 -> vfs_stat()                          -> sys_stat64()
    -> ? __fput()                          -> ? restore_all()                     -> ? trace_hardirqs_on_thunk()
    -> syscall_call()+0x7

Still mostly readable, but more compressed, 11 lines only. Width is 
110+ chars though, so does not fit on col80 screens easily. This might 
be overdoing the horizontal compression, for little gain.

6) color tricks to de-emphasise unknown entries.

On color consoles I'd also print unknown entries in grey, to make it 
easier to interpret screenshots and 'dmesg' output. (The color codes 
might not make it into the syslog, but that's OK.)

I'd also print the symbolic resolution of the crash RIP in red.

Here's a mockup, I'm using ASCII color codes, so this might not render 
in color on all mail readers:

RIP: 0010:[<ffffffff81127cc2>]  [<ffffffff81127cc2>][31mgeneric_exec_single[m+0x52/0x70

=====================

Conclusion:

So to me #4 looks best, and it's 16 lines instead of 31. Not as 
compact as your mockup that has 13 lines, but pretty close.

(I'd also do the color tricks on #6, but that's more technically 
challenging and I also don't look forward fighting the syslog guys 
over it...)

I'd guess that some people would prefer #2 or #3, depending on how 
ergonomic the parentheses and brackets are for them.

Thanks,

	Ingo
