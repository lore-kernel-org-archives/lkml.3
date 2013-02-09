Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537Ab3BIUBW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 15:01:22 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35471 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499Ab3BIUBU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 15:01:20 -0500
Date: Sat, 09 Feb 2013 10:15:44 -0600
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH v5 20/20] scripts/gdb: Add basic documentation
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@alien8.de>, linux-doc@vger.kernel.org
In-Reply-To: <adb8ca13259fed849a5cabc66303d495edea03f3.1359463075.git.jan.kiszka@siemens.com>
	(from jan.kiszka@siemens.com on Tue Jan 29 06:38:03 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1360426544.12062.26@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29/2013 06:38:03 AM, Jan Kiszka wrote:
> CC: Rob Landley <rob@landley.net>
> CC: linux-doc@vger.kernel.org
> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
> ---
>  Documentation/gdb-kernel-debugging.txt |  155  
> ++++++++++++++++++++++++++++++++
>  1 files changed, 155 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/gdb-kernel-debugging.txt
> 
> diff --git a/Documentation/gdb-kernel-debugging.txt  
> b/Documentation/gdb-kernel-debugging.txt
> new file mode 100644
> index 0000000..0ea46e1
> --- /dev/null
> +++ b/Documentation/gdb-kernel-debugging.txt
> @@ -0,0 +1,155 @@
> +Debugging kernel and modules via gdb
> +====================================
> +
> +The kernel debugger kgdb, hypervisors like QEMU or JTAG-based  
> hardware
> +interfaces allow to debug the Linux kernel and its modules during  
> runtime
> +using gdb.

This could use some clarification.

Technically they're attaching gdb to the hardware using the gdbserver  
protocol, instead of attaching to a specific process like the gdbserver  
client program does. (I think of it as "pid 0": your register state  
isn't a "register profile" but the actual contents of the hardware  
registers, and your memory map is physical.)

Two of these three methods (jtag and emulator) are independent of  
linux, and the fact the hardware you're attached to may or may not be  
running linux (or u-boot, or a bare metal hello world) is irrelevant.  
Only kgdb requires linux to be running to produce/consume gdbserver  
procol with information about current hardware state.

When Linux _is_ running, if you want symbol data you can point gdb at  
an unstripped vmlinux. (Which is an ELF image, the build usually feeds  
that through objdump and glues a wrapper on the front to make it  
bootable on bare metal, but this is the one with symbols still in it.)  
But even with symbols, trying to dig through Linux's various  
abstractions and data structures to find anything belonging to an  
actual process from outside the kernel is a flaming pain, so you've  
made some gdb plugins to help out there. Cool.

> Gdb comes with a powerful scripting interface for python. The
> +kernel provides a collection of helper scripts that can simplify  
> typical
> +kernel debugging steps. This is a short tutorial about how to enable  
> and use
> +them. It focuses on QEMU/KVM virtual machines as target, but the  
> examples can
> +be transferred to the other gdb stubs as well.
> +
> +
> +Requirements
> +------------
> +
> + o gdb 7.1+ (recommended: 7.3+) with python support enabled  
> (typically true
> +   for distributions)
> +
> +
> +Setup
> +-----
> +
> + o Create a virtual Linux machine for QEMU/KVM (see  
> www.linux-kvm.org and
> +   www.qemu.org for more details)

If it helps, I've got a dozen different targets as  
"system-image-*.tar.bz2" at
http://landley.net/aboriginal/bin and the "run-emulator.sh" script  
inside each one gives the qemu command line to boot it to a shell  
prompt. At that shell prompt you can grab the relevant kernel config  
with "zcat /proc/config.gz" to build your own kernel, and the  
toolchains I did so with are in the same directory. (The README in  
there describes other categories of file in the directory.)

That at least gives you a "known working" version to compare your own  
attempts against.

> + o Build the kernel with CONFIG_DEBUG_INFO enabled, but leave
> +   CONFIG_DEBUG_INFO_REDUCED off
> +
> + o Install that kernel on the guest.
> +
> +   Alternatively, QEMU allows to boot the kernel directly using  
> -kernel,
> +   -append, -initrd command line switches. This is generally only  
> useful if
> +   you do not depend on modules. See QEMU documentation for more  
> details on
> +   this mode.

It's qemu's built-in bootloader, no different than any other  
bootloader. If your hardware needs a module to access the block device  
you want to keep the rest of your modules on, A) you're making a  
peverse architectural decision, B) stick it in the initramfs.

(I could do up an example of that sort of setup if you like. The images  
I linked to above keep a squashfs on a virtual hard drive, I could do  
an initramfs that loads the IDE module and then switch_root to it. I  
just haven't bothered because the easy way works.)

> + o Enable the gdb stub of QEMU/KVM, either
> +    - at VM startup time by appending "-s" to the QEMU command line
> +   or
> +    - during runtime by issuing "gdbserver" from the QEMU monitor
> +      console

Initiallly I thought this document would be more about kgdb, but this  
is about how to use a direct hardware attached debugger (or kgdb  
emulating one). Hence the clarification up top.

> + o cd /path/to/linux-build
> +
> + o Start gdb: gdb vmlinux
> +
> +   Note: Some distros may restrict auto-loading of gdb scripts to  
> known safe
> +   directories. In case gdb reports to refuse loading  
> vmlinux-gdb.py, add
> +
> +    add-add-auto-load-safe-path /path/to/linux-build
> +
> +   to ~/.gdbinit. See gdb help for more details.
> +
> + o Attach to the booted guest:
> +    (gdb) target remote :1234

I've found the "target remote |" option useful, where you pipe the I/O  
to another command that forwards data to the target board.

(I once had to debug a program on a board that only had a serial  
console, and that was always on and attached to another machine. So I  
piped to ssh which ran a term program which launched netcat on the  
board to connect the remote end because the FSF didn't bother to make a  
stdio option for gdbserver so you _have_ to use loopback. Although that  
was a few versions back, maybe they fixed this...)

*shrug* Possibly off topic...

The rest is about what the plugins do, looks fine to me. :)

