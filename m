Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab3I2WrY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 18:47:24 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:48480 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940Ab3I2WrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 18:47:22 -0400
Date: Mon, 30 Sep 2013 00:47:20 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [GIT PULL] perf fixes
Message-ID: <20130929224720.GA282@x4>
References: <20130928180327.GA5000@gmail.com>
 <20130929114700.GB282@x4>
 <20130929213329.GA2125@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130929213329.GA2125@tassilo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.09.29 at 14:33 -0700, Andi Kleen wrote:
> > breaks "perf top" on my machine. I just see a gray screen with no text
> > at all. Sometimes the following error messages are printed:
> >  *** Error in `perf': invalid fastbin entry (free): 0x00000000029b18c0 ***
> >  *** Error in `perf': malloc(): memory corruption (fast): 0x0000000000ee0b10 ***
> 
> Hmm, works for me. In fact I wrote it to fix a perf top issue.
> 
> What does valgrind say?

Here's the -fsanitize=address output instead:

markus@x4 perf % perf top --stdio 2>&1 | asan_symbolize.py
=================================================================
==24617== ERROR: AddressSanitizer: heap-buffer-overflow on address 0x600c0000b638 at pc 0x7f2683fad79d bp 0x7fffbb8ec3b0 sp 0x7fffbb8ebb70
WRITE of size 9 at 0x600c0000b638 thread T0
    #0 0x7f2683fad79c in __interceptor_strcpy ??:?
    #1 0x4e422c in strcpy /usr/include/bits/string3.h:104
    #2 0x4ddeff in dso__load /usr/src/linux/tools/perf/util/symbol.c:1085
    #3 0x509058 in map__load /usr/src/linux/tools/perf/util/map.c:159
    #4 0x49fa6b in perf_event__preprocess_sample /usr/src/linux/tools/perf/util/event.c:762
    #5 0x455fa0 in perf_event__process_sample /usr/src/linux/tools/perf/builtin-top.c:719
    #6 0x45be8e in perf_top__mmap_read /usr/src/linux/tools/perf/builtin-top.c:870
    #7 0x41f88d in run_builtin /usr/src/linux/tools/perf/perf.c:319
    #8 0x41bc05 in run_argv /usr/src/linux/tools/perf/perf.c:376
    #9 0x7f2682d41a74 in __libc_start_main /home/markus/glibc/csu/libc-start.c:269
    #10 0x41e948 in _start /home/markus/glibc/csu/../sysdeps/x86_64/start.S:122
0x600c0000b63d is located 0 bytes to the right of 61-byte region [0x600c0000b600,0x600c0000b63d)
allocated by thread T0 here:
    #0 0x7f2683fb6d6f in __interceptor_realloc ??:?
    #1 0x4e420f in dso__load_sym /usr/src/linux/tools/perf/util/symbol-elf.c:951
    #2 0x4ddeff in dso__load /usr/src/linux/tools/perf/util/symbol.c:1085
    #3 0x509058 in map__load /usr/src/linux/tools/perf/util/map.c:159
    #4 0x49fa6b in perf_event__preprocess_sample /usr/src/linux/tools/perf/util/event.c:762
    #5 0x455fa0 in perf_event__process_sample /usr/src/linux/tools/perf/builtin-top.c:719
    #6 0x45be8e in perf_top__mmap_read /usr/src/linux/tools/perf/builtin-top.c:870
    #7 0x41f88d in run_builtin /usr/src/linux/tools/perf/perf.c:319
    #8 0x41bc05 in run_argv /usr/src/linux/tools/perf/perf.c:376
    #9 0x7f2682d41a74 in __libc_start_main /home/markus/glibc/csu/libc-start.c:269
Shadow bytes around the buggy address:
  0x0c01ffff9670: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0c01ffff9680: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0c01ffff9690: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0c01ffff96a0: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
  0x0c01ffff96b0: fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa fa
=>0x0c01ffff96c0: 00 00 00 00 00 00 00[05]fa fa fa fa fd fd fd fd
  0x0c01ffff96d0: fd fd fd fd fa fa fa fa fd fd fd fd fd fd fd fd
  0x0c01ffff96e0: fa fa fa fa fd fd fd fd fd fd fd fa fa fa fa fa
  0x0c01ffff96f0: fd fd fd fd fd fd fd fd fa fa fa fa fd fd fd fd
  0x0c01ffff9700: fd fd fd fd fa fa fa fa fd fd fd fd fd fd fd fd
  0x0c01ffff9710: fa fa fa fa fd fd fd fd fd fd fd fd fa fa fa fa
Shadow byte legend (one shadow byte represents 8 application bytes):
  Addressable:           00
  Partially addressable: 01 02 03 04 05 06 07
  Heap left redzone:     fa
  Heap righ redzone:     fb
  Freed Heap region:     fd
  Stack left redzone:    f1
  Stack mid redzone:     f2
  Stack right redzone:   f3
  Stack partial redzone: f4
  Stack after return:    f5
  Stack use after scope: f8
  Global redzone:        f9
  Global init order:     f6
  Poisoned by user:      f7
  ASan internal:         fe
==24617== ABORTING

And please note that cloned functions are demangled just fine on my machine
even without your patch, e.g.:

 10.61%  libQtGui.so.4.8.5   [.] QFontEngineFT::stringToCMap(QChar const*, int, QGlyphLayout*, int*, QFlags<QTextEngine::ShaperFlag>) const [clone .part.20]

-- 
Markus
