Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab3EGXTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 19:19:32 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:28880 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299Ab3EGXTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 19:19:31 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Kit/dYjAqtt85BmT13uUw
Date: Tue, 7 May 2013 16:19:25 -0700
From: Tony Lindgren <tony@atomide.com>
To: torvalds@linux-foundation.org
Cc: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [GIT PULL 4/5] ARM: arm-soc: late cleanups
Message-ID: <20130507231925.GR28721@atomide.com>
References: <1367947574-2934383-1-git-send-email-arnd@arndb.de>
 <1367947574-2934383-5-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367947574-2934383-5-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

* Arnd Bergmann <arnd@arndb.de> [130507 10:32]:
> The following changes since commit
> 
>    763e6b9 Merge tag 'dt-for-linus-2' into for-next
> 
> are available in the git repository at
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/cleanup-for-linus-2
...
 
> Vaibhav Hiremath (1):
>       ARM: OMAP2+: Fix mismerge for timer.c between ff931c82 and da4a686a

Turns out this urgent boot fix got undone in the merge somehow.
Maybe just reapply it? The following should do it with some fuzz:

$ git show 626479696d2 | patch -p1

Or let me know if you want me to send you a patch.

Then in addition to the above, I'm also seeing a regression with commit
8a965b3b (mm, slab_common: Fix bootstrap creation of kmalloc caches),
but it seems to be related to some kconfig option. Seeing it on at least
omap and vexpress, I'll post more info on that once I've tracked it down:

[    0.000000] Unable to handle kernel NULL pointer dereference at virtual address 00000054
[    0.000000] pgd = c0004000
[    0.000000] [00000054] *pgd=00000000
[    0.000000] Internal error: Oops: 5 [#1] SMP ARM
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.9.0-11485-gbb9055b #633
[    0.000000] task: c078d7d0 ti: c0782000 task.ti: c0782000
[    0.000000] PC is at kmem_cache_alloc_trace+0x50/0x178
[    0.000000] LR is at kmem_cache_alloc_trace+0x38/0x178
[    0.000000] pc : [<c010d058>]    lr : [<c010d040>]    psr: 600001d3
[    0.000000] sp : c0783f70  ip : 600001d3  fp : 00000000
[    0.000000] r10: 000000c0  r9 : c00a5444  r8 : 000080d0
[    0.000000] r7 : 00000000  r6 : 600001d3  r5 : 00000000  r4 : 00008000
[    0.000000] r3 : 00000050  r2 : c0782000  r1 : c078d7d0  r0 : c010d040
[    0.000000] Flags: nZCv  IRQs off  FIQs off  Mode SVC_32  ISA ARM  Segment kernel
[    0.000000] Control: 10c5387d  Table: 80004019  DAC: 00000015
[    0.000000] Process swapper/0 (pid: 0, stack limit = 0xc0782240)
[    0.000000] Stack: (0xc0783f70 to 0xc0784000)
[    0.000000] 3f60:                                     00002014 00000010 c07d6510 00000000
[    0.000000] 3f80: 00000000 00000000 00000000 413fc082 c078a480 c00a5444 c07d6510 00000000
[    0.000000] 3fa0: 00000010 c0766348 ffffffff c073cfb4 bfffffff c080d78c c080d780 c0720828
[    0.000000] 3fc0: ffffffff ffffffff c0720478 00000000 00000000 c0766348 00000000 10c5387d
[    0.000000] 3fe0: c078a4c8 c076674c c078ecb4 80004059 00000000 80008074 00000000 00000000
[    0.000000] [<c010d058>] (kmem_cache_alloc_trace+0x50/0x178) from [<c00a5444>] (alloc_desc+0x24/0xb4)
[    0.000000] [<c00a5444>] (alloc_desc+0x24/0xb4) from [<c073cfb4>] (early_irq_init+0x78/0xec)
[    0.000000] [<c073cfb4>] (early_irq_init+0x78/0xec) from [<c0720828>] (start_kernel+0x17c/0x33c)
[    0.000000] [<c0720828>] (start_kernel+0x17c/0x33c) from [<80008074>] (0x80008074)
[    0.000000] Code: e5923014 e2833014 e1a03103 e0873003 (e5931004)
[    0.000000] ---[ end trace 1b75b31a2719ed1c ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!

Regards,

Tony
