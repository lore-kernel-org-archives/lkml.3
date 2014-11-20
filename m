Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569AbaKTQsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:48:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49301 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756062AbaKTQsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:48:22 -0500
Date: Thu, 20 Nov 2014 11:48:09 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Dave Jones <davej@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        WANG Chao <chaowang@redhat.com>, Baoquan He <bhe@redhat.com>,
        Dave Young <dyoung@redhat.com>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141120164809.GA22216@redhat.com>
References: <CA+55aFyOTpVQiku0xn=UHnXdYweKHZ5AsEUN9wUvOqH9XX4ENg@mail.gmail.com>
 <20141118145234.GA7487@redhat.com>
 <alpine.DEB.2.11.1411181914020.3909@nanos>
 <20141118215540.GD35311@redhat.com>
 <20141118220254.GA2571@redhat.com>
 <20141119144105.GB108701@redhat.com>
 <20141119150333.GB2953@redhat.com>
 <20141119153852.GA16146@redhat.com>
 <20141119162806.GD2953@redhat.com>
 <20141120161055.GA8309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141120161055.GA8309@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 20, 2014 at 11:10:55AM -0500, Dave Jones wrote:
> On Wed, Nov 19, 2014 at 11:28:06AM -0500, Vivek Goyal wrote:
>  
>  > I am wondering may be in some cases we panic in second kernel and sit
>  > there. Probably we should append a kernel command line automatically
>  > say "panic=1" so that it reboots itself if second kernel panics.
>  > 
>  > By any chance, have you enabled "CONFIG_RANDOMIZE_BASE"? If yes, please
>  > disable that as currently kexec/kdump stuff does not work with it. And
>  > it hangs very early in the boot process and I had to hook serial console
>  > to get following message on console.
> 
> I did have that enabled. (Perhaps the kconfig should conflict?)

Hi Dave,

Actually kexec/kdump allows booting into a different kernel than running
kernel. So one could have KEXEC and CONFIG_RANDOMIZE_BASE enabled in
the kernel at the same time but still booting into a kernel with
CONFIG_RANDOMIZE_BASE=n and that should work. CONFIG_RANDOMIZE_BASE is
only a problem if it is enabled in second kernel.So kconfig conflict
might not be a good fit here.

