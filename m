Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaCBJV6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 04:21:58 -0500
Received: from www84.your-server.de ([213.133.104.84]:48027 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbaCBJUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 04:20:53 -0500
From: Stefani Seibold <stefani@seibold.net>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        ak@linux.intel.com, aarcange@redhat.com, john.stultz@linaro.org,
        luto@amacapital.net, xemul@parallels.com, gorcunov@openvz.org,
        andriy.shevchenko@linux.intel.com
Cc: Martin.Runge@rohde-schwarz.com, Andreas.Brief@rohde-schwarz.com,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH v21 00/12] Add 32 bit VDSO time function support
Date: Sun,  2 Mar 2014 10:20:08 +0100
Message-Id: <1393752020-6740-1-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.9.0
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add the functions vdso_gettimeofday(), vdso_clock_gettime()
and vdso_time() to the 32 bit VDSO.

The reason to do this was to get a fast reliable time stamp. Many developers
uses TSC to get a fast time stamp, without knowing the pitfalls. VDSO
time functions a fast and a reliable way, because the kernel knows the
best time source and the P- and C-state of the CPU.

The helper library to use the VDSO functions can be download at
http://http://seibold.net/vdso.c
The libary is very small, only 228 lines of code. Compile it with
gcc -Wall -O3 -fpic vdso.c -lrt -shared -o libvdso.so
and use it with LD_PRELOAD=<path>/libvdso.so

This kind of helper must be integrated into glibc, for x86 64 bit and
PowerPC it is already there.

Some linux 32 bit kernel benchmark results (all measurements are in nano
seconds):

Intel(R) Celeron(TM) CPU 400MHz

Average time kernel call:
 gettimeofday(): 1039
 clock_gettime(): 1578
 time(): 526
Average time VDSO call:
 gettimeofday(): 378
 clock_gettime(): 303
 time(): 60

Celeron(R) Dual-Core CPU T3100 1.90GHz

Average time kernel call:
 gettimeofday(): 209
 clock_gettime(): 406
 time(): 135
Average time VDSO call:
 gettimeofday(): 51
 clock_gettime(): 43
 time(): 10

So you can see a performance increase between 4 and 13, depending on the
CPU and the function.

The address layout of the VDSO has changed, because there is no fixed
address space available on a x86 32 bit kernel, despite the name. Because
someone decided to add an offset to the __FIXADDR_TOP for virtualization.

Also the IA32 Emulation uses the whole 4 GB address space, so there is no
fixed address available.

This was the reason not depend on this kind of address and change the layout
of the VDSO. The VDSO for a 32 bit application has now three pages:

^ Higher Address
|
+----------------------------------------+
+ VDSO page (includes code) ro+x         +
+----------------------------------------+
+ VVAR page (export kernel variables) ro +
+----------------------------------------+
+ HPET page (mapped registers) ro 
+----------------------------------------+
|
^ Lower Address

The VDSO page for a 32 bit resided still on 0xffffe000, the the VVAR and
HPET page are mapped before.

In the non compat mode the VMA of the VDSO is now 3 pages for a 32 bit kernel.
So this decrease the available logical address room by 2 pages.

The patch is against kernel 3.14 (e7651b819e90da924991d727d3c007200a18670d)

Changelog:
25.11.2012 - first release and proof of concept for linux 3.4
11.12.2012 - Port to linux 3.7 and code cleanup
12.12.2012 - fixes suggested by Andy Lutomirski
           - fixes suggested by John Stultz
           - use call VDSO32_vsyscall instead of int 80
           - code cleanup
17.12.2012 - support for IA32_EMULATION, this includes
             - code cleanup
             - include cleanup to fix compile warnings and errors
             - move out seqcount from seqlock, enable use in VDSO
             - map FIXMAP and HPET into the 32 bit address space
18.12.2012 - split into separate patches
30.01.2014 - revamp the code
             - code clean up
             - VDSO layout changed
             - no fixed addresses
             - port to 3.14
01.02.2014 - code cleanup
02.02.2014 - code cleanup
             - split into more patches
             - use HPET_COUNTER instead of hard coded value
             - fix changelog to the right year ;-)
02.02.2014 - reverse the mapping, this make the new VDSO 32 bit support
             full compatible.
03.02.2014 - code cleanup
             - fix comment
             - fix ABI break in vdso32.lds.S
04.02.2014 - revamp IA32 emulation support
             - introduce VVAR macro
             - rearranged vsyscall_gtod_data struture for IA32 emulation support
             - code cleanup
05.02.2014 - revamp IA32 emulation support
             - replace seqcount_t by an unsigned, to make the vsyscall_gtod_data
               structure independed of kernel config and functions.
08.02.2014 - revamp IA32 emulation support
             - replace all internal structures by fix size elements
10.02.2014 - code cleanup
             - add commets
             - revamp inline assembly
12.02.2014 - add conditional fixmap of vvar and hpet pages for 32 bit kernel
14.02.2014 - fix CONFIG_PARAVIRT_CLOCK, which is not supported in 32 bit VDSO
15.02.2014 - fix tsc
             code cleanup
             tested make ARCH=i386 allyesconfig and make allyesconfig
16.02.2014 - code cleanup
             - fix all C=1 warnings, also some one not introduced by this patch
             - hack to fix C=1 32 bit VDSO spinlock for a 64 bit kernel
             - fix VDSO Makefile for newer gcc
             tested for gcc 4.3.4 and 4.8.1
             tested ARCH=i386 allyesconfig, defconfig and allmodconfig
             tested X86_64 allyesconfig, defconfig and allmodconfig
17.02.2014 - In case of a 32 bit VDSO for a 64 bit kernel fake a 32 bit kernel
             configuration.
19.02.2014 - Add missing #undef and #define to fake proper 32 bit kernel config
             Add a missing #ifdef CONFIG_HPET_TIMER
             tested again ARCH=i386 allyesconfig, defconfig and allmodconfig
             tested again ARCH=X86_64 allyesconfig, defconfig and allmodconfig
02.03.2014 - Add fixes suggested by Andy Lutomirski
             - Patch alternatives in the 32 bit VDSO
	     - Use the default ABI for the 32 bit VDSO
	     - Inline the CLOCK MONOTONIC VDSO code
	     - Zero pad the VVAR page
	     - fix "patch alternatives" compile for 32 bit kernel
