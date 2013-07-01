Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab3GAMuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 08:50:51 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:50210 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741Ab3GAMuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 08:50:50 -0400
Date: Mon, 1 Jul 2013 14:50:46 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] x86: Use asm-goto to implement mutex fast path on x86-64
Message-ID: <20130701125045.GA24336@gmail.com>
References: <1372416851-56830-1-git-send-email-wedsonaf@gmail.com>
 <20130628111948.GA31065@gmail.com>
 <20130628140938.GA24819@pd.tnic>
 <CANeycqpiXO-B1+f-OXZfHaxxPd2aVEL0kutFp6-sALHqXNrazQ@mail.gmail.com>
 <20130630220004.GA23124@pd.tnic>
 <20130701075046.GB1681@gmail.com>
 <20130701102306.GC23515@pd.tnic>
 <20130701111122.GA18772@gmail.com>
 <20130701122954.GD23515@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130701122954.GD23515@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <bp@alien8.de> wrote:

> On Mon, Jul 01, 2013 at 01:11:22PM +0200, Ingo Molnar wrote:
> > Hm, a 6 seconds win looks _way_ too much - we don't execute that much 
> > mutex code, let alone a portion of it.
> > 
> > This could perhaps be a bootup-to-bootup cache layout systematic jitter 
> > artifact, which isn't captured by stddev observations?
> > 
> > Doing something like this with a relatively fresh version of perf:
> > 
> >   perf stat --repeat 10 -a --sync \
> >    --pre 'make -s O=defconfig-build/ clean; echo 1 > /proc/sys/vm/drop_caches' \
> >    make -s -j64 O=defconfig-build/ bzImage
> > 
> > ... might do the trick (untested!). (Also note the use of -a: this should 
> > run on an otherwise quiescent system.)
> 
> Yep, I didn't run -a since I wanted to trace only the build process.
> Btw, the build-kernel.sh script looks like this:
> 
> #!/bin/bash
> 
> NUM_CPUS=$(cat /proc/cpuinfo | grep processor | wc -l)
> MAKE_OPTS=-j$(($NUM_CPUS+1))
> 
> echo 3 > /proc/sys/vm/drop_caches
> make $MAKE_OPTS mrproper
> make $MAKE_OPTS oldconfig
> make $MAKE_OPTS
> <EOF>
> 
> Let me try your perf tracing variant.
> 
> > As a sidenote, we could add this as a convenience feature, triggered via:
> > 
> >    perf stat --flush-vm-caches
> > 
> > ... or so, in addition to the already existing --sync option.
> 
> Is this something which we want to use a lot? [...]

For cache-cold measurements I'm sure it's handy.

> [...] Also, there's 1, 2 and 3 as arg to drop_caches:
> 
> drop_caches
> 
> Writing to this will cause the kernel to drop clean caches, dentries and
> inodes from memory, causing that memory to become free.
> 
> To free pagecache:
> 	echo 1 > /proc/sys/vm/drop_caches
> To free dentries and inodes:
> 	echo 2 > /proc/sys/vm/drop_caches
> To free pagecache, dentries and inodes:
> 	echo 3 > /proc/sys/vm/drop_caches

Yeah, so it would have to be a --vm-drop-caches <N> option I guess.

Thanks,

	Ingo
