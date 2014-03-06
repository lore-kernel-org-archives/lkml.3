Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbaCFEmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 23:42:18 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:36873 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbaCFEmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 23:42:16 -0500
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
        Stephane Eranian <eranian@google.com>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 0/3] powerpc/perf: Enable linking with libunwind
Date: Wed,  5 Mar 2014 20:41:56 -0800
Message-Id: <1394080919-17957-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030604-0928-0000-0000-00000032F7DB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we try to create backtraces (call-graphs) with the perf tool

	perf record -g /tmp/sprintft

we get backtraces with duplicate arcs for sprintft[1]:

    14.61%  sprintft  libc-2.18.so       [.] __random                            
            |
            --- __random
               |
               |--61.09%-- __random
               |          |
               |          |--97.18%-- rand
               |          |          do_my_sprintf
               |          |          main
               |          |          generic_start_main.isra.0
               |          |          __libc_start_main
               |          |          0x0
               |          |
               |           --2.82%-- do_my_sprintf
               |                     main
               |                     generic_start_main.isra.0
               |                     __libc_start_main
               |                     0x0
               |
                --38.91%-- rand
                          |          
                          |--92.90%-- rand
                          |          |
                          |          |--99.87%-- do_my_sprintf
                          |          |          main
                          |          |          generic_start_main.isra.0
                          |          |          __libc_start_main
                          |          |          0x0
                          |           --0.13%-- [...]
                          |
                           --7.10%-- do_my_sprintf
                                     main
                                     generic_start_main.isra.0
                                     __libc_start_main
                                     0x0

(where the two arcs both have the same backtrace but are not merged).

Linking with libunwind seems to create better backtraces. While x86 and
ARM processors have support for linking with libunwind but Power does not.
This patchset is an RFC for linking with libunwind.

With this patchset and running:

	/tmp/perf record --call-graph=dwarf,8192 /tmp/sprintft

the backtrace is:

    14.94%  sprintft  libc-2.18.so       [.] __random                            
            |
            --- __random
                rand
                do_my_sprintf
                main
                generic_start_main.isra.0
                __libc_start_main
                (nil)

This appears better.

One downside is that we now need the kernel to save the entire user stack
(the 8192 in the command line is the default user stack size).

A second issue is that this invocation of perf (with --call-graph=dwarf,8192)
seems to fail for backtraces involving tail-calls[2]

	/tmp/perf record -g ./tailcall
gives 

    20.00%  tailcall  tailcall           [.] work2
            |
            --- work2
                work

shows the tail function 'work2' as "called from" 'work()'

But with libunwind:

	/tmp/perf record --call-graph=dwarf,8192 ./tailcall
we get:

   20.50%  tailcall  tailcall           [.] work2
            |
            --- work2

the caller of 'work' is not shown.

I am debugging this, but would appreciate any feedback/pointers on the
patchset/direction:

	- Does libunwind need the entire user stack to work or are there
	  optimizations we can do to save the minimal entries for it to
	  perform the unwind.

	- Does libunwind work with tailcalls like the one above ?

	- Are there benefits to linking with libunwind (even if it does not
	  yet solve the tailcall problem)

	- Are there any examples of using libdwarf to solve the tailcall
	  issue ?

[1] sprintft (excerpt from a test program by Maynard Johnson).

	char * do_my_sprintf(char * strx, int num)
	{
		int i;
		for (i = 0; i < inner_iterations; i++) {
			int r = rand() % 10;
			sprintf(my_string, "%s ...%d\n", strx+r, num);
			if (strlen(my_string) > 15)
				num = 15;
		}
		return my_string;
	}

[2] tailcall (Powerpc assembly, from Anton Blanchard)

    Build with: gcc -O2 --static -nostdlib -o tailcall tailcall.S

	#define ITERATIONS 1000000000

		.align 2
		.globl _start
		.globl ._start
		.section ".opd","aw"
	_start:
		.quad ._start
		.quad .TOC.@tocbase
		.quad 0;

		.text;
	._start:
		lis     4,ITERATIONS@h
		ori     4,4,ITERATIONS@l
		mtctr   4

	1:      bl      work
		bdnz    1b

		li 0,1  /* sys_exit */
		sc

	work:
		mflr    30
		bl      work2
		mtlr    30
		blr

	work2:
		blr


Sukadev Bhattiprolu (3):
  power: perf: Enable saving the user stack in a sample.
  power: perf tool: Add libunwind support for Power
  perf: Use 64-bit value when comparing sample_regs

 arch/powerpc/Kconfig                        |    2 +
 arch/powerpc/include/uapi/asm/perf_regs.h   |   70 ++++++++++++++++++
 arch/powerpc/perf/Makefile                  |    1 +
 arch/powerpc/perf/perf-regs.c               |  104 +++++++++++++++++++++++++++
 tools/perf/arch/powerpc/Makefile            |    5 ++
 tools/perf/arch/powerpc/include/perf_regs.h |   69 ++++++++++++++++++
 tools/perf/arch/powerpc/util/unwind.c       |   63 ++++++++++++++++
 tools/perf/config/Makefile                  |    7 ++
 tools/perf/util/unwind.c                    |    4 +-
 9 files changed, 323 insertions(+), 2 deletions(-)
 create mode 100644 arch/powerpc/include/uapi/asm/perf_regs.h
 create mode 100644 arch/powerpc/perf/perf-regs.c
 create mode 100644 tools/perf/arch/powerpc/include/perf_regs.h
 create mode 100644 tools/perf/arch/powerpc/util/unwind.c

-- 
1.7.9.5

