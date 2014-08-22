Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241AbaHVMiZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 08:38:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920AbaHVMiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 08:38:24 -0400
Date: Fri, 22 Aug 2014 18:06:51 +0530
From: Amit Shah <amit.shah@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 1/2] rcu: Parallelize and economize NOCB
 kthread wakeups
Message-ID: <20140822123651.GH16198@grmbl.mre>
References: <20140812160621.GC4752@linux.vnet.ibm.com>
 <20140812213936.GA3106@linux.vnet.ibm.com>
 <20140812214151.GB3106@linux.vnet.ibm.com>
 <20140813054439.GA29913@grmbl.mre>
 <20140813130049.GS4752@linux.vnet.ibm.com>
 <20140815052411.GF1934@grmbl.mre>
 <20140815150402.GD4752@linux.vnet.ibm.com>
 <20140818175345.GD31856@grmbl.mre>
 <20140819040149.GJ4752@linux.vnet.ibm.com>
 <20140822122453.GG16198@grmbl.mre>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822122453.GG16198@grmbl.mre>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Fri) 22 Aug 2014 [17:54:53], Amit Shah wrote:
> On (Mon) 18 Aug 2014 [21:01:49], Paul E. McKenney wrote:
> 
> > The odds are low over the next few days.  I am adding nastier rcutorture
> > testing, however.  It would still be very good to get debug information
> > from your setup.  One approach would be to convert the trace function
> > calls into printk(), if that would help.
> 
> I added a few printks on the lines of the traces in cases where
> rcu_nocb_poll was checked -- since that reproduces the hang.  Are the
> following traces sufficient, or should I keep adding more printks?
> 
> In the case of rcu-trace-nopoll.txt, the messages stop after a while
> (when the guest locks up hard).  That's when I kill the qemu process.

And this is bt from gdb when the endless 

  RCUDEBUG __call_rcu_nocb_enqueue 2146 rcu_preempt 0 WakeNot

messages are being spewed.

I can't time it, but hope it gives some indication along with the printks.

Program received signal SIGINT, Interrupt.
io_serial_out (p=0xffffffff82940780 <serial8250_ports>, offset=<optimized out>, value=<optimized out>) at drivers/tty/serial/8250/8250_core.c:439
439	      }
(gdb) bt
#0  io_serial_out (p=0xffffffff82940780 <serial8250_ports>, offset=<optimized out>, value=<optimized out>) at drivers/tty/serial/8250/8250_core.c:439
#1  0xffffffff812b260a in serial_port_out (up=<optimized out>, offset=<optimized out>, value=<optimized out>) at include/linux/serial_core.h:214
#2  0xffffffff812b4781 in serial8250_console_putchar (port=0xffffffff82940780 <serial8250_ports>, ch=111) at drivers/tty/serial/8250/8250_core.c:2990
#3  0xffffffff812af07d in uart_console_write (port=0xffffffff82940780 <serial8250_ports>, 
    s=0xffffffff828dd96a <text+58> "t\n8fff]\nes: 4KB 0, 2MB 0, 4MB 0, 1GB 0\n6K bss, 33036K reserved)\n2 17:46:45 IST 2014\n", count=60, 
    putchar=0xffffffff812b4758 <serial8250_console_putchar>) at drivers/tty/serial/serial_core.c:1747
#4  0xffffffff812b470c in serial8250_console_write (co=<optimized out>, s=<optimized out>, count=60) at drivers/tty/serial/8250/8250_core.c:3025
#5  0xffffffff8107f517 in call_console_drivers (level=<optimized out>, len=60, text=<optimized out>) at kernel/printk/printk.c:1421
#6  0xffffffff81080498 in console_unlock () at kernel/printk/printk.c:2244
#7  0xffffffff81080b39 in vprintk_emit (facility=<optimized out>, level=<optimized out>, dict=<optimized out>, dictlen=<optimized out>, 
    fmt=<optimized out>, args=<optimized out>) at kernel/printk/printk.c:1786
#8  0xffffffff813e5235 in printk (fmt=<optimized out>) at kernel/printk/printk.c:1851
#9  0xffffffff8108e46b in __call_rcu_nocb_enqueue (rdp=0xffff88000fbcce00, rhp=<optimized out>, rhtp=<optimized out>, rhcount=<optimized out>, 
    rhcount_lazy=<optimized out>, flags=<optimized out>) at kernel/rcu/tree_plugin.h:2144
