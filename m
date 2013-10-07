Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab3JGJ1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 05:27:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:57544 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab3JGJ1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 05:27:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1048,1371106800"; 
   d="scan'208";a="406465467"
Date: Mon, 7 Oct 2013 17:27:44 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com
Subject: Re: [x86] BUG: unable to handle kernel paging request at 00740060
Message-ID: <20131007092744.GA28686@localhost>
References: <20131005234430.GA22485@localhost>
 <20131007085533.GZ3081@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131007085533.GZ3081@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 07, 2013 at 10:55:33AM +0200, Peter Zijlstra wrote:
> On Sun, Oct 06, 2013 at 07:44:30AM +0800, Fengguang Wu wrote:
> > Greetings,
> > 
> > I got the below dmesg and the first bad commit is
> > 
> > commit 0c44c2d0f459cd7e275242b72f500137c4fa834d
> > Author: Peter Zijlstra <peterz@infradead.org>
> > Date:   Wed Sep 11 15:19:24 2013 +0200
> > 
> >     x86: Use asm goto to implement better modify_and_test() functions
> >     
> >     Linus suggested using asm goto to get rid of the typical SETcc + TEST
> >     instruction pair -- which also clobbers an extra register -- for our
> >     typical modify_and_test() functions.
> >     
> >     Because asm goto doesn't allow output fields it has to include an
> >     unconditinal memory clobber when it changes a memory variable to force
> >     a reload.
> >     
> >     Luckily all atomic ops already imply a compiler barrier to go along
> >     with their memory barrier semantics.
> >     
> >     Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> >     Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> >     Link: http://lkml.kernel.org/n/tip-0mtn9siwbeo1d33bap1422se@git.kernel.org
> >     Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> 
> Well that blows,.. Anybody got any clue as to where to start looking?
> I've not actually seen anything like this on my own machines.

Perhaps it's related to one of

- the randconfig
- kvm
- gcc

In the end of dmesg file, there is the qemu command line to run the kernel:

qemu-system-x86_64 -cpu kvm64 -enable-kvm -kernel
/kernel/i386-randconfig-j1-10052106/a0cf1abc25ac197dd97b857c0f6341066a8cb1cf/vmlinuz-3.12.0-rc2-next-20130927-03100-ga0cf1ab -append 'hung_task_panic=1
rcutree.rcu_cpu_stall_timeout=100 log_buf_len=8M ignore_loglevel debug sched_debug apic=debug dynamic_printk sysrq_always_enabled panic=10
prompt_ramdisk=0 console=ttyS0,115200 console=tty0 vga=normal  root=/dev/ram0 rw
link=/kernel-tests/run-queue/kvm/i386-randconfig-j1-10052106/next:master/.vmlinuz-a0cf1abc25ac197dd97b857c0f6341066a8cb1cf-20131005211923-7-athens
branch=next/master
BOOT_IMAGE=/kernel/i386-randconfig-j1-10052106/a0cf1abc25ac197dd97b857c0f6341066a8cb1cf/vmlinuz-3.12.0-rc2-next-20130927-03100-ga0cf1ab'  -initrd
/kernel-tests/initrd/quantal-core-i386.cgz -m 256M -smp 2 -net nic,vlan=0,macaddr=00:00:00:00:00:00,model=virtio -net user,vlan=0,hostfwd=tcp::10661-:22
-net nic,vlan=1,model=e1000 -net user,vlan=1 -boot order=nc -no-reboot -watchdog i6300esb -drive
file=/fs/LABEL=KVM/disk0-quantal-athens-6,media=disk,if=virtio -drive file=/fs/LABEL=KVM/disk1-quantal-athens-6,media=disk,if=virtio -drive
file=/fs/LABEL=KVM/disk2-quantal-athens-6,media=disk,if=virtio -drive file=/fs/LABEL=KVM/disk3-quantal-athens-6,media=disk,if=virtio -drive
file=/fs/LABEL=KVM/disk4-quantal-athens-6,media=disk,if=virtio -drive file=/fs/LABEL=KVM/disk5-quantal-athens-6,media=disk,if=virtio -pidfile
/dev/shm/kboot/pid-quantal-athens-6 -serial file:/dev/shm/kboot/serial-quantal-athens-6 -daemonize -display none -monitor null    

> Wu, do you use the same compiler version for all the builds that crash
> like this (I'm assuming the other email was this same commit)? Does a
> different compiler make things work again?

Good point. I'll try a different compiler.

Thanks,
Fengguang
