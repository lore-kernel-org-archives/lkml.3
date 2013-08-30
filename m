Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945Ab3H3Mbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 08:31:40 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:60031 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab3H3Mbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 08:31:39 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Fri, 30 Aug 2013 14:31:37 +0200
Message-ID: <CA+icZUWNrZQgjuXX+7JFgRKfCjYR_fSkfeRxHot_=xpLSaNaxg@mail.gmail.com>
Subject: [3.11-rc7] Building perf-only the "official" way seems to be BROKEN?
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

[ INTRO ]

I build all my Linux-kernels nowadays with 'make deb-pkg' which
generates Debian packages for me.
Currently, there is no mechanism to build a linux-tools package.
In the Debian/Ubuntu world linux-tools package ships binaries and docs
for perf tool.
Some people sent patches to generate a linux-tools package via 'make
deb-pkg' to the linux-kbuild ML.
But since this is not in upstream, someone like me has to build perf manually!

This issue came up when I wanted to try the spinlock-lockref
improvements in Linux v3.11-rc7+ and run the test-case "t.c" (renamed
to "t_lockref_from-linus.c") from Linus.

Ingo suggested for easier benchmarking to use perf...

   $ perf stat --null --repeat 5

WARNING: You require the perf-version fitting for your kernel-version!

   $ perf stat --null --repeat 5 ./t_lockref_from-linus

[ OUTPUT ]
perf_3.11.0-rc7 not found
You may need to install linux-tools-3.11.0-rc7
[ /OUTPUT ]

Please, for more details see also this thread on LKML...
"[PATCH v7 1/4] spinlock: A new lockref structure for lockless update
of refcount"


[ SOLVE BUILD-DEPENDS ON UBUNTU/PRECISE ]

Before building perf, you need to solve the build-depends (which means
"get the missing required packages to build perf").
Normally, you should only do on a Debian-like system (like pointed out
by Peter Z.)...

   $ apt-get build-dep linux-tools

...but with a Ubuntu-kernel v3.2.x and corresponding "ancient"
linux-tools in the repositories you can't!

I ended up with this line by looking at the warnings from 'make -C
tools/ perf_install'...

   $ sudo apt-get install libelf-dev libdw-dev libunwind7-dev
libslang2-dev libnuma-dev


[ BUILD PERF-ONLY ]

So, I have finished a Linux-kernel build and wanted to build perf
(from tools-dir) ONLY!

I followed the advices (I am a "good" guy) seen for example in the
"tools/Makefile" file.

[ tools/Makefile ]
...
        @echo 'You can do:'
        @echo ' $$ make -C tools/ <tool>_install' <--- NOTE THIS ONE!
        @echo ''
        @echo '  from the kernel command line to build and install one of'
        @echo '  the tools above'
        @echo ''
        @echo '  $$ make tools/install'
        @echo ''
        @echo '  installs all tools.'
...

OK, so I did this for a perf-only build...


   $ LANG=C LC_ALL=C make -C tools/ perf_install 2>&1 | tee ../build-perf.txt

...this breaks like this...

...
make[2]: Entering directory
`/home/wearefam/src/linux-kernel/linux/tools/lib/traceevent'
make[2]: Leaving directory
`/home/wearefam/src/linux-kernel/linux/tools/lib/traceevent'
    LINK perf
gcc: error: /home/wearefam/src/linux-kernel/linux/tools/lib/lk/liblk.a:
No such file or directory
make[1]: *** [perf] Error 1
make[1]: Leaving directory `/home/wearefam/src/linux-kernel/linux/tools/perf'
make: *** [perf_install] Error 2


[ WHY IS LIBLK NOT BUILT? ]

NO, indeed there exists no liblk.a!

   $ LANG=C LC_ALL=C ll tools/lib/lk/

[ OUTPUT ]
total 20
drwxr-xr-x 2 wearefam wearefam 4096 Aug 30 12:11 ./
drwxr-xr-x 4 wearefam wearefam 4096 Jul 11 19:42 ../
-rw-r--r-- 1 wearefam wearefam 1430 Aug 30 09:56 Makefile
-rw-r--r-- 1 wearefam wearefam 2144 Jul 11 19:42 debugfs.c
-rw-r--r-- 1 wearefam wearefam  619 Jul 11 19:42 debugfs.h
[ /OUTPUT ]

Why is liblk not built?

Let's have a look into some Makefiles...

[ linux/tools/Makefile ]

41:liblk: FORCE
44:perf: liblk FORCE

As you can see from the order of building, liblk should be built
before perf and liblk is FORCE(d) for perf.
Maybe, the perf experts can help here?
( Cannot say, if linux/tools/perf/Makefile needs some massage for a
perf-only build? )


[ WORKAROUND ]

Doing these 3 steps let me build perf (with docs etc.)...

   $ sudo apt-get install libelf-dev libdw-dev libunwind7-dev
libslang2-dev libnuma-dev

   $ LANG=C LC_ALL=C make -C tools/ liblk

   $ LANG=C LC_ALL=C make -C tools/ perf_install


[ YES, IT WORKED ]

   $ ~/src/linux-kernel/linux/tools/perf/perf --version

[ OUTPUT ]
 perf version 3.11.rc7.ga7370
[ /OUTPUT ]

   $ ~/src/linux-kernel/linux/tools/perf/perf stat --null --repeat 5

[ OUTPUT ]
./t_lockref_from-linus
Total loops: 2652351
Total loops: 2604876
Total loops: 2649696
Total loops: 2651417
Total loops: 2644068

 Performance counter stats for './t_lockref_from-linus' (5 runs):

      10,002926693 seconds time elapsed
          ( +-  0,00% )
[ /OUTPUT ]

   $ cat /proc/version

[ OUTPUT ]
Linux version 3.11.0-rc7-1-lockref-small
(sedat.dilek@gmail.com@fambox) (gcc version 4.6.3 (Ubuntu/Linaro
4.6.3-1ubuntu5) ) #1 SMP Fri Aug 30 10:23:19 CEST 2013
[ /OUTPUT ]

Please, have a look at this!

Thanks in advance.

Regards,
- Sedat -

P.S.: Cleanup perf-only build (for the sake of completeness).

[ CLEANUP PERF-ONLY BUILD (WORKAROUND) ]

   $ LANG=C LC_ALL=C make -C tools/ liblk_clean

   $ LANG=C LC_ALL=C make -C tools/ perf_clean

- EOT -
