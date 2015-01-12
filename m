Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbbALKlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 05:41:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082AbbALKlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 05:41:17 -0500
Date: Mon, 12 Jan 2015 11:36:05 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Wang Nan <wangnan0@huawei.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, lizefan@huawei.com, acme@kernel.org
Subject: Re: [PATCH] perf: fix building error in x86_64 when dwarf unwind is
 on.
Message-ID: <20150112103605.GA26229@krava.redhat.com>
References: <20150109144332.GB14750@krava.brq.redhat.com>
 <1421029255-23039-1-git-send-email-wangnan0@huawei.com>
 <20150112032810.GA25581@sejong>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150112032810.GA25581@sejong>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 12:28:10PM +0900, Namhyung Kim wrote:
> On Mon, Jan 12, 2015 at 10:20:55AM +0800, Wang Nan wrote:
> > From: Namhyung Kim <namhyung@kernel.org>
> > 
> > When build with 'make ARCH=x86' and dwarf unwind is on, there is a
> > compiling error:
> > 
> >    CC       /home/wn/perf/arch/x86/util/unwind-libdw.o
> >    CC       /home/wn/perf/arch/x86/tests/regs_load.o
> >  arch/x86/tests/regs_load.S: Assembler messages:
> >  arch/x86/tests/regs_load.S:65: Error: operand type mismatch for `push'
> >  arch/x86/tests/regs_load.S:72: Error: operand type mismatch for `pop'
> >  make[1]: *** [/home/wn/perf/arch/x86/tests/regs_load.o] Error 1
> >  make[1]: INTERNAL: Exiting with 25 jobserver tokens available; should be 24!
> >  make: *** [all] Error 2
> >  ...
> > 
> > Which is caused by incorrectly undefine macro HAVE_ARCH_X86_64_SUPPORT.
> > 'config/Makefile.arch' tests __x86_64__ only when 'ARCH=x86_64'.
> > However, when building x86_64 kernel, ARCH=x86 is valid and commonly
> > used. Building systems, such as yocto, uses x86_64 compiler with
> > 'ARCH=x86' to build x86_64 perf, which causes mismatching.
> > 
> > As __LP64__ is defined for x86_64 as well, we can consolidate the
> > __x86_64__ check to the __LP64__ check and get rid of the IS_X86_64
> > IMHO.
> > 
> > (This patch is made by Namhyung Kim when replying my v1 patch:
> > 
> > https://lkml.org/lkml/2015/1/7/17
> > 
> > I modified the code to remove dependency on RAW_ARCH:
> > 
> > https://lkml.org/lkml/2015/1/7/865
> > 
> > Namhyung Kim didn't provide his SOB in his original email. I add
> > mine only for my modification.)
> 
> Please feel free to add my SOB to this patch.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

Acked-by: Jiri Olsa <jolsa@kernel.org>

also.. I tried 32bit build on x86_64, but I had to disable python
support explicitly to succeed:

  $ make EXTRA_CFLAGS=-m32 NO_LIBPYTHON=1

seems like 'python-config --cflags' returns -m64, which beats -m32,
and the features code always detects 64bit version, which fails
to link at the end with all the rest 32bit stuff

hopefully some python enthusiast will fix it one day,
anyway it's great the 32bit build works.. sort of ;-)

thanks,
jirka
