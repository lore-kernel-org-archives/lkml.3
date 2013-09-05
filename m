Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab3IENb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 09:31:29 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:45932 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755Ab3IENb1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 09:31:27 -0400
Date: Thu, 5 Sep 2013 15:31:23 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
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
Message-ID: <20130905133123.GA24351@gmail.com>
References: <20130830204852.GE13318@ZenIV.linux.org.uk>
 <52214EBC.90100@hp.com>
 <20130831023516.GI13318@ZenIV.linux.org.uk>
 <20130831024233.GJ13318@ZenIV.linux.org.uk>
 <5224E647.80303@hp.com>
 <20130903060130.GD16261@gmail.com>
 <5225FCEE.7030901@hp.com>
 <CA+55aFyNmLt9GeR5XyxOs7aGLwH3EBCB+K9D6uGBef3FziP2-A@mail.gmail.com>
 <CA+55aFw0jme+qK5b_VJVqoVD6cZuSjVsm-Sgjf_YkPXgMToqUA@mail.gmail.com>
 <52274943.1040005@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52274943.1040005@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Waiman Long <waiman.long@hp.com> wrote:

> On 09/03/2013 03:09 PM, Linus Torvalds wrote:
> >On Tue, Sep 3, 2013 at 8:34 AM, Linus Torvalds
> ><torvalds@linux-foundation.org>  wrote:
> >>I suspect the tty_ldisc_lock() could be made to go away if we care.
> >Heh. I just pulled the tty patches from Greg, and the locking has
> >changed completely.
> >
> >It may actually fix your AIM7 test-case, because while the global
> >spinlock remains (it got renamed to "tty_ldiscs_lock" - there's an
> >added "s"), the common operations now take the per-tty lock to get the
> >ldisc for that tty, rather than that global spinlock (which just
> >protects the actual ldisk array now).
> >
> >That said, I don't know what AIM7 really ends up doing, but your
> >profile seems to have every access through tty_ldisc_[de]ref() that
> >now uses only the per-tty lock. Of course, how much that helps ends up
> >depending on whether AIM7 uses lots of tty's or just one shared one.
> >
> >Anyway, it might be worth testing my current -git tree.
> >
> >                   Linus
> 
> The latest tty patches did work. The tty related spinlock contention
> is now completely gone. The short workload can now reach over 8M JPM
> which is the highest I have ever seen.
> 
> The perf profile was:
> 
> 5.85%     reaim  reaim                 [.] mul_short
> 4.87%     reaim  [kernel.kallsyms]     [k] ebitmap_get_bit
> 4.72%     reaim  reaim                 [.] mul_int
> 4.71%     reaim  reaim                 [.] mul_long
> 2.67%     reaim  libc-2.12.so          [.] __random_r
> 2.64%     reaim  [kernel.kallsyms]     [k] lockref_get_not_zero
> 1.58%     reaim  [kernel.kallsyms]     [k] copy_user_generic_string
> 1.48%     reaim  [kernel.kallsyms]     [k] mls_level_isvalid
> 1.35%     reaim  [kernel.kallsyms]     [k] find_next_bit

6%+ spent in ebitmap_get_bit() and mls_level_isvalid() looks like 
something worth optimizing.

Is that called very often, or is it perhaps cache-bouncing for some 
reason?

Btw., you ought to be able to see instructions where the CPU is in some 
sort of stall (either it ran out of work, or it is cache-missing, or it is 
executing something complex), via:

  perf top -e stalled-cycles-frontend -e stalled-cycles-backend

run it for a while and pick the one which has more entries and have a 
look. Both profiles will keep updating in the background.

(Note: on Haswell CPUs stalled-cycles events are not yet available.)

Another performance analysis trick is to run this while your workload is 
executing:

  perf stat -a -ddd sleep 60

and have a look at the output - it will color-code suspicious looking 
counts.

For example, this is on a 32-way box running a kernel build:

