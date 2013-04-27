Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab3D0QOR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 12:14:17 -0400
Received: from mail.skyhub.de ([78.46.96.112]:49636 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623Ab3D0QOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 12:14:15 -0400
Date: Sat, 27 Apr 2013 18:14:07 +0200
From: Borislav Petkov <bp@alien8.de>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl, tytso@mit.edu,
        davem@davemloft.net, fweisbec@gmail.com, oleg@redhat.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf/x86/intel/P4: Robistify P4 PMU types
Message-ID: <20130427161407.GD4358@pd.tnic>
References: <20130424072630.GB1780@gmail.com>
 <tip-5ac2b5c2721501a8f5c5e1cd4116cbc31ace6886@git.kernel.org>
 <20130426161328.GA16818@pd.tnic>
 <20130426162444.GC17430@moon>
 <20130426163952.GC15361@pd.tnic>
 <20130426164652.GO13008@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130426164652.GO13008@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 08:46:52PM +0400, Cyrill Gorcunov wrote:
> On Fri, Apr 26, 2013 at 06:39:52PM +0200, Borislav Petkov wrote:
> >                                              #    0.25  stalled cycles per insn
> >            590,855 branches                  #  237.877 M/sec
> >             12,882 branch-misses             #    2.18% of all branches
> > 	    ^^^^^^^^^^^^^^^^^^^^
> > 
> > Those above?

Well, perf top looks ok to me, here's a snapshot:

   PerfTop:      63 irqs/sec  kernel:79.4%  exact:  0.0% [4000Hz cycles],  (all, 2 CPUs)
--------------------------------------------------------------------------------------------------------------------------------------------

    11.21%  [kernel]               [k] __lock_acquire                
     7.87%  libc-2.13.so           [.] 0x00078b0c                    
     5.78%  libz.so.1.2.7          [.] 0x00003731                    
     4.29%  libpthread-2.13.so     [.] pthread_rwlock_unlock         
     3.74%  libpthread-2.13.so     [.] pthread_rwlock_rdlock         
     3.67%  [kernel]               [k] lock_release                  
     2.55%  [kernel]               [k] lock_acquire                  
     2.27%  perf                   [.] symbols__insert               
     2.15%  sshd                   [.] 0x0004707e                    
     1.62%  libc-2.13.so           [.] vfprintf                      
     1.58%  [kernel]               [k] mark_held_locks               
     1.40%  [kernel]               [k] do_raw_spin_lock              
     1.37%  [kernel]               [k] trace_hardirqs_on_caller      
     1.29%  [kernel]               [k] sub_preempt_count             
     1.17%  perf                   [.] symbol_filter                 
     1.13%  [kernel]               [k] mark_lock                     
     1.05%  [kernel]               [k] trace_hardirqs_off_caller     
     0.96%  perf                   [.] rb_next                       
     0.94%  libc-2.13.so           [.] memchr                        
     0.80%  libbfd-2.22-system.so  [.] 0x000bb009                    
     0.72%  [kernel]               [k] __schedule                    
     0.71%  [kernel]               [k] ioread16                      
     0.67%  [kernel]               [k] _raw_spin_unlock_irqrestore   
     0.66%  [kernel]               [k] __switch_to                   
     0.59%  [kernel]               [k] do_raw_spin_unlock            
     0.56%  perf                   [.] dso__load_sym
...

I can annotate symbols and disassemble works fine too, along with
refresh and per-insn overhead.

The other trivial test passes too, although branch-misses doesn't get
counted:

./perf stat sleep 1

 Performance counter stats for 'sleep 1':

          1.433368 task-clock                #    0.001 CPUs utilized          
                 1 context-switches          #    0.698 K/sec                  
                 0 cpu-migrations            #    0.000 K/sec                  
               147 page-faults               #    0.103 M/sec                  
            78,446 cycles                    #    0.055 GHz                    
                 0 stalled-cycles-frontend   #    0.00% frontend cycles idle   
                 0 stalled-cycles-backend    #    0.00% backend  cycles idle    [27.37%]
         1,268,044 instructions              #   16.16  insns per cycle         [27.37%]
           223,742 branches                  #  156.095 M/sec                   [27.37%]
     <not counted> branch-misses

       1.002191045 seconds time elapsed

However, if I do this, it works:

./perf stat -e branch-misses sleep 1

 Performance counter stats for 'sleep 1':

             8,583 branch-misses

       1.001992384 seconds time elapsed


Oh, btw, tip/master has

commit 697dfd884438058b15032b0169887c742704434a
Merge: 0fbd06761f5c f697036b93aa
Author: H. Peter Anvin <hpa@linux.intel.com>
Date:   Thu Apr 25 14:00:22 2013 -0700

    Merge tag 'efi-urgent' into x86/urgent

as its top commit.

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
