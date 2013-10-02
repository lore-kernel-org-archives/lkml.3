Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196Ab3JBGFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 02:05:22 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:61870 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab3JBGFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 02:05:19 -0400
X-AuditID: 9c93017e-b7ca5ae0000013bb-20-524bb79d1561
From: Namhyung Kim <namhyung@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        David Ahern <dsahern@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] perf auto-dep: Speed up feature tests by building them in parallel
References: <20130912133855.GA23780@gmail.com>
	<CA+55aFwgyjqRHxLaWGxxsg_v07FrxbVTeLdHTGp7MfeSRjrKsQ@mail.gmail.com>
	<CA+55aFyCeXXr=57em8CC_Uzfk5PvOw0RHyA309wuOP-oDL7VxA@mail.gmail.com>
	<20130912184341.GA11400@ghostprotocols.net>
	<52321CE4.1080804@gmail.com>
	<20130912200236.GC11400@ghostprotocols.net>
	<20130912203116.GD32644@gmail.com> <20130912204313.GA3259@gmail.com>
	<20130915091029.GA21465@gmail.com> <20130930164210.GA22342@gmail.com>
Date: Wed, 02 Oct 2013 15:05:17 +0900
In-Reply-To: <20130930164210.GA22342@gmail.com> (Ingo Molnar's message of
	"Mon, 30 Sep 2013 18:42:10 +0200")
Message-ID: <87zjqsmcma.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Mon, 30 Sep 2013 18:42:10 +0200, Ingo Molnar wrote:
> This series (with combo patch attached) implements (much) faster 
> perf-tools feature-auto-detection.
>
> I used 3 tricks to implement feature auto-dependencies and to speed up 
> feature detection:
>
>   - standalone Makefile in config/feature-checks/ built in parallel
>
>   - split-out standalone .c files in config/feature-checks/*.c
>
>   - used GCC's auto-dependency generation feature (-MD) to track the
>     effects of system library addition/removal.

I have a memory that this could lead to a nasty build failure.  Please
see the commit b6f4f804108b ("tools lib traceevent: Do not generate
dependency for system header files").

The problem is that it turned out to depend on some compiler headers
which are located under some directory with a version number.  If so,
when compiler upgraded to a new version, it cannot find the original
dependencies so fail to build.

 $ cat config/feature-checks/test-libelf.d
  test-libelf: test-libelf.c /usr/include/libelf.h /usr/include/sys/types.h \
   /usr/include/features.h /usr/include/stdc-predef.h \
   /usr/include/sys/cdefs.h /usr/include/bits/wordsize.h \
   /usr/include/gnu/stubs.h /usr/include/gnu/stubs-64.h \
   /usr/include/bits/types.h /usr/include/bits/typesizes.h \
   /usr/include/time.h \
   /usr/lib/gcc/x86_64-redhat-linux/4.7.2/include/stddef.h \
   /usr/include/endian.h /usr/include/bits/endian.h \
   /usr/include/bits/byteswap.h /usr/include/bits/byteswap-16.h \
   /usr/include/sys/select.h /usr/include/bits/select.h \
   /usr/include/bits/sigset.h /usr/include/bits/time.h \
   /usr/include/sys/sysmacros.h /usr/include/bits/pthreadtypes.h \
   /usr/include/elf.h \
   /usr/lib/gcc/x86_64-redhat-linux/4.7.2/include/stdint.h \
   /usr/include/stdint.h /usr/include/bits/wchar.h


In this case we are using this for feature-checking, so I guess it'd
fail to check the feature after upgrade.

Thanks,
Namhyung