> 
> After rebuilding without it, this..
> 
>  > > dracut: *** Stripping files done ***
>  > > dracut: *** Store current command line parameters ***
>  > > dracut: *** Creating image file ***
>  > > dracut: *** Creating image file done ***
>  > > kdumpctl: cat: write error: Broken pipe
>  > > kdumpctl: kexec: failed to load kdump kernel
>  > > kdumpctl: Starting kdump: [FAILED]
>  
> went away. It generated the image, and things looked good.
> I did echo c > /proc/sysrq-trigger and got this..
> 
> SysRq : Trigger a crash
> BUG: sleeping function called from invalid context at arch/x86/mm/fault.c:1192
> in_atomic(): 0, irqs_disabled(): 0, pid: 8860, name: bash
> 3 locks held by bash/8860:
>  #0:  (sb_writers#5){......}, at: [<ffffffff811eac13>] vfs_write+0x1b3/0x1f0
>  #1:  (rcu_read_lock){......}, at: [<ffffffff8144a435>] __handle_sysrq+0x5/0x1b0
>  #2:  (&mm->mmap_sem){......}, at: [<ffffffff8103cb20>] __do_page_fault+0x140/0x600
> Preemption disabled at:[<ffffffff817ca332>] printk+0x5c/0x72
> 
> CPU: 1 PID: 8860 Comm: bash Not tainted 3.18.0-rc5+ #95 [loadavg: 0.54 0.24 0.09 2/143 8909]
>  00000000000004a8 00000000e1f75c1b ffff880236473c28 ffffffff817ce5c7
>  0000000000000000 0000000000000000 ffff880236473c58 ffffffff8109af8a
>  ffff880236473c58 0000000000000029 0000000000000000 ffff880236473d88
> Call Trace:
>  [<ffffffff817ce5c7>] dump_stack+0x4f/0x7c
>  [<ffffffff8109af8a>] __might_sleep+0x12a/0x190
>  [<ffffffff8103cb3b>] __do_page_fault+0x15b/0x600
>  [<ffffffff811613b2>] ? irq_work_queue+0x62/0xd0
>  [<ffffffff8137ad7d>] ? trace_hardirqs_off_thunk+0x3a/0x3f
>  [<ffffffff8103cfec>] do_page_fault+0xc/0x10
>  [<ffffffff817dbcf2>] page_fault+0x22/0x30
>  [<ffffffff817ca332>] ? printk+0x5c/0x72
>  [<ffffffff81449ce6>] ? sysrq_handle_crash+0x16/0x20
>  [<ffffffff8144a567>] __handle_sysrq+0x137/0x1b0
>  [<ffffffff8144a435>] ? __handle_sysrq+0x5/0x1b0
>  [<ffffffff8144aa4a>] write_sysrq_trigger+0x4a/0x50
>  [<ffffffff81259f2d>] proc_reg_write+0x3d/0x80
>  [<ffffffff811eab1a>] vfs_write+0xba/0x1f0
>  [<ffffffff811eb628>] SyS_write+0x58/0xd0
>  [<ffffffff817da052>] system_call_fastpath+0x12/0x17
> Oops: 0002 [#1] PREEMPT SMP DEBUG_PAGEALLOC
> CPU: 1 PID: 8860 Comm: bash Not tainted 3.18.0-rc5+ #95 [loadavg: 0.54 0.24 0.09 1/143 8909]
> task: ffff8800a1a60000 ti: ffff880236470000 task.ti: ffff880236470000
> RIP: 0010:[<ffffffff81449ce6>]  [<ffffffff81449ce6>] sysrq_handle_crash+0x16/0x20
> RSP: 0018:ffff880236473e38  EFLAGS: 00010246
> RAX: 000000000000000f RBX: ffffffff81cb4a00 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: ffffffff817ca332 RDI: 0000000000000063
> RBP: ffff880236473e38 R08: 0000000000000001 R09: 0000000000000001
> R10: 0000000000000358 R11: 0000000000000357 R12: 0000000000000063
> R13: 0000000000000000 R14: 0000000000000007 R15: 0000000000000000
> FS:  00007fc652f4e740(0000) GS:ffff880244200000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000023a3b2000 CR4: 00000000001407e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Stack:
>  ffff880236473e78 ffffffff8144a567 ffffffff8144a435 0000000000000002
>  0000000000000002 00007fc652f51000 0000000000000002 ffff880236473f48
>  ffff880236473ea8 ffffffff8144aa4a 0000000000000002 00007fc652f51000
> Call Trace:
>  [<ffffffff8144a567>] __handle_sysrq+0x137/0x1b0
>  [<ffffffff8144a435>] ? __handle_sysrq+0x5/0x1b0
>  [<ffffffff8144aa4a>] write_sysrq_trigger+0x4a/0x50
>  [<ffffffff81259f2d>] proc_reg_write+0x3d/0x80
>  [<ffffffff811eab1a>] vfs_write+0xba/0x1f0
>  [<ffffffff811eb628>] SyS_write+0x58/0xd0
>  [<ffffffff817da052>] system_call_fastpath+0x12/0x17
> Code: 01 f4 45 39 a5 b4 00 00 00 75 e2 4c 89 ef e8 d2 f7 ff ff eb d8 0f 1f 44 00 00 55 c7 05 08 b7 7e 00 01 00 00 00 48 89 e5 0f ae f8 <c6> 04 25 00 00 00 00 01 5d c3 0f 1f 44 00 00 55 31 c0 48 89 e5 
> RIP  [<ffffffff81449ce6>] sysrq_handle_crash+0x16/0x20
>  RSP <ffff880236473e38>
> CR2: 0000000000000000
> 
> Which, asides from the sleeping while atomic thing which isn't important,
> does what I expected.  Shortly later, it rebooted.
> 
> And then /var/crash was empty.

These messages came from first kernel. I think we have failed very early
in second kernel boot.

Can we try following and retry and see if some additional messages show
up on console and help us narrow down the problem.

- Enable verbose boot messages. CONFIG_X86_VERBOSE_BOOTUP=y

- Enable early printk in second kernel. (earlyprintk=ttyS0,115200).

  You can either enable early printk in first kernel and reboot. That way
  second kernel will automatically have it enabled. Or you can edit
  "/etc/sysconfig/kdump" and append earlyprintk=<> to KDUMP_COMMANDLINE_APPEND. 
  You will need to restart kdump service after this.

- Enable some debug output during runtime from kexec purgatory. For that one
  needs to pass additional arguments to /sbin/kexec. You can edit
  /etc/sysconfig/kdump file and modify "KEXEC_ARGS" to pass additional
  arguments to /sbin/kexec during kernel load. I use following for my
  serial console.

  KEXEC_ARGS="--console-serial --serial=0x3f8 --serial-baud=115200"

  You will need to restart kdump service.

I hope above give us some information to work with and figure out where
did we fail while booting into second kernel.

Thanks
Vivek
