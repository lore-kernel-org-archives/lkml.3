Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933859AbaE3PvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 11:51:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38204 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933500AbaE3Pu5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 11:50:57 -0400
Date: Fri, 30 May 2014 17:50:51 +0200
From: Jan Kara <jack@suse.cz>
To: Jet Chen <jet.chen@intel.com>
Cc: Jan Kara <jack@suse.cz>, Fengguang Wu <fengguang.wu@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [prink]  BUG: spinlock lockup suspected on CPU#0, swapper/1
Message-ID: <20140530155051.GD2419@quack.suse.cz>
References: <538808FD.3060707@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <538808FD.3060707@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added some CCs from a report that may be related]
On Fri 30-05-14 12:28:45, Jet Chen wrote:
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> commit bafe980f5afc7ccc693fd8c81c8aa5a02fbb5ae0
> Author:     Jan Kara <jack@suse.cz>
> AuthorDate: Thu May 22 10:43:35 2014 +1000
> Commit:     Stephen Rothwell <sfr@canb.auug.org.au>
> CommitDate: Thu May 22 10:43:35 2014 +1000
> 
>     printk: enable interrupts before calling console_trylock_for_printk()
>         We need interrupts disabled when calling console_trylock_for_printk() only
>     so that cpu id we pass to can_use_console() remains valid (for other
>     things console_sem provides all the exclusion we need and deadlocks on
>     console_sem due to interrupts are impossible because we use
>     down_trylock()).  However if we are rescheduled, we are guaranteed to run
>     on an online cpu so we can easily just get the cpu id in
>     can_use_console().
>         We can lose a bit of performance when we enable interrupts in
>     vprintk_emit() and then disable them again in console_unlock() but OTOH it
>     can somewhat reduce interrupt latency caused by console_unlock()
>     especially since later in the patch series we will want to spin on
>     console_sem in console_trylock_for_printk().
>         Signed-off-by: Jan Kara <jack@suse.cz>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
  Thanks for report. So after I had a deeper look I have to say I don't
quite understand this.  See below:

> [    7.490555] EDD information not available.
> [    7.490999] ### dt-test ### No testcase data in device tree; not running tests
> [    7.491848] [    7.492350] BUG: spinlock lockup suspected on CPU#0, swapper/1
> [    7.492350]  lock: serial8250_ports+0x0/0x4c0, .magic: dead4ead, .owner: swapper/1, .owner_cpu: 0
> [    7.492350] CPU: 0 PID: 1 Comm: swapper Not tainted 3.15.0-rc5-00567-gbafe980 #1
> [    7.492350]  80038000 80038000 80027a8c 81b9bd30 80027ab4 81b968d0 81eb5198 82755f80
> [    7.492350]  dead4ead 80038340 00000001 00000000 82755f80 a08b8bfc 80027ad0 81077777
> [    7.492350]  a08b8bfc 00000000 82755f80 00000086 00000001 80027af0 81baeda4 00000000
> [    7.492350] Call Trace:
> [    7.492350]  [<81b9bd30>] dump_stack+0x16/0x18
> [    7.492350]  [<81b968d0>] spin_dump+0x90/0x97
> [    7.492350]  [<81077777>] do_raw_spin_lock+0xa7/0xf0
> [    7.492350]  [<81baeda4>] _raw_spin_lock_irqsave+0x54/0x60
> [    7.492350]  [<815f652c>] ? serial8250_console_write+0x11c/0x140
> [    7.492350]  [<815f6410>] ? serial8250_modem_status+0xc0/0xc0
> [    7.492350]  [<815f652c>] serial8250_console_write+0x11c/0x140
> [    7.492350]  [<815f6410>] ? serial8250_modem_status+0xc0/0xc0
> [    7.492350]  [<8107b534>] call_console_drivers.constprop.20+0x64/0x130
> [    7.492350]  [<8107bcb5>] console_unlock+0x445/0x4d0
> [    7.492350]  [<8107be98>] vprintk_emit+0x158/0x4d0
> [    7.492350]  [<81b969b9>] printk+0x38/0x3a
> [    7.492350]  [<81b95fd0>] print_circular_bug_header+0x35/0xc1
> [    7.492350]  [<81b960c6>] print_circular_bug+0x6a/0x268
> [    7.492350]  [<810743c2>] __lock_acquire+0x19c2/0x1b20
> [    7.492350]  [<81070d18>] ? check_irq_usage+0x88/0xc0
> [    7.492350]  [<810750e5>] lock_acquire+0x85/0x190
> [    7.492350]  [<8107dc8c>] ? __irq_get_desc_lock+0x3c/0x70
> [    7.492350]  [<81baed9d>] _raw_spin_lock_irqsave+0x4d/0x60
> [    7.492350]  [<8107dc8c>] ? __irq_get_desc_lock+0x3c/0x70
> [    7.492350]  [<8107dc8c>] __irq_get_desc_lock+0x3c/0x70
> [    7.492350]  [<8107eb1e>] __disable_irq_nosync+0x1e/0x50
> [    7.492350]  [<8107eb58>] disable_irq_nosync+0x8/0x10
> [    7.492350]  [<815f5c78>] serial8250_startup+0x488/0x720
> [    7.492350]  [<810de6d0>] ? __get_free_pages+0x20/0x40
> [    7.492350]  [<815f205e>] uart_startup.part.4+0x6e/0x1e0
> [    7.492350]  [<815f2a40>] uart_open+0xe0/0x140
> [    7.492350]  [<815f2960>] ? uart_ioctl+0x2f0/0x2f0
> [    7.492350]  [<815e4b51>] tty_open+0x141/0x510
> [    7.492350]  [<815e4a10>] ? tty_ioctl+0xb20/0xb20
> [    7.492350]  [<81118bc0>] chrdev_open+0x60/0x140
> [    7.492350]  [<8111372c>] do_dentry_open+0x14c/0x230
> [    7.492350]  [<81118b60>] ? exact_lock+0x20/0x20
> [    7.492350]  [<8111459e>] finish_open+0x2e/0x40
> [    7.492350]  [<8112132a>] do_last+0x4aa/0xd30
> [    7.492350]  [<8111f4fd>] ? link_path_walk+0x1dd/0x700
> [    7.492350]  [<81121c5a>] path_openat+0xaa/0x610
> [    7.492350]  [<811221ec>] do_filp_open+0x2c/0x70
> [    7.492350]  [<81114a81>] do_sys_open+0x111/0x210
> [    7.492350]  [<81600000>] ? _xfer_secondary_pool+0x150/0x230
> [    7.492350]  [<81114b9d>] SyS_open+0x1d/0x20
> [    7.492350]  [<8212bda4>] kernel_init_freeable+0x1c6/0x236
> [    7.492350]  [<8212b4f2>] ? do_early_param+0x78/0x78
> [    7.492350]  [<81b9238b>] kernel_init+0xb/0xd0
> [    7.492350]  [<81063b12>] ? schedule_tail+0x12/0x40
> [    7.492350]  [<81bb0080>] ret_from_kernel_thread+0x20/0x30
> [    7.492350]  [<81b92380>] ? rest_init+0x130/0x130
> [    7.492350] ======================================================
  So far this is clear. We hold port->lock while trying to report lockdep
problem and reporting needs to take port->lock. So this bug is a secondary
problem.

...
> [    7.492350] ======================================================
> [    7.492350] [ INFO: possible circular locking dependency detected ]
> [    7.492350] 3.15.0-rc5-00567-gbafe980 #1 Not tainted
> [    7.492350] -------------------------------------------------------
> [    7.492350] swapper/1 is trying to acquire lock:
> [    7.492350]  (&irq_desc_lock_class){-.-...}, at: [<8107dc8c>] __irq_get_desc_lock+0x3c/0x70
> [    7.492350] 
> [    7.492350] but task is already holding lock:
> [    7.492350]  (&port_lock_key){......}, at: [<815f5b27>] serial8250_startup+0x337/0x720
> [    7.492350] 
> [    7.492350] which lock already depends on the new lock.
> [    7.492350] 
> [    7.492350] 
> [    7.492350] the existing dependency chain (in reverse order) is:
> [    7.492350] 
> -> #2 (&port_lock_key){......}:
> [    7.492350]        [<810750e5>] lock_acquire+0x85/0x190
> [    7.492350]        [<81baed9d>] _raw_spin_lock_irqsave+0x4d/0x60
> [    7.492350]        [<8106eb1c>] down_trylock+0xc/0x30
> [    7.492350]        [<8107b795>] console_trylock+0x15/0xb0
> [    7.492350]        [<8107be8f>] vprintk_emit+0x14f/0x4d0
> [    7.492350]        [<81b969b9>] printk+0x38/0x3a
> [    7.492350]        [<82137f78>] print_ICs+0x5b/0x3e7
> [    7.492350]        [<8212bb41>] do_one_initcall+0x8b/0x128
> [    7.492350]        [<8212bd7d>] kernel_init_freeable+0x19f/0x236
> [    7.492350]        [<81b9238b>] kernel_init+0xb/0xd0
> [    7.492350]        [<81bb0080>] ret_from_kernel_thread+0x20/0x30
  But this looks really strange. How can we possibly get port_lock_key in
down_trylock() which calls raw_spin_lock_irqsave() on console_sem->lock?
That looks like some strange lockdep key aliasing issue? Peter do you have
any idea?

								Honza

> -> #1 (i8259A_lock){-.....}:
> [    7.492350]        [<810750e5>] lock_acquire+0x85/0x190
> [    7.492350]        [<81baed9d>] _raw_spin_lock_irqsave+0x4d/0x60
> [    7.492350]        [<81005af1>] unmask_8259A_irq+0x11/0x60
> [    7.492350]        [<81005b4b>] enable_8259A_irq+0xb/0x10
> [    7.492350]        [<8107fffb>] irq_enable+0x2b/0x40
> [    7.492350]        [<8108005d>] irq_startup+0x4d/0x60
> [    7.492350]        [<8107f2bc>] __setup_irq+0x39c/0x460
> [    7.492350]        [<8107f433>] setup_irq+0x33/0x80
> [    7.492350]        [<8212db15>] setup_default_timer_irq+0xf/0x11
> [    7.492350]        [<8212db2d>] hpet_time_init+0x16/0x18
> [    7.492350]        [<8212daff>] x86_late_time_init+0x9/0x10
> [    7.492350]        [<8212ba3d>] start_kernel+0x331/0x3aa
> [    7.492350]        [<8212b380>] i386_start_kernel+0x12e/0x131
> [    7.492350] 
> -> #0 (&irq_desc_lock_class){-.-...}:
> [    7.492350]        [<810743c2>] __lock_acquire+0x19c2/0x1b20
> [    7.492350]        [<810750e5>] lock_acquire+0x85/0x190
> [    7.492350]        [<81baed9d>] _raw_spin_lock_irqsave+0x4d/0x60
> [    7.492350]        [<8107dc8c>] __irq_get_desc_lock+0x3c/0x70
> [    7.492350]        [<8107eb1e>] __disable_irq_nosync+0x1e/0x50
> [    7.492350]        [<8107eb58>] disable_irq_nosync+0x8/0x10
> [    7.492350]        [<815f5c78>] serial8250_startup+0x488/0x720
> [    7.492350]        [<815f205e>] uart_startup.part.4+0x6e/0x1e0
> [    7.492350]        [<815f2a40>] uart_open+0xe0/0x140
> [    7.492350]        [<815e4b51>] tty_open+0x141/0x510
> [    7.492350]        [<81118bc0>] chrdev_open+0x60/0x140
> [    7.492350]        [<8111372c>] do_dentry_open+0x14c/0x230
> [    7.492350]        [<8111459e>] finish_open+0x2e/0x40
> [    7.492350]        [<8112132a>] do_last+0x4aa/0xd30
> [    7.492350]        [<81121c5a>] path_openat+0xaa/0x610
> [    7.492350]        [<811221ec>] do_filp_open+0x2c/0x70
> [    7.492350]        [<81114a81>] do_sys_open+0x111/0x210
> [    7.492350]        [<81114b9d>] SyS_open+0x1d/0x20
> [    7.492350]        [<8212bda4>] kernel_init_freeable+0x1c6/0x236
> [    7.492350]        [<81b9238b>] kernel_init+0xb/0xd0
> [    7.492350]        [<81bb0080>] ret_from_kernel_thread+0x20/0x30
> [    7.492350] 
> [    7.492350] other info that might help us debug this:
> [    7.492350] 
> [    7.492350] Chain exists of:
>   &irq_desc_lock_class --> i8259A_lock --> &port_lock_key
> 
> [    7.492350]  Possible unsafe locking scenario:
> [    7.492350] 
> [    7.492350]        CPU0                    CPU1
> [    7.492350]        ----                    ----
> [    7.492350]   lock(&port_lock_key);
> [    7.492350]                                lock(i8259A_lock);
> [    7.492350]                                lock(&port_lock_key);
> [    7.492350]   lock(&irq_desc_lock_class);
> [    7.492350] 
> [    7.492350]  *** DEADLOCK ***
> [    7.492350] 
> [    7.492350] 3 locks held by swapper/1:
> [    7.492350]  #0:  (&tty->legacy_mutex){+.+.+.}, at: [<81baf736>] tty_lock_nested+0x36/0x80
> [    7.492350]  #1:  (&port->mutex){+.+.+.}, at: [<815f2991>] uart_open+0x31/0x140
> [    7.492350]  #2:  (&port_lock_key){......}, at: [<815f5b27>] serial8250_startup+0x337/0x720
> [    7.492350] 
> [    7.492350] stack backtrace:
> [    7.492350] CPU: 0 PID: 1 Comm: swapper Not tainted 3.15.0-rc5-00567-gbafe980 #1
> [    7.492350]  82412ea0 82412ea0 80027be4 81b9bd30 80027c10 81b962ba 81ebd41a 82413720
> [    7.492350]  80038534 00000003 82634380 80038000 80038534 00000003 00000002 80027c88
> [    7.492350]  810743c2 8003851c 8003851c 80027c44 81070d18 00001bd9 00000000 00000004
> [    7.492350] Call Trace:
> [    7.492350]  [<81b9bd30>] dump_stack+0x16/0x18
> [    7.492350]  [<81b962ba>] print_circular_bug+0x25e/0x268
> [    7.492350]  [<810743c2>] __lock_acquire+0x19c2/0x1b20
> [    7.492350]  [<81070d18>] ? check_irq_usage+0x88/0xc0
> [    7.492350]  [<810750e5>] lock_acquire+0x85/0x190
> [    7.492350]  [<8107dc8c>] ? __irq_get_desc_lock+0x3c/0x70
> [    7.492350]  [<81baed9d>] _raw_spin_lock_irqsave+0x4d/0x60
> [    7.492350]  [<8107dc8c>] ? __irq_get_desc_lock+0x3c/0x70
> [    7.492350]  [<8107dc8c>] __irq_get_desc_lock+0x3c/0x70
> [    7.492350]  [<8107eb1e>] __disable_irq_nosync+0x1e/0x50
> [    7.492350]  [<8107eb58>] disable_irq_nosync+0x8/0x10
> [    7.492350]  [<815f5c78>] serial8250_startup+0x488/0x720
> [    7.492350]  [<810de6d0>] ? __get_free_pages+0x20/0x40
> [    7.492350]  [<815f205e>] uart_startup.part.4+0x6e/0x1e0
> [    7.492350]  [<815f2a40>] uart_open+0xe0/0x140
> [    7.492350]  [<815f2960>] ? uart_ioctl+0x2f0/0x2f0
> [    7.492350]  [<815e4b51>] tty_open+0x141/0x510
> [    7.492350]  [<815e4a10>] ? tty_ioctl+0xb20/0xb20
> [    7.492350]  [<81118bc0>] chrdev_open+0x60/0x140
> [    7.492350]  [<8111372c>] do_dentry_open+0x14c/0x230
> [    7.492350]  [<81118b60>] ? exact_lock+0x20/0x20
> [    7.492350]  [<8111459e>] finish_open+0x2e/0x40
> [    7.492350]  [<8112132a>] do_last+0x4aa/0xd30
> [    7.492350]  [<8111f4fd>] ? link_path_walk+0x1dd/0x700
> [    7.492350]  [<81121c5a>] path_openat+0xaa/0x610
> [    7.492350]  [<811221ec>] do_filp_open+0x2c/0x70
> [    7.492350]  [<81114a81>] do_sys_open+0x111/0x210
> [    7.492350]  [<81600000>] ? _xfer_secondary_pool+0x150/0x230
> [    7.492350]  [<81114b9d>] SyS_open+0x1d/0x20
> [    7.492350]  [<8212bda4>] kernel_init_freeable+0x1c6/0x236
> [    7.492350]  [<8212b4f2>] ? do_early_param+0x78/0x78
> [    7.492350]  [<81b9238b>] kernel_init+0xb/0xd0
> [    7.492350]  [<81063b12>] ? schedule_tail+0x12/0x40
> [    7.492350]  [<81bb0080>] ret_from_kernel_thread+0x20/0x30
> [    7.492350]  [<81b92380>] ? rest_init+0x130/0x130
> [   78.177434] Freeing unused kernel memory: 736K (8212b000 - 821e3000)
> /etc/rcS.d/S00fbsetup: line 3: /sbin/modprobe: No such file or directory
> 
> Please wait: booting...
> Starting udev
> error initializing inotify
> error sending message: Connection refused
> error sending message: Connection refused
> Starting Bootlog daemon: bootlogd: cannot find console device 4:64 under /dev
> bootlogd.
> [   78.215246] gfs2: path_lookup on rootfs returned error -2
> Configuring network interfaces... ifconfig: socket: Address family not supported by protocol
> done.
> hwclock: can't open '/dev/misc/rtc': No such file or directory
> Running postinst /etc/rpm-postinsts/100...
> 
> Elapsed time: 80
> qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel /kernel/i386-randconfig-ib0-05300841/bafe980f5afc7ccc693fd8c81c8aa5a02fbb5ae0/vmlinuz-3.15.0-rc5-00567-gbafe980 -append 'hung_task_panic=1 earlyprintk=ttyS0,115200 debug apic=debug sysrq_always_enabled rcupdate.rcu_cpu_stall_timeout=100 panic=10 softlockup_panic=1 nmi_watchdog=panic  prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw link=/kbuild-tests/run-queue/kvm/i386-randconfig-ib0-05300841/next:master:bafe980f5afc7ccc693fd8c81c8aa5a02fbb5ae0:bisect-linux2/.vmlinuz-bafe980f5afc7ccc693fd8c81c8aa5a02fbb5ae0-20140530095827-2-ivb42 branch=next/master BOOT_IMAGE=/kernel/i386-randconfig-ib0-05300841/bafe980f5afc7ccc693fd8c81c8aa5a02fbb5ae0/vmlinuz-3.15.0-rc5-00567-gbafe980 drbd.minor_count=8'  -initrd /kernel-tests/initrd/yocto-minimal-i386.cgz -m 320 -smp 2 -net nic,vlan=1,model=e1000 -net user,vlan=1 -boot order=nc -no-reboot -watchdog i6300esb -rtc base=localtime -pidfile /dev/shm/kboot/pid-yocto-ivb42-1 -serial file:/dev/shm/kboot/serial-yocto-ivb42-1 -daemonize -display none -monitor null 
> 


