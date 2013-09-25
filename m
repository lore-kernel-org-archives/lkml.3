Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab3IYU0Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 16:26:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49381 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab3IYU0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:26:15 -0400
Date: Wed, 25 Sep 2013 13:26:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergei Trofimovich <slyfox@gentoo.org>,
        Timur Tabi <timur@freescale.com>, Greg KH <greg@kroah.com>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: build failure after merge of the akpm tree
Message-Id: <20130925132612.d1685bc8fb72558eef6fb09d@linux-foundation.org>
In-Reply-To: <20130925110643.db5fa154bea3838ed6affa45@canb.auug.org.au>
References: <20130925110643.db5fa154bea3838ed6affa45@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Sep 2013 11:06:43 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> After merging the akpm tree, linux-next builds (powerpc allmodconfig)
> fail like this:

I can't get powerpc to build at all at present:

  CHK     include/config/kernel.release
  CHK     include/generated/uapi/linux/version.h
  CHK     include/generated/utsrelease.h
  CC      arch/powerpc/kernel/asm-offsets.s
In file included from include/linux/vtime.h:6,
                 from include/linux/hardirq.h:7,
                 from include/linux/memcontrol.h:24,
                 from include/linux/swap.h:8,
                 from include/linux/suspend.h:4,
                 from arch/powerpc/kernel/asm-offsets.c:24:
arch/powerpc/include/generated/asm/vtime.h:1:31: error: asm-generic/vtime.h: No such file or directory

> drivers/tty/ehv_bytechan.c:362:1: error: type defaults to 'int' in declaration of 'console_initcall' [-Werror=implicit-int]
> 
> Caused by commit 0f01cf96c2d4 ("./Makefile: enable -Werror=implicit-int
> and -Werror=strict-prototypes by default") which has bee in linux-next
> since Aug 16.  This commit exposed that fact that
> drivers/tty/ehv_bytechan.c can be built as a module, but has a
> console_initcall (which is not available to modules).  This was
> originally introduced in commit dcd83aaff1c8 ("tty/powerpc: introduce the
> ePAPR embedded hypervisor byte channel driver") in v3.2.
> 
> Anyone got a good solution?

console_initcall() is a macro defined in init.h.  But we forgot to
provide a version for #ifdef MODULE.

At include/linux/init.h line 284 we see:

/* Don't use these in loadable modules, but some people do... */
#define early_initcall(fn)		module_init(fn)
#define core_initcall(fn)		module_init(fn)
...

So we *could* add console_initcall() there.  But the problem is that it
won't work as desired - when the driver is loaded as a module,
ehv_bc_console_init() will be called at modprobe time, which is far far
later than console_initcall-time.

So the ehv_bytechan.c developers need to work out what they want to do
here.  Do we disallow building that driver as a module?  Or do we
permit that, and run ehv_bc_console_init() at modprobe time (needs
testing!).

If the latter then I'd be reluctant to add a modular version of
console_initcall() because the thing's very presence is misleading. 
otoh, drivers which use such a console_initcall() _might_ work, and
everyone tests their drivers both built-in and as modules, don't they? 
Don't they?
