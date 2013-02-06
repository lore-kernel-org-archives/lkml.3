Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab3BFJXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 04:23:49 -0500
Received: from david.siemens.de ([192.35.17.14]:16300 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833Ab3BFJXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 04:23:45 -0500
Message-ID: <511220FC.3090200@siemens.com>
Date: Wed, 06 Feb 2013 10:23:08 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
CC: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@alien8.de>, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org
Subject: [PATCH v6 20/20] scripts/gdb: Add basic documentation
References: <cover.1359463075.git.jan.kiszka@siemens.com> <adb8ca13259fed849a5cabc66303d495edea03f3.1359463075.git.jan.kiszka@siemens.com>
In-Reply-To: <adb8ca13259fed849a5cabc66303d495edea03f3.1359463075.git.jan.kiszka@siemens.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Rob Landley <rob@landley.net>
CC: linux-doc@vger.kernel.org
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---

Just to close the request Boris had regarding help on the commands.

Changes in v6:
 - explain how to obtain help on commands and functions
 - minor wording fixes

 Documentation/gdb-kernel-debugging.txt |  158 ++++++++++++++++++++++++++++++++
 1 files changed, 158 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/gdb-kernel-debugging.txt

diff --git a/Documentation/gdb-kernel-debugging.txt b/Documentation/gdb-kernel-debugging.txt
new file mode 100644
index 0000000..1b5b3da
--- /dev/null
+++ b/Documentation/gdb-kernel-debugging.txt
@@ -0,0 +1,158 @@
+Debugging kernel and modules via gdb
+====================================
+
+The kernel debugger kgdb, hypervisors like QEMU or JTAG-based hardware
+interfaces allow to debug the Linux kernel and its modules during runtime
+using gdb. Gdb comes with a powerful scripting interface for python. The
+kernel provides a collection of helper scripts that can simplify typical
+kernel debugging steps. This is a short tutorial about how to enable and use
+them. It focuses on QEMU/KVM virtual machines as target, but the examples can
+be transferred to the other gdb stubs as well.
+
+
+Requirements
+------------
+
+ o gdb 7.1+ (recommended: 7.3+) with python support enabled (typically true
+   for distributions)
+
+
+Setup
+-----
+
+ o Create a virtual Linux machine for QEMU/KVM (see www.linux-kvm.org and
+   www.qemu.org for more details)
+
+ o Build the kernel with CONFIG_DEBUG_INFO enabled, but leave
+   CONFIG_DEBUG_INFO_REDUCED off
+
+ o Install that kernel on the guest.
+
+   Alternatively, QEMU allows to boot the kernel directly using -kernel,
+   -append, -initrd command line switches. This is generally only useful if
+   you do not depend on modules. See QEMU documentation for more details on
+   this mode.
+
+ o Enable the gdb stub of QEMU/KVM, either
+    - at VM startup time by appending "-s" to the QEMU command line
+   or
+    - during runtime by issuing "gdbserver" from the QEMU monitor
+      console
+
+ o cd /path/to/linux-build
+
+ o Start gdb: gdb vmlinux
+
+   Note: Some distros may restrict auto-loading of gdb scripts to known safe
+   directories. In case gdb reports to refuse loading vmlinux-gdb.py, add
+
+    add-add-auto-load-safe-path /path/to/linux-build
+
+   to ~/.gdbinit. See gdb help for more details.
+
+ o Attach to the booted guest:
+    (gdb) target remote :1234
+
+
+Examples of using the Linux-provided gdb helpers
+------------------------------------------------
+
+ o Load module (and main kernel) symbols:
+    (gdb) lx-symbols
+    loading vmlinux
+    scanning for modules in /home/user/linux/build
+    loading @0xffffffffa0020000: /home/user/linux/build/net/netfilter/xt_tcpudp.ko
+    loading @0xffffffffa0016000: /home/user/linux/build/net/netfilter/xt_pkttype.ko
+    loading @0xffffffffa0002000: /home/user/linux/build/net/netfilter/xt_limit.ko
+    loading @0xffffffffa00ca000: /home/user/linux/build/net/packet/af_packet.ko
+    loading @0xffffffffa003c000: /home/user/linux/build/fs/fuse/fuse.ko
+    ...
+    loading @0xffffffffa0000000: /home/user/linux/build/drivers/ata/ata_generic.ko
+
+ o Set a breakpoint on some not yet loaded module function, e.g.:
+    (gdb) b btrfs_init_sysfs
+    Function "btrfs_init_sysfs" not defined.
+    Make breakpoint pending on future shared library load? (y or [n]) y
+    Breakpoint 1 (btrfs_init_sysfs) pending.
+
+ o Continue the target
+    (gdb) c
+
+ o Load the module on the target and watch the symbols being loaded as well as
+   the breakpoint hit:
+    loading @0xffffffffa0034000: /home/user/linux/build/lib/libcrc32c.ko
+    loading @0xffffffffa0050000: /home/user/linux/build/lib/lzo/lzo_compress.ko
+    loading @0xffffffffa006e000: /home/user/linux/build/lib/zlib_deflate/zlib_deflate.ko
+    loading @0xffffffffa01b1000: /home/user/linux/build/fs/btrfs/btrfs.ko
+
+    Breakpoint 1, btrfs_init_sysfs () at /home/user/linux/fs/btrfs/sysfs.c:36
+    36              btrfs_kset = kset_create_and_add("btrfs", NULL, fs_kobj);
+
+ o Dump the log buffer of the target kernel:
+    (gdb) lx-dmesg
+    [     0.000000] Initializing cgroup subsys cpuset
+    [     0.000000] Initializing cgroup subsys cpu
+    [     0.000000] Linux version 3.8.0-rc4-dbg+ (...
+    [     0.000000] Command line: root=/dev/sda2 resume=/dev/sda1 vga=0x314
+    [     0.000000] e820: BIOS-provided physical RAM map:
+    [     0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009fbff] usable
+    [     0.000000] BIOS-e820: [mem 0x000000000009fc00-0x000000000009ffff] reserved
+    ....
+
+ o Examine fields of the current task struct:
+    (gdb) p $lx_current().pid
+    $1 = 4998
+    (gdb) p $lx_current().comm
+    $2 = "modprobe\000\000\000\000\000\000\000"
+
+ o Make use of the per-cpu function for the current or a specified CPU:
+    (gdb) p $lx_per_cpu("runqueues").nr_running
+    $3 = 1
+    (gdb) p $lx_per_cpu("runqueues", 2).nr_running
+    $4 = 0
+
+ o Dig into hrtimers using the container_of helper:
+    (gdb) set $next = $lx_per_cpu("hrtimer_bases").clock_base[0].active.next
+    (gdb) p *$container_of($next, "struct hrtimer", "node")
+    $5 = {
+      node = {
+        node = {
+          __rb_parent_color = 18446612133355256072,
+          rb_right = 0x0 <irq_stack_union>,
+          rb_left = 0x0 <irq_stack_union>
+        },
+        expires = {
+          tv64 = 1835268000000
+        }
+      },
+      _softexpires = {
+        tv64 = 1835268000000
+      },
+      function = 0xffffffff81078232 <tick_sched_timer>,
+      base = 0xffff88003fd0d6f0,
+      state = 1,
+      start_pid = 0,
+      start_site = 0xffffffff81055c1f <hrtimer_start_range_ns+20>,
+      start_comm = "swapper/2\000\000\000\000\000\000"
+    }
+
+
+List of commands and functions
+------------------------------
+
+The number of commands and convenience functions may evolve over the time,
+this is just a snapshot of the initial version:
+
+ (gdb) apropos lx
+ function lx_current -- Return current task
+ function lx_module -- Find module by name and return the module variable
+ function lx_modvar -- Return global variable of a module
+ function lx_per_cpu -- Return per-cpu variable
+ function lx_task_by_pid -- Find Linux task by PID and return the task_struct variable
+ function lx_thread_info -- Calculate Linux thread_info from task variable
+ lx-dmesg -- Print Linux kernel log buffer
+ lx-lsmod -- List currently loaded modules
+ lx-symbols -- (Re-)load symbols of Linux kernel and currently loaded modules
+
+Detailed help can be obtained via "help <command-name>" for commands and "help
+function <function-name>" for convenience functions.
-- 
1.7.3.4