> #
> # Automatically generated file; DO NOT EDIT.
> # Linux/i386 3.15.0-rc5 Kernel Configuration
> #
> # CONFIG_64BIT is not set
> CONFIG_X86_32=y
> CONFIG_X86=y
> CONFIG_INSTRUCTION_DECODER=y
> CONFIG_OUTPUT_FORMAT="elf32-i386"
> CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
> CONFIG_LOCKDEP_SUPPORT=y
> CONFIG_STACKTRACE_SUPPORT=y
> CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> CONFIG_MMU=y
> CONFIG_NEED_SG_DMA_LENGTH=y
> CONFIG_GENERIC_ISA_DMA=y
> CONFIG_GENERIC_BUG=y
> CONFIG_GENERIC_HWEIGHT=y
> CONFIG_ARCH_MAY_HAVE_PC_FDC=y
> CONFIG_RWSEM_XCHGADD_ALGORITHM=y
> CONFIG_GENERIC_CALIBRATE_DELAY=y
> CONFIG_ARCH_HAS_CPU_RELAX=y
> CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
> CONFIG_HAVE_SETUP_PER_CPU_AREA=y
> CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK=y
> CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK=y
> CONFIG_ARCH_HIBERNATION_POSSIBLE=y
> CONFIG_ARCH_SUSPEND_POSSIBLE=y
> CONFIG_ARCH_WANT_HUGE_PMD_SHARE=y
> CONFIG_ARCH_WANT_GENERAL_HUGETLB=y
> # CONFIG_ZONE_DMA32 is not set
> # CONFIG_AUDIT_ARCH is not set
> CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
> CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
> CONFIG_ARCH_HWEIGHT_CFLAGS="-fcall-saved-ecx -fcall-saved-edx"
> CONFIG_ARCH_SUPPORTS_UPROBES=y
> CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
> CONFIG_IRQ_WORK=y
> CONFIG_BUILDTIME_EXTABLE_SORT=y
> 
> #
> # General setup
> #
> CONFIG_BROKEN_ON_SMP=y
> CONFIG_INIT_ENV_ARG_LIMIT=32
> CONFIG_CROSS_COMPILE=""
> # CONFIG_COMPILE_TEST is not set
> CONFIG_LOCALVERSION=""
> CONFIG_LOCALVERSION_AUTO=y
> CONFIG_HAVE_KERNEL_GZIP=y
> CONFIG_HAVE_KERNEL_BZIP2=y
> CONFIG_HAVE_KERNEL_LZMA=y
> CONFIG_HAVE_KERNEL_XZ=y
> CONFIG_HAVE_KERNEL_LZO=y
> CONFIG_HAVE_KERNEL_LZ4=y
> # CONFIG_KERNEL_GZIP is not set
> # CONFIG_KERNEL_BZIP2 is not set
> # CONFIG_KERNEL_LZMA is not set
> CONFIG_KERNEL_XZ=y
> # CONFIG_KERNEL_LZO is not set
> # CONFIG_KERNEL_LZ4 is not set
> CONFIG_DEFAULT_HOSTNAME="(none)"
> CONFIG_SWAP=y
> CONFIG_SYSVIPC=y
> CONFIG_SYSVIPC_SYSCTL=y
> # CONFIG_POSIX_MQUEUE is not set
> CONFIG_FHANDLE=y
> # CONFIG_USELIB is not set
> CONFIG_AUDIT=y
> CONFIG_HAVE_ARCH_AUDITSYSCALL=y
> CONFIG_AUDITSYSCALL=y
> CONFIG_AUDIT_WATCH=y
> CONFIG_AUDIT_TREE=y
> 
> #
> # IRQ subsystem
> #
> CONFIG_GENERIC_IRQ_PROBE=y
> CONFIG_GENERIC_IRQ_SHOW=y
> CONFIG_IRQ_DOMAIN=y
> CONFIG_IRQ_DOMAIN_DEBUG=y
> CONFIG_IRQ_FORCED_THREADING=y
> CONFIG_SPARSE_IRQ=y
> CONFIG_CLOCKSOURCE_WATCHDOG=y
> CONFIG_ARCH_CLOCKSOURCE_DATA=y
> CONFIG_GENERIC_TIME_VSYSCALL=y
> CONFIG_KTIME_SCALAR=y
> CONFIG_GENERIC_CLOCKEVENTS=y
> CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
> CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
> CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
> CONFIG_GENERIC_CMOS_UPDATE=y
> 
> #
> # Timers subsystem
> #
> CONFIG_HZ_PERIODIC=y
> # CONFIG_NO_HZ_IDLE is not set
> # CONFIG_NO_HZ is not set
> # CONFIG_HIGH_RES_TIMERS is not set
> 
> #
> # CPU/Task time and stats accounting
> #
> CONFIG_TICK_CPU_ACCOUNTING=y
> # CONFIG_IRQ_TIME_ACCOUNTING is not set
> # CONFIG_BSD_PROCESS_ACCT is not set
> # CONFIG_TASKSTATS is not set
> 
> #
> # RCU Subsystem
> #
> CONFIG_TINY_RCU=y
> # CONFIG_PREEMPT_RCU is not set
> CONFIG_RCU_STALL_COMMON=y
> # CONFIG_TREE_RCU_TRACE is not set
> CONFIG_IKCONFIG=y
> # CONFIG_IKCONFIG_PROC is not set
> CONFIG_LOG_BUF_SHIFT=17
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_ARCH_WANTS_PROT_NUMA_PROT_NONE=y
> CONFIG_CGROUPS=y
> CONFIG_CGROUP_DEBUG=y
> # CONFIG_CGROUP_FREEZER is not set
> # CONFIG_CGROUP_DEVICE is not set
> CONFIG_CPUSETS=y
> CONFIG_PROC_PID_CPUSET=y
> # CONFIG_CGROUP_CPUACCT is not set
> # CONFIG_RESOURCE_COUNTERS is not set
> CONFIG_CGROUP_PERF=y
> # CONFIG_CGROUP_SCHED is not set
> CONFIG_BLK_CGROUP=y
> # CONFIG_DEBUG_BLK_CGROUP is not set
> CONFIG_CHECKPOINT_RESTORE=y
> CONFIG_NAMESPACES=y
> CONFIG_UTS_NS=y
> # CONFIG_IPC_NS is not set
> # CONFIG_USER_NS is not set
> # CONFIG_PID_NS is not set
> # CONFIG_NET_NS is not set
> # CONFIG_SCHED_AUTOGROUP is not set
> # CONFIG_SYSFS_DEPRECATED is not set
> # CONFIG_RELAY is not set
> CONFIG_BLK_DEV_INITRD=y
> CONFIG_INITRAMFS_SOURCE=""
> CONFIG_RD_GZIP=y
> CONFIG_RD_BZIP2=y
> CONFIG_RD_LZMA=y
> # CONFIG_RD_XZ is not set
> CONFIG_RD_LZO=y
> CONFIG_RD_LZ4=y
> # CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> CONFIG_SYSCTL=y
> CONFIG_ANON_INODES=y
> CONFIG_HAVE_UID16=y
> CONFIG_SYSCTL_EXCEPTION_TRACE=y
> CONFIG_HAVE_PCSPKR_PLATFORM=y
> CONFIG_EXPERT=y
> # CONFIG_UID16 is not set
> # CONFIG_SGETMASK_SYSCALL is not set
> # CONFIG_SYSFS_SYSCALL is not set
> # CONFIG_SYSCTL_SYSCALL is not set
> CONFIG_KALLSYMS=y
> CONFIG_KALLSYMS_ALL=y
> CONFIG_PRINTK=y
> CONFIG_BUG=y
> CONFIG_PCSPKR_PLATFORM=y
> # CONFIG_BASE_FULL is not set
> CONFIG_FUTEX=y
> CONFIG_EPOLL=y
> CONFIG_SIGNALFD=y
> CONFIG_TIMERFD=y
> CONFIG_EVENTFD=y
> CONFIG_SHMEM=y
> # CONFIG_AIO is not set
> CONFIG_PCI_QUIRKS=y
> CONFIG_EMBEDDED=y
> CONFIG_HAVE_PERF_EVENTS=y
> CONFIG_PERF_USE_VMALLOC=y
> 
> #
> # Kernel Performance Events And Counters
> #
> CONFIG_PERF_EVENTS=y
> CONFIG_DEBUG_PERF_USE_VMALLOC=y
> CONFIG_VM_EVENT_COUNTERS=y
> CONFIG_SLUB_DEBUG=y
> CONFIG_COMPAT_BRK=y
> # CONFIG_SLAB is not set
> CONFIG_SLUB=y
> # CONFIG_SLOB is not set
> CONFIG_SYSTEM_TRUSTED_KEYRING=y
> CONFIG_PROFILING=y
> CONFIG_TRACEPOINTS=y
> # CONFIG_OPROFILE is not set
> CONFIG_HAVE_OPROFILE=y
> CONFIG_OPROFILE_NMI_TIMER=y
> CONFIG_JUMP_LABEL=y
> CONFIG_UPROBES=y
> # CONFIG_HAVE_64BIT_ALIGNED_ACCESS is not set
> CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS=y
> CONFIG_ARCH_USE_BUILTIN_BSWAP=y
> CONFIG_HAVE_IOREMAP_PROT=y
> CONFIG_HAVE_KPROBES=y
> CONFIG_HAVE_KRETPROBES=y
> CONFIG_HAVE_OPTPROBES=y
> CONFIG_HAVE_KPROBES_ON_FTRACE=y
> CONFIG_HAVE_ARCH_TRACEHOOK=y
> CONFIG_HAVE_DMA_ATTRS=y
> CONFIG_HAVE_DMA_CONTIGUOUS=y
> CONFIG_GENERIC_SMP_IDLE_THREAD=y
> CONFIG_HAVE_REGS_AND_STACK_ACCESS_API=y
> CONFIG_HAVE_DMA_API_DEBUG=y
> CONFIG_HAVE_HW_BREAKPOINT=y
> CONFIG_HAVE_MIXED_BREAKPOINTS_REGS=y
> CONFIG_HAVE_USER_RETURN_NOTIFIER=y
> CONFIG_HAVE_PERF_EVENTS_NMI=y
> CONFIG_HAVE_PERF_REGS=y
> CONFIG_HAVE_PERF_USER_STACK_DUMP=y
> CONFIG_HAVE_ARCH_JUMP_LABEL=y
> CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG=y
> CONFIG_HAVE_ALIGNED_STRUCT_PAGE=y
> CONFIG_HAVE_CMPXCHG_LOCAL=y
> CONFIG_HAVE_CMPXCHG_DOUBLE=y
> CONFIG_ARCH_WANT_IPC_PARSE_VERSION=y
> CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
> CONFIG_SECCOMP_FILTER=y
> CONFIG_HAVE_CC_STACKPROTECTOR=y
> CONFIG_CC_STACKPROTECTOR=y
> # CONFIG_CC_STACKPROTECTOR_NONE is not set
> CONFIG_CC_STACKPROTECTOR_REGULAR=y
> # CONFIG_CC_STACKPROTECTOR_STRONG is not set
> CONFIG_HAVE_IRQ_TIME_ACCOUNTING=y
> CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE=y
> CONFIG_MODULES_USE_ELF_REL=y
> CONFIG_CLONE_BACKWARDS=y
> CONFIG_OLD_SIGSUSPEND3=y
> CONFIG_OLD_SIGACTION=y
> 
> #
> # GCOV-based kernel profiling
> #
> # CONFIG_GCOV_KERNEL is not set
> CONFIG_HAVE_GENERIC_DMA_COHERENT=y
> CONFIG_SLABINFO=y
> CONFIG_RT_MUTEXES=y
> CONFIG_BASE_SMALL=1
> # CONFIG_MODULES is not set
> CONFIG_BLOCK=y
> CONFIG_LBDAF=y
> CONFIG_BLK_DEV_BSG=y
> CONFIG_BLK_DEV_BSGLIB=y
> CONFIG_BLK_DEV_INTEGRITY=y
> CONFIG_BLK_DEV_THROTTLING=y
> CONFIG_BLK_CMDLINE_PARSER=y
> 
> #
> # Partition Types
> #
> # CONFIG_PARTITION_ADVANCED is not set
> CONFIG_AMIGA_PARTITION=y
> CONFIG_MSDOS_PARTITION=y
> CONFIG_EFI_PARTITION=y
> 
> #
> # IO Schedulers
> #
> CONFIG_IOSCHED_NOOP=y
> CONFIG_IOSCHED_DEADLINE=y
> CONFIG_IOSCHED_CFQ=y
> CONFIG_CFQ_GROUP_IOSCHED=y
> CONFIG_DEFAULT_DEADLINE=y
> # CONFIG_DEFAULT_CFQ is not set
> # CONFIG_DEFAULT_NOOP is not set
> CONFIG_DEFAULT_IOSCHED="deadline"
> CONFIG_ASN1=y
> CONFIG_UNINLINE_SPIN_UNLOCK=y
> CONFIG_FREEZER=y
> 
> #
> # Processor type and features
> #
> # CONFIG_ZONE_DMA is not set
> # CONFIG_SMP is not set
> # CONFIG_X86_MPPARSE is not set
> CONFIG_GOLDFISH=y
> CONFIG_X86_EXTENDED_PLATFORM=y
> CONFIG_X86_GOLDFISH=y
> # CONFIG_X86_INTEL_LPSS is not set
> # CONFIG_X86_RDC321X is not set
> CONFIG_X86_32_IRIS=y
> # CONFIG_SCHED_OMIT_FRAME_POINTER is not set
> CONFIG_HYPERVISOR_GUEST=y
> CONFIG_PARAVIRT=y
> # CONFIG_PARAVIRT_DEBUG is not set
> CONFIG_KVM_GUEST=y
> # CONFIG_KVM_DEBUG_FS is not set
> # CONFIG_LGUEST_GUEST is not set
> # CONFIG_PARAVIRT_TIME_ACCOUNTING is not set
> CONFIG_PARAVIRT_CLOCK=y
> CONFIG_NO_BOOTMEM=y
> # CONFIG_MEMTEST is not set
> # CONFIG_M486 is not set
> # CONFIG_M586 is not set
> # CONFIG_M586TSC is not set
> # CONFIG_M586MMX is not set
> # CONFIG_M686 is not set
> CONFIG_MPENTIUMII=y
> # CONFIG_MPENTIUMIII is not set
> # CONFIG_MPENTIUMM is not set
> # CONFIG_MPENTIUM4 is not set
> # CONFIG_MK6 is not set
> # CONFIG_MK7 is not set
> # CONFIG_MK8 is not set
> # CONFIG_MCRUSOE is not set
> # CONFIG_MEFFICEON is not set
> # CONFIG_MWINCHIPC6 is not set
> # CONFIG_MWINCHIP3D is not set
> # CONFIG_MELAN is not set
> # CONFIG_MGEODEGX1 is not set
> # CONFIG_MGEODE_LX is not set
> # CONFIG_MCYRIXIII is not set
> # CONFIG_MVIAC3_2 is not set
> # CONFIG_MVIAC7 is not set
> # CONFIG_MCORE2 is not set
> # CONFIG_MATOM is not set
> CONFIG_X86_GENERIC=y
> CONFIG_X86_INTERNODE_CACHE_SHIFT=6
> CONFIG_X86_L1_CACHE_SHIFT=6
> CONFIG_X86_INTEL_USERCOPY=y
> CONFIG_X86_USE_PPRO_CHECKSUM=y
> CONFIG_X86_TSC=y
> CONFIG_X86_CMPXCHG64=y
> CONFIG_X86_CMOV=y
> CONFIG_X86_MINIMUM_CPU_FAMILY=5
> CONFIG_X86_DEBUGCTLMSR=y
> CONFIG_PROCESSOR_SELECT=y
> CONFIG_CPU_SUP_INTEL=y
> CONFIG_CPU_SUP_CYRIX_32=y
> CONFIG_CPU_SUP_AMD=y
> CONFIG_CPU_SUP_CENTAUR=y
> # CONFIG_CPU_SUP_TRANSMETA_32 is not set
> CONFIG_CPU_SUP_UMC_32=y
> CONFIG_HPET_TIMER=y
> CONFIG_HPET_EMULATE_RTC=y
> # CONFIG_DMI is not set
> CONFIG_NR_CPUS=1
> CONFIG_PREEMPT_NONE=y
> # CONFIG_PREEMPT_VOLUNTARY is not set
> # CONFIG_PREEMPT is not set
> CONFIG_PREEMPT_COUNT=y
> CONFIG_X86_UP_APIC=y
> CONFIG_X86_UP_IOAPIC=y
> CONFIG_X86_LOCAL_APIC=y
> CONFIG_X86_IO_APIC=y
> # CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS is not set
> # CONFIG_X86_MCE is not set
> CONFIG_VM86=y
> CONFIG_TOSHIBA=y
> CONFIG_I8K=y
> CONFIG_X86_REBOOTFIXUPS=y
> CONFIG_MICROCODE=y
> # CONFIG_MICROCODE_INTEL is not set
> CONFIG_MICROCODE_AMD=y
> CONFIG_MICROCODE_OLD_INTERFACE=y
> # CONFIG_MICROCODE_INTEL_EARLY is not set
> # CONFIG_MICROCODE_AMD_EARLY is not set
> # CONFIG_MICROCODE_EARLY is not set
> CONFIG_X86_MSR=y
> # CONFIG_X86_CPUID is not set
> # CONFIG_NOHIGHMEM is not set
> CONFIG_HIGHMEM4G=y
> # CONFIG_HIGHMEM64G is not set
> # CONFIG_VMSPLIT_3G is not set
> # CONFIG_VMSPLIT_3G_OPT is not set
> CONFIG_VMSPLIT_2G=y
> # CONFIG_VMSPLIT_2G_OPT is not set
> # CONFIG_VMSPLIT_1G is not set
> CONFIG_PAGE_OFFSET=0x80000000
> CONFIG_HIGHMEM=y
> CONFIG_ARCH_FLATMEM_ENABLE=y
> CONFIG_ARCH_SPARSEMEM_ENABLE=y
> CONFIG_ARCH_SELECT_MEMORY_MODEL=y
> CONFIG_ILLEGAL_POINTER_VALUE=0
> CONFIG_SELECT_MEMORY_MODEL=y
> CONFIG_FLATMEM_MANUAL=y
> # CONFIG_SPARSEMEM_MANUAL is not set
> CONFIG_FLATMEM=y
> CONFIG_FLAT_NODE_MEM_MAP=y
> CONFIG_SPARSEMEM_STATIC=y
> CONFIG_HAVE_MEMBLOCK=y
> CONFIG_HAVE_MEMBLOCK_NODE_MAP=y
> CONFIG_ARCH_DISCARD_MEMBLOCK=y
> CONFIG_MEMORY_ISOLATION=y
> # CONFIG_HAVE_BOOTMEM_INFO_NODE is not set
> CONFIG_PAGEFLAGS_EXTENDED=y
> CONFIG_SPLIT_PTLOCK_CPUS=4
> CONFIG_COMPACTION=y
> CONFIG_MIGRATION=y
> # CONFIG_PHYS_ADDR_T_64BIT is not set
> CONFIG_ZONE_DMA_FLAG=0
> CONFIG_BOUNCE=y
> CONFIG_NEED_BOUNCE_POOL=y
> CONFIG_VIRT_TO_BUS=y
> CONFIG_KSM=y
> CONFIG_DEFAULT_MMAP_MIN_ADDR=4096
> # CONFIG_TRANSPARENT_HUGEPAGE is not set
> # CONFIG_CROSS_MEMORY_ATTACH is not set
> CONFIG_NEED_PER_CPU_KM=y
> # CONFIG_CLEANCACHE is not set
> # CONFIG_FRONTSWAP is not set
> CONFIG_CMA=y
> CONFIG_CMA_DEBUG=y
> # CONFIG_ZBUD is not set
> CONFIG_ZSMALLOC=y
> # CONFIG_PGTABLE_MAPPING is not set
> CONFIG_GENERIC_EARLY_IOREMAP=y
> CONFIG_HIGHPTE=y
> CONFIG_X86_CHECK_BIOS_CORRUPTION=y
> # CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK is not set
> CONFIG_X86_RESERVE_LOW=64
> CONFIG_MATH_EMULATION=y
> CONFIG_MTRR=y
> # CONFIG_MTRR_SANITIZER is not set
> # CONFIG_X86_PAT is not set
> CONFIG_ARCH_RANDOM=y
> # CONFIG_X86_SMAP is not set
> # CONFIG_EFI is not set
> CONFIG_SECCOMP=y
> # CONFIG_HZ_100 is not set
> # CONFIG_HZ_250 is not set
> CONFIG_HZ_300=y
> # CONFIG_HZ_1000 is not set
> CONFIG_HZ=300
> # CONFIG_SCHED_HRTICK is not set
> # CONFIG_KEXEC is not set
> # CONFIG_CRASH_DUMP is not set
> CONFIG_PHYSICAL_START=0x1000000
> CONFIG_RELOCATABLE=y
> # CONFIG_RANDOMIZE_BASE is not set
> CONFIG_X86_NEED_RELOCS=y
> CONFIG_PHYSICAL_ALIGN=0x200000
> # CONFIG_COMPAT_VDSO is not set
> # CONFIG_CMDLINE_BOOL is not set
> CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
> 
> #
> # Power management and ACPI options
> #
> CONFIG_SUSPEND=y
> CONFIG_SUSPEND_FREEZER=y
> # CONFIG_HIBERNATION is not set
> CONFIG_PM_SLEEP=y
> CONFIG_PM_AUTOSLEEP=y
> # CONFIG_PM_WAKELOCKS is not set
> CONFIG_PM_RUNTIME=y
> CONFIG_PM=y
> # CONFIG_PM_DEBUG is not set
> # CONFIG_WQ_POWER_EFFICIENT_DEFAULT is not set
> CONFIG_ACPI=y
> CONFIG_ACPI_SLEEP=y
> # CONFIG_ACPI_PROCFS_POWER is not set
> # CONFIG_ACPI_EC_DEBUGFS is not set
> CONFIG_ACPI_AC=y
> CONFIG_ACPI_BATTERY=y
> CONFIG_ACPI_BUTTON=y
> # CONFIG_ACPI_VIDEO is not set
> CONFIG_ACPI_FAN=y
> # CONFIG_ACPI_DOCK is not set
> CONFIG_ACPI_PROCESSOR=y
> # CONFIG_ACPI_IPMI is not set
> # CONFIG_ACPI_PROCESSOR_AGGREGATOR is not set
> CONFIG_ACPI_THERMAL=y
> # CONFIG_ACPI_CUSTOM_DSDT is not set
> # CONFIG_ACPI_INITRD_TABLE_OVERRIDE is not set
> # CONFIG_ACPI_DEBUG is not set
> # CONFIG_ACPI_PCI_SLOT is not set
> CONFIG_X86_PM_TIMER=y
> # CONFIG_ACPI_CONTAINER is not set
> # CONFIG_ACPI_SBS is not set
> # CONFIG_ACPI_HED is not set
> # CONFIG_ACPI_CUSTOM_METHOD is not set
> # CONFIG_ACPI_REDUCED_HARDWARE_ONLY is not set
> # CONFIG_ACPI_APEI is not set
> CONFIG_SFI=y
> # CONFIG_APM is not set
> 
> #
> # CPU Frequency scaling
> #
> CONFIG_CPU_FREQ=y
> CONFIG_CPU_FREQ_GOV_COMMON=y
> # CONFIG_CPU_FREQ_STAT is not set
> CONFIG_CPU_FREQ_DEFAULT_GOV_PERFORMANCE=y
> # CONFIG_CPU_FREQ_DEFAULT_GOV_POWERSAVE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_USERSPACE is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_ONDEMAND is not set
> # CONFIG_CPU_FREQ_DEFAULT_GOV_CONSERVATIVE is not set
> CONFIG_CPU_FREQ_GOV_PERFORMANCE=y
> CONFIG_CPU_FREQ_GOV_POWERSAVE=y
> CONFIG_CPU_FREQ_GOV_USERSPACE=y
> CONFIG_CPU_FREQ_GOV_ONDEMAND=y
> CONFIG_CPU_FREQ_GOV_CONSERVATIVE=y
> 
> #
> # x86 CPU frequency scaling drivers
> #
> CONFIG_X86_INTEL_PSTATE=y
> # CONFIG_X86_PCC_CPUFREQ is not set
> # CONFIG_X86_ACPI_CPUFREQ is not set
> # CONFIG_X86_POWERNOW_K6 is not set
> CONFIG_X86_POWERNOW_K7=y
> CONFIG_X86_POWERNOW_K7_ACPI=y
> # CONFIG_X86_GX_SUSPMOD is not set
> CONFIG_X86_SPEEDSTEP_CENTRINO=y
> CONFIG_X86_SPEEDSTEP_CENTRINO_TABLE=y
> CONFIG_X86_SPEEDSTEP_ICH=y
> # CONFIG_X86_SPEEDSTEP_SMI is not set
> CONFIG_X86_P4_CLOCKMOD=y
> CONFIG_X86_CPUFREQ_NFORCE2=y
> CONFIG_X86_LONGRUN=y
> # CONFIG_X86_LONGHAUL is not set
> # CONFIG_X86_E_POWERSAVER is not set
> 
> #
> # shared options
> #
> CONFIG_X86_SPEEDSTEP_LIB=y
> CONFIG_X86_SPEEDSTEP_RELAXED_CAP_CHECK=y
> 
> #
> # CPU Idle
> #
> CONFIG_CPU_IDLE=y
> # CONFIG_CPU_IDLE_MULTIPLE_DRIVERS is not set
> CONFIG_CPU_IDLE_GOV_LADDER=y
> CONFIG_CPU_IDLE_GOV_MENU=y
> # CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED is not set
> # CONFIG_INTEL_IDLE is not set
> 
> #
> # Bus options (PCI etc.)
> #
> CONFIG_PCI=y
> # CONFIG_PCI_GOBIOS is not set
> # CONFIG_PCI_GOMMCONFIG is not set
> # CONFIG_PCI_GODIRECT is not set
> # CONFIG_PCI_GOOLPC is not set
> CONFIG_PCI_GOANY=y
> CONFIG_PCI_BIOS=y
> CONFIG_PCI_DIRECT=y
> CONFIG_PCI_MMCONFIG=y
> CONFIG_PCI_OLPC=y
> CONFIG_PCI_DOMAINS=y
> # CONFIG_PCI_CNB20LE_QUIRK is not set
> # CONFIG_PCIEPORTBUS is not set
> # CONFIG_PCI_MSI is not set
> # CONFIG_PCI_DEBUG is not set
> # CONFIG_PCI_REALLOC_ENABLE_AUTO is not set
> # CONFIG_PCI_STUB is not set
> CONFIG_HT_IRQ=y
> # CONFIG_PCI_IOV is not set
> # CONFIG_PCI_PRI is not set
> # CONFIG_PCI_PASID is not set
> # CONFIG_PCI_IOAPIC is not set
> CONFIG_PCI_LABEL=y
> 
> #
> # PCI host controller drivers
> #
> CONFIG_ISA_DMA_API=y
> CONFIG_ISA=y
> CONFIG_EISA=y
> # CONFIG_EISA_VLB_PRIMING is not set
> CONFIG_EISA_PCI_EISA=y
> # CONFIG_EISA_VIRTUAL_ROOT is not set
> CONFIG_EISA_NAMES=y
> CONFIG_SCx200=y
> CONFIG_SCx200HR_TIMER=y
> CONFIG_OLPC=y
> # CONFIG_OLPC_XO15_SCI is not set
> # CONFIG_ALIX is not set
> CONFIG_NET5501=y
> CONFIG_AMD_NB=y
> CONFIG_PCCARD=y
> CONFIG_PCMCIA=y
> # CONFIG_PCMCIA_LOAD_CIS is not set
> CONFIG_CARDBUS=y
> 
> #
> # PC-card bridges
> #
> # CONFIG_YENTA is not set
> # CONFIG_PD6729 is not set
> # CONFIG_I82092 is not set
> # CONFIG_I82365 is not set
> CONFIG_TCIC=y
> CONFIG_PCMCIA_PROBE=y
> CONFIG_PCCARD_NONSTATIC=y
> # CONFIG_HOTPLUG_PCI is not set
> # CONFIG_RAPIDIO is not set
> # CONFIG_X86_SYSFB is not set
> 
> #
> # Executable file formats / Emulations
> #
> CONFIG_BINFMT_ELF=y
> CONFIG_ARCH_BINFMT_ELF_RANDOMIZE_PIE=y
> CONFIG_BINFMT_SCRIPT=y
> CONFIG_HAVE_AOUT=y
> CONFIG_BINFMT_AOUT=y
> CONFIG_BINFMT_MISC=y
> # CONFIG_COREDUMP is not set
> CONFIG_HAVE_ATOMIC_IOMAP=y
> CONFIG_NET=y
> 
> #
> # Networking options
> #
> CONFIG_PACKET=y
> CONFIG_PACKET_DIAG=y
> CONFIG_UNIX=y
> # CONFIG_UNIX_DIAG is not set
> # CONFIG_NET_KEY is not set
> # CONFIG_INET is not set
> # CONFIG_NETWORK_SECMARK is not set
> CONFIG_NET_PTP_CLASSIFY=y
> CONFIG_NETWORK_PHY_TIMESTAMPING=y
> # CONFIG_NETFILTER is not set
> # CONFIG_ATM is not set
> # CONFIG_BRIDGE is not set
> CONFIG_VLAN_8021Q=y
> # CONFIG_VLAN_8021Q_GVRP is not set
> # CONFIG_VLAN_8021Q_MVRP is not set
> # CONFIG_DECNET is not set
> CONFIG_LLC=y
> CONFIG_LLC2=y
> CONFIG_IPX=y
> # CONFIG_IPX_INTERN is not set
> CONFIG_ATALK=y
> CONFIG_DEV_APPLETALK=y
> CONFIG_LTPC=y
> # CONFIG_COPS is not set
> CONFIG_IPDDP=y
> CONFIG_IPDDP_ENCAP=y
> # CONFIG_X25 is not set
> # CONFIG_LAPB is not set
> CONFIG_PHONET=y
> # CONFIG_IEEE802154 is not set
> # CONFIG_NET_SCHED is not set
> # CONFIG_DCB is not set
> CONFIG_DNS_RESOLVER=y
> CONFIG_BATMAN_ADV=y
> # CONFIG_BATMAN_ADV_NC is not set
> CONFIG_BATMAN_ADV_MCAST=y
> CONFIG_BATMAN_ADV_DEBUG=y
> CONFIG_OPENVSWITCH=y
> CONFIG_VSOCKETS=y
> CONFIG_NETLINK_MMAP=y
> CONFIG_NETLINK_DIAG=y
> CONFIG_NET_MPLS_GSO=y
> # CONFIG_HSR is not set
> CONFIG_CGROUP_NET_PRIO=y
> # CONFIG_CGROUP_NET_CLASSID is not set
> CONFIG_NET_RX_BUSY_POLL=y
> CONFIG_BQL=y
> 
> #
> # Network testing
> #
> # CONFIG_HAMRADIO is not set
> CONFIG_CAN=y
> CONFIG_CAN_RAW=y
> CONFIG_CAN_BCM=y
> CONFIG_CAN_GW=y
> 
> #
> # CAN Device Drivers
> #
> CONFIG_CAN_VCAN=y
> # CONFIG_CAN_SLCAN is not set
> CONFIG_CAN_DEV=y
> # CONFIG_CAN_CALC_BITTIMING is not set
> CONFIG_CAN_LEDS=y
> # CONFIG_PCH_CAN is not set
> CONFIG_CAN_GRCAN=y
> # CONFIG_CAN_SJA1000 is not set
> CONFIG_CAN_C_CAN=y
> # CONFIG_CAN_C_CAN_PLATFORM is not set
> # CONFIG_CAN_C_CAN_STRICT_FRAME_ORDERING is not set
> # CONFIG_CAN_C_CAN_PCI is not set
> # CONFIG_CAN_CC770 is not set
> 
> #
> # CAN USB interfaces
> #
> CONFIG_CAN_EMS_USB=y
> CONFIG_CAN_ESD_USB2=y
> CONFIG_CAN_KVASER_USB=y
> CONFIG_CAN_PEAK_USB=y
> CONFIG_CAN_8DEV_USB=y
> # CONFIG_CAN_SOFTING is not set
> # CONFIG_CAN_DEBUG_DEVICES is not set
> # CONFIG_IRDA is not set
> # CONFIG_BT is not set
> CONFIG_WIRELESS=y
> CONFIG_CFG80211=y
> CONFIG_NL80211_TESTMODE=y
> # CONFIG_CFG80211_DEVELOPER_WARNINGS is not set
> # CONFIG_CFG80211_REG_DEBUG is not set
> CONFIG_CFG80211_CERTIFICATION_ONUS=y
> CONFIG_CFG80211_DEFAULT_PS=y
> CONFIG_CFG80211_DEBUGFS=y
> # CONFIG_CFG80211_INTERNAL_REGDB is not set
> # CONFIG_CFG80211_WEXT is not set
> # CONFIG_LIB80211 is not set
> CONFIG_MAC80211=y
> # CONFIG_MAC80211_RC_PID is not set
> # CONFIG_MAC80211_RC_MINSTREL is not set
> CONFIG_MAC80211_RC_DEFAULT=""
> 
> #
> # Some wireless drivers require a rate control algorithm
> #
> # CONFIG_MAC80211_MESH is not set
> CONFIG_MAC80211_LEDS=y
> # CONFIG_MAC80211_DEBUGFS is not set
> # CONFIG_MAC80211_MESSAGE_TRACING is not set
> # CONFIG_MAC80211_DEBUG_MENU is not set
> # CONFIG_WIMAX is not set
> # CONFIG_RFKILL is not set
> CONFIG_RFKILL_REGULATOR=y
> # CONFIG_NET_9P is not set
> CONFIG_CAIF=y
> # CONFIG_CAIF_DEBUG is not set
> CONFIG_CAIF_NETDEV=y
> CONFIG_CAIF_USB=y
> CONFIG_NFC=y
> CONFIG_NFC_DIGITAL=y
> CONFIG_NFC_NCI=y
> CONFIG_NFC_HCI=y
> CONFIG_NFC_SHDLC=y
> 
> #
> # Near Field Communication (NFC) devices
> #
> CONFIG_NFC_PN533=y
> CONFIG_NFC_SIM=y
> CONFIG_NFC_PORT100=y
> CONFIG_NFC_PN544=y
> CONFIG_NFC_PN544_I2C=y
> CONFIG_NFC_MICROREAD=y
> CONFIG_NFC_MICROREAD_I2C=y
> CONFIG_NFC_MRVL=y
> # CONFIG_NFC_MRVL_USB is not set
> 
> #
> # Device Drivers
> #
> 
> #
> # Generic Driver Options
> #
> CONFIG_UEVENT_HELPER_PATH=""
> # CONFIG_DEVTMPFS is not set
> CONFIG_STANDALONE=y
> # CONFIG_PREVENT_FIRMWARE_BUILD is not set
> CONFIG_FW_LOADER=y
> # CONFIG_FIRMWARE_IN_KERNEL is not set
> CONFIG_EXTRA_FIRMWARE=""
> CONFIG_FW_LOADER_USER_HELPER=y
> # CONFIG_DEBUG_DRIVER is not set
> CONFIG_DEBUG_DEVRES=y
> # CONFIG_SYS_HYPERVISOR is not set
> # CONFIG_GENERIC_CPU_DEVICES is not set
> CONFIG_GENERIC_CPU_AUTOPROBE=y
> CONFIG_REGMAP=y
> CONFIG_REGMAP_I2C=y
> CONFIG_REGMAP_MMIO=y
> CONFIG_REGMAP_IRQ=y
> CONFIG_DMA_SHARED_BUFFER=y
> # CONFIG_DMA_CMA is not set
> 
> #
> # Bus devices
> #
> CONFIG_CONNECTOR=y
> CONFIG_PROC_EVENTS=y
> CONFIG_MTD=y
> CONFIG_MTD_REDBOOT_PARTS=y
> CONFIG_MTD_REDBOOT_DIRECTORY_BLOCK=-1
> CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
> # CONFIG_MTD_REDBOOT_PARTS_READONLY is not set
> # CONFIG_MTD_CMDLINE_PARTS is not set
> CONFIG_MTD_OF_PARTS=y
> # CONFIG_MTD_AR7_PARTS is not set
> 
> #
> # User Modules And Translation Layers
> #
> CONFIG_MTD_BLKDEVS=y
> CONFIG_MTD_BLOCK=y
> CONFIG_FTL=y
> # CONFIG_NFTL is not set
> CONFIG_INFTL=y
> CONFIG_RFD_FTL=y
> # CONFIG_SSFDC is not set
> # CONFIG_SM_FTL is not set
> CONFIG_MTD_OOPS=y
> CONFIG_MTD_SWAP=y
> 
> #
> # RAM/ROM/Flash chip drivers
> #
> CONFIG_MTD_CFI=y
> CONFIG_MTD_JEDECPROBE=y
> CONFIG_MTD_GEN_PROBE=y
> CONFIG_MTD_CFI_ADV_OPTIONS=y
> # CONFIG_MTD_CFI_NOSWAP is not set
> # CONFIG_MTD_CFI_BE_BYTE_SWAP is not set
> CONFIG_MTD_CFI_LE_BYTE_SWAP=y
> # CONFIG_MTD_CFI_GEOMETRY is not set
> CONFIG_MTD_MAP_BANK_WIDTH_1=y
> CONFIG_MTD_MAP_BANK_WIDTH_2=y
> CONFIG_MTD_MAP_BANK_WIDTH_4=y
> # CONFIG_MTD_MAP_BANK_WIDTH_8 is not set
> # CONFIG_MTD_MAP_BANK_WIDTH_16 is not set
> # CONFIG_MTD_MAP_BANK_WIDTH_32 is not set
> CONFIG_MTD_CFI_I1=y
> CONFIG_MTD_CFI_I2=y
> # CONFIG_MTD_CFI_I4 is not set
> # CONFIG_MTD_CFI_I8 is not set
> CONFIG_MTD_OTP=y
> CONFIG_MTD_CFI_INTELEXT=y
> # CONFIG_MTD_CFI_AMDSTD is not set
> # CONFIG_MTD_CFI_STAA is not set
> CONFIG_MTD_CFI_UTIL=y
> CONFIG_MTD_RAM=y
> CONFIG_MTD_ROM=y
> CONFIG_MTD_ABSENT=y
> 
> #
> # Mapping drivers for chip access
> #
> # CONFIG_MTD_COMPLEX_MAPPINGS is not set
> CONFIG_MTD_PHYSMAP=y
> CONFIG_MTD_PHYSMAP_COMPAT=y
> CONFIG_MTD_PHYSMAP_START=0x8000000
> CONFIG_MTD_PHYSMAP_LEN=0
> CONFIG_MTD_PHYSMAP_BANKWIDTH=2
> # CONFIG_MTD_PHYSMAP_OF is not set
> # CONFIG_MTD_SC520CDP is not set
> # CONFIG_MTD_NETSC520 is not set
> CONFIG_MTD_SCx200_DOCFLASH=y
> # CONFIG_MTD_AMD76XROM is not set
> CONFIG_MTD_ICHXROM=y
> # CONFIG_MTD_ESB2ROM is not set
> # CONFIG_MTD_CK804XROM is not set
> # CONFIG_MTD_SCB2_FLASH is not set
> # CONFIG_MTD_NETtel is not set
> CONFIG_MTD_L440GX=y
> # CONFIG_MTD_INTEL_VR_NOR is not set
> # CONFIG_MTD_PLATRAM is not set
> 
> #
> # Self-contained MTD device drivers
> #
> # CONFIG_MTD_PMC551 is not set
> CONFIG_MTD_SLRAM=y
> CONFIG_MTD_PHRAM=y
> # CONFIG_MTD_MTDRAM is not set
> CONFIG_MTD_BLOCK2MTD=y
> 
> #
> # Disk-On-Chip Device Drivers
> #
> CONFIG_MTD_DOCG3=y
> CONFIG_BCH_CONST_M=14
> CONFIG_BCH_CONST_T=4
> CONFIG_MTD_NAND_ECC=y
> CONFIG_MTD_NAND_ECC_SMC=y
> CONFIG_MTD_NAND=y
> CONFIG_MTD_NAND_BCH=y
> CONFIG_MTD_NAND_ECC_BCH=y
> # CONFIG_MTD_SM_COMMON is not set
> CONFIG_MTD_NAND_DENALI=y
> # CONFIG_MTD_NAND_DENALI_PCI is not set
> CONFIG_MTD_NAND_GPIO=y
> CONFIG_MTD_NAND_IDS=y
> # CONFIG_MTD_NAND_RICOH is not set
> CONFIG_MTD_NAND_DISKONCHIP=y
> # CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADVANCED is not set
> CONFIG_MTD_NAND_DISKONCHIP_PROBE_ADDRESS=0
> # CONFIG_MTD_NAND_DISKONCHIP_BBTWRITE is not set
> CONFIG_MTD_NAND_DOCG4=y
> # CONFIG_MTD_NAND_CAFE is not set
> # CONFIG_MTD_NAND_CS553X is not set
> CONFIG_MTD_NAND_NANDSIM=y
> CONFIG_MTD_NAND_PLATFORM=y
> CONFIG_MTD_ONENAND=y
> CONFIG_MTD_ONENAND_VERIFY_WRITE=y
> # CONFIG_MTD_ONENAND_GENERIC is not set
> CONFIG_MTD_ONENAND_OTP=y
> CONFIG_MTD_ONENAND_2X_PROGRAM=y
> 
> #
> # LPDDR flash memory drivers
> #
> CONFIG_MTD_LPDDR=y
> CONFIG_MTD_QINFO_PROBE=y
> CONFIG_MTD_UBI=y
> CONFIG_MTD_UBI_WL_THRESHOLD=4096
> CONFIG_MTD_UBI_BEB_LIMIT=20
> CONFIG_MTD_UBI_FASTMAP=y
> # CONFIG_MTD_UBI_GLUEBI is not set
> # CONFIG_MTD_UBI_BLOCK is not set
> CONFIG_OF=y
> 
> #
> # Device Tree and Open Firmware support
> #
> CONFIG_OF_SELFTEST=y
> CONFIG_OF_PROMTREE=y
> CONFIG_OF_ADDRESS=y
> CONFIG_OF_ADDRESS_PCI=y
> CONFIG_OF_IRQ=y
> CONFIG_OF_PCI=y
> CONFIG_OF_PCI_IRQ=y
> CONFIG_OF_MTD=y
> CONFIG_PARPORT=y
> CONFIG_ARCH_MIGHT_HAVE_PC_PARPORT=y
> CONFIG_PARPORT_PC=y
> # CONFIG_PARPORT_SERIAL is not set
> CONFIG_PARPORT_PC_FIFO=y
> CONFIG_PARPORT_PC_SUPERIO=y
> CONFIG_PARPORT_PC_PCMCIA=y
> # CONFIG_PARPORT_GSC is not set
> # CONFIG_PARPORT_AX88796 is not set
> # CONFIG_PARPORT_1284 is not set
> CONFIG_PARPORT_NOT_PC=y
> CONFIG_PNP=y
> # CONFIG_PNP_DEBUG_MESSAGES is not set
> 
> #
> # Protocols
> #
> # CONFIG_ISAPNP is not set
> # CONFIG_PNPBIOS is not set
> CONFIG_PNPACPI=y
> CONFIG_BLK_DEV=y
> CONFIG_BLK_DEV_NULL_BLK=y
> CONFIG_BLK_DEV_FD=y
> # CONFIG_PARIDE is not set
> # CONFIG_BLK_DEV_PCIESSD_MTIP32XX is not set
> # CONFIG_ZRAM is not set
> # CONFIG_BLK_CPQ_CISS_DA is not set
> # CONFIG_BLK_DEV_DAC960 is not set
> # CONFIG_BLK_DEV_UMEM is not set
> # CONFIG_BLK_DEV_COW_COMMON is not set
> CONFIG_BLK_DEV_LOOP=y
> CONFIG_BLK_DEV_LOOP_MIN_COUNT=8
> # CONFIG_BLK_DEV_CRYPTOLOOP is not set
> 
> #
> # DRBD disabled because PROC_FS or INET not selected
> #
> CONFIG_BLK_DEV_NBD=y
> # CONFIG_BLK_DEV_NVME is not set
> # CONFIG_BLK_DEV_SX8 is not set
> # CONFIG_BLK_DEV_RAM is not set
> CONFIG_CDROM_PKTCDVD=y
> CONFIG_CDROM_PKTCDVD_BUFFERS=8
> # CONFIG_CDROM_PKTCDVD_WCACHE is not set
> CONFIG_ATA_OVER_ETH=y
> CONFIG_BLK_DEV_HD=y
> # CONFIG_BLK_DEV_RSXX is not set
> 
> #
> # Misc devices
> #
> CONFIG_SENSORS_LIS3LV02D=y
> # CONFIG_AD525X_DPOT is not set
> CONFIG_DUMMY_IRQ=y
> # CONFIG_IBM_ASM is not set
> # CONFIG_PHANTOM is not set
> # CONFIG_SGI_IOC4 is not set
> # CONFIG_TIFM_CORE is not set
> CONFIG_ICS932S401=y
> # CONFIG_ATMEL_SSC is not set
> CONFIG_ENCLOSURE_SERVICES=y
> # CONFIG_HP_ILO is not set
> CONFIG_APDS9802ALS=y
> # CONFIG_ISL29003 is not set
> CONFIG_ISL29020=y
> CONFIG_SENSORS_TSL2550=y
> CONFIG_SENSORS_BH1780=y
> CONFIG_SENSORS_BH1770=y
> # CONFIG_SENSORS_APDS990X is not set
> # CONFIG_HMC6352 is not set
> CONFIG_DS1682=y
> # CONFIG_VMWARE_BALLOON is not set
> CONFIG_BMP085=y
> CONFIG_BMP085_I2C=y
> # CONFIG_PCH_PHUB is not set
> # CONFIG_USB_SWITCH_FSA9480 is not set
> # CONFIG_SRAM is not set
> CONFIG_C2PORT=y
> CONFIG_C2PORT_DURAMAR_2150=y
> 
> #
> # EEPROM support
> #
> # CONFIG_EEPROM_AT24 is not set
> CONFIG_EEPROM_LEGACY=y
> # CONFIG_EEPROM_MAX6875 is not set
> CONFIG_EEPROM_93CX6=y
> # CONFIG_CB710_CORE is not set
> 
> #
> # Texas Instruments shared transport line discipline
> #
> # CONFIG_TI_ST is not set
> CONFIG_SENSORS_LIS3_I2C=y
> 
> #
> # Altera FPGA firmware download module
> #
> CONFIG_ALTERA_STAPL=y
> # CONFIG_VMWARE_VMCI is not set
> 
> #
> # Intel MIC Host Driver
> #
> 
> #
> # Intel MIC Card Driver
> #
> CONFIG_ECHO=y
> CONFIG_HAVE_IDE=y
> # CONFIG_IDE is not set
> 
> #
> # SCSI device support
> #
> CONFIG_SCSI_MOD=y
> # CONFIG_RAID_ATTRS is not set
> CONFIG_SCSI=y
> CONFIG_SCSI_DMA=y
> CONFIG_SCSI_TGT=y
> CONFIG_SCSI_NETLINK=y
> # CONFIG_SCSI_PROC_FS is not set
> 
> #
> # SCSI support type (disk, tape, CD-ROM)
> #
> CONFIG_BLK_DEV_SD=y
> # CONFIG_CHR_DEV_ST is not set
> CONFIG_CHR_DEV_OSST=y
> CONFIG_BLK_DEV_SR=y
> # CONFIG_BLK_DEV_SR_VENDOR is not set
> # CONFIG_CHR_DEV_SG is not set
> # CONFIG_CHR_DEV_SCH is not set
> CONFIG_SCSI_ENCLOSURE=y
> CONFIG_SCSI_MULTI_LUN=y
> # CONFIG_SCSI_CONSTANTS is not set
> # CONFIG_SCSI_LOGGING is not set
> CONFIG_SCSI_SCAN_ASYNC=y
> 
> #
> # SCSI Transports
> #
> CONFIG_SCSI_SPI_ATTRS=y
> CONFIG_SCSI_FC_ATTRS=y
> # CONFIG_SCSI_FC_TGT_ATTRS is not set
> CONFIG_SCSI_ISCSI_ATTRS=y
> CONFIG_SCSI_SAS_ATTRS=y
> # CONFIG_SCSI_SAS_LIBSAS is not set
> # CONFIG_SCSI_SRP_ATTRS is not set
> CONFIG_SCSI_LOWLEVEL=y
> CONFIG_ISCSI_BOOT_SYSFS=y
> # CONFIG_SCSI_BNX2_ISCSI is not set
> # CONFIG_SCSI_BNX2X_FCOE is not set
> # CONFIG_BE2ISCSI is not set
> # CONFIG_BLK_DEV_3W_XXXX_RAID is not set
> # CONFIG_SCSI_HPSA is not set
> # CONFIG_SCSI_3W_9XXX is not set
> # CONFIG_SCSI_3W_SAS is not set
> # CONFIG_SCSI_7000FASST is not set
> # CONFIG_SCSI_ACARD is not set
> CONFIG_SCSI_AHA152X=y
> CONFIG_SCSI_AHA1542=y
> CONFIG_SCSI_AHA1740=y
> # CONFIG_SCSI_AACRAID is not set
> # CONFIG_SCSI_AIC7XXX is not set
> # CONFIG_SCSI_AIC79XX is not set
> # CONFIG_SCSI_AIC94XX is not set
> # CONFIG_SCSI_MVSAS is not set
> # CONFIG_SCSI_MVUMI is not set
> # CONFIG_SCSI_DPT_I2O is not set
> CONFIG_SCSI_ADVANSYS=y
> CONFIG_SCSI_IN2000=y
> # CONFIG_SCSI_ARCMSR is not set
> # CONFIG_SCSI_ESAS2R is not set
> # CONFIG_MEGARAID_NEWGEN is not set
> # CONFIG_MEGARAID_LEGACY is not set
> # CONFIG_MEGARAID_SAS is not set
> # CONFIG_SCSI_MPT2SAS is not set
> # CONFIG_SCSI_MPT3SAS is not set
> # CONFIG_SCSI_UFSHCD is not set
> # CONFIG_SCSI_HPTIOP is not set
> # CONFIG_SCSI_BUSLOGIC is not set
> # CONFIG_VMWARE_PVSCSI is not set
> # CONFIG_LIBFC is not set
> # CONFIG_LIBFCOE is not set
> # CONFIG_FCOE is not set
> # CONFIG_FCOE_FNIC is not set
> # CONFIG_SCSI_DMX3191D is not set
> # CONFIG_SCSI_DTC3280 is not set
> # CONFIG_SCSI_EATA is not set
> CONFIG_SCSI_FUTURE_DOMAIN=y
> CONFIG_SCSI_GDTH=y
> # CONFIG_SCSI_ISCI is not set
> # CONFIG_SCSI_GENERIC_NCR5380 is not set
> # CONFIG_SCSI_GENERIC_NCR5380_MMIO is not set
> # CONFIG_SCSI_IPS is not set
> # CONFIG_SCSI_INITIO is not set
> # CONFIG_SCSI_INIA100 is not set
> # CONFIG_SCSI_PPA is not set
> # CONFIG_SCSI_IMM is not set
> CONFIG_SCSI_NCR53C406A=y
> # CONFIG_SCSI_STEX is not set
> # CONFIG_SCSI_SYM53C8XX_2 is not set
> # CONFIG_SCSI_IPR is not set
> CONFIG_SCSI_PAS16=y
> CONFIG_SCSI_QLOGIC_FAS=y
> # CONFIG_SCSI_QLOGIC_1280 is not set
> # CONFIG_SCSI_QLA_FC is not set
> # CONFIG_SCSI_QLA_ISCSI is not set
> # CONFIG_SCSI_LPFC is not set
> CONFIG_SCSI_SIM710=y
> # CONFIG_SCSI_SYM53C416 is not set
> # CONFIG_SCSI_DC395x is not set
> # CONFIG_SCSI_DC390T is not set
> CONFIG_SCSI_T128=y
> CONFIG_SCSI_U14_34F=y
> # CONFIG_SCSI_U14_34F_TAGGED_QUEUE is not set
> CONFIG_SCSI_U14_34F_LINKED_COMMANDS=y
> CONFIG_SCSI_U14_34F_MAX_TAGS=8
> CONFIG_SCSI_ULTRASTOR=y
> # CONFIG_SCSI_NSP32 is not set
> # CONFIG_SCSI_DEBUG is not set
> # CONFIG_SCSI_PMCRAID is not set
> # CONFIG_SCSI_PM8001 is not set
> # CONFIG_SCSI_SRP is not set
> # CONFIG_SCSI_BFA_FC is not set
> # CONFIG_SCSI_CHELSIO_FCOE is not set
> # CONFIG_SCSI_LOWLEVEL_PCMCIA is not set
> CONFIG_SCSI_DH=y
> # CONFIG_SCSI_DH_RDAC is not set
> CONFIG_SCSI_DH_HP_SW=y
> # CONFIG_SCSI_DH_EMC is not set
> CONFIG_SCSI_DH_ALUA=y
> # CONFIG_SCSI_OSD_INITIATOR is not set
> CONFIG_ATA=y
> # CONFIG_ATA_NONSTANDARD is not set
> # CONFIG_ATA_VERBOSE_ERROR is not set
> CONFIG_ATA_ACPI=y
> # CONFIG_SATA_ZPODD is not set
> CONFIG_SATA_PMP=y
> 
> #
> # Controllers with non-SFF native interface
> #
> # CONFIG_SATA_AHCI is not set
> # CONFIG_SATA_AHCI_PLATFORM is not set
> # CONFIG_SATA_INIC162X is not set
> # CONFIG_SATA_ACARD_AHCI is not set
> # CONFIG_SATA_SIL24 is not set
> CONFIG_ATA_SFF=y
> 
> #
> # SFF controllers with custom DMA interface
> #
> # CONFIG_PDC_ADMA is not set
> # CONFIG_SATA_QSTOR is not set
> # CONFIG_SATA_SX4 is not set
> CONFIG_ATA_BMDMA=y
> 
> #
> # SATA SFF controllers with BMDMA
> #
> # CONFIG_ATA_PIIX is not set
> # CONFIG_SATA_MV is not set
> # CONFIG_SATA_NV is not set
> # CONFIG_SATA_PROMISE is not set
> # CONFIG_SATA_SIL is not set
> # CONFIG_SATA_SIS is not set
> # CONFIG_SATA_SVW is not set
> # CONFIG_SATA_ULI is not set
> # CONFIG_SATA_VIA is not set
> # CONFIG_SATA_VITESSE is not set
> 
> #
> # PATA SFF controllers with BMDMA
> #
> # CONFIG_PATA_ALI is not set
> # CONFIG_PATA_AMD is not set
> # CONFIG_PATA_ARTOP is not set
> # CONFIG_PATA_ATIIXP is not set
> # CONFIG_PATA_ATP867X is not set
> # CONFIG_PATA_CMD64X is not set
> # CONFIG_PATA_CS5520 is not set
> # CONFIG_PATA_CS5530 is not set
> # CONFIG_PATA_CS5535 is not set
> # CONFIG_PATA_CS5536 is not set
> # CONFIG_PATA_CYPRESS is not set
> # CONFIG_PATA_EFAR is not set
> # CONFIG_PATA_HPT366 is not set
> # CONFIG_PATA_HPT37X is not set
> # CONFIG_PATA_HPT3X2N is not set
> # CONFIG_PATA_HPT3X3 is not set
> # CONFIG_PATA_IT8213 is not set
> # CONFIG_PATA_IT821X is not set
> # CONFIG_PATA_JMICRON is not set
> # CONFIG_PATA_MARVELL is not set
> # CONFIG_PATA_NETCELL is not set
> # CONFIG_PATA_NINJA32 is not set
> # CONFIG_PATA_NS87415 is not set
> # CONFIG_PATA_OLDPIIX is not set
> # CONFIG_PATA_OPTIDMA is not set
> # CONFIG_PATA_PDC2027X is not set
> # CONFIG_PATA_PDC_OLD is not set
> # CONFIG_PATA_RADISYS is not set
> # CONFIG_PATA_RDC is not set
> # CONFIG_PATA_SC1200 is not set
> # CONFIG_PATA_SCH is not set
> # CONFIG_PATA_SERVERWORKS is not set
> # CONFIG_PATA_SIL680 is not set
> # CONFIG_PATA_SIS is not set
> # CONFIG_PATA_TOSHIBA is not set
> # CONFIG_PATA_TRIFLEX is not set
> # CONFIG_PATA_VIA is not set
> # CONFIG_PATA_WINBOND is not set
> 
> #
> # PIO-only SFF controllers
> #
> # CONFIG_PATA_CMD640_PCI is not set
> # CONFIG_PATA_MPIIX is not set
> # CONFIG_PATA_NS87410 is not set
> # CONFIG_PATA_OPTI is not set
> # CONFIG_PATA_PCMCIA is not set
> CONFIG_PATA_PLATFORM=y
> CONFIG_PATA_OF_PLATFORM=y
> CONFIG_PATA_QDI=y
> # CONFIG_PATA_RZ1000 is not set
> # CONFIG_PATA_WINBOND_VLB is not set
> 
> #
> # Generic fallback / legacy drivers
> #
> # CONFIG_PATA_ACPI is not set
> # CONFIG_ATA_GENERIC is not set
> CONFIG_PATA_LEGACY=y
> CONFIG_MD=y
> # CONFIG_BLK_DEV_MD is not set
> # CONFIG_BCACHE is not set
> CONFIG_BLK_DEV_DM_BUILTIN=y
> CONFIG_BLK_DEV_DM=y
> CONFIG_DM_DEBUG=y
> CONFIG_DM_BUFIO=y
> CONFIG_DM_CRYPT=y
> CONFIG_DM_SNAPSHOT=y
> # CONFIG_DM_THIN_PROVISIONING is not set
> # CONFIG_DM_CACHE is not set
> # CONFIG_DM_ERA is not set
> CONFIG_DM_MIRROR=y
> # CONFIG_DM_LOG_USERSPACE is not set
> # CONFIG_DM_RAID is not set
> CONFIG_DM_ZERO=y
> # CONFIG_DM_MULTIPATH is not set
> CONFIG_DM_DELAY=y
> # CONFIG_DM_UEVENT is not set
> CONFIG_DM_FLAKEY=y
> CONFIG_DM_VERITY=y
> CONFIG_DM_SWITCH=y
> CONFIG_TARGET_CORE=y
> # CONFIG_TCM_IBLOCK is not set
> CONFIG_TCM_FILEIO=y
> CONFIG_TCM_PSCSI=y
> # CONFIG_LOOPBACK_TARGET is not set
> CONFIG_ISCSI_TARGET=y
> # CONFIG_FUSION is not set
> 
> #
> # IEEE 1394 (FireWire) support
> #
> # CONFIG_FIREWIRE is not set
> # CONFIG_FIREWIRE_NOSY is not set
> # CONFIG_I2O is not set
> CONFIG_MACINTOSH_DRIVERS=y
> CONFIG_MAC_EMUMOUSEBTN=y
> # CONFIG_NETDEVICES is not set
> 
> #
> # Input device support
> #
> CONFIG_INPUT=y
> CONFIG_INPUT_FF_MEMLESS=y
> CONFIG_INPUT_POLLDEV=y
> CONFIG_INPUT_SPARSEKMAP=y
> CONFIG_INPUT_MATRIXKMAP=y
> 
> #
> # Userland interfaces
> #
> # CONFIG_INPUT_MOUSEDEV is not set
> CONFIG_INPUT_JOYDEV=y
> CONFIG_INPUT_EVDEV=y
> # CONFIG_INPUT_EVBUG is not set
> 
> #
> # Input Device Drivers
> #
> CONFIG_INPUT_KEYBOARD=y
> CONFIG_KEYBOARD_ADP5520=y
> CONFIG_KEYBOARD_ADP5588=y
> CONFIG_KEYBOARD_ADP5589=y
> CONFIG_KEYBOARD_ATKBD=y
> CONFIG_KEYBOARD_QT1070=y
> # CONFIG_KEYBOARD_QT2160 is not set
> CONFIG_KEYBOARD_LKKBD=y
> CONFIG_KEYBOARD_GPIO=y
> CONFIG_KEYBOARD_GPIO_POLLED=y
> CONFIG_KEYBOARD_TCA6416=y
> # CONFIG_KEYBOARD_TCA8418 is not set
> # CONFIG_KEYBOARD_MATRIX is not set
> # CONFIG_KEYBOARD_LM8323 is not set
> # CONFIG_KEYBOARD_LM8333 is not set
> CONFIG_KEYBOARD_MAX7359=y
> # CONFIG_KEYBOARD_MCS is not set
> # CONFIG_KEYBOARD_MPR121 is not set
> # CONFIG_KEYBOARD_NEWTON is not set
> CONFIG_KEYBOARD_OPENCORES=y
> CONFIG_KEYBOARD_GOLDFISH_EVENTS=y
> # CONFIG_KEYBOARD_STOWAWAY is not set
> CONFIG_KEYBOARD_SUNKBD=y
> CONFIG_KEYBOARD_STMPE=y
> CONFIG_KEYBOARD_TC3589X=y
> # CONFIG_KEYBOARD_TWL4030 is not set
> CONFIG_KEYBOARD_XTKBD=y
> CONFIG_KEYBOARD_CROS_EC=y
> CONFIG_INPUT_LEDS=y
> # CONFIG_INPUT_MOUSE is not set
> CONFIG_INPUT_JOYSTICK=y
> # CONFIG_JOYSTICK_ANALOG is not set
> CONFIG_JOYSTICK_A3D=y
> # CONFIG_JOYSTICK_ADI is not set
> CONFIG_JOYSTICK_COBRA=y
> CONFIG_JOYSTICK_GF2K=y
> # CONFIG_JOYSTICK_GRIP is not set
> # CONFIG_JOYSTICK_GRIP_MP is not set
> # CONFIG_JOYSTICK_GUILLEMOT is not set
> CONFIG_JOYSTICK_INTERACT=y
> CONFIG_JOYSTICK_SIDEWINDER=y
> # CONFIG_JOYSTICK_TMDC is not set
> # CONFIG_JOYSTICK_IFORCE is not set
> CONFIG_JOYSTICK_WARRIOR=y
> # CONFIG_JOYSTICK_MAGELLAN is not set
> CONFIG_JOYSTICK_SPACEORB=y
> CONFIG_JOYSTICK_SPACEBALL=y
> CONFIG_JOYSTICK_STINGER=y
> CONFIG_JOYSTICK_TWIDJOY=y
> # CONFIG_JOYSTICK_ZHENHUA is not set
> CONFIG_JOYSTICK_DB9=y
> CONFIG_JOYSTICK_GAMECON=y
> # CONFIG_JOYSTICK_TURBOGRAFX is not set
> CONFIG_JOYSTICK_AS5011=y
> # CONFIG_JOYSTICK_JOYDUMP is not set
> CONFIG_JOYSTICK_XPAD=y
> # CONFIG_JOYSTICK_XPAD_FF is not set
> # CONFIG_JOYSTICK_XPAD_LEDS is not set
> CONFIG_INPUT_TABLET=y
> CONFIG_TABLET_USB_ACECAD=y
> # CONFIG_TABLET_USB_AIPTEK is not set
> CONFIG_TABLET_USB_GTCO=y
> CONFIG_TABLET_USB_HANWANG=y
> CONFIG_TABLET_USB_KBTAB=y
> CONFIG_TABLET_USB_WACOM=y
> CONFIG_INPUT_TOUCHSCREEN=y
> # CONFIG_TOUCHSCREEN_AD7879 is not set
> # CONFIG_TOUCHSCREEN_ATMEL_MXT is not set
> CONFIG_TOUCHSCREEN_AUO_PIXCIR=y
> # CONFIG_TOUCHSCREEN_BU21013 is not set
> CONFIG_TOUCHSCREEN_CY8CTMG110=y
> # CONFIG_TOUCHSCREEN_CYTTSP_CORE is not set
> CONFIG_TOUCHSCREEN_CYTTSP4_CORE=y
> # CONFIG_TOUCHSCREEN_CYTTSP4_I2C is not set
> # CONFIG_TOUCHSCREEN_DA9034 is not set
> CONFIG_TOUCHSCREEN_DYNAPRO=y
> # CONFIG_TOUCHSCREEN_HAMPSHIRE is not set
> CONFIG_TOUCHSCREEN_EETI=y
> CONFIG_TOUCHSCREEN_EGALAX=y
> # CONFIG_TOUCHSCREEN_FUJITSU is not set
> CONFIG_TOUCHSCREEN_ILI210X=y
> CONFIG_TOUCHSCREEN_GUNZE=y
> # CONFIG_TOUCHSCREEN_ELO is not set
> # CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
> CONFIG_TOUCHSCREEN_WACOM_I2C=y
> CONFIG_TOUCHSCREEN_MAX11801=y
> # CONFIG_TOUCHSCREEN_MCS5000 is not set
> CONFIG_TOUCHSCREEN_MMS114=y
> CONFIG_TOUCHSCREEN_MTOUCH=y
> # CONFIG_TOUCHSCREEN_INEXIO is not set
> CONFIG_TOUCHSCREEN_MK712=y
> CONFIG_TOUCHSCREEN_HTCPEN=y
> CONFIG_TOUCHSCREEN_PENMOUNT=y
> # CONFIG_TOUCHSCREEN_EDT_FT5X06 is not set
> # CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
> # CONFIG_TOUCHSCREEN_TOUCHWIN is not set
> # CONFIG_TOUCHSCREEN_PIXCIR is not set
> CONFIG_TOUCHSCREEN_USB_COMPOSITE=y
> CONFIG_TOUCHSCREEN_MC13783=y
> CONFIG_TOUCHSCREEN_USB_EGALAX=y
> CONFIG_TOUCHSCREEN_USB_PANJIT=y
> # CONFIG_TOUCHSCREEN_USB_3M is not set
> # CONFIG_TOUCHSCREEN_USB_ITM is not set
> CONFIG_TOUCHSCREEN_USB_ETURBO=y
> CONFIG_TOUCHSCREEN_USB_GUNZE=y
> # CONFIG_TOUCHSCREEN_USB_DMC_TSC10 is not set
> # CONFIG_TOUCHSCREEN_USB_IRTOUCH is not set
> # CONFIG_TOUCHSCREEN_USB_IDEALTEK is not set
> CONFIG_TOUCHSCREEN_USB_GENERAL_TOUCH=y
> CONFIG_TOUCHSCREEN_USB_GOTOP=y
> CONFIG_TOUCHSCREEN_USB_JASTEC=y
> CONFIG_TOUCHSCREEN_USB_ELO=y
> # CONFIG_TOUCHSCREEN_USB_E2I is not set
> CONFIG_TOUCHSCREEN_USB_ZYTRONIC=y
> # CONFIG_TOUCHSCREEN_USB_ETT_TC45USB is not set
> # CONFIG_TOUCHSCREEN_USB_NEXIO is not set
> # CONFIG_TOUCHSCREEN_USB_EASYTOUCH is not set
> CONFIG_TOUCHSCREEN_TOUCHIT213=y
> CONFIG_TOUCHSCREEN_TSC_SERIO=y
> # CONFIG_TOUCHSCREEN_TSC2007 is not set
> CONFIG_TOUCHSCREEN_ST1232=y
> CONFIG_TOUCHSCREEN_STMPE=y
> CONFIG_TOUCHSCREEN_SUR40=y
> CONFIG_TOUCHSCREEN_TPS6507X=y
> CONFIG_TOUCHSCREEN_ZFORCE=y
> # CONFIG_INPUT_MISC is not set
> 
> #
> # Hardware I/O ports
> #
> CONFIG_SERIO=y
> CONFIG_ARCH_MIGHT_HAVE_PC_SERIO=y
> CONFIG_SERIO_I8042=y
> CONFIG_SERIO_SERPORT=y
> # CONFIG_SERIO_CT82C710 is not set
> CONFIG_SERIO_PARKBD=y
> # CONFIG_SERIO_PCIPS2 is not set
> CONFIG_SERIO_LIBPS2=y
> CONFIG_SERIO_RAW=y
> CONFIG_SERIO_ALTERA_PS2=y
> CONFIG_SERIO_PS2MULT=y
> CONFIG_SERIO_ARC_PS2=y
> CONFIG_SERIO_APBPS2=y
> CONFIG_SERIO_OLPC_APSP=y
> CONFIG_GAMEPORT=y
> CONFIG_GAMEPORT_NS558=y
> # CONFIG_GAMEPORT_L4 is not set
> # CONFIG_GAMEPORT_EMU10K1 is not set
> # CONFIG_GAMEPORT_FM801 is not set
> 
> #
> # Character devices
> #
> CONFIG_TTY=y
> # CONFIG_VT is not set
> # CONFIG_UNIX98_PTYS is not set
> # CONFIG_LEGACY_PTYS is not set
> # CONFIG_SERIAL_NONSTANDARD is not set
> # CONFIG_NOZOMI is not set
> CONFIG_N_GSM=y
> # CONFIG_TRACE_ROUTER is not set
> CONFIG_TRACE_SINK=y
> # CONFIG_GOLDFISH_TTY is not set
> # CONFIG_DEVKMEM is not set
> 
> #
> # Serial drivers
> #
> CONFIG_SERIAL_8250=y
> CONFIG_SERIAL_8250_DEPRECATED_OPTIONS=y
> # CONFIG_SERIAL_8250_PNP is not set
> CONFIG_SERIAL_8250_CONSOLE=y
> CONFIG_FIX_EARLYCON_MEM=y
> CONFIG_SERIAL_8250_PCI=y
> # CONFIG_SERIAL_8250_CS is not set
> CONFIG_SERIAL_8250_NR_UARTS=4
> CONFIG_SERIAL_8250_RUNTIME_UARTS=4
> CONFIG_SERIAL_8250_EXTENDED=y
> # CONFIG_SERIAL_8250_MANY_PORTS is not set
> CONFIG_SERIAL_8250_SHARE_IRQ=y
> CONFIG_SERIAL_8250_DETECT_IRQ=y
> # CONFIG_SERIAL_8250_RSA is not set
> CONFIG_SERIAL_8250_DW=y
> 
> #
> # Non-8250 serial port support
> #
> # CONFIG_SERIAL_MFD_HSU is not set
> CONFIG_SERIAL_CORE=y
> CONFIG_SERIAL_CORE_CONSOLE=y
> # CONFIG_SERIAL_JSM is not set
> CONFIG_SERIAL_OF_PLATFORM=y
> # CONFIG_SERIAL_SCCNXP is not set
> CONFIG_SERIAL_TIMBERDALE=y
> CONFIG_SERIAL_ALTERA_JTAGUART=y
> CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE=y
> # CONFIG_SERIAL_ALTERA_JTAGUART_CONSOLE_BYPASS is not set
> CONFIG_SERIAL_ALTERA_UART=y
> CONFIG_SERIAL_ALTERA_UART_MAXPORTS=4
> CONFIG_SERIAL_ALTERA_UART_BAUDRATE=115200
> CONFIG_SERIAL_ALTERA_UART_CONSOLE=y
> # CONFIG_SERIAL_PCH_UART is not set
> # CONFIG_SERIAL_XILINX_PS_UART is not set
> CONFIG_SERIAL_ARC=y
> # CONFIG_SERIAL_ARC_CONSOLE is not set
> CONFIG_SERIAL_ARC_NR_PORTS=1
> # CONFIG_SERIAL_RP2 is not set
> CONFIG_SERIAL_FSL_LPUART=y
> # CONFIG_SERIAL_FSL_LPUART_CONSOLE is not set
> CONFIG_TTY_PRINTK=y
> # CONFIG_PRINTER is not set
> CONFIG_PPDEV=y
> CONFIG_IPMI_HANDLER=y
> # CONFIG_IPMI_PANIC_EVENT is not set
> CONFIG_IPMI_DEVICE_INTERFACE=y
> CONFIG_IPMI_SI=y
> # CONFIG_IPMI_SI_PROBE_DEFAULTS is not set
> CONFIG_IPMI_WATCHDOG=y
> CONFIG_IPMI_POWEROFF=y
> CONFIG_HW_RANDOM=y
> CONFIG_HW_RANDOM_TIMERIOMEM=y
> CONFIG_HW_RANDOM_INTEL=y
> CONFIG_HW_RANDOM_AMD=y
> CONFIG_HW_RANDOM_GEODE=y
> CONFIG_HW_RANDOM_VIA=y
> # CONFIG_HW_RANDOM_TPM is not set
> # CONFIG_NVRAM is not set
> CONFIG_DTLK=y
> # CONFIG_R3964 is not set
> # CONFIG_APPLICOM is not set
> # CONFIG_SONYPI is not set
> 
> #
> # PCMCIA character devices
> #
> CONFIG_SYNCLINK_CS=y
> # CONFIG_CARDMAN_4000 is not set
> CONFIG_CARDMAN_4040=y
> CONFIG_MWAVE=y
> # CONFIG_SCx200_GPIO is not set
> CONFIG_PC8736x_GPIO=y
> CONFIG_NSC_GPIO=y
> CONFIG_RAW_DRIVER=y
> CONFIG_MAX_RAW_DEVS=256
> # CONFIG_HPET is not set
> CONFIG_HANGCHECK_TIMER=y
> CONFIG_TCG_TPM=y
> CONFIG_TCG_TIS=y
> CONFIG_TCG_TIS_I2C_ATMEL=y
> CONFIG_TCG_TIS_I2C_INFINEON=y
> CONFIG_TCG_TIS_I2C_NUVOTON=y
> CONFIG_TCG_NSC=y
> # CONFIG_TCG_ATMEL is not set
> # CONFIG_TCG_INFINEON is not set
> CONFIG_TCG_ST33_I2C=y
> CONFIG_TELCLOCK=y
> CONFIG_DEVPORT=y
> CONFIG_I2C=y
> CONFIG_I2C_BOARDINFO=y
> CONFIG_I2C_COMPAT=y
> CONFIG_I2C_CHARDEV=y
> # CONFIG_I2C_MUX is not set
> CONFIG_I2C_HELPER_AUTO=y
> CONFIG_I2C_SMBUS=y
> CONFIG_I2C_ALGOBIT=y
> CONFIG_I2C_ALGOPCA=y
> 
> #
> # I2C Hardware Bus support
> #
> 
> #
> # PC SMBus host controller drivers
> #
> # CONFIG_I2C_ALI1535 is not set
> # CONFIG_I2C_ALI1563 is not set
> # CONFIG_I2C_ALI15X3 is not set
> # CONFIG_I2C_AMD756 is not set
> # CONFIG_I2C_AMD8111 is not set
> # CONFIG_I2C_I801 is not set
> # CONFIG_I2C_ISCH is not set
> # CONFIG_I2C_ISMT is not set
> # CONFIG_I2C_PIIX4 is not set
> # CONFIG_I2C_NFORCE2 is not set
> # CONFIG_I2C_SIS5595 is not set
> # CONFIG_I2C_SIS630 is not set
> # CONFIG_I2C_SIS96X is not set
> # CONFIG_I2C_VIA is not set
> # CONFIG_I2C_VIAPRO is not set
> 
> #
> # ACPI drivers
> #
> # CONFIG_I2C_SCMI is not set
> 
> #
> # I2C system bus drivers (mostly embedded / system-on-chip)
> #
> CONFIG_I2C_CBUS_GPIO=y
> # CONFIG_I2C_DESIGNWARE_PLATFORM is not set
> # CONFIG_I2C_DESIGNWARE_PCI is not set
> # CONFIG_I2C_EG20T is not set
> CONFIG_I2C_GPIO=y
> CONFIG_I2C_KEMPLD=y
> CONFIG_I2C_OCORES=y
> # CONFIG_I2C_PCA_PLATFORM is not set
> # CONFIG_I2C_PXA is not set
> # CONFIG_I2C_PXA_PCI is not set
> # CONFIG_I2C_SIMTEC is not set
> CONFIG_I2C_XILINX=y
> 
> #
> # External I2C/SMBus adapter drivers
> #
> CONFIG_I2C_DIOLAN_U2C=y
> CONFIG_I2C_PARPORT=y
> CONFIG_I2C_PARPORT_LIGHT=y
> CONFIG_I2C_ROBOTFUZZ_OSIF=y
> CONFIG_I2C_TAOS_EVM=y
> CONFIG_I2C_TINY_USB=y
> CONFIG_I2C_VIPERBOARD=y
> 
> #
> # Other I2C/SMBus bus drivers
> #
> # CONFIG_I2C_ELEKTOR is not set
> CONFIG_I2C_PCA_ISA=y
> # CONFIG_SCx200_ACB is not set
> # CONFIG_I2C_DEBUG_CORE is not set
> # CONFIG_I2C_DEBUG_ALGO is not set
> # CONFIG_I2C_DEBUG_BUS is not set
> # CONFIG_SPI is not set
> # CONFIG_SPMI is not set
> CONFIG_HSI=y
> CONFIG_HSI_BOARDINFO=y
> 
> #
> # HSI clients
> #
> CONFIG_HSI_CHAR=y
> 
> #
> # PPS support
> #
> CONFIG_PPS=y
> # CONFIG_PPS_DEBUG is not set
> CONFIG_NTP_PPS=y
> 
> #
> # PPS clients support
> #
> # CONFIG_PPS_CLIENT_KTIMER is not set
> CONFIG_PPS_CLIENT_LDISC=y
> CONFIG_PPS_CLIENT_PARPORT=y
> CONFIG_PPS_CLIENT_GPIO=y
> 
> #
> # PPS generators support
> #
> 
> #
> # PTP clock support
> #
> CONFIG_PTP_1588_CLOCK=y
> 
> #
> # Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks.
> #
> CONFIG_PTP_1588_CLOCK_PCH=y
> CONFIG_ARCH_WANT_OPTIONAL_GPIOLIB=y
> CONFIG_GPIOLIB=y
> CONFIG_GPIO_DEVRES=y
> CONFIG_OF_GPIO=y
> CONFIG_GPIO_ACPI=y
> CONFIG_DEBUG_GPIO=y
> # CONFIG_GPIO_SYSFS is not set
> CONFIG_GPIO_GENERIC=y
> # CONFIG_GPIO_DA9055 is not set
> CONFIG_GPIO_MAX730X=y
> 
> #
> # Memory mapped GPIO drivers:
> #
> # CONFIG_GPIO_GENERIC_PLATFORM is not set
> # CONFIG_GPIO_DWAPB is not set
> CONFIG_GPIO_IT8761E=y
> CONFIG_GPIO_F7188X=y
> CONFIG_GPIO_SCH311X=y
> # CONFIG_GPIO_SYSCON is not set
> # CONFIG_GPIO_SCH is not set
> # CONFIG_GPIO_ICH is not set
> # CONFIG_GPIO_VX855 is not set
> # CONFIG_GPIO_LYNXPOINT is not set
> CONFIG_GPIO_GRGPIO=y
> 
> #
> # I2C GPIO expanders:
> #
> CONFIG_GPIO_ARIZONA=y
> # CONFIG_GPIO_LP3943 is not set
> CONFIG_GPIO_MAX7300=y
> CONFIG_GPIO_MAX732X=y
> # CONFIG_GPIO_MAX732X_IRQ is not set
> CONFIG_GPIO_PCA953X=y
> # CONFIG_GPIO_PCA953X_IRQ is not set
> CONFIG_GPIO_PCF857X=y
> # CONFIG_GPIO_SX150X is not set
> # CONFIG_GPIO_STMPE is not set
> CONFIG_GPIO_TC3589X=y
> CONFIG_GPIO_TPS65912=y
> # CONFIG_GPIO_TWL4030 is not set
> # CONFIG_GPIO_TWL6040 is not set
> CONFIG_GPIO_ADP5520=y
> # CONFIG_GPIO_ADP5588 is not set
> CONFIG_GPIO_ADNP=y
> 
> #
> # PCI GPIO expanders:
> #
> # CONFIG_GPIO_BT8XX is not set
> # CONFIG_GPIO_AMD8111 is not set
> # CONFIG_GPIO_INTEL_MID is not set
> # CONFIG_GPIO_PCH is not set
> # CONFIG_GPIO_ML_IOH is not set
> # CONFIG_GPIO_SODAVILLE is not set
> # CONFIG_GPIO_RDC321X is not set
> 
> #
> # SPI GPIO expanders:
> #
> # CONFIG_GPIO_MCP23S08 is not set
> 
> #
> # AC97 GPIO expanders:
> #
> 
> #
> # LPC GPIO expanders:
> #
> CONFIG_GPIO_KEMPLD=y
> 
> #
> # MODULbus GPIO expanders:
> #
> # CONFIG_GPIO_PALMAS is not set
> # CONFIG_GPIO_BCM_KONA is not set
> 
> #
> # USB GPIO expanders:
> #
> # CONFIG_GPIO_VIPERBOARD is not set
> CONFIG_W1=y
> # CONFIG_W1_CON is not set
> 
> #
> # 1-wire Bus Masters
> #
> # CONFIG_W1_MASTER_MATROX is not set
> CONFIG_W1_MASTER_DS2490=y
> CONFIG_W1_MASTER_DS2482=y
> # CONFIG_W1_MASTER_DS1WM is not set
> CONFIG_W1_MASTER_GPIO=y
> 
> #
> # 1-wire Slaves
> #
> CONFIG_W1_SLAVE_THERM=y
> # CONFIG_W1_SLAVE_SMEM is not set
> CONFIG_W1_SLAVE_DS2408=y
> CONFIG_W1_SLAVE_DS2408_READBACK=y
> CONFIG_W1_SLAVE_DS2413=y
> CONFIG_W1_SLAVE_DS2423=y
> # CONFIG_W1_SLAVE_DS2431 is not set
> CONFIG_W1_SLAVE_DS2433=y
> CONFIG_W1_SLAVE_DS2433_CRC=y
> CONFIG_W1_SLAVE_DS2760=y
> CONFIG_W1_SLAVE_DS2780=y
> CONFIG_W1_SLAVE_DS2781=y
> # CONFIG_W1_SLAVE_DS28E04 is not set
> CONFIG_W1_SLAVE_BQ27000=y
> CONFIG_POWER_SUPPLY=y
> CONFIG_POWER_SUPPLY_DEBUG=y
> CONFIG_PDA_POWER=y
> # CONFIG_GENERIC_ADC_BATTERY is not set
> # CONFIG_MAX8925_POWER is not set
> # CONFIG_TEST_POWER is not set
> CONFIG_BATTERY_DS2760=y
> CONFIG_BATTERY_DS2780=y
> CONFIG_BATTERY_DS2781=y
> CONFIG_BATTERY_DS2782=y
> # CONFIG_BATTERY_OLPC is not set
> # CONFIG_BATTERY_SBS is not set
> CONFIG_BATTERY_BQ27x00=y
> CONFIG_BATTERY_BQ27X00_I2C=y
> CONFIG_BATTERY_BQ27X00_PLATFORM=y
> CONFIG_BATTERY_DA9030=y
> CONFIG_BATTERY_MAX17040=y
> # CONFIG_BATTERY_MAX17042 is not set
> CONFIG_CHARGER_PCF50633=y
> CONFIG_CHARGER_ISP1704=y
> CONFIG_CHARGER_MAX8903=y
> # CONFIG_CHARGER_TWL4030 is not set
> CONFIG_CHARGER_LP8727=y
> CONFIG_CHARGER_LP8788=y
> CONFIG_CHARGER_GPIO=y
> # CONFIG_CHARGER_MANAGER is not set
> CONFIG_CHARGER_MAX14577=y
> CONFIG_CHARGER_MAX8998=y
> CONFIG_CHARGER_BQ2415X=y
> # CONFIG_CHARGER_BQ24190 is not set
> CONFIG_CHARGER_BQ24735=y
> CONFIG_CHARGER_SMB347=y
> CONFIG_BATTERY_GOLDFISH=y
> CONFIG_POWER_RESET=y
> # CONFIG_POWER_RESET_GPIO is not set
> # CONFIG_POWER_AVS is not set
> CONFIG_HWMON=y
> CONFIG_HWMON_VID=y
> CONFIG_HWMON_DEBUG_CHIP=y
> 
> #
> # Native drivers
> #
> # CONFIG_SENSORS_AD7414 is not set
> # CONFIG_SENSORS_AD7418 is not set
> CONFIG_SENSORS_ADM1021=y
> # CONFIG_SENSORS_ADM1025 is not set
> CONFIG_SENSORS_ADM1026=y
> # CONFIG_SENSORS_ADM1029 is not set
> CONFIG_SENSORS_ADM1031=y
> # CONFIG_SENSORS_ADM9240 is not set
> # CONFIG_SENSORS_ADT7410 is not set
> CONFIG_SENSORS_ADT7411=y
> CONFIG_SENSORS_ADT7462=y
> # CONFIG_SENSORS_ADT7470 is not set
> # CONFIG_SENSORS_ADT7475 is not set
> # CONFIG_SENSORS_ASC7621 is not set
> # CONFIG_SENSORS_K8TEMP is not set
> # CONFIG_SENSORS_K10TEMP is not set
> # CONFIG_SENSORS_FAM15H_POWER is not set
> # CONFIG_SENSORS_APPLESMC is not set
> CONFIG_SENSORS_ASB100=y
> CONFIG_SENSORS_ATXP1=y
> CONFIG_SENSORS_DS620=y
> CONFIG_SENSORS_DS1621=y
> CONFIG_SENSORS_DA9055=y
> # CONFIG_SENSORS_I5K_AMB is not set
> # CONFIG_SENSORS_F71805F is not set
> # CONFIG_SENSORS_F71882FG is not set
> CONFIG_SENSORS_F75375S=y
> CONFIG_SENSORS_MC13783_ADC=y
> CONFIG_SENSORS_FSCHMD=y
> CONFIG_SENSORS_GL518SM=y
> CONFIG_SENSORS_GL520SM=y
> CONFIG_SENSORS_G760A=y
> CONFIG_SENSORS_G762=y
> CONFIG_SENSORS_GPIO_FAN=y
> CONFIG_SENSORS_HIH6130=y
> CONFIG_SENSORS_IBMAEM=y
> # CONFIG_SENSORS_IBMPEX is not set
> # CONFIG_SENSORS_IIO_HWMON is not set
> CONFIG_SENSORS_CORETEMP=y
> # CONFIG_SENSORS_IT87 is not set
> # CONFIG_SENSORS_JC42 is not set
> CONFIG_SENSORS_LINEAGE=y
> CONFIG_SENSORS_LTC2945=y
> CONFIG_SENSORS_LTC4151=y
> CONFIG_SENSORS_LTC4215=y
> # CONFIG_SENSORS_LTC4222 is not set
> # CONFIG_SENSORS_LTC4245 is not set
> CONFIG_SENSORS_LTC4260=y
> # CONFIG_SENSORS_LTC4261 is not set
> CONFIG_SENSORS_MAX16065=y
> CONFIG_SENSORS_MAX1619=y
> CONFIG_SENSORS_MAX1668=y
> CONFIG_SENSORS_MAX197=y
> CONFIG_SENSORS_MAX6639=y
> CONFIG_SENSORS_MAX6642=y
> # CONFIG_SENSORS_MAX6650 is not set
> # CONFIG_SENSORS_MAX6697 is not set
> # CONFIG_SENSORS_HTU21 is not set
> CONFIG_SENSORS_MCP3021=y
> CONFIG_SENSORS_LM63=y
> # CONFIG_SENSORS_LM73 is not set
> CONFIG_SENSORS_LM75=y
> # CONFIG_SENSORS_LM77 is not set
> # CONFIG_SENSORS_LM78 is not set
> CONFIG_SENSORS_LM80=y
> # CONFIG_SENSORS_LM83 is not set
> CONFIG_SENSORS_LM85=y
> CONFIG_SENSORS_LM87=y
> CONFIG_SENSORS_LM90=y
> # CONFIG_SENSORS_LM92 is not set
> # CONFIG_SENSORS_LM93 is not set
> CONFIG_SENSORS_LM95234=y
> # CONFIG_SENSORS_LM95241 is not set
> CONFIG_SENSORS_LM95245=y
> CONFIG_SENSORS_PC87360=y
> # CONFIG_SENSORS_PC87427 is not set
> # CONFIG_SENSORS_NTC_THERMISTOR is not set
> # CONFIG_SENSORS_NCT6775 is not set
> # CONFIG_SENSORS_PCF8591 is not set
> # CONFIG_PMBUS is not set
> CONFIG_SENSORS_SHT15=y
> CONFIG_SENSORS_SHT21=y
> # CONFIG_SENSORS_SIS5595 is not set
> CONFIG_SENSORS_DME1737=y
> CONFIG_SENSORS_EMC1403=y
> # CONFIG_SENSORS_EMC2103 is not set
> CONFIG_SENSORS_EMC6W201=y
> CONFIG_SENSORS_SMSC47M1=y
> CONFIG_SENSORS_SMSC47M192=y
> CONFIG_SENSORS_SMSC47B397=y
> # CONFIG_SENSORS_SCH56XX_COMMON is not set
> CONFIG_SENSORS_SMM665=y
> CONFIG_SENSORS_ADC128D818=y
> CONFIG_SENSORS_ADS1015=y
> # CONFIG_SENSORS_ADS7828 is not set
> CONFIG_SENSORS_AMC6821=y
> CONFIG_SENSORS_INA209=y
> # CONFIG_SENSORS_INA2XX is not set
> # CONFIG_SENSORS_THMC50 is not set
> CONFIG_SENSORS_TMP102=y
> CONFIG_SENSORS_TMP401=y
> CONFIG_SENSORS_TMP421=y
> CONFIG_SENSORS_VIA_CPUTEMP=y
> # CONFIG_SENSORS_VIA686A is not set
> CONFIG_SENSORS_VT1211=y
> # CONFIG_SENSORS_VT8231 is not set
> CONFIG_SENSORS_W83781D=y
> CONFIG_SENSORS_W83791D=y
> # CONFIG_SENSORS_W83792D is not set
> CONFIG_SENSORS_W83793=y
> CONFIG_SENSORS_W83795=y
> # CONFIG_SENSORS_W83795_FANCTRL is not set
> # CONFIG_SENSORS_W83L785TS is not set
> # CONFIG_SENSORS_W83L786NG is not set
> # CONFIG_SENSORS_W83627HF is not set
> # CONFIG_SENSORS_W83627EHF is not set
> 
> #
> # ACPI drivers
> #
> # CONFIG_SENSORS_ACPI_POWER is not set
> # CONFIG_SENSORS_ATK0110 is not set
> CONFIG_THERMAL=y
> CONFIG_THERMAL_HWMON=y
> # CONFIG_THERMAL_OF is not set
> # CONFIG_THERMAL_DEFAULT_GOV_STEP_WISE is not set
> CONFIG_THERMAL_DEFAULT_GOV_FAIR_SHARE=y
> # CONFIG_THERMAL_DEFAULT_GOV_USER_SPACE is not set
> CONFIG_THERMAL_GOV_FAIR_SHARE=y
> # CONFIG_THERMAL_GOV_STEP_WISE is not set
> CONFIG_THERMAL_GOV_USER_SPACE=y
> # CONFIG_THERMAL_EMULATION is not set
> CONFIG_INTEL_POWERCLAMP=y
> # CONFIG_ACPI_INT3403_THERMAL is not set
> 
> #
> # Texas Instruments thermal drivers
> #
> # CONFIG_WATCHDOG is not set
> CONFIG_SSB_POSSIBLE=y
> 
> #
> # Sonics Silicon Backplane
> #
> CONFIG_SSB=y
> CONFIG_SSB_SPROM=y
> CONFIG_SSB_PCIHOST_POSSIBLE=y
> CONFIG_SSB_PCIHOST=y
> # CONFIG_SSB_B43_PCI_BRIDGE is not set
> CONFIG_SSB_PCMCIAHOST_POSSIBLE=y
> CONFIG_SSB_PCMCIAHOST=y
> CONFIG_SSB_SDIOHOST_POSSIBLE=y
> CONFIG_SSB_SDIOHOST=y
> # CONFIG_SSB_SILENT is not set
> CONFIG_SSB_DEBUG=y
> CONFIG_SSB_DRIVER_PCICORE_POSSIBLE=y
> # CONFIG_SSB_DRIVER_PCICORE is not set
> # CONFIG_SSB_DRIVER_GPIO is not set
> CONFIG_BCMA_POSSIBLE=y
> 
> #
> # Broadcom specific AMBA
> #
> CONFIG_BCMA=y
> CONFIG_BCMA_HOST_PCI_POSSIBLE=y
> CONFIG_BCMA_HOST_PCI=y
> CONFIG_BCMA_HOST_SOC=y
> CONFIG_BCMA_DRIVER_GMAC_CMN=y
> CONFIG_BCMA_DRIVER_GPIO=y
> # CONFIG_BCMA_DEBUG is not set
> 
> #
> # Multifunction device drivers
> #
> CONFIG_MFD_CORE=y
> # CONFIG_MFD_CS5535 is not set
> # CONFIG_MFD_AS3711 is not set
> # CONFIG_MFD_AS3722 is not set
> CONFIG_PMIC_ADP5520=y
> # CONFIG_MFD_AAT2870_CORE is not set
> # CONFIG_MFD_BCM590XX is not set
> CONFIG_MFD_CROS_EC=y
> CONFIG_MFD_CROS_EC_I2C=y
> CONFIG_PMIC_DA903X=y
> # CONFIG_MFD_DA9052_I2C is not set
> CONFIG_MFD_DA9055=y
> CONFIG_MFD_DA9063=y
> CONFIG_MFD_MC13XXX=y
> CONFIG_MFD_MC13XXX_I2C=y
> CONFIG_HTC_PASIC3=y
> CONFIG_HTC_I2CPLD=y
> # CONFIG_LPC_ICH is not set
> # CONFIG_LPC_SCH is not set
> # CONFIG_MFD_JANZ_CMODIO is not set
> CONFIG_MFD_KEMPLD=y
> CONFIG_MFD_88PM800=y
> # CONFIG_MFD_88PM805 is not set
> # CONFIG_MFD_88PM860X is not set
> CONFIG_MFD_MAX14577=y
> CONFIG_MFD_MAX77686=y
> CONFIG_MFD_MAX77693=y
> CONFIG_MFD_MAX8907=y
> CONFIG_MFD_MAX8925=y
> # CONFIG_MFD_MAX8997 is not set
> CONFIG_MFD_MAX8998=y
> CONFIG_MFD_VIPERBOARD=y
> CONFIG_MFD_RETU=y
> CONFIG_MFD_PCF50633=y
> # CONFIG_PCF50633_ADC is not set
> CONFIG_PCF50633_GPIO=y
> # CONFIG_MFD_RDC321X is not set
> # CONFIG_MFD_RTSX_PCI is not set
> # CONFIG_MFD_RTSX_USB is not set
> # CONFIG_MFD_RC5T583 is not set
> # CONFIG_MFD_SEC_CORE is not set
> CONFIG_MFD_SI476X_CORE=y
> CONFIG_MFD_SM501=y
> # CONFIG_MFD_SM501_GPIO is not set
> CONFIG_MFD_SMSC=y
> CONFIG_ABX500_CORE=y
> # CONFIG_AB3100_CORE is not set
> CONFIG_MFD_STMPE=y
> 
> #
> # STMicroelectronics STMPE Interface Drivers
> #
> CONFIG_STMPE_I2C=y
> CONFIG_MFD_SYSCON=y
> # CONFIG_MFD_TI_AM335X_TSCADC is not set
> CONFIG_MFD_LP3943=y
> CONFIG_MFD_LP8788=y
> CONFIG_MFD_PALMAS=y
> CONFIG_TPS6105X=y
> # CONFIG_TPS65010 is not set
> CONFIG_TPS6507X=y
> # CONFIG_MFD_TPS65090 is not set
> CONFIG_MFD_TPS65217=y
> # CONFIG_MFD_TPS65218 is not set
> # CONFIG_MFD_TPS6586X is not set
> # CONFIG_MFD_TPS65910 is not set
> CONFIG_MFD_TPS65912=y
> CONFIG_MFD_TPS65912_I2C=y
> # CONFIG_MFD_TPS80031 is not set
> CONFIG_TWL4030_CORE=y
> # CONFIG_MFD_TWL4030_AUDIO is not set
> CONFIG_TWL6040_CORE=y
> CONFIG_MFD_WL1273_CORE=y
> CONFIG_MFD_LM3533=y
> # CONFIG_MFD_TIMBERDALE is not set
> CONFIG_MFD_TC3589X=y
> # CONFIG_MFD_TMIO is not set
> # CONFIG_MFD_VX855 is not set
> CONFIG_MFD_ARIZONA=y
> CONFIG_MFD_ARIZONA_I2C=y
> # CONFIG_MFD_WM5102 is not set
> CONFIG_MFD_WM5110=y
> CONFIG_MFD_WM8997=y
> # CONFIG_MFD_WM8400 is not set
> # CONFIG_MFD_WM831X_I2C is not set
> # CONFIG_MFD_WM8350_I2C is not set
> # CONFIG_MFD_WM8994 is not set
> CONFIG_REGULATOR=y
> CONFIG_REGULATOR_DEBUG=y
> CONFIG_REGULATOR_FIXED_VOLTAGE=y
> CONFIG_REGULATOR_VIRTUAL_CONSUMER=y
> CONFIG_REGULATOR_USERSPACE_CONSUMER=y
> CONFIG_REGULATOR_88PM800=y
> CONFIG_REGULATOR_ACT8865=y
> CONFIG_REGULATOR_AD5398=y
> CONFIG_REGULATOR_ANATOP=y
> CONFIG_REGULATOR_DA903X=y
> CONFIG_REGULATOR_DA9055=y
> # CONFIG_REGULATOR_DA9063 is not set
> CONFIG_REGULATOR_DA9210=y
> CONFIG_REGULATOR_FAN53555=y
> CONFIG_REGULATOR_GPIO=y
> CONFIG_REGULATOR_ISL6271A=y
> CONFIG_REGULATOR_LP3971=y
> CONFIG_REGULATOR_LP3972=y
> CONFIG_REGULATOR_LP872X=y
> CONFIG_REGULATOR_LP8755=y
> CONFIG_REGULATOR_LP8788=y
> CONFIG_REGULATOR_MAX14577=y
> CONFIG_REGULATOR_MAX1586=y
> CONFIG_REGULATOR_MAX8649=y
> CONFIG_REGULATOR_MAX8660=y
> CONFIG_REGULATOR_MAX8907=y
> CONFIG_REGULATOR_MAX8925=y
> CONFIG_REGULATOR_MAX8952=y
> CONFIG_REGULATOR_MAX8973=y
> CONFIG_REGULATOR_MAX8998=y
> CONFIG_REGULATOR_MAX77686=y
> CONFIG_REGULATOR_MAX77693=y
> # CONFIG_REGULATOR_MC13783 is not set
> # CONFIG_REGULATOR_MC13892 is not set
> CONFIG_REGULATOR_PALMAS=y
> CONFIG_REGULATOR_PCF50633=y
> CONFIG_REGULATOR_PFUZE100=y
> CONFIG_REGULATOR_TPS51632=y
> CONFIG_REGULATOR_TPS6105X=y
> # CONFIG_REGULATOR_TPS62360 is not set
> CONFIG_REGULATOR_TPS65023=y
> CONFIG_REGULATOR_TPS6507X=y
> CONFIG_REGULATOR_TPS65217=y
> # CONFIG_REGULATOR_TPS65912 is not set
> CONFIG_REGULATOR_TWL4030=y
> CONFIG_MEDIA_SUPPORT=y
> 
> #
> # Multimedia core support
> #
> CONFIG_MEDIA_CAMERA_SUPPORT=y
> CONFIG_MEDIA_ANALOG_TV_SUPPORT=y
> CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
> # CONFIG_MEDIA_RADIO_SUPPORT is not set
> CONFIG_MEDIA_RC_SUPPORT=y
> # CONFIG_MEDIA_CONTROLLER is not set
> CONFIG_VIDEO_DEV=y
> CONFIG_VIDEO_V4L2=y
> # CONFIG_VIDEO_ADV_DEBUG is not set
> CONFIG_VIDEO_FIXED_MINOR_RANGES=y
> CONFIG_VIDEOBUF_GEN=y
> CONFIG_VIDEOBUF2_CORE=y
> CONFIG_VIDEOBUF2_MEMOPS=y
> CONFIG_VIDEOBUF2_DMA_CONTIG=y
> CONFIG_VIDEOBUF2_VMALLOC=y
> CONFIG_DVB_CORE=y
> # CONFIG_TTPCI_EEPROM is not set
> CONFIG_DVB_MAX_ADAPTERS=8
> CONFIG_DVB_DYNAMIC_MINORS=y
> 
> #
> # Media drivers
> #
> CONFIG_RC_CORE=y
> CONFIG_RC_MAP=y
> # CONFIG_RC_DECODERS is not set
> # CONFIG_RC_DEVICES is not set
> # CONFIG_MEDIA_USB_SUPPORT is not set
> # CONFIG_MEDIA_PCI_SUPPORT is not set
> CONFIG_V4L_PLATFORM_DRIVERS=y
> # CONFIG_VIDEO_CAFE_CCIC is not set
> CONFIG_SOC_CAMERA=y
> CONFIG_SOC_CAMERA_SCALE_CROP=y
> CONFIG_SOC_CAMERA_PLATFORM=y
> CONFIG_VIDEO_RCAR_VIN=y
> CONFIG_V4L_MEM2MEM_DRIVERS=y
> # CONFIG_VIDEO_SH_VEU is not set
> # CONFIG_V4L_TEST_DRIVERS is not set
> 
> #
> # Supported MMC/SDIO adapters
> #
> # CONFIG_SMS_SDIO_DRV is not set
> CONFIG_MEDIA_PARPORT_SUPPORT=y
> CONFIG_VIDEO_BWQCAM=y
> # CONFIG_VIDEO_CQCAM is not set
> CONFIG_VIDEO_PMS=y
> # CONFIG_CYPRESS_FIRMWARE is not set
> 
> #
> # Media ancillary drivers (tuners, sensors, i2c, frontends)
> #
> # CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
> CONFIG_VIDEO_IR_I2C=y
> 
> #
> # Encoders, decoders, sensors and other helper chips
> #
> 
> #
> # Audio decoders, processors and mixers
> #
> # CONFIG_VIDEO_TVAUDIO is not set
> CONFIG_VIDEO_TDA7432=y
> # CONFIG_VIDEO_TDA9840 is not set
> # CONFIG_VIDEO_TEA6415C is not set
> CONFIG_VIDEO_TEA6420=y
> # CONFIG_VIDEO_MSP3400 is not set
> # CONFIG_VIDEO_CS5345 is not set
> # CONFIG_VIDEO_CS53L32A is not set
> # CONFIG_VIDEO_TLV320AIC23B is not set
> # CONFIG_VIDEO_UDA1342 is not set
> # CONFIG_VIDEO_WM8775 is not set
> # CONFIG_VIDEO_WM8739 is not set
> CONFIG_VIDEO_VP27SMPX=y
> CONFIG_VIDEO_SONY_BTF_MPX=y
> 
> #
> # RDS decoders
> #
> CONFIG_VIDEO_SAA6588=y
> 
> #
> # Video decoders
> #
> CONFIG_VIDEO_ADV7180=y
> CONFIG_VIDEO_ADV7183=y
> CONFIG_VIDEO_BT819=y
> CONFIG_VIDEO_BT856=y
> # CONFIG_VIDEO_BT866 is not set
> CONFIG_VIDEO_KS0127=y
> # CONFIG_VIDEO_ML86V7667 is not set
> # CONFIG_VIDEO_SAA7110 is not set
> # CONFIG_VIDEO_SAA711X is not set
> CONFIG_VIDEO_SAA7191=y
> CONFIG_VIDEO_TVP514X=y
> CONFIG_VIDEO_TVP5150=y
> # CONFIG_VIDEO_TVP7002 is not set
> CONFIG_VIDEO_TW2804=y
> CONFIG_VIDEO_TW9903=y
> CONFIG_VIDEO_TW9906=y
> CONFIG_VIDEO_VPX3220=y
> 
> #
> # Video and audio decoders
> #
> # CONFIG_VIDEO_SAA717X is not set
> CONFIG_VIDEO_CX25840=y
> 
> #
> # Video encoders
> #
> # CONFIG_VIDEO_SAA7127 is not set
> CONFIG_VIDEO_SAA7185=y
> # CONFIG_VIDEO_ADV7170 is not set
> CONFIG_VIDEO_ADV7175=y
> CONFIG_VIDEO_ADV7343=y
> # CONFIG_VIDEO_ADV7393 is not set
> CONFIG_VIDEO_AK881X=y
> CONFIG_VIDEO_THS8200=y
> 
> #
> # Camera sensor devices
> #
> CONFIG_VIDEO_OV7640=y
> # CONFIG_VIDEO_OV7670 is not set
> CONFIG_VIDEO_VS6624=y
> CONFIG_VIDEO_MT9V011=y
> # CONFIG_VIDEO_SR030PC30 is not set
> 
> #
> # Flash devices
> #
> 
> #
> # Video improvement chips
> #
> CONFIG_VIDEO_UPD64031A=y
> # CONFIG_VIDEO_UPD64083 is not set
> 
> #
> # Audio/Video compression chips
> #
> # CONFIG_VIDEO_SAA6752HS is not set
> 
> #
> # Miscellaneous helper chips
> #
> CONFIG_VIDEO_THS7303=y
> CONFIG_VIDEO_M52790=y
> 
> #
> # Sensors used on soc_camera driver
> #
> 
> #
> # soc_camera sensor drivers
> #
> CONFIG_SOC_CAMERA_IMX074=y
> CONFIG_SOC_CAMERA_MT9M001=y
> # CONFIG_SOC_CAMERA_MT9M111 is not set
> # CONFIG_SOC_CAMERA_MT9T031 is not set
> CONFIG_SOC_CAMERA_MT9T112=y
> CONFIG_SOC_CAMERA_MT9V022=y
> CONFIG_SOC_CAMERA_OV2640=y
> CONFIG_SOC_CAMERA_OV5642=y
> CONFIG_SOC_CAMERA_OV6650=y
> CONFIG_SOC_CAMERA_OV772X=y
> # CONFIG_SOC_CAMERA_OV9640 is not set
> # CONFIG_SOC_CAMERA_OV9740 is not set
> CONFIG_SOC_CAMERA_RJ54N1=y
> # CONFIG_SOC_CAMERA_TW9910 is not set
> CONFIG_MEDIA_TUNER=y
> 
> #
> # Customize TV tuners
> #
> # CONFIG_MEDIA_TUNER_SIMPLE is not set
> CONFIG_MEDIA_TUNER_TDA8290=y
> CONFIG_MEDIA_TUNER_TDA827X=y
> CONFIG_MEDIA_TUNER_TDA18271=y
> CONFIG_MEDIA_TUNER_TDA9887=y
> # CONFIG_MEDIA_TUNER_TEA5761 is not set
> CONFIG_MEDIA_TUNER_TEA5767=y
> # CONFIG_MEDIA_TUNER_MT20XX is not set
> CONFIG_MEDIA_TUNER_MT2060=y
> CONFIG_MEDIA_TUNER_MT2063=y
> CONFIG_MEDIA_TUNER_MT2266=y
> CONFIG_MEDIA_TUNER_MT2131=y
> # CONFIG_MEDIA_TUNER_QT1010 is not set
> CONFIG_MEDIA_TUNER_XC2028=y
> CONFIG_MEDIA_TUNER_XC5000=y
> CONFIG_MEDIA_TUNER_XC4000=y
> CONFIG_MEDIA_TUNER_MXL5005S=y
> CONFIG_MEDIA_TUNER_MXL5007T=y
> CONFIG_MEDIA_TUNER_MC44S803=y
> CONFIG_MEDIA_TUNER_MAX2165=y
> CONFIG_MEDIA_TUNER_TDA18218=y
> CONFIG_MEDIA_TUNER_FC0011=y
> # CONFIG_MEDIA_TUNER_FC0012 is not set
> CONFIG_MEDIA_TUNER_FC0013=y
> CONFIG_MEDIA_TUNER_TDA18212=y
> CONFIG_MEDIA_TUNER_E4000=y
> # CONFIG_MEDIA_TUNER_FC2580 is not set
> # CONFIG_MEDIA_TUNER_M88TS2022 is not set
> CONFIG_MEDIA_TUNER_TUA9001=y
> CONFIG_MEDIA_TUNER_IT913X=y
> # CONFIG_MEDIA_TUNER_R820T is not set
> 
> #
> # Customise DVB Frontends
> #
> 
> #
> # Multistandard (satellite) frontends
> #
> # CONFIG_DVB_STB0899 is not set
> # CONFIG_DVB_STB6100 is not set
> CONFIG_DVB_STV090x=y
> # CONFIG_DVB_STV6110x is not set
> 
> #
> # Multistandard (cable + terrestrial) frontends
> #
> # CONFIG_DVB_DRXK is not set
> # CONFIG_DVB_TDA18271C2DD is not set
> 
> #
> # DVB-S (satellite) frontends
> #
> CONFIG_DVB_CX24110=y
> CONFIG_DVB_CX24123=y
> # CONFIG_DVB_MT312 is not set
> # CONFIG_DVB_ZL10036 is not set
> CONFIG_DVB_ZL10039=y
> CONFIG_DVB_S5H1420=y
> # CONFIG_DVB_STV0288 is not set
> CONFIG_DVB_STB6000=y
> CONFIG_DVB_STV0299=y
> CONFIG_DVB_STV6110=y
> CONFIG_DVB_STV0900=y
> CONFIG_DVB_TDA8083=y
> CONFIG_DVB_TDA10086=y
> CONFIG_DVB_TDA8261=y
> # CONFIG_DVB_VES1X93 is not set
> CONFIG_DVB_TUNER_ITD1000=y
> CONFIG_DVB_TUNER_CX24113=y
> CONFIG_DVB_TDA826X=y
> CONFIG_DVB_TUA6100=y
> CONFIG_DVB_CX24116=y
> # CONFIG_DVB_CX24117 is not set
> CONFIG_DVB_SI21XX=y
> CONFIG_DVB_TS2020=y
> # CONFIG_DVB_DS3000 is not set
> CONFIG_DVB_MB86A16=y
> # CONFIG_DVB_TDA10071 is not set
> 
> #
> # DVB-T (terrestrial) frontends
> #
> CONFIG_DVB_SP8870=y
> CONFIG_DVB_SP887X=y
> CONFIG_DVB_CX22700=y
> CONFIG_DVB_CX22702=y
> # CONFIG_DVB_S5H1432 is not set
> CONFIG_DVB_DRXD=y
> CONFIG_DVB_L64781=y
> CONFIG_DVB_TDA1004X=y
> CONFIG_DVB_NXT6000=y
> # CONFIG_DVB_MT352 is not set
> CONFIG_DVB_ZL10353=y
> # CONFIG_DVB_DIB3000MB is not set
> # CONFIG_DVB_DIB3000MC is not set
> CONFIG_DVB_DIB7000M=y
> CONFIG_DVB_DIB7000P=y
> CONFIG_DVB_DIB9000=y
> # CONFIG_DVB_TDA10048 is not set
> CONFIG_DVB_AF9013=y
> # CONFIG_DVB_EC100 is not set
> CONFIG_DVB_HD29L2=y
> # CONFIG_DVB_STV0367 is not set
> # CONFIG_DVB_CXD2820R is not set
> CONFIG_DVB_RTL2830=y
> 
> #
> # DVB-C (cable) frontends
> #
> CONFIG_DVB_VES1820=y
> CONFIG_DVB_TDA10021=y
> CONFIG_DVB_TDA10023=y
> # CONFIG_DVB_STV0297 is not set
> 
> #
> # ATSC (North American/Korean Terrestrial/Cable DTV) frontends
> #
> CONFIG_DVB_NXT200X=y
> CONFIG_DVB_OR51211=y
> CONFIG_DVB_OR51132=y
> CONFIG_DVB_BCM3510=y
> CONFIG_DVB_LGDT330X=y
> CONFIG_DVB_LGDT3305=y
> CONFIG_DVB_LG2160=y
> CONFIG_DVB_S5H1409=y
> CONFIG_DVB_AU8522=y
> # CONFIG_DVB_AU8522_DTV is not set
> CONFIG_DVB_AU8522_V4L=y
> # CONFIG_DVB_S5H1411 is not set
> 
> #
> # ISDB-T (terrestrial) frontends
> #
> CONFIG_DVB_S921=y
> # CONFIG_DVB_DIB8000 is not set
> CONFIG_DVB_MB86A20S=y
> 
> #
> # Digital terrestrial only tuners/PLL
> #
> CONFIG_DVB_PLL=y
> CONFIG_DVB_TUNER_DIB0070=y
> CONFIG_DVB_TUNER_DIB0090=y
> 
> #
> # SEC control devices for DVB-S
> #
> CONFIG_DVB_DRX39XYJ=y
> CONFIG_DVB_LNBP21=y
> CONFIG_DVB_LNBP22=y
> CONFIG_DVB_ISL6405=y
> CONFIG_DVB_ISL6421=y
> # CONFIG_DVB_ISL6423 is not set
> CONFIG_DVB_A8293=y
> # CONFIG_DVB_LGS8GL5 is not set
> CONFIG_DVB_LGS8GXX=y
> CONFIG_DVB_ATBM8830=y
> CONFIG_DVB_TDA665x=y
> # CONFIG_DVB_IX2505V is not set
> CONFIG_DVB_M88RS2000=y
> # CONFIG_DVB_AF9033 is not set
> 
> #
> # Tools to develop new frontends
> #
> # CONFIG_DVB_DUMMY_FE is not set
> 
> #
> # Graphics support
> #
> # CONFIG_AGP is not set
> CONFIG_VGA_ARB=y
> CONFIG_VGA_ARB_MAX_GPUS=16
> # CONFIG_VGA_SWITCHEROO is not set
> 
> #
> # Direct Rendering Manager
> #
> CONFIG_DRM=y
> # CONFIG_DRM_TDFX is not set
> # CONFIG_DRM_R128 is not set
> # CONFIG_DRM_RADEON is not set
> # CONFIG_DRM_NOUVEAU is not set
> # CONFIG_DRM_I915 is not set
> # CONFIG_DRM_MGA is not set
> # CONFIG_DRM_VIA is not set
> # CONFIG_DRM_SAVAGE is not set
> # CONFIG_DRM_VMWGFX is not set
> # CONFIG_DRM_GMA500 is not set
> # CONFIG_DRM_UDL is not set
> # CONFIG_DRM_AST is not set
> # CONFIG_DRM_MGAG200 is not set
> # CONFIG_DRM_CIRRUS_QEMU is not set
> # CONFIG_DRM_QXL is not set
> # CONFIG_DRM_BOCHS is not set
> # CONFIG_DRM_PTN3460 is not set
> 
> #
> # Frame buffer Devices
> #
> CONFIG_FB=y
> CONFIG_FIRMWARE_EDID=y
> # CONFIG_FB_DDC is not set
> # CONFIG_FB_BOOT_VESA_SUPPORT is not set
> CONFIG_FB_CFB_FILLRECT=y
> CONFIG_FB_CFB_COPYAREA=y
> CONFIG_FB_CFB_IMAGEBLIT=y
> # CONFIG_FB_CFB_REV_PIXELS_IN_BYTE is not set
> CONFIG_FB_SYS_FILLRECT=y
> CONFIG_FB_SYS_COPYAREA=y
> CONFIG_FB_SYS_IMAGEBLIT=y
> CONFIG_FB_FOREIGN_ENDIAN=y
> # CONFIG_FB_BOTH_ENDIAN is not set
> CONFIG_FB_BIG_ENDIAN=y
> # CONFIG_FB_LITTLE_ENDIAN is not set
> CONFIG_FB_SYS_FOPS=y
> CONFIG_FB_DEFERRED_IO=y
> # CONFIG_FB_SVGALIB is not set
> # CONFIG_FB_MACMODES is not set
> # CONFIG_FB_BACKLIGHT is not set
> CONFIG_FB_MODE_HELPERS=y
> # CONFIG_FB_TILEBLITTING is not set
> 
> #
> # Frame buffer hardware drivers
> #
> # CONFIG_FB_CIRRUS is not set
> # CONFIG_FB_PM2 is not set
> # CONFIG_FB_CYBER2000 is not set
> CONFIG_FB_ARC=y
> # CONFIG_FB_ASILIANT is not set
> # CONFIG_FB_IMSTT is not set
> # CONFIG_FB_VGA16 is not set
> CONFIG_FB_UVESA=y
> # CONFIG_FB_VESA is not set
> # CONFIG_FB_N411 is not set
> CONFIG_FB_HGA=y
> # CONFIG_FB_OPENCORES is not set
> CONFIG_FB_S1D13XXX=y
> # CONFIG_FB_NVIDIA is not set
> # CONFIG_FB_RIVA is not set
> # CONFIG_FB_I740 is not set
> # CONFIG_FB_LE80578 is not set
> # CONFIG_FB_MATROX is not set
> # CONFIG_FB_RADEON is not set
> # CONFIG_FB_ATY128 is not set
> # CONFIG_FB_ATY is not set
> # CONFIG_FB_S3 is not set
> # CONFIG_FB_SAVAGE is not set
> # CONFIG_FB_SIS is not set
> # CONFIG_FB_VIA is not set
> # CONFIG_FB_NEOMAGIC is not set
> # CONFIG_FB_KYRO is not set
> # CONFIG_FB_3DFX is not set
> # CONFIG_FB_VOODOO1 is not set
> # CONFIG_FB_VT8623 is not set
> # CONFIG_FB_TRIDENT is not set
> # CONFIG_FB_ARK is not set
> # CONFIG_FB_PM3 is not set
> # CONFIG_FB_CARMINE is not set
> # CONFIG_FB_GEODE is not set
> # CONFIG_FB_TMIO is not set
> # CONFIG_FB_SM501 is not set
> CONFIG_FB_SMSCUFX=y
> CONFIG_FB_UDL=y
> CONFIG_FB_GOLDFISH=y
> CONFIG_FB_VIRTUAL=y
> CONFIG_FB_METRONOME=y
> # CONFIG_FB_MB862XX is not set
> CONFIG_FB_BROADSHEET=y
> CONFIG_FB_AUO_K190X=y
> CONFIG_FB_AUO_K1900=y
> CONFIG_FB_AUO_K1901=y
> # CONFIG_FB_SIMPLE is not set
> # CONFIG_EXYNOS_VIDEO is not set
> CONFIG_FB_SSD1307=y
> CONFIG_BACKLIGHT_LCD_SUPPORT=y
> CONFIG_LCD_CLASS_DEVICE=y
> # CONFIG_LCD_PLATFORM is not set
> CONFIG_BACKLIGHT_CLASS_DEVICE=y
> CONFIG_BACKLIGHT_GENERIC=y
> # CONFIG_BACKLIGHT_LM3533 is not set
> CONFIG_BACKLIGHT_PWM=y
> # CONFIG_BACKLIGHT_DA903X is not set
> CONFIG_BACKLIGHT_MAX8925=y
> # CONFIG_BACKLIGHT_APPLE is not set
> # CONFIG_BACKLIGHT_SAHARA is not set
> CONFIG_BACKLIGHT_ADP5520=y
> CONFIG_BACKLIGHT_ADP8860=y
> CONFIG_BACKLIGHT_ADP8870=y
> # CONFIG_BACKLIGHT_PCF50633 is not set
> # CONFIG_BACKLIGHT_LM3630A is not set
> CONFIG_BACKLIGHT_LM3639=y
> CONFIG_BACKLIGHT_LP855X=y
> # CONFIG_BACKLIGHT_LP8788 is not set
> CONFIG_BACKLIGHT_PANDORA=y
> CONFIG_BACKLIGHT_TPS65217=y
> CONFIG_BACKLIGHT_GPIO=y
> CONFIG_BACKLIGHT_LV5207LP=y
> CONFIG_BACKLIGHT_BD6107=y
> # CONFIG_VGASTATE is not set
> CONFIG_HDMI=y
> # CONFIG_LOGO is not set
> # CONFIG_SOUND is not set
> 
> #
> # HID support
> #
> # CONFIG_HID is not set
> 
> #
> # USB HID support
> #
> # CONFIG_USB_HID is not set
> # CONFIG_HID_PID is not set
> 
> #
> # USB HID Boot Protocol drivers
> #
> CONFIG_USB_KBD=y
> # CONFIG_USB_MOUSE is not set
> 
> #
> # I2C HID support
> #
> # CONFIG_I2C_HID is not set
> CONFIG_USB_OHCI_LITTLE_ENDIAN=y
> CONFIG_USB_SUPPORT=y
> CONFIG_USB_COMMON=y
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB=y
> # CONFIG_USB_DEBUG is not set
> # CONFIG_USB_ANNOUNCE_NEW_DEVICES is not set
> 
> #
> # Miscellaneous USB options
> #
> CONFIG_USB_DEFAULT_PERSIST=y
> CONFIG_USB_DYNAMIC_MINORS=y
> CONFIG_USB_OTG=y
> CONFIG_USB_OTG_WHITELIST=y
> CONFIG_USB_OTG_BLACKLIST_HUB=y
> # CONFIG_USB_MON is not set
> # CONFIG_USB_WUSB_CBAF is not set
> 
> #
> # USB Host Controller Drivers
> #
> CONFIG_USB_C67X00_HCD=y
> CONFIG_USB_XHCI_HCD=y
> CONFIG_USB_EHCI_HCD=y
> # CONFIG_USB_EHCI_ROOT_HUB_TT is not set
> CONFIG_USB_EHCI_TT_NEWSCHED=y
> CONFIG_USB_EHCI_PCI=y
> CONFIG_USB_EHCI_HCD_PLATFORM=y
> CONFIG_USB_OXU210HP_HCD=y
> # CONFIG_USB_ISP116X_HCD is not set
> CONFIG_USB_ISP1760_HCD=y
> # CONFIG_USB_ISP1362_HCD is not set
> # CONFIG_USB_FUSBH200_HCD is not set
> CONFIG_USB_FOTG210_HCD=y
> # CONFIG_USB_OHCI_HCD is not set
> # CONFIG_USB_UHCI_HCD is not set
> # CONFIG_USB_U132_HCD is not set
> CONFIG_USB_SL811_HCD=y
> CONFIG_USB_SL811_HCD_ISO=y
> CONFIG_USB_SL811_CS=y
> # CONFIG_USB_R8A66597_HCD is not set
> CONFIG_USB_HCD_BCMA=y
> CONFIG_USB_HCD_SSB=y
> # CONFIG_USB_HCD_TEST_MODE is not set
> 
> #
> # USB Device Class drivers
> #
> CONFIG_USB_ACM=y
> CONFIG_USB_PRINTER=y
> CONFIG_USB_WDM=y
> # CONFIG_USB_TMC is not set
> 
> #
> # NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
> #
> 
> #
> # also be needed; see USB_STORAGE Help for more info
> #
> CONFIG_USB_STORAGE=y
> # CONFIG_USB_STORAGE_DEBUG is not set
> # CONFIG_USB_STORAGE_REALTEK is not set
> CONFIG_USB_STORAGE_DATAFAB=y
> # CONFIG_USB_STORAGE_FREECOM is not set
> CONFIG_USB_STORAGE_ISD200=y
> # CONFIG_USB_STORAGE_USBAT is not set
> # CONFIG_USB_STORAGE_SDDR09 is not set
> CONFIG_USB_STORAGE_SDDR55=y
> # CONFIG_USB_STORAGE_JUMPSHOT is not set
> CONFIG_USB_STORAGE_ALAUDA=y
> CONFIG_USB_STORAGE_ONETOUCH=y
> CONFIG_USB_STORAGE_KARMA=y
> CONFIG_USB_STORAGE_CYPRESS_ATACB=y
> CONFIG_USB_STORAGE_ENE_UB6250=y
> CONFIG_USB_UAS=y
> 
> #
> # USB Imaging devices
> #
> # CONFIG_USB_MDC800 is not set
> CONFIG_USB_MICROTEK=y
> CONFIG_USB_MUSB_HDRC=y
> CONFIG_USB_MUSB_HOST=y
> CONFIG_USB_MUSB_TUSB6010=y
> # CONFIG_USB_MUSB_DSPS is not set
> # CONFIG_USB_MUSB_UX500 is not set
> CONFIG_MUSB_PIO_ONLY=y
> # CONFIG_USB_DWC3 is not set
> CONFIG_USB_DWC2=y
> # CONFIG_USB_DWC2_DEBUG is not set
> # CONFIG_USB_DWC2_TRACK_MISSED_SOFS is not set
> CONFIG_USB_CHIPIDEA=y
> # CONFIG_USB_CHIPIDEA_HOST is not set
> CONFIG_USB_CHIPIDEA_DEBUG=y
> 
> #
> # USB port drivers
> #
> CONFIG_USB_USS720=y
> CONFIG_USB_SERIAL=y
> # CONFIG_USB_SERIAL_CONSOLE is not set
> CONFIG_USB_SERIAL_GENERIC=y
> CONFIG_USB_SERIAL_SIMPLE=y
> CONFIG_USB_SERIAL_AIRCABLE=y
> # CONFIG_USB_SERIAL_ARK3116 is not set
> CONFIG_USB_SERIAL_BELKIN=y
> CONFIG_USB_SERIAL_CH341=y
> # CONFIG_USB_SERIAL_WHITEHEAT is not set
> # CONFIG_USB_SERIAL_DIGI_ACCELEPORT is not set
> CONFIG_USB_SERIAL_CP210X=y
> # CONFIG_USB_SERIAL_CYPRESS_M8 is not set
> CONFIG_USB_SERIAL_EMPEG=y
> # CONFIG_USB_SERIAL_FTDI_SIO is not set
> # CONFIG_USB_SERIAL_VISOR is not set
> # CONFIG_USB_SERIAL_IPAQ is not set
> # CONFIG_USB_SERIAL_IR is not set
> # CONFIG_USB_SERIAL_EDGEPORT is not set
> # CONFIG_USB_SERIAL_EDGEPORT_TI is not set
> CONFIG_USB_SERIAL_F81232=y
> # CONFIG_USB_SERIAL_GARMIN is not set
> CONFIG_USB_SERIAL_IPW=y
> CONFIG_USB_SERIAL_IUU=y
> CONFIG_USB_SERIAL_KEYSPAN_PDA=y
> # CONFIG_USB_SERIAL_KEYSPAN is not set
> # CONFIG_USB_SERIAL_KLSI is not set
> # CONFIG_USB_SERIAL_KOBIL_SCT is not set
> # CONFIG_USB_SERIAL_MCT_U232 is not set
> CONFIG_USB_SERIAL_METRO=y
> CONFIG_USB_SERIAL_MOS7720=y
> # CONFIG_USB_SERIAL_MOS7715_PARPORT is not set
> CONFIG_USB_SERIAL_MOS7840=y
> CONFIG_USB_SERIAL_MXUPORT=y
> CONFIG_USB_SERIAL_NAVMAN=y
> CONFIG_USB_SERIAL_PL2303=y
> CONFIG_USB_SERIAL_OTI6858=y
> CONFIG_USB_SERIAL_QCAUX=y
> CONFIG_USB_SERIAL_QUALCOMM=y
> # CONFIG_USB_SERIAL_SPCP8X5 is not set
> # CONFIG_USB_SERIAL_SAFE is not set
> # CONFIG_USB_SERIAL_SIERRAWIRELESS is not set
> CONFIG_USB_SERIAL_SYMBOL=y
> # CONFIG_USB_SERIAL_TI is not set
> CONFIG_USB_SERIAL_CYBERJACK=y
> # CONFIG_USB_SERIAL_XIRCOM is not set
> CONFIG_USB_SERIAL_WWAN=y
> # CONFIG_USB_SERIAL_OPTION is not set
> # CONFIG_USB_SERIAL_OMNINET is not set
> # CONFIG_USB_SERIAL_OPTICON is not set
> # CONFIG_USB_SERIAL_XSENS_MT is not set
> CONFIG_USB_SERIAL_WISHBONE=y
> CONFIG_USB_SERIAL_ZTE=y
> # CONFIG_USB_SERIAL_SSU100 is not set
> # CONFIG_USB_SERIAL_QT2 is not set
> CONFIG_USB_SERIAL_DEBUG=y
> 
> #
> # USB Miscellaneous drivers
> #
> CONFIG_USB_EMI62=y
> CONFIG_USB_EMI26=y
> CONFIG_USB_ADUTUX=y
> CONFIG_USB_SEVSEG=y
> CONFIG_USB_RIO500=y
> CONFIG_USB_LEGOTOWER=y
> CONFIG_USB_LCD=y
> CONFIG_USB_LED=y
> # CONFIG_USB_CYPRESS_CY7C63 is not set
> CONFIG_USB_CYTHERM=y
> # CONFIG_USB_IDMOUSE is not set
> CONFIG_USB_FTDI_ELAN=y
> CONFIG_USB_APPLEDISPLAY=y
> # CONFIG_USB_SISUSBVGA is not set
> # CONFIG_USB_LD is not set
> # CONFIG_USB_TRANCEVIBRATOR is not set
> # CONFIG_USB_IOWARRIOR is not set
> # CONFIG_USB_TEST is not set
> CONFIG_USB_EHSET_TEST_FIXTURE=y
> CONFIG_USB_ISIGHTFW=y
> CONFIG_USB_YUREX=y
> CONFIG_USB_EZUSB_FX2=y
> CONFIG_USB_HSIC_USB3503=y
> 
> #
> # USB Physical Layer drivers
> #
> CONFIG_USB_PHY=y
> CONFIG_USB_OTG_FSM=y
> # CONFIG_NOP_USB_XCEIV is not set
> # CONFIG_SAMSUNG_USB2PHY is not set
> # CONFIG_SAMSUNG_USB3PHY is not set
> # CONFIG_USB_GPIO_VBUS is not set
> CONFIG_TAHVO_USB=y
> CONFIG_TAHVO_USB_HOST_BY_DEFAULT=y
> # CONFIG_USB_ISP1301 is not set
> # CONFIG_USB_RCAR_PHY is not set
> # CONFIG_USB_GADGET is not set
> # CONFIG_UWB is not set
> CONFIG_MMC=y
> CONFIG_MMC_DEBUG=y
> # CONFIG_MMC_CLKGATE is not set
> 
> #
> # MMC/SD/SDIO Card Drivers
> #
> # CONFIG_MMC_BLOCK is not set
> CONFIG_SDIO_UART=y
> CONFIG_MMC_TEST=y
> 
> #
> # MMC/SD/SDIO Host Controller Drivers
> #
> CONFIG_MMC_SDHCI=y
> # CONFIG_MMC_SDHCI_PCI is not set
> # CONFIG_MMC_SDHCI_ACPI is not set
> CONFIG_MMC_SDHCI_PLTFM=y
> # CONFIG_MMC_SDHCI_OF_ARASAN is not set
> # CONFIG_MMC_WBSD is not set
> # CONFIG_MMC_TIFM_SD is not set
> # CONFIG_MMC_GOLDFISH is not set
> # CONFIG_MMC_SDRICOH_CS is not set
> # CONFIG_MMC_CB710 is not set
> # CONFIG_MMC_VIA_SDMMC is not set
> CONFIG_MMC_VUB300=y
> CONFIG_MMC_USHC=y
> CONFIG_MEMSTICK=y
> # CONFIG_MEMSTICK_DEBUG is not set
> 
> #
> # MemoryStick drivers
> #
> # CONFIG_MEMSTICK_UNSAFE_RESUME is not set
> CONFIG_MSPRO_BLOCK=y
> # CONFIG_MS_BLOCK is not set
> 
> #
> # MemoryStick Host Controller Drivers
> #
> # CONFIG_MEMSTICK_TIFM_MS is not set
> # CONFIG_MEMSTICK_JMICRON_38X is not set
> # CONFIG_MEMSTICK_R592 is not set
> CONFIG_NEW_LEDS=y
> CONFIG_LEDS_CLASS=y
> 
> #
> # LED drivers
> #
> CONFIG_LEDS_LM3530=y
> # CONFIG_LEDS_LM3533 is not set
> # CONFIG_LEDS_LM3642 is not set
> # CONFIG_LEDS_PCA9532 is not set
> CONFIG_LEDS_GPIO=y
> CONFIG_LEDS_LP3944=y
> CONFIG_LEDS_LP55XX_COMMON=y
> # CONFIG_LEDS_LP5521 is not set
> CONFIG_LEDS_LP5523=y
> CONFIG_LEDS_LP5562=y
> CONFIG_LEDS_LP8501=y
> # CONFIG_LEDS_LP8788 is not set
> CONFIG_LEDS_PCA955X=y
> CONFIG_LEDS_PCA963X=y
> # CONFIG_LEDS_PCA9685 is not set
> CONFIG_LEDS_DA903X=y
> CONFIG_LEDS_PWM=y
> # CONFIG_LEDS_REGULATOR is not set
> # CONFIG_LEDS_BD2802 is not set
> CONFIG_LEDS_LT3593=y
> CONFIG_LEDS_ADP5520=y
> CONFIG_LEDS_MC13783=y
> # CONFIG_LEDS_TCA6507 is not set
> CONFIG_LEDS_LM355x=y
> # CONFIG_LEDS_OT200 is not set
> CONFIG_LEDS_BLINKM=y
> 
> #
> # LED Triggers
> #
> CONFIG_LEDS_TRIGGERS=y
> CONFIG_LEDS_TRIGGER_TIMER=y
> CONFIG_LEDS_TRIGGER_ONESHOT=y
> CONFIG_LEDS_TRIGGER_HEARTBEAT=y
> # CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
> CONFIG_LEDS_TRIGGER_CPU=y
> CONFIG_LEDS_TRIGGER_GPIO=y
> # CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
> 
> #
> # iptables trigger is under Netfilter config (LED target)
> #
> CONFIG_LEDS_TRIGGER_TRANSIENT=y
> CONFIG_LEDS_TRIGGER_CAMERA=y
> # CONFIG_ACCESSIBILITY is not set
> # CONFIG_EDAC is not set
> CONFIG_RTC_LIB=y
> CONFIG_RTC_CLASS=y
> CONFIG_RTC_HCTOSYS=y
> CONFIG_RTC_SYSTOHC=y
> CONFIG_RTC_HCTOSYS_DEVICE="rtc0"
> # CONFIG_RTC_DEBUG is not set
> 
> #
> # RTC interfaces
> #
> # CONFIG_RTC_INTF_SYSFS is not set
> CONFIG_RTC_INTF_PROC=y
> # CONFIG_RTC_INTF_DEV is not set
> CONFIG_RTC_DRV_TEST=y
> 
> #
> # I2C RTC drivers
> #
> CONFIG_RTC_DRV_88PM80X=y
> CONFIG_RTC_DRV_DS1307=y
> CONFIG_RTC_DRV_DS1374=y
> CONFIG_RTC_DRV_DS1672=y
> # CONFIG_RTC_DRV_DS3232 is not set
> CONFIG_RTC_DRV_HYM8563=y
> CONFIG_RTC_DRV_LP8788=y
> CONFIG_RTC_DRV_MAX6900=y
> # CONFIG_RTC_DRV_MAX8907 is not set
> CONFIG_RTC_DRV_MAX8925=y
> # CONFIG_RTC_DRV_MAX8998 is not set
> CONFIG_RTC_DRV_MAX77686=y
> CONFIG_RTC_DRV_RS5C372=y
> CONFIG_RTC_DRV_ISL1208=y
> CONFIG_RTC_DRV_ISL12022=y
> CONFIG_RTC_DRV_ISL12057=y
> CONFIG_RTC_DRV_X1205=y
> CONFIG_RTC_DRV_PALMAS=y
> CONFIG_RTC_DRV_PCF2127=y
> CONFIG_RTC_DRV_PCF8523=y
> CONFIG_RTC_DRV_PCF8563=y
> CONFIG_RTC_DRV_PCF8583=y
> CONFIG_RTC_DRV_M41T80=y
> CONFIG_RTC_DRV_M41T80_WDT=y
> # CONFIG_RTC_DRV_BQ32K is not set
> CONFIG_RTC_DRV_TWL4030=y
> # CONFIG_RTC_DRV_S35390A is not set
> # CONFIG_RTC_DRV_FM3130 is not set
> # CONFIG_RTC_DRV_RX8581 is not set
> # CONFIG_RTC_DRV_RX8025 is not set
> CONFIG_RTC_DRV_EM3027=y
> CONFIG_RTC_DRV_RV3029C2=y
> 
> #
> # SPI RTC drivers
> #
> 
> #
> # Platform RTC drivers
> #
> CONFIG_RTC_DRV_CMOS=y
> # CONFIG_RTC_DRV_DS1286 is not set
> CONFIG_RTC_DRV_DS1511=y
> CONFIG_RTC_DRV_DS1553=y
> CONFIG_RTC_DRV_DS1742=y
> CONFIG_RTC_DRV_DA9055=y
> # CONFIG_RTC_DRV_STK17TA8 is not set
> CONFIG_RTC_DRV_M48T86=y
> CONFIG_RTC_DRV_M48T35=y
> # CONFIG_RTC_DRV_M48T59 is not set
> # CONFIG_RTC_DRV_MSM6242 is not set
> CONFIG_RTC_DRV_BQ4802=y
> CONFIG_RTC_DRV_RP5C01=y
> # CONFIG_RTC_DRV_V3020 is not set
> CONFIG_RTC_DRV_DS2404=y
> # CONFIG_RTC_DRV_PCF50633 is not set
> 
> #
> # on-CPU RTC drivers
> #
> CONFIG_RTC_DRV_MC13XXX=y
> # CONFIG_RTC_DRV_SNVS is not set
> CONFIG_RTC_DRV_MOXART=y
> 
> #
> # HID Sensor RTC drivers
> #
> # CONFIG_DMADEVICES is not set
> CONFIG_AUXDISPLAY=y
> # CONFIG_KS0108 is not set
> CONFIG_UIO=y
> # CONFIG_UIO_CIF is not set
> CONFIG_UIO_PDRV_GENIRQ=y
> CONFIG_UIO_DMEM_GENIRQ=y
> # CONFIG_UIO_AEC is not set
> # CONFIG_UIO_SERCOS3 is not set
> # CONFIG_UIO_PCI_GENERIC is not set
> # CONFIG_UIO_NETX is not set
> # CONFIG_UIO_MF624 is not set
> CONFIG_VIRT_DRIVERS=y
> 
> #
> # Virtio drivers
> #
> # CONFIG_VIRTIO_PCI is not set
> # CONFIG_VIRTIO_MMIO is not set
> 
> #
> # Microsoft Hyper-V guest support
> #
> # CONFIG_HYPERV is not set
> # CONFIG_STAGING is not set
> # CONFIG_X86_PLATFORM_DEVICES is not set
> # CONFIG_GOLDFISH_PIPE is not set
> CONFIG_CHROME_PLATFORMS=y
> # CONFIG_CHROMEOS_PSTORE is not set
> 
> #
> # Hardware Spinlock drivers
> #
> CONFIG_CLKSRC_I8253=y
> CONFIG_CLKEVT_I8253=y
> CONFIG_I8253_LOCK=y
> CONFIG_CLKBLD_I8253=y
> # CONFIG_SH_TIMER_CMT is not set
> # CONFIG_SH_TIMER_MTU2 is not set
> # CONFIG_SH_TIMER_TMU is not set
> # CONFIG_EM_TIMER_STI is not set
> CONFIG_MAILBOX=y
> CONFIG_IOMMU_SUPPORT=y
> CONFIG_OF_IOMMU=y
> 
> #
> # Remoteproc drivers
> #
> # CONFIG_STE_MODEM_RPROC is not set
> 
> #
> # Rpmsg drivers
> #
> CONFIG_PM_DEVFREQ=y
> 
> #
> # DEVFREQ Governors
> #
> CONFIG_DEVFREQ_GOV_SIMPLE_ONDEMAND=y
> # CONFIG_DEVFREQ_GOV_PERFORMANCE is not set
> CONFIG_DEVFREQ_GOV_POWERSAVE=y
> CONFIG_DEVFREQ_GOV_USERSPACE=y
> 
> #
> # DEVFREQ Drivers
> #
> CONFIG_EXTCON=y
> 
> #
> # Extcon Device Drivers
> #
> CONFIG_EXTCON_GPIO=y
> CONFIG_EXTCON_ADC_JACK=y
> # CONFIG_EXTCON_MAX14577 is not set
> # CONFIG_EXTCON_MAX77693 is not set
> CONFIG_EXTCON_PALMAS=y
> # CONFIG_MEMORY is not set
> CONFIG_IIO=y
> CONFIG_IIO_BUFFER=y
> # CONFIG_IIO_BUFFER_CB is not set
> CONFIG_IIO_KFIFO_BUF=y
> CONFIG_IIO_TRIGGERED_BUFFER=y
> CONFIG_IIO_TRIGGER=y
> CONFIG_IIO_CONSUMERS_PER_TRIGGER=2
> 
> #
> # Accelerometers
> #
> CONFIG_BMA180=y
> CONFIG_IIO_ST_ACCEL_3AXIS=y
> CONFIG_IIO_ST_ACCEL_I2C_3AXIS=y
> 
> #
> # Analog to digital converters
> #
> # CONFIG_EXYNOS_ADC is not set
> CONFIG_LP8788_ADC=y
> # CONFIG_MAX1363 is not set
> CONFIG_MCP3422=y
> CONFIG_NAU7802=y
> # CONFIG_TI_ADC081C is not set
> # CONFIG_TWL4030_MADC is not set
> # CONFIG_TWL6030_GPADC is not set
> # CONFIG_VF610_ADC is not set
> # CONFIG_VIPERBOARD_ADC is not set
> 
> #
> # Amplifiers
> #
> 
> #
> # Hid Sensor IIO Common
> #
> CONFIG_IIO_ST_SENSORS_I2C=y
> CONFIG_IIO_ST_SENSORS_CORE=y
> 
> #
> # Digital to analog converters
> #
> # CONFIG_AD5064 is not set
> # CONFIG_AD5380 is not set
> CONFIG_AD5446=y
> # CONFIG_MAX517 is not set
> CONFIG_MCP4725=y
> 
> #
> # Frequency Synthesizers DDS/PLL
> #
> 
> #
> # Clock Generator/Distribution
> #
> 
> #
> # Phase-Locked Loop (PLL) frequency synthesizers
> #
> 
> #
> # Digital gyroscope sensors
> #
> CONFIG_IIO_ST_GYRO_3AXIS=y
> CONFIG_IIO_ST_GYRO_I2C_3AXIS=y
> CONFIG_ITG3200=y
> 
> #
> # Humidity sensors
> #
> CONFIG_DHT11=y
> CONFIG_SI7005=y
> 
> #
> # Inertial measurement units
> #
> CONFIG_INV_MPU6050_IIO=y
> 
> #
> # Light sensors
> #
> CONFIG_ADJD_S311=y
> CONFIG_APDS9300=y
> # CONFIG_CM32181 is not set
> # CONFIG_CM36651 is not set
> CONFIG_GP2AP020A00F=y
> # CONFIG_SENSORS_LM3533 is not set
> CONFIG_LTR501=y
> CONFIG_TCS3472=y
> CONFIG_SENSORS_TSL2563=y
> CONFIG_TSL4531=y
> CONFIG_VCNL4000=y
> 
> #
> # Magnetometer sensors
> #
> CONFIG_AK8975=y
> # CONFIG_MAG3110 is not set
> CONFIG_IIO_ST_MAGN_3AXIS=y
> CONFIG_IIO_ST_MAGN_I2C_3AXIS=y
> 
> #
> # Inclinometer sensors
> #
> 
> #
> # Triggers - standalone
> #
> CONFIG_IIO_INTERRUPT_TRIGGER=y
> CONFIG_IIO_SYSFS_TRIGGER=y
> 
> #
> # Pressure sensors
> #
> # CONFIG_MPL3115 is not set
> CONFIG_IIO_ST_PRESS=y
> CONFIG_IIO_ST_PRESS_I2C=y
> 
> #
> # Temperature sensors
> #
> CONFIG_TMP006=y
> # CONFIG_NTB is not set
> # CONFIG_VME_BUS is not set
> CONFIG_PWM=y
> CONFIG_PWM_SYSFS=y
> # CONFIG_PWM_FSL_FTM is not set
> CONFIG_PWM_LP3943=y
> # CONFIG_PWM_LPSS is not set
> CONFIG_PWM_PCA9685=y
> CONFIG_PWM_TWL=y
> CONFIG_PWM_TWL_LED=y
> CONFIG_IRQCHIP=y
> CONFIG_IPACK_BUS=y
> # CONFIG_BOARD_TPCI200 is not set
> CONFIG_SERIAL_IPOCTAL=y
> # CONFIG_RESET_CONTROLLER is not set
> CONFIG_FMC=y
> # CONFIG_FMC_FAKEDEV is not set
> # CONFIG_FMC_TRIVIAL is not set
> # CONFIG_FMC_WRITE_EEPROM is not set
> CONFIG_FMC_CHARDEV=y
> 
> #
> # PHY Subsystem
> #
> CONFIG_GENERIC_PHY=y
> CONFIG_BCM_KONA_USB2_PHY=y
> CONFIG_PHY_SAMSUNG_USB2=y
> # CONFIG_POWERCAP is not set
> # CONFIG_MCB is not set
> 
> #
> # Firmware Drivers
> #
> CONFIG_EDD=y
> CONFIG_EDD_OFF=y
> CONFIG_FIRMWARE_MEMMAP=y
> CONFIG_DELL_RBU=y
> CONFIG_DCDBAS=y
> # CONFIG_ISCSI_IBFT_FIND is not set
> CONFIG_GOOGLE_FIRMWARE=y
> 
> #
> # Google Firmware Drivers
> #
> 
> #
> # File systems
> #
> CONFIG_DCACHE_WORD_ACCESS=y
> CONFIG_EXT2_FS=y
> CONFIG_EXT2_FS_XATTR=y
> # CONFIG_EXT2_FS_POSIX_ACL is not set
> # CONFIG_EXT2_FS_SECURITY is not set
> CONFIG_EXT2_FS_XIP=y
> CONFIG_EXT3_FS=y
> # CONFIG_EXT3_DEFAULTS_TO_ORDERED is not set
> CONFIG_EXT3_FS_XATTR=y
> # CONFIG_EXT3_FS_POSIX_ACL is not set
> # CONFIG_EXT3_FS_SECURITY is not set
> CONFIG_EXT4_FS=y
> CONFIG_EXT4_FS_POSIX_ACL=y
> # CONFIG_EXT4_FS_SECURITY is not set
> CONFIG_EXT4_DEBUG=y
> CONFIG_FS_XIP=y
> CONFIG_JBD=y
> CONFIG_JBD_DEBUG=y
> CONFIG_JBD2=y
> # CONFIG_JBD2_DEBUG is not set
> CONFIG_FS_MBCACHE=y
> CONFIG_REISERFS_FS=y
> # CONFIG_REISERFS_CHECK is not set
> # CONFIG_REISERFS_PROC_INFO is not set
> # CONFIG_REISERFS_FS_XATTR is not set
> CONFIG_JFS_FS=y
> # CONFIG_JFS_POSIX_ACL is not set
> # CONFIG_JFS_SECURITY is not set
> # CONFIG_JFS_DEBUG is not set
> # CONFIG_JFS_STATISTICS is not set
> # CONFIG_XFS_FS is not set
> CONFIG_GFS2_FS=y
> CONFIG_OCFS2_FS=y
> CONFIG_OCFS2_FS_O2CB=y
> # CONFIG_OCFS2_FS_STATS is not set
> # CONFIG_OCFS2_DEBUG_MASKLOG is not set
> CONFIG_OCFS2_DEBUG_FS=y
> CONFIG_BTRFS_FS=y
> # CONFIG_BTRFS_FS_POSIX_ACL is not set
> CONFIG_BTRFS_FS_CHECK_INTEGRITY=y
> # CONFIG_BTRFS_FS_RUN_SANITY_TESTS is not set
> # CONFIG_BTRFS_DEBUG is not set
> CONFIG_BTRFS_ASSERT=y
> CONFIG_NILFS2_FS=y
> CONFIG_FS_POSIX_ACL=y
> CONFIG_EXPORTFS=y
> # CONFIG_FILE_LOCKING is not set
> CONFIG_FSNOTIFY=y
> # CONFIG_DNOTIFY is not set
> # CONFIG_INOTIFY_USER is not set
> # CONFIG_FANOTIFY is not set
> CONFIG_QUOTA=y
> # CONFIG_QUOTA_NETLINK_INTERFACE is not set
> # CONFIG_PRINT_QUOTA_WARNING is not set
> # CONFIG_QUOTA_DEBUG is not set
> CONFIG_QUOTA_TREE=y
> # CONFIG_QFMT_V1 is not set
> CONFIG_QFMT_V2=y
> CONFIG_QUOTACTL=y
> CONFIG_AUTOFS4_FS=y
> # CONFIG_FUSE_FS is not set
> 
> #
> # Caches
> #
> # CONFIG_FSCACHE is not set
> 
> #
> # CD-ROM/DVD Filesystems
> #
> CONFIG_ISO9660_FS=y
> # CONFIG_JOLIET is not set
> # CONFIG_ZISOFS is not set
> # CONFIG_UDF_FS is not set
> 
> #
> # DOS/FAT/NT Filesystems
> #
> CONFIG_FAT_FS=y
> CONFIG_MSDOS_FS=y
> CONFIG_VFAT_FS=y
> CONFIG_FAT_DEFAULT_CODEPAGE=437
> CONFIG_FAT_DEFAULT_IOCHARSET="iso8859-1"
> CONFIG_NTFS_FS=y
> # CONFIG_NTFS_DEBUG is not set
> # CONFIG_NTFS_RW is not set
> 
> #
> # Pseudo filesystems
> #
> CONFIG_PROC_FS=y
> CONFIG_PROC_KCORE=y
> CONFIG_PROC_SYSCTL=y
> # CONFIG_PROC_PAGE_MONITOR is not set
> CONFIG_KERNFS=y
> CONFIG_SYSFS=y
> CONFIG_TMPFS=y
> CONFIG_TMPFS_POSIX_ACL=y
> CONFIG_TMPFS_XATTR=y
> # CONFIG_HUGETLBFS is not set
> # CONFIG_HUGETLB_PAGE is not set
> CONFIG_CONFIGFS_FS=y
> CONFIG_MISC_FILESYSTEMS=y
> CONFIG_ADFS_FS=y
> # CONFIG_ADFS_FS_RW is not set
> CONFIG_AFFS_FS=y
> CONFIG_ECRYPT_FS=y
> CONFIG_ECRYPT_FS_MESSAGING=y
> CONFIG_HFS_FS=y
> CONFIG_HFSPLUS_FS=y
> # CONFIG_HFSPLUS_FS_POSIX_ACL is not set
> CONFIG_BEFS_FS=y
> # CONFIG_BEFS_DEBUG is not set
> CONFIG_BFS_FS=y
> CONFIG_EFS_FS=y
> CONFIG_JFFS2_FS=y
> CONFIG_JFFS2_FS_DEBUG=0
> CONFIG_JFFS2_FS_WRITEBUFFER=y
> CONFIG_JFFS2_FS_WBUF_VERIFY=y
> # CONFIG_JFFS2_SUMMARY is not set
> # CONFIG_JFFS2_FS_XATTR is not set
> CONFIG_JFFS2_COMPRESSION_OPTIONS=y
> CONFIG_JFFS2_ZLIB=y
> # CONFIG_JFFS2_LZO is not set
> # CONFIG_JFFS2_RTIME is not set
> # CONFIG_JFFS2_RUBIN is not set
> # CONFIG_JFFS2_CMODE_NONE is not set
> # CONFIG_JFFS2_CMODE_PRIORITY is not set
> CONFIG_JFFS2_CMODE_SIZE=y
> # CONFIG_JFFS2_CMODE_FAVOURLZO is not set
> # CONFIG_UBIFS_FS is not set
> # CONFIG_LOGFS is not set
> # CONFIG_CRAMFS is not set
> CONFIG_SQUASHFS=y
> # CONFIG_SQUASHFS_FILE_CACHE is not set
> CONFIG_SQUASHFS_FILE_DIRECT=y
> # CONFIG_SQUASHFS_DECOMP_SINGLE is not set
> # CONFIG_SQUASHFS_DECOMP_MULTI is not set
> CONFIG_SQUASHFS_DECOMP_MULTI_PERCPU=y
> CONFIG_SQUASHFS_XATTR=y
> # CONFIG_SQUASHFS_ZLIB is not set
> CONFIG_SQUASHFS_LZO=y
> CONFIG_SQUASHFS_XZ=y
> # CONFIG_SQUASHFS_4K_DEVBLK_SIZE is not set
> # CONFIG_SQUASHFS_EMBEDDED is not set
> CONFIG_SQUASHFS_FRAGMENT_CACHE_SIZE=3
> # CONFIG_VXFS_FS is not set
> CONFIG_MINIX_FS=y
> CONFIG_OMFS_FS=y
> # CONFIG_HPFS_FS is not set
> # CONFIG_QNX4FS_FS is not set
> CONFIG_QNX6FS_FS=y
> CONFIG_QNX6FS_DEBUG=y
> # CONFIG_ROMFS_FS is not set
> CONFIG_PSTORE=y
> # CONFIG_PSTORE_CONSOLE is not set
> CONFIG_PSTORE_RAM=y
> CONFIG_SYSV_FS=y
> CONFIG_UFS_FS=y
> CONFIG_UFS_FS_WRITE=y
> # CONFIG_UFS_DEBUG is not set
> CONFIG_F2FS_FS=y
> CONFIG_F2FS_STAT_FS=y
> # CONFIG_F2FS_FS_XATTR is not set
> CONFIG_F2FS_CHECK_FS=y
> # CONFIG_NETWORK_FILESYSTEMS is not set
> CONFIG_NLS=y
> CONFIG_NLS_DEFAULT="iso8859-1"
> CONFIG_NLS_CODEPAGE_437=y
> CONFIG_NLS_CODEPAGE_737=y
> CONFIG_NLS_CODEPAGE_775=y
> # CONFIG_NLS_CODEPAGE_850 is not set
> CONFIG_NLS_CODEPAGE_852=y
> # CONFIG_NLS_CODEPAGE_855 is not set
> CONFIG_NLS_CODEPAGE_857=y
> # CONFIG_NLS_CODEPAGE_860 is not set
> CONFIG_NLS_CODEPAGE_861=y
> CONFIG_NLS_CODEPAGE_862=y
> CONFIG_NLS_CODEPAGE_863=y
> CONFIG_NLS_CODEPAGE_864=y
> CONFIG_NLS_CODEPAGE_865=y
> # CONFIG_NLS_CODEPAGE_866 is not set
> # CONFIG_NLS_CODEPAGE_869 is not set
> CONFIG_NLS_CODEPAGE_936=y
> CONFIG_NLS_CODEPAGE_950=y
> CONFIG_NLS_CODEPAGE_932=y
> # CONFIG_NLS_CODEPAGE_949 is not set
> # CONFIG_NLS_CODEPAGE_874 is not set
> # CONFIG_NLS_ISO8859_8 is not set
> # CONFIG_NLS_CODEPAGE_1250 is not set
> CONFIG_NLS_CODEPAGE_1251=y
> CONFIG_NLS_ASCII=y
> # CONFIG_NLS_ISO8859_1 is not set
> # CONFIG_NLS_ISO8859_2 is not set
> CONFIG_NLS_ISO8859_3=y
> CONFIG_NLS_ISO8859_4=y
> CONFIG_NLS_ISO8859_5=y
> # CONFIG_NLS_ISO8859_6 is not set
> CONFIG_NLS_ISO8859_7=y
> CONFIG_NLS_ISO8859_9=y
> CONFIG_NLS_ISO8859_13=y
> CONFIG_NLS_ISO8859_14=y
> CONFIG_NLS_ISO8859_15=y
> # CONFIG_NLS_KOI8_R is not set
> CONFIG_NLS_KOI8_U=y
> CONFIG_NLS_MAC_ROMAN=y
> CONFIG_NLS_MAC_CELTIC=y
> CONFIG_NLS_MAC_CENTEURO=y
> CONFIG_NLS_MAC_CROATIAN=y
> CONFIG_NLS_MAC_CYRILLIC=y
> # CONFIG_NLS_MAC_GAELIC is not set
> # CONFIG_NLS_MAC_GREEK is not set
> # CONFIG_NLS_MAC_ICELAND is not set
> CONFIG_NLS_MAC_INUIT=y
> CONFIG_NLS_MAC_ROMANIAN=y
> # CONFIG_NLS_MAC_TURKISH is not set
> CONFIG_NLS_UTF8=y
> 
> #
> # Kernel hacking
> #
> CONFIG_TRACE_IRQFLAGS_SUPPORT=y
> 
> #
> # printk and dmesg options
> #
> CONFIG_PRINTK_TIME=y
> CONFIG_DEFAULT_MESSAGE_LOGLEVEL=4
> # CONFIG_BOOT_PRINTK_DELAY is not set
> # CONFIG_DYNAMIC_DEBUG is not set
> 
> #
> # Compile-time checks and compiler options
> #
> # CONFIG_DEBUG_INFO is not set
> # CONFIG_ENABLE_WARN_DEPRECATED is not set
> # CONFIG_ENABLE_MUST_CHECK is not set
> CONFIG_FRAME_WARN=1024
> # CONFIG_STRIP_ASM_SYMS is not set
> # CONFIG_READABLE_ASM is not set
> # CONFIG_UNUSED_SYMBOLS is not set
> CONFIG_DEBUG_FS=y
> # CONFIG_HEADERS_CHECK is not set
> CONFIG_DEBUG_SECTION_MISMATCH=y
> CONFIG_ARCH_WANT_FRAME_POINTERS=y
> CONFIG_FRAME_POINTER=y
> # CONFIG_DEBUG_FORCE_WEAK_PER_CPU is not set
> # CONFIG_MAGIC_SYSRQ is not set
> CONFIG_DEBUG_KERNEL=y
> 
> #
> # Memory Debugging
> #
> # CONFIG_DEBUG_PAGEALLOC is not set
> # CONFIG_DEBUG_OBJECTS is not set
> # CONFIG_SLUB_DEBUG_ON is not set
> CONFIG_SLUB_STATS=y
> CONFIG_HAVE_DEBUG_KMEMLEAK=y
> # CONFIG_DEBUG_KMEMLEAK is not set
> # CONFIG_DEBUG_STACK_USAGE is not set
> # CONFIG_DEBUG_VM is not set
> CONFIG_DEBUG_VIRTUAL=y
> # CONFIG_DEBUG_MEMORY_INIT is not set
> # CONFIG_DEBUG_HIGHMEM is not set
> CONFIG_HAVE_DEBUG_STACKOVERFLOW=y
> CONFIG_DEBUG_STACKOVERFLOW=y
> CONFIG_HAVE_ARCH_KMEMCHECK=y
> # CONFIG_KMEMCHECK is not set
> # CONFIG_DEBUG_SHIRQ is not set
> 
> #
> # Debug Lockups and Hangs
> #
> # CONFIG_LOCKUP_DETECTOR is not set
> # CONFIG_DETECT_HUNG_TASK is not set
> CONFIG_PANIC_ON_OOPS=y
> CONFIG_PANIC_ON_OOPS_VALUE=1
> CONFIG_PANIC_TIMEOUT=0
> CONFIG_SCHED_DEBUG=y
> CONFIG_SCHEDSTATS=y
> CONFIG_TIMER_STATS=y
> 
> #
> # Lock Debugging (spinlocks, mutexes, etc...)
> #
> CONFIG_DEBUG_RT_MUTEXES=y
> CONFIG_DEBUG_PI_LIST=y
> CONFIG_RT_MUTEX_TESTER=y
> CONFIG_DEBUG_SPINLOCK=y
> CONFIG_DEBUG_MUTEXES=y
> # CONFIG_DEBUG_WW_MUTEX_SLOWPATH is not set
> CONFIG_DEBUG_LOCK_ALLOC=y
> CONFIG_PROVE_LOCKING=y
> CONFIG_LOCKDEP=y
> # CONFIG_LOCK_STAT is not set
> # CONFIG_DEBUG_LOCKDEP is not set
> CONFIG_DEBUG_ATOMIC_SLEEP=y
> CONFIG_DEBUG_LOCKING_API_SELFTESTS=y
> # CONFIG_LOCK_TORTURE_TEST is not set
> CONFIG_TRACE_IRQFLAGS=y
> CONFIG_STACKTRACE=y
> # CONFIG_DEBUG_KOBJECT is not set
> CONFIG_DEBUG_BUGVERBOSE=y
> # CONFIG_DEBUG_LIST is not set
> CONFIG_DEBUG_SG=y
> CONFIG_DEBUG_NOTIFIERS=y
> # CONFIG_DEBUG_CREDENTIALS is not set
> 
> #
> # RCU Debugging
> #
> CONFIG_PROVE_RCU=y
> # CONFIG_PROVE_RCU_REPEATEDLY is not set
> CONFIG_SPARSE_RCU_POINTER=y
> # CONFIG_TORTURE_TEST is not set
> # CONFIG_RCU_TORTURE_TEST is not set
> CONFIG_RCU_CPU_STALL_TIMEOUT=21
> CONFIG_RCU_TRACE=y
> # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
> CONFIG_NOTIFIER_ERROR_INJECTION=y
> # CONFIG_PM_NOTIFIER_ERROR_INJECT is not set
> # CONFIG_FAULT_INJECTION is not set
> CONFIG_LATENCYTOP=y
> CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS=y
> # CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is not set
> CONFIG_USER_STACKTRACE_SUPPORT=y
> CONFIG_NOP_TRACER=y
> CONFIG_HAVE_FUNCTION_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
> CONFIG_HAVE_FUNCTION_GRAPH_FP_TEST=y
> CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
> CONFIG_HAVE_DYNAMIC_FTRACE=y
> CONFIG_HAVE_DYNAMIC_FTRACE_WITH_REGS=y
> CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
> CONFIG_HAVE_SYSCALL_TRACEPOINTS=y
> CONFIG_HAVE_C_RECORDMCOUNT=y
> CONFIG_TRACER_MAX_TRACE=y
> CONFIG_TRACE_CLOCK=y
> CONFIG_RING_BUFFER=y
> CONFIG_EVENT_TRACING=y
> CONFIG_CONTEXT_SWITCH_TRACER=y
> CONFIG_TRACING=y
> CONFIG_GENERIC_TRACER=y
> CONFIG_TRACING_SUPPORT=y
> CONFIG_FTRACE=y
> # CONFIG_FUNCTION_TRACER is not set
> # CONFIG_IRQSOFF_TRACER is not set
> CONFIG_SCHED_TRACER=y
> CONFIG_FTRACE_SYSCALLS=y
> CONFIG_TRACER_SNAPSHOT=y
> # CONFIG_TRACER_SNAPSHOT_PER_CPU_SWAP is not set
> CONFIG_BRANCH_PROFILE_NONE=y
> # CONFIG_PROFILE_ANNOTATED_BRANCHES is not set
> # CONFIG_PROFILE_ALL_BRANCHES is not set
> # CONFIG_STACK_TRACER is not set
> # CONFIG_BLK_DEV_IO_TRACE is not set
> CONFIG_UPROBE_EVENT=y
> CONFIG_PROBE_EVENTS=y
> # CONFIG_FTRACE_STARTUP_TEST is not set
> # CONFIG_MMIOTRACE is not set
> CONFIG_RING_BUFFER_BENCHMARK=y
> # CONFIG_RING_BUFFER_STARTUP_TEST is not set
> 
> #
> # Runtime Testing
> #
> CONFIG_LKDTM=y
> CONFIG_TEST_LIST_SORT=y
> # CONFIG_BACKTRACE_SELF_TEST is not set
> CONFIG_RBTREE_TEST=y
> CONFIG_ATOMIC64_SELFTEST=y
> # CONFIG_TEST_STRING_HELPERS is not set
> CONFIG_TEST_KSTRTOX=y
> # CONFIG_PROVIDE_OHCI1394_DMA_INIT is not set
> # CONFIG_DMA_API_DEBUG is not set
> # CONFIG_SAMPLES is not set
> CONFIG_HAVE_ARCH_KGDB=y
> # CONFIG_KGDB is not set
> # CONFIG_STRICT_DEVMEM is not set
> CONFIG_X86_VERBOSE_BOOTUP=y
> CONFIG_EARLY_PRINTK=y
> # CONFIG_EARLY_PRINTK_DBGP is not set
> CONFIG_X86_PTDUMP=y
> # CONFIG_DEBUG_RODATA is not set
> # CONFIG_DOUBLEFAULT is not set
> # CONFIG_DEBUG_TLBFLUSH is not set
> CONFIG_IOMMU_STRESS=y
> CONFIG_HAVE_MMIOTRACE_SUPPORT=y
> CONFIG_IO_DELAY_TYPE_0X80=0
> CONFIG_IO_DELAY_TYPE_0XED=1
> CONFIG_IO_DELAY_TYPE_UDELAY=2
> CONFIG_IO_DELAY_TYPE_NONE=3
> # CONFIG_IO_DELAY_0X80 is not set
> # CONFIG_IO_DELAY_0XED is not set
> # CONFIG_IO_DELAY_UDELAY is not set
> CONFIG_IO_DELAY_NONE=y
> CONFIG_DEFAULT_IO_DELAY_TYPE=3
> # CONFIG_DEBUG_BOOT_PARAMS is not set
> # CONFIG_CPA_DEBUG is not set
> # CONFIG_OPTIMIZE_INLINING is not set
> # CONFIG_DEBUG_NMI_SELFTEST is not set
> CONFIG_X86_DEBUG_STATIC_CPU_HAS=y
> 
> #
> # Security options
> #
> CONFIG_KEYS=y
> CONFIG_PERSISTENT_KEYRINGS=y
> CONFIG_BIG_KEYS=y
> CONFIG_TRUSTED_KEYS=y
> CONFIG_ENCRYPTED_KEYS=y
> # CONFIG_KEYS_DEBUG_PROC_KEYS is not set
> CONFIG_SECURITY_DMESG_RESTRICT=y
> CONFIG_SECURITY=y
> CONFIG_SECURITYFS=y
> CONFIG_SECURITY_NETWORK=y
> CONFIG_SECURITY_PATH=y
> # CONFIG_SECURITY_TOMOYO is not set
> CONFIG_SECURITY_APPARMOR=y
> CONFIG_SECURITY_APPARMOR_BOOTPARAM_VALUE=1
> CONFIG_SECURITY_APPARMOR_HASH=y
> # CONFIG_SECURITY_YAMA is not set
> CONFIG_INTEGRITY=y
> CONFIG_INTEGRITY_SIGNATURE=y
> # CONFIG_INTEGRITY_AUDIT is not set
> # CONFIG_INTEGRITY_ASYMMETRIC_KEYS is not set
> # CONFIG_IMA is not set
> CONFIG_EVM=y
> CONFIG_EVM_HMAC_VERSION=2
> # CONFIG_DEFAULT_SECURITY_APPARMOR is not set
> CONFIG_DEFAULT_SECURITY_DAC=y
> CONFIG_DEFAULT_SECURITY=""
> CONFIG_XOR_BLOCKS=y
> CONFIG_CRYPTO=y
> 
> #
> # Crypto core or helper
> #
> CONFIG_CRYPTO_ALGAPI=y
> CONFIG_CRYPTO_ALGAPI2=y
> CONFIG_CRYPTO_AEAD=y
> CONFIG_CRYPTO_AEAD2=y
> CONFIG_CRYPTO_BLKCIPHER=y
> CONFIG_CRYPTO_BLKCIPHER2=y
> CONFIG_CRYPTO_HASH=y
> CONFIG_CRYPTO_HASH2=y
> CONFIG_CRYPTO_RNG=y
> CONFIG_CRYPTO_RNG2=y
> CONFIG_CRYPTO_PCOMP=y
> CONFIG_CRYPTO_PCOMP2=y
> CONFIG_CRYPTO_MANAGER=y
> CONFIG_CRYPTO_MANAGER2=y
> CONFIG_CRYPTO_USER=y
> # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
> CONFIG_CRYPTO_GF128MUL=y
> CONFIG_CRYPTO_NULL=y
> CONFIG_CRYPTO_WORKQUEUE=y
> CONFIG_CRYPTO_CRYPTD=y
> CONFIG_CRYPTO_AUTHENC=y
> CONFIG_CRYPTO_ABLK_HELPER=y
> CONFIG_CRYPTO_GLUE_HELPER_X86=y
> 
> #
> # Authenticated Encryption with Associated Data
> #
> CONFIG_CRYPTO_CCM=y
> CONFIG_CRYPTO_GCM=y
> CONFIG_CRYPTO_SEQIV=y
> 
> #
> # Block modes
> #
> CONFIG_CRYPTO_CBC=y
> CONFIG_CRYPTO_CTR=y
> # CONFIG_CRYPTO_CTS is not set
> CONFIG_CRYPTO_ECB=y
> CONFIG_CRYPTO_LRW=y
> CONFIG_CRYPTO_PCBC=y
> CONFIG_CRYPTO_XTS=y
> 
> #
> # Hash modes
> #
> CONFIG_CRYPTO_CMAC=y
> CONFIG_CRYPTO_HMAC=y
> CONFIG_CRYPTO_XCBC=y
> CONFIG_CRYPTO_VMAC=y
> 
> #
> # Digest
> #
> CONFIG_CRYPTO_CRC32C=y
> CONFIG_CRYPTO_CRC32C_INTEL=y
> CONFIG_CRYPTO_CRC32=y
> # CONFIG_CRYPTO_CRC32_PCLMUL is not set
> CONFIG_CRYPTO_CRCT10DIF=y
> CONFIG_CRYPTO_GHASH=y
> CONFIG_CRYPTO_MD4=y
> CONFIG_CRYPTO_MD5=y
> CONFIG_CRYPTO_MICHAEL_MIC=y
> CONFIG_CRYPTO_RMD128=y
> # CONFIG_CRYPTO_RMD160 is not set
> CONFIG_CRYPTO_RMD256=y
> CONFIG_CRYPTO_RMD320=y
> CONFIG_CRYPTO_SHA1=y
> CONFIG_CRYPTO_SHA256=y
> CONFIG_CRYPTO_SHA512=y
> CONFIG_CRYPTO_TGR192=y
> CONFIG_CRYPTO_WP512=y
> 
> #
> # Ciphers
> #
> CONFIG_CRYPTO_AES=y
> # CONFIG_CRYPTO_AES_586 is not set
> # CONFIG_CRYPTO_AES_NI_INTEL is not set
> CONFIG_CRYPTO_ANUBIS=y
> CONFIG_CRYPTO_ARC4=y
> CONFIG_CRYPTO_BLOWFISH=y
> CONFIG_CRYPTO_BLOWFISH_COMMON=y
> CONFIG_CRYPTO_CAMELLIA=y
> CONFIG_CRYPTO_CAST_COMMON=y
> CONFIG_CRYPTO_CAST5=y
> # CONFIG_CRYPTO_CAST6 is not set
> CONFIG_CRYPTO_DES=y
> CONFIG_CRYPTO_FCRYPT=y
> # CONFIG_CRYPTO_KHAZAD is not set
> # CONFIG_CRYPTO_SALSA20 is not set
> # CONFIG_CRYPTO_SALSA20_586 is not set
> CONFIG_CRYPTO_SEED=y
> CONFIG_CRYPTO_SERPENT=y
> CONFIG_CRYPTO_SERPENT_SSE2_586=y
> # CONFIG_CRYPTO_TEA is not set
> CONFIG_CRYPTO_TWOFISH=y
> CONFIG_CRYPTO_TWOFISH_COMMON=y
> # CONFIG_CRYPTO_TWOFISH_586 is not set
> 
> #
> # Compression
> #
> # CONFIG_CRYPTO_DEFLATE is not set
> CONFIG_CRYPTO_ZLIB=y
> # CONFIG_CRYPTO_LZO is not set
> # CONFIG_CRYPTO_LZ4 is not set
> CONFIG_CRYPTO_LZ4HC=y
> 
> #
> # Random Number Generation
> #
> # CONFIG_CRYPTO_ANSI_CPRNG is not set
> CONFIG_CRYPTO_USER_API=y
> CONFIG_CRYPTO_USER_API_HASH=y
> CONFIG_CRYPTO_USER_API_SKCIPHER=y
> CONFIG_CRYPTO_HASH_INFO=y
> CONFIG_CRYPTO_HW=y
> # CONFIG_CRYPTO_DEV_PADLOCK is not set
> # CONFIG_CRYPTO_DEV_GEODE is not set
> # CONFIG_CRYPTO_DEV_HIFN_795X is not set
> # CONFIG_CRYPTO_DEV_CCP is not set
> CONFIG_ASYMMETRIC_KEY_TYPE=y
> CONFIG_ASYMMETRIC_PUBLIC_KEY_SUBTYPE=y
> CONFIG_PUBLIC_KEY_ALGO_RSA=y
> CONFIG_X509_CERTIFICATE_PARSER=y
> CONFIG_HAVE_KVM=y
> # CONFIG_VIRTUALIZATION is not set
> CONFIG_BINARY_PRINTF=y
> 
> #
> # Library routines
> #
> CONFIG_RAID6_PQ=y
> CONFIG_BITREVERSE=y
> CONFIG_GENERIC_STRNCPY_FROM_USER=y
> CONFIG_GENERIC_STRNLEN_USER=y
> CONFIG_GENERIC_NET_UTILS=y
> CONFIG_GENERIC_FIND_FIRST_BIT=y
> CONFIG_GENERIC_PCI_IOMAP=y
> CONFIG_GENERIC_IOMAP=y
> CONFIG_GENERIC_IO=y
> CONFIG_PERCPU_RWSEM=y
> CONFIG_CRC_CCITT=y
> CONFIG_CRC16=y
> CONFIG_CRC_T10DIF=y
> CONFIG_CRC_ITU_T=y
> CONFIG_CRC32=y
> # CONFIG_CRC32_SELFTEST is not set
> CONFIG_CRC32_SLICEBY8=y
> # CONFIG_CRC32_SLICEBY4 is not set
> # CONFIG_CRC32_SARWATE is not set
> # CONFIG_CRC32_BIT is not set
> CONFIG_CRC7=y
> CONFIG_LIBCRC32C=y
> # CONFIG_CRC8 is not set
> CONFIG_AUDIT_GENERIC=y
> # CONFIG_AUDIT_ARCH_COMPAT_GENERIC is not set
> CONFIG_RANDOM32_SELFTEST=y
> CONFIG_ZLIB_INFLATE=y
> CONFIG_ZLIB_DEFLATE=y
> CONFIG_LZO_COMPRESS=y
> CONFIG_LZO_DECOMPRESS=y
> CONFIG_LZ4HC_COMPRESS=y
> CONFIG_LZ4_DECOMPRESS=y
> CONFIG_XZ_DEC=y
> CONFIG_XZ_DEC_X86=y
> # CONFIG_XZ_DEC_POWERPC is not set
> # CONFIG_XZ_DEC_IA64 is not set
> # CONFIG_XZ_DEC_ARM is not set
> CONFIG_XZ_DEC_ARMTHUMB=y
> # CONFIG_XZ_DEC_SPARC is not set
> CONFIG_XZ_DEC_BCJ=y
> CONFIG_XZ_DEC_TEST=y
> CONFIG_DECOMPRESS_GZIP=y
> CONFIG_DECOMPRESS_BZIP2=y
> CONFIG_DECOMPRESS_LZMA=y
> CONFIG_DECOMPRESS_LZO=y
> CONFIG_DECOMPRESS_LZ4=y
> CONFIG_REED_SOLOMON=y
> CONFIG_REED_SOLOMON_ENC8=y
> CONFIG_REED_SOLOMON_DEC8=y
> CONFIG_REED_SOLOMON_DEC16=y
> CONFIG_BCH=y
> CONFIG_BCH_CONST_PARAMS=y
> CONFIG_ASSOCIATIVE_ARRAY=y
> CONFIG_HAS_IOMEM=y
> CONFIG_HAS_IOPORT_MAP=y
> CONFIG_HAS_DMA=y
> CONFIG_CHECK_SIGNATURE=y
> CONFIG_DQL=y
> CONFIG_NLATTR=y
> CONFIG_ARCH_HAS_ATOMIC64_DEC_IF_POSITIVE=y
> CONFIG_AVERAGE=y
> CONFIG_CLZ_TAB=y
> # CONFIG_CORDIC is not set
> CONFIG_DDR=y
> CONFIG_MPILIB=y
> CONFIG_SIGNATURE=y
> CONFIG_OID_REGISTRY=y
> 

> _______________________________________________
> LKP mailing list
> LKP@linux.intel.com
> 

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
