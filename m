Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751668AbaHaRuT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 13:50:19 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:45674 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaHaRuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 13:50:16 -0400
Date: Sun, 31 Aug 2014 10:50:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org, linux-cris-kernel@axis.com
Cc: Jesper Nilsson <jesper.nilsson@axis.com>,
        Mikael Starvik <starvik@axis.com>,
        Grant Likely <grant.likely@linaro.org>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>
Subject: Status of 'cris' architecture support in Linux kernel
Message-ID: <20140831175010.GA15408@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The idea was to create a crisv32 kernel and initramfs to work with qemu
for the ongoing Linux kernel test project.

After spending a number of days (and nights) on it, the results don't look
very encouraging.

My overall conclusion is that 'cris' architecture support in the Linux kernel
is in bad shape, does not work anymore, and would require substantial effort
to get it into working state.

Anyway, below are my individual findings. If there is an ongoing effort to
improve cris support in the upstream kernel, specifically support for crisv32,
please let me know. I'll be happy to test the resulting kernels.

Thanks,
Guenter

---------------------

Individual findings:

headers_install

make ARCH=cris INSTALL_HDR_PATH=/tmp headers_install

results in:

./scripts/Makefile.headersinst:14: arch/cris/include/uapi/asm/arch-v10/Kbuild:
	No such file or directory
make[2]: *** No rule to make target `arch/cris/include/uapi/asm/arch-v10/Kbuild'.  Stop.

-----------

Trying to enable architecture specific drivers:

Enabling ETRAX_I2C or ETRAX_STREAMCOPROC results in compile errors.
The errors date back as far as 2.6.27 and are thus not the result
of later API changes. I did not attempt to enable any other functionality.

-----------

qemu: Attempts to load images in qemu fail.

Command line:

qemu-system-cris -serial stdio -kernel vmlinux -monitor none \
	-nographic -append "console=ttyS0,115200,N,8 rdinit=/sbin/init" \
	-initrd busybox-cris.img

This command yields no output; using arch/cris/boot/Image has the same result.

With arch/cris/boot/zImage, the result is:

Uncompressing Linux...


invalid compressed format (err=1)

 -- System halted

---

Research shows that there is a working image and root file system at the
qemu web site. Further research shows that this image includes code which
was never merged upstream. The missing code includes (at least) early console
support as well as support for the crisv32 serial interface.

After some digging, I found at least some of the code in out-of-tree sources.
After adding early console support, there is console output, but the image
crashes with the following log message.

...
NET: Registered protocol family 16
Switched to clocksource crisv32_rotime
Unable to handle kernel NULL pointer dereferenceOops: 0000
CPU: 0
ERP: c001029e SRP: c00108ce  CCS: 00028008 USP: 00000000 MOF: 00000000
 r0: c0230660  r1: c1ff3e7c   r2: 00000014  r3: 00000001
 r4: c1ff3e88  r5: c1ffffff   r6: c0102b94  r7: 00000000
 r8: c1ff3e58  r9: c1ff3e80  r10: c1ff3e7c r11: c0230660
r12: 00000001 r13: 80000200 oR10: c1ff3e7c acr: 00000018
 sp: c1ff3dd4
       Data MMU Cause: 00000100
Instruction MMU Cause: 00000000
Process swapper (pid: 1, stackpage=c1ff1c40)

Stack from c1ff3cbc:
       c0004a44 c01e84e6 c1ff3e20 c1ff3e28 00000000 c1ffffff c1ff3cf8 c000589c 
       00000018 00000000 c1ff3dd4 00000000 00000000 00000000 c1ff3e88 c1ff3d04 
       c0004b6e c0293bb0 c1ff3dcc c0005220 00000000 c0230660 c1ff3e7c 00000014 
Call Trace: [<c0004a44>] [<c01e84e6>] [<c000589c>] [<c0004b6e>] [<c0005220>] [<c0102b94>] [<c00fb92c>] 
       [<c002922c>] [<c00fbd58>] [<c00fb858>] [<c00fbc02>] [<c002922c>] [<c0008896>] [<c0102b94>] [<c00108ce>] 
       [<c001029e>] [<c0010250>] [<c00be2d6>] [<c00203f4>] [<c00108ce>] [<c00ff4d8>] [<c00b81b4>] [<c00be3b0>] 
       [<c00ff4d8>] [<c0004236>] [<c00041bc>] [<c00205ae>] [<c00ff4d8>] [<c00203f4>] [<c01e6f22>] [<c01e6f36>] 
       [<c000547e>] 
Code: 04 29 0f 00 43 36 68 30 18 21 14 22 (62) 2a c0 22 32 30 b0 05 0c 21 6f fa 
Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

---[ end Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

Manual backtrace:

c0004a44	show_stack
c01e84e6	printk
c000589c	show_registers
c0004b6e	die_if_kernel
c0005220	get_mmu_context
c0102b94	strcmp
c00fb92c	idr_get_empty_slot
c002922c	__init_waitqueue_head
c00fbd58	ida_get_new_above
c00fb858	ida_pre_get
c00fbc02	ida_get_new_above
c002922c	__init_waitqueue_head
c0008896	d_mmu_refill
c0102b94	strcmp
c00108ce	walk_system_ram_range
c001029e	find_next_iomem_res
c0010250	find_next_iomem_res
c00be2d6	kclist_add_private
c00203f4	parse_args
c00108ce	walk_system_ram_range
c00ff4d8	strcpy
c00b81b4	proc_register
c00be3b0	kcore_update_ram
c00ff4d8	strcpy
c0004236	do_one_initcall
c00041bc	do_one_initcall
c00205ae	parse_args
c00ff4d8	strcpy
c00203f4	parse_args
c01e6f22	kernel_init
c01e6f36	kernel_init

----------------
I did not attempt to bisect the problem.

I got an earlier kernel, 2.6.27, to proceed further, though I did not attempt
to load initramfs (the kernel had a missing symbol when I tried to enable 
initramfs support).

I was able to find the serial driver for crisv32 in an out-of-kernel tree
and port it to 2.6.27 to the point where it loads. I did not attempt to do
this with the current upstream kernel, as it crashed before it gets to
the point of trying to load the driver.

The crisv32 serial driver (or at least the version I found) is far from
acceptable for upstream integration and would require major cleanup or even
rewrite effort if it was to be merged upstream. The version I found is from
a 2.6.26 kernel, while the kernel version at the qemu web site (binary only)
is 2.6.33, so the driver I worked with is not the latest version and may
have been improved later. However, the result was not published, or I was
unable to find it.

-----------------

Toolchain

Creating a toolchain from upstream sources required a number of patches.

Linux headers:
- Fix the basic headers_install problem mentioned above
- Export ptrace.h
- Some post-processing after installing the headers; specifically,
  create a couple of symlinks in the headers directory
  	usr/include/arch-v10/arch -> usr/include/arch [for crisv10]
  	usr/include/arch-v32/arch -> usr/include/arch [for crisv32]

gcc:
- binutils 2.24
- uclibc 0.9.33.2
- gcc 4.7.4
  Requires a backport from upstream gcc to compile.
  Later versions of gcc (4.8.3, 4.9.1) fail with internal compiler errors
  even after patching.

Toolchain was built successfully with buildroot (after adding cris support to
it) with above patches / changes.
