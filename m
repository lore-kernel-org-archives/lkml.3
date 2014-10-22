Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026AbaJVR0Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 13:26:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44506 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbaJVR0X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 13:26:23 -0400
Date: Wed, 22 Oct 2014 19:26:17 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Nicolas Pitre <nico@linaro.org>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: lockdep splat in CPU hotplug
In-Reply-To: <20141022125951.64fb1ed3@gandalf.local.home>
Message-ID: <alpine.LNX.2.00.1410221924040.17725@pobox.suse.cz>
References: <alpine.LNX.2.00.1410211255531.24255@pobox.suse.cz> <alpine.LNX.2.00.1410221125280.22681@pobox.suse.cz> <20141022125951.64fb1ed3@gandalf.local.home>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Oct 2014, Steven Rostedt wrote:

> > Still, the lockdep stacktrace is bogus and didn't really help 
> > understanding this. Any idea why it's wrong?
> 
> Could possibly be from a tail call?

Doesn't seem so:

(gdb) disassemble cpuidle_pause
Dump of assembler code for function cpuidle_pause:
   0xffffffff81491880 <+0>:     push   %rbp
   0xffffffff81491881 <+1>:     xor    %esi,%esi
   0xffffffff81491883 <+3>:     mov    $0xffffffff81a9eb20,%rdi
   0xffffffff8149188a <+10>:    mov    %rsp,%rbp
   0xffffffff8149188d <+13>:    callq  0xffffffff815b9ed0 <mutex_lock_nested>
   0xffffffff81491892 <+18>:    callq  0xffffffff81491680 <cpuidle_uninstall_idle_handler>
   0xffffffff81491897 <+23>:    mov    $0xffffffff81a9eb20,%rdi
   0xffffffff8149189e <+30>:    callq  0xffffffff815bbe60 <mutex_unlock>
   0xffffffff814918a3 <+35>:    pop    %rbp
   0xffffffff814918a4 <+36>:    retq   
End of assembler dump.
(gdb) disassemble cpuidle_uninstall_idle_handler
Dump of assembler code for function cpuidle_uninstall_idle_handler:
   0xffffffff81491680 <+0>:     mov    0x159da32(%rip),%eax        # 0xffffffff82a2f0b8 <enabled_devices>
   0xffffffff81491686 <+6>:     push   %rbp
   0xffffffff81491687 <+7>:     mov    %rsp,%rbp
   0xffffffff8149168a <+10>:    test   %eax,%eax
   0xffffffff8149168c <+12>:    je     0xffffffff8149169d <cpuidle_uninstall_idle_handler+29>
   0xffffffff8149168e <+14>:    movl   $0x0,0x64794c(%rip)        # 0xffffffff81ad8fe4 <initialized>
   0xffffffff81491698 <+24>:    callq  0xffffffff810cf9b0 <wake_up_all_idle_cpus>
   0xffffffff8149169d <+29>:    callq  0xffffffff810b47b0 <synchronize_sched>
   0xffffffff814916a2 <+34>:    pop    %rbp
   0xffffffff814916a3 <+35>:    retq   
End of assembler dump.
(gdb) disassemble synchronize_sched
Dump of assembler code for function synchronize_sched:
   0xffffffff810b47b0 <+0>:     push   %rbp
   0xffffffff810b47b1 <+1>:     xor    %edx,%edx
   0xffffffff810b47b3 <+3>:     mov    $0xad5,%esi
   0xffffffff810b47b8 <+8>:     mov    $0xffffffff817fad6d,%rdi
   0xffffffff810b47bf <+15>:    mov    %rsp,%rbp
   0xffffffff810b47c2 <+18>:    callq  0xffffffff81075900 <__might_sleep>
   0xffffffff810b47c7 <+23>:    incl   %gs:0xbaa0
   0xffffffff810b47cf <+31>:    mov    0x5587b2(%rip),%rdi        # 0xffffffff8160cf88 <cpu_online_mask>
   0xffffffff810b47d6 <+38>:    mov    $0x200,%esi
   0xffffffff810b47db <+43>:    callq  0xffffffff8130e710 <__bitmap_weight>
   0xffffffff810b47e0 <+48>:    decl   %gs:0xbaa0
   0xffffffff810b47e8 <+56>:    cmp    $0x1,%eax
   0xffffffff810b47eb <+59>:    jbe    0xffffffff810b4803 <synchronize_sched+83>
   0xffffffff810b47ed <+61>:    mov    0xbdf97d(%rip),%eax        # 0xffffffff81c94170 <rcu_expedited>
   0xffffffff810b47f3 <+67>:    test   %eax,%eax
   0xffffffff810b47f5 <+69>:    jne    0xffffffff810b4808 <synchronize_sched+88>
   0xffffffff810b47f7 <+71>:    mov    $0xffffffff810b3d80,%rdi
   0xffffffff810b47fe <+78>:    callq  0xffffffff810b1b00 <wait_rcu_gp>
   0xffffffff810b4803 <+83>:    pop    %rbp
   0xffffffff810b4804 <+84>:    retq   
   0xffffffff810b4805 <+85>:    nopl   (%rax)
   0xffffffff810b4808 <+88>:    callq  0xffffffff810b4820 <synchronize_sched_expedited>
   0xffffffff810b480d <+93>:    pop    %rbp
   0xffffffff810b480e <+94>:    xchg   %ax,%ax
   0xffffffff810b4810 <+96>:    retq   

> > >  ======================================================
> > >  [ INFO: possible circular locking dependency detected ]
> > >  3.18.0-rc1-00069-gc2661b8 #1 Not tainted
> > >  -------------------------------------------------------
> > >  do_s2disk/2367 is trying to acquire lock:
> > >   (cpuidle_lock){+.+.+.}, at: [<ffffffff814916c2>] cpuidle_pause_and_lock+0x12/0x20
> > >  
> > > but task is already holding lock:
> > >   (cpu_hotplug.lock#2){+.+.+.}, at: [<ffffffff810522ea>] cpu_hotplug_begin+0x4a/0x80
> > >  
> > > which lock already depends on the new lock.
> > > 
> > > the existing dependency chain (in reverse order) is:
> > > 
> > > -> #1 (cpu_hotplug.lock#2){+.+.+.}:
> > >         [<ffffffff81099fac>] lock_acquire+0xac/0x130
> > >         [<ffffffff815b9f2c>] mutex_lock_nested+0x5c/0x3b0
> > >         [<ffffffff81491892>] cpuidle_pause+0x12/0x30
> 
> Where exactly does that address point to?

(gdb) disassemble cpuidle_pause
Dump of assembler code for function cpuidle_pause:
   0xffffffff81491880 <+0>:     push   %rbp
   0xffffffff81491881 <+1>:     xor    %esi,%esi
   0xffffffff81491883 <+3>:     mov    $0xffffffff81a9eb20,%rdi
   0xffffffff8149188a <+10>:    mov    %rsp,%rbp
   0xffffffff8149188d <+13>:    callq  0xffffffff815b9ed0 <mutex_lock_nested>
   0xffffffff81491892 <+18>:    callq  0xffffffff81491680 <cpuidle_uninstall_idle_handler>
   0xffffffff81491897 <+23>:    mov    $0xffffffff81a9eb20,%rdi
   0xffffffff8149189e <+30>:    callq  0xffffffff815bbe60 <mutex_unlock>
   0xffffffff814918a3 <+35>:    pop    %rbp
   0xffffffff814918a4 <+36>:    retq   

-- 
Jiri Kosina
SUSE Labs
