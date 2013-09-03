Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761455Ab3ICXLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 19:11:45 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:56480 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933207Ab3ICXLH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 19:11:07 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUXsPTXT8TYoVp+_xnhB5EgnR4FyadaVVzXBFOVA=9fQ9g@mail.gmail.com>
References: <5220F090.5050908@hp.com>
	<20130830194059.GC13318@ZenIV.linux.org.uk>
	<5220F811.9060902@hp.com>
	<20130830202608.GD13318@ZenIV.linux.org.uk>
	<52210225.60805@hp.com>
	<20130830204852.GE13318@ZenIV.linux.org.uk>
	<52214EBC.90100@hp.com>
	<20130831023516.GI13318@ZenIV.linux.org.uk>
	<20130831024233.GJ13318@ZenIV.linux.org.uk>
	<5224E647.80303@hp.com>
	<20130903060130.GD16261@gmail.com>
	<5225FCEE.7030901@hp.com>
	<CA+icZUXsPTXT8TYoVp+_xnhB5EgnR4FyadaVVzXBFOVA=9fQ9g@mail.gmail.com>
Date: Wed, 4 Sep 2013 01:11:05 +0200
Message-ID: <CA+icZUXBNoiBCjsLr6Nbdtw5aEGXN_13vgZ4H7CGZ4qVnOiwAw@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] spinlock: A new lockref structure for lockless
 update of refcount
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Waiman Long <waiman.long@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 4, 2013 at 12:41 AM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Tue, Sep 3, 2013 at 5:14 PM, Waiman Long <waiman.long@hp.com> wrote:
>> On 09/03/2013 02:01 AM, Ingo Molnar wrote:
>>>
>>> * Waiman Long<waiman.long@hp.com>  wrote:
>>>
>>>> Yes, that patch worked. It eliminated the lglock as a bottleneck in the
>>>> AIM7 workload. The lg_global_lock did not show up in the perf profile,
>>>> whereas the lg_local_lock was only 0.07%.
>>>
>>> Just curious: what's the worst bottleneck now in the optimized kernel? :-)
>>>
>>> Thanks,
>>>
>>>         Ingo
>>
>> With the following patches on v3.11:
>> 1. Linus's version of lockref patch
>> 2. Al's lglock patch
>> 3. My preliminary patch to convert prepend_path under RCU
>>
>
> With no reference where to get those patches, it's a bit hard to follow.
>
> I will try some perf benchmarking with the attached patch against
> Linux "WfW" edition.
>

Eat thiz...

$ cat /proc/version
Linux version 3.11.0-1-lockref-small (sedat.dilek@gmail.com@fambox)
(gcc version 4.6.3 (Ubuntu/Linaro 4.6.3-1ubuntu5) ) #1 SMP Wed Sep 4
00:53:25 CEST 2013

$ ~/src/linux-kernel/linux/tools/perf/perf stat --null --repeat 5
../scripts/t_lockref_from-linus
Total loops: 26786226
Total loops: 26970142
Total loops: 26593312
Total loops: 26885806
Total loops: 26944076

 Performance counter stats for '../scripts/t_lockref_from-linus' (5 runs):

      10,011755076 seconds time elapsed
          ( +-  0,10% )

$ sudo ~/src/linux-kernel/linux/tools/perf/perf record -e cycles:pp
../scripts/t_lockref_from-linus
Total loops: 26267751
[ perf record: Woken up 25 times to write data ]
[ perf record: Captured and wrote 6.112 MB perf.data (~267015 samples) ]

$ sudo ~/src/linux-kernel/linux/tools/perf/perf report -tui