Rob

> +
> +Examples of using the Linux-provided gdb helpers
> +------------------------------------------------
> +
> + o Load module (and main kernel) symbols:
> +    (gdb) lx-symbols
> +    loading vmlinux
> +    scanning for modules in /home/user/linux/build
> +    loading @0xffffffffa0020000:  
> /home/user/linux/build/net/netfilter/xt_tcpudp.ko
> +    loading @0xffffffffa0016000:  
> /home/user/linux/build/net/netfilter/xt_pkttype.ko
> +    loading @0xffffffffa0002000:  
> /home/user/linux/build/net/netfilter/xt_limit.ko
> +    loading @0xffffffffa00ca000:  
> /home/user/linux/build/net/packet/af_packet.ko
> +    loading @0xffffffffa003c000:  
> /home/user/linux/build/fs/fuse/fuse.ko
> +    ...
> +    loading @0xffffffffa0000000:  
> /home/user/linux/build/drivers/ata/ata_generic.ko
> +
> + o Set a breakpoint on some not yet loaded module function, e.g.:
> +    (gdb) b btrfs_init_sysfs
> +    Function "btrfs_init_sysfs" not defined.
> +    Make breakpoint pending on future shared library load? (y or  
> [n]) y
> +    Breakpoint 1 (btrfs_init_sysfs) pending.
> +
> + o Continue the target
> +    (gdb) c
> +
> + o Load the module on the target and watch the symbols being loaded  
> as well as
> +   the breakpoint hit:
> +    loading @0xffffffffa0034000:  
> /home/user/linux/build/lib/libcrc32c.ko
> +    loading @0xffffffffa0050000:  
> /home/user/linux/build/lib/lzo/lzo_compress.ko
> +    loading @0xffffffffa006e000:  
> /home/user/linux/build/lib/zlib_deflate/zlib_deflate.ko
> +    loading @0xffffffffa01b1000:  
> /home/user/linux/build/fs/btrfs/btrfs.ko
> +
> +    Breakpoint 1, btrfs_init_sysfs () at  
> /home/user/linux/fs/btrfs/sysfs.c:36
> +    36              btrfs_kset = kset_create_and_add("btrfs", NULL,  
> fs_kobj);
> +
> + o Dump the log buffer of the target kernel:
> +    (gdb) lx-dmesg
> +    [     0.000000] Initializing cgroup subsys cpuset
> +    [     0.000000] Initializing cgroup subsys cpu
> +    [     0.000000] Linux version 3.8.0-rc4-dbg+ (...
> +    [     0.000000] Command line: root=/dev/sda2 resume=/dev/sda1  
> vga=0x314
> +    [     0.000000] e820: BIOS-provided physical RAM map:
> +    [     0.000000] BIOS-e820: [mem  
> 0x0000000000000000-0x000000000009fbff] usable
> +    [     0.000000] BIOS-e820: [mem  
> 0x000000000009fc00-0x000000000009ffff] reserved
> +    ....
> +
> + o Examine fields of the current task struct:
> +    (gdb) p $lx_current().pid
> +    $1 = 4998
> +    (gdb) p $lx_current().comm
> +    $2 = "modprobe\000\000\000\000\000\000\000"
> +
> + o Make use of the per-cpu helper for the current or a specified CPU:
> +    (gdb) p $lx_per_cpu("runqueues").nr_running
> +    $3 = 1
> +    (gdb) p $lx_per_cpu("runqueues", 2).nr_running
> +    $4 = 0
> +
> + o Dig into hrtimers using the container_of helper:
> +    (gdb) set $next =  
> $lx_per_cpu("hrtimer_bases").clock_base[0].active.next
> +    (gdb) p *$container_of($next, "struct hrtimer", "node")
> +    $5 = {
> +      node = {
> +        node = {
> +          __rb_parent_color = 18446612133355256072,
> +          rb_right = 0x0 <irq_stack_union>,
> +          rb_left = 0x0 <irq_stack_union>
> +        },
> +        expires = {
> +          tv64 = 1835268000000
> +        }
> +      },
> +      _softexpires = {
> +        tv64 = 1835268000000
> +      },
> +      function = 0xffffffff81078232 <tick_sched_timer>,
> +      base = 0xffff88003fd0d6f0,
> +      state = 1,
> +      start_pid = 0,
> +      start_site = 0xffffffff81055c1f <hrtimer_start_range_ns+20>,
> +      start_comm = "swapper/2\000\000\000\000\000\000"
> +    }
> +
> +
> +List of commands and helper
> +---------------------------
> +
> +The number of commands and convenience helpers may evolve over the  
> time, this
> +is just a snapshot of the initial version:
> +
> + (gdb) apropos lx
> + function lx_current -- Return current task
> + function lx_module -- Find module by name and return the module  
> variable
> + function lx_modvar -- Return global variable of a module
> + function lx_per_cpu -- Return per-cpu variable
> + function lx_task_by_pid -- Find Linux task by PID and return the  
> task_struct variable
> + function lx_thread_info -- Calculate Linux thread_info from task  
> variable
> + lx-dmesg -- Print Linux kernel log buffer
> + lx-lsmod -- List currently loaded modules
> + lx-symbols -- (Re-)load symbols of Linux kernel and currently  
> loaded modules
> --
> 1.7.3.4
> 
> 
> 