vega:~> perf stat -addd sleep 10

 Performance counter stats for 'sleep 10':

     320753.639566 task-clock                #   32.068 CPUs utilized           [100.00%]
           187,962 context-switches          #    0.586 K/sec                   [100.00%]
            22,989 cpu-migrations            #    0.072 K/sec                   [100.00%]
         6,622,424 page-faults               #    0.021 M/sec                  
   817,576,186,285 cycles                    #    2.549 GHz                     [27.82%]
   214,366,744,930 stalled-cycles-frontend   #   26.22% frontend cycles idle    [16.75%]
    45,454,323,703 stalled-cycles-backend    #    5.56% backend  cycles idle    [16.72%]
   474,770,833,376 instructions              #    0.58  insns per cycle        
                                             #    0.45  stalled cycles per insn [22.27%]
   105,860,676,229 branches                  #  330.037 M/sec                   [33.37%]
     5,964,088,457 branch-misses             #    5.63% of all branches         [33.36%]
   244,982,563,232 L1-dcache-loads           #  763.772 M/sec                   [33.35%]
     7,503,377,286 L1-dcache-load-misses     #    3.06% of all L1-dcache hits   [33.36%]
    19,606,194,180 LLC-loads                 #   61.125 M/sec                   [22.26%]
     1,232,340,603 LLC-load-misses           #    6.29% of all LL-cache hits    [16.69%]
   261,749,251,526 L1-icache-loads           #  816.045 M/sec                   [16.69%]
    11,821,747,974 L1-icache-load-misses     #    4.52% of all L1-icache hits   [16.67%]
   244,253,746,431 dTLB-loads                #  761.500 M/sec                   [27.78%]
       126,546,407 dTLB-load-misses          #    0.05% of all dTLB cache hits  [33.30%]
   260,909,042,891 iTLB-loads                #  813.425 M/sec                   [33.31%]
        73,911,000 iTLB-load-misses          #    0.03% of all iTLB cache hits  [33.31%]
     7,989,072,388 L1-dcache-prefetches      #   24.907 M/sec                   [27.76%]
                 0 L1-dcache-prefetch-misses #    0.000 K/sec                   [33.32%]

      10.002245831 seconds time elapsed

the system is nicely saturated, caches are more or less normally utilized, 
but about a quarter of all frontend cycles are idle.

So then I ran:

  perf top -e stalled-cycles-frontend

which gave me this profile:

     2.21%            cc1  cc1                                [.] ht_lookup_with_hash                                  
     1.86%            cc1  libc-2.15.so                       [.] _int_malloc                                          
     1.66%            cc1  [kernel.kallsyms]                  [k] page_fault                                           
     1.48%            cc1  cc1                                [.] _cpp_lex_direct                                      
     1.33%            cc1  cc1                                [.] grokdeclarator                                       
     1.26%            cc1  cc1                                [.] ggc_internal_alloc_stat                              
     1.19%            cc1  cc1                                [.] ggc_internal_cleared_alloc_stat                      
     1.12%            cc1  libc-2.15.so                       [.] _int_free                                            
     1.10%            cc1  libc-2.15.so                       [.] malloc                                               
     0.95%            cc1  cc1                                [.] c_lex_with_flags                                     
     0.95%            cc1  cc1                                [.] cpp_get_token_1                                      
     0.92%            cc1  cc1                                [.] c_parser_declspecs                                   

where gcc's ht_lookup_with_hash() is having trouble:

which function is visibly getting stalls from a hash walk:

    0.79 :        a0f303:       addl   $0x1,0x80(%rdi)
    0.01 :        a0f30a:       mov    %rdi,%rbx
    0.18 :        a0f30d:       mov    %rsi,%r15
    0.00 :        a0f310:       lea    -0x1(%r14),%r13d
    0.13 :        a0f314:       and    %r13d,%r10d
    0.05 :        a0f317:       mov    %r10d,%eax
    0.34 :        a0f31a:       mov    (%rcx,%rax,8),%r9
   24.87 :        a0f31e:       lea    0x0(,%rax,8),%rdx
    0.02 :        a0f326:       test   %r9,%r9
    0.00 :        a0f329:       je     a0f5bd <ht_lookup_with_hash+0x2ed>
    0.31 :        a0f32f:       cmp    $0xffffffffffffffff,%r9
    0.18 :        a0f333:       je     a0f6e1 <ht_lookup_with_hash+0x411>
    0.37 :        a0f339:       cmp    %r12d,0xc(%r9)
   24.41 :        a0f33d:       jne    a0f3a0 <ht_lookup_with_hash+0xd0>

So giving that function some attention would probably give the most bang 
for bucks on this particular workload.

Thanks,

	Ingo