Samples: 159K of event 'cycles:pp', Event count (approx.): 77088218721
 12,52%uit_lockref_from-ui[kernel.kallsyms]   ui[k] irq_ret.rn
  4,37%uit_lockref_from-ui[kernel.kallsyms]   ui[k] __ticket_spin_lock
  4,18%uit_lockref_from-ui[kernel.kallsyms]   ui[k] __acct_.pdate_integrals
  3,90%uit_lockref_from-ui[kernel.kallsyms]   ui[k] .ser_exit
  3,17%uit_lockref_from-ui[kernel.kallsyms]   ui[k] __d_look.p_rc.
  3,14%uit_lockref_from-ui[kernel.kallsyms]   ui[k] lockref_get_or_lock
  3,01%uit_lockref_from-ui[kernel.kallsyms]   ui[k] local_clock
  2,72%uit_lockref_from-ui[kernel.kallsyms]   ui[k] kmem_cache_alloc
  2,54%uit_lockref_from-uilibc-2.15.so        ui[.] __xstat64
  2,45%uit_lockref_from-ui[kernel.kallsyms]   ui[k] link_path_walk
  2,23%uit_lockref_from-ui[kernel.kallsyms]   ui[k] kmem_cache_free
  1,90%uit_lockref_from-ui[kernel.kallsyms]   ui[k] rc._eqs_exit_common.isra.43
  1,88%uit_lockref_from-ui[kernel.kallsyms]   ui[k] tracesys
  1,82%uit_lockref_from-ui[kernel.kallsyms]   ui[k] rc._eqs_enter_common.isra.45
  1,77%uit_lockref_from-ui[kernel.kallsyms]   ui[k] sched_clock_cp.
  1,76%uit_lockref_from-ui[kernel.kallsyms]   ui[k] .ser_enter
  1,73%uit_lockref_from-ui[kernel.kallsyms]   ui[k] lockref_p.t_or_lock
  1,70%uit_lockref_from-ui[kernel.kallsyms]   ui[k] path_look.pat
  1,53%uit_lockref_from-ui[kernel.kallsyms]   ui[k] native_read_tsc
  1,52%uit_lockref_from-ui[kernel.kallsyms]   ui[k] native_sched_clock
  1,51%uit_lockref_from-ui[kernel.kallsyms]   ui[k] cp_new_stat
  1,51%uit_lockref_from-ui[kernel.kallsyms]   ui[k] syscall_trace_enter
  1,46%uit_lockref_from-ui[kernel.kallsyms]   ui[k] acco.nt_system_time
  1,42%uit_lockref_from-ui[kernel.kallsyms]   ui[k] path_init
  1,42%uit_lockref_from-ui[kernel.kallsyms]   ui[k] copy_.ser_generic_.nrolled
  1,39%uit_lockref_from-ui[kernel.kallsyms]   ui[k] jiffies_to_timeval
  1,39%uit_lockref_from-ui[kernel.kallsyms]   ui[k] getname_flags
  1,37%uit_lockref_from-ui[kernel.kallsyms]   ui[k] vfs_getattr
  1,25%uit_lockref_from-ui[kernel.kallsyms]   ui[k] common_perm
  1,14%uit_lockref_from-ui[kernel.kallsyms]   ui[k] get_vtime_delta
  1,13%uit_lockref_from-ui[kernel.kallsyms]   ui[k] look.p_fast
  1,12%uit_lockref_from-ui[kernel.kallsyms]   ui[k] syscall_trace_leave
  1,05%uit_lockref_from-ui[kernel.kallsyms]   ui[k] system_call
  0,99%uit_lockref_from-ui[kernel.kallsyms]   ui[k] generic_fillattr
  0,94%uit_lockref_from-ui[kernel.kallsyms]   ui[k] .ser_path_at_empty
  0,91%uit_lockref_from-ui[kernel.kallsyms]   ui[k] acco.nt_.ser_time
  0,90%uit_lockref_from-ui[kernel.kallsyms]   ui[k] __ticket_spin_.nlock
  0,87%uit_lockref_from-ui[kernel.kallsyms]   ui[k] strncpy_from_.ser
  0,83%uit_lockref_from-ui[kernel.kallsyms]   ui[k] filename_look.p
  0,82%uit_lockref_from-ui[kernel.kallsyms]   ui[k] generic_permission
  0,78%uit_lockref_from-ui[kernel.kallsyms]   ui[k] complete_walk
  0,75%uit_lockref_from-ui[kernel.kallsyms]   ui[k] vfs_fstatat
  0,74%uit_lockref_from-ui[kernel.kallsyms]   ui[k] lg_local_lock
  0,72%uit_lockref_from-ui[kernel.kallsyms]   ui[k] vtime_acco.nt_.ser
  0,67%uit_lockref_from-ui[kernel.kallsyms]   ui[k] dp.t
  0,66%uit_lockref_from-ui[kernel.kallsyms]   ui[k] __inode_permission
  0,62%uit_lockref_from-ui[kernel.kallsyms]   ui[k] rc._eqs_enter
  0,58%uit_lockref_from-ui[kernel.kallsyms]   ui[k] lg_local_.nlock
  0,56%uit_lockref_from-ui[kernel.kallsyms]   ui[k] vtime_.ser_enter
  0,50%uit_lockref_from-ui[kernel.kallsyms]   ui[k] cp.acct_acco.nt_field
  0,48%uit_lockref_from-ui[kernel.kallsyms]   ui[k] sec.rity_inode_permission
  0,48%uit_lockref_from-uit_lockref_from-lin.sui[.] start_ro.tine
  0,47%uit_lockref_from-ui[kernel.kallsyms]   ui[k] sec.rity_inode_getattr
  0,47%uit_lockref_from-ui[kernel.kallsyms]   ui[k] acct_acco.nt_cp.time
Press '?' for help on key bindings

Here the annotated entries for the first two entries:

irq_return
       │
       │
       │
       │    Disassembly of section .text:
       │
       │    ffffffff816d4f2c <irq_return>:
100,00 │    ↓ jmpq   120
       │      data32 data32 data32 data32 nopw %cs:0x0(%rax,%rax,1)


__ticket_spin_lock
       │
       │
       │
       │    Disassembly of section .text:
       │
       │    ffffffff8104ff10 <__ticket_spin_lock>:
  2,55 │      push   %rbp
  1,19 │      mov    $0x10000,%eax
  2,16 │      mov    %rsp,%rbp
 84,70 │      lock   xadd   %eax,(%rdi)
  0,14 │      mov    %eax,%edx
       │      shr    $0x10,%edx
  4,33 │      cmp    %ax,%dx
  0,03 │    ↓ je     2a
       │      nop
       │20:   pause
  0,03 │      movzwl (%rdi),%eax
       │      cmp    %dx,%ax
       │    ↑ jne    20
  0,03 │2a:   pop    %rbp
  4,84 │    ← retq

- Sedat -