#10 0xffffffff81091140 in __call_rcu_nocb (flags=<optimized out>, lazy=<optimized out>, rhp=<optimized out>, rdp=<optimized out>)
    at kernel/rcu/tree_plugin.h:2166
#11 __call_rcu (head=0xffff88000e6c5390, func=0xffffffff81131346 <free_object_rcu>, rsp=0xffffffff818389c0 <rcu_preempt_state>, cpu=<optimized out>, 
    lazy=<optimized out>) at kernel/rcu/tree.c:2687
#12 0xffffffff81091673 in call_rcu (head=<optimized out>, func=<optimized out>) at kernel/rcu/tree_plugin.h:678
#13 0xffffffff81131756 in put_object (object=0xffff88000e6c5308) at mm/kmemleak.c:471
#14 0xffffffff81131b8c in delete_object_full (ptr=<optimized out>) at mm/kmemleak.c:641
#15 0xffffffff813e1782 in kmemleak_free (ptr=<optimized out>) at mm/kmemleak.c:944
#16 0xffffffff81128782 in kmemleak_free_recursive (flags=<optimized out>, ptr=<optimized out>) at include/linux/kmemleak.h:50
#17 slab_free_hook (s=0xffffffff82940780 <serial8250_ports>, x=0xffff88000e991c68) at mm/slub.c:1265
#18 0xffffffff8112a725 in slab_free (addr=<optimized out>, x=<optimized out>, page=<optimized out>, s=<optimized out>) at mm/slub.c:2644
#19 kmem_cache_free (s=<optimized out>, x=0xffff88000e991c68) at mm/slub.c:2681
#20 0xffffffff8121d84c in ida_get_new_above (ida=0xffffffff82940780 <serial8250_ports>, starting_id=<optimized out>, p_id=<optimized out>) at lib/idr.c:999
#21 0xffffffff8121dbe6 in ida_simple_get (ida=0xffffffff82940780 <serial8250_ports>, start=1016, end=<optimized out>, gfp_mask=0) at lib/idr.c:1101
#22 0xffffffff81188f19 in __kernfs_new_node (root=<optimized out>, name=0x0 <irq_stack_union>, mode=33060, flags=514) at fs/kernfs/dir.c:530
#23 0xffffffff81189e22 in kernfs_new_node (parent=0xffff88000e651000, name=<optimized out>, mode=33060, flags=<optimized out>) at fs/kernfs/dir.c:558
#24 0xffffffff8118b3a3 in __kernfs_create_file (parent=<optimized out>, name=<optimized out>, mode=<optimized out>, size=4096, 
    ops=0xffffffff81424a80 <sysfs_file_kfops_rw>, priv=<optimized out>, ns=0x0 <irq_stack_union>, name_is_static=true, key=0xffffffff81bc3a20 <__key.17290>)
    at fs/kernfs/file.c:920
#25 0xffffffff8118bb6e in sysfs_add_file_mode_ns (parent=0xffff88000e651000, attr=0xffff88000e621358, is_bin=<optimized out>, mode=<optimized out>, 
    ns=<optimized out>) at fs/sysfs/file.c:256
#26 0xffffffff8118c4c0 in create_files (update=<optimized out>, grp=<optimized out>, kobj=<optimized out>, parent=<optimized out>) at fs/sysfs/group.c:58
#27 internal_create_group (kobj=0xffff88000e67a1a8, update=<optimized out>, grp=0xffff88000e621298) at fs/sysfs/group.c:116
#28 0xffffffff8118c562 in sysfs_create_group (kobj=<optimized out>, grp=<optimized out>) at fs/sysfs/group.c:138
#29 0xffffffff81aa09e9 in kernel_add_sysfs_param (name_skip=<optimized out>, kparam=<optimized out>, name=<optimized out>) at kernel/params.c:783
#30 param_sysfs_builtin () at kernel/params.c:820
#31 param_sysfs_init () at kernel/params.c:940
#32 0xffffffff810003f4 in do_one_initcall (fn=0xffffffff81aa0886 <param_sysfs_init>) at init/main.c:791
#33 0xffffffff81a8d08a in do_initcall_level (level=<optimized out>) at init/main.c:857
#34 do_initcalls () at init/main.c:865
#35 do_basic_setup () at init/main.c:884
#36 kernel_init_freeable () at init/main.c:1005
#37 0xffffffff813e084d in kernel_init (unused=<optimized out>) at init/main.c:935
#38 <signal handler called>
#39 0x0000000000000000 in irq_stack_union ()
#40 0x0000000000000000 in ?? ()



		Amit
