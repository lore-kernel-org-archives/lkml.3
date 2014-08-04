Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaHDUpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 16:45:40 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:63223 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119AbaHDUpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 16:45:38 -0400
Date: Mon, 4 Aug 2014 13:45:33 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>, akpm@linux-foundation.org
Subject: Re: [PATCH 3.2 00/94] 3.2.62-rc1 review
Message-ID: <20140804204533.GA32681@roeck-us.net>
References: <lsq.1407170911.107020799@decadent.org.uk>
 <20140804175544.GA7631@roeck-us.net>
 <1407181779.8341.29.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407181779.8341.29.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 08:49:39PM +0100, Ben Hutchings wrote:
> On Mon, 2014-08-04 at 10:55 -0700, Guenter Roeck wrote:
> > On Mon, Aug 04, 2014 at 05:48:31PM +0100, Ben Hutchings wrote:
> > > This is the start of the stable review cycle for the 3.2.62 release.
> > > There are 94 patches in this series, which will be posted as responses
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed Aug 06 17:00:00 UTC 2014.
> > > Anything received after that time might be too late.
> > > 
> > Build results:
> > 	total: 111 pass: 105 fail: 6
> > Failed builds:
> > 	microblaze:mmu_defconfig
> > 	microblaze:nommu_defconfig
> > 	mips:allmodconfig
> > 	sparc64:allmodconfig
> > 	xtensa:defconfig
> > 	xtensa:allmodconfig
> > 
> > Qemu tests all passed.
> > 
> > This is a significant improvement over the previous versions, where we used
> > to see up to 10 build failures. The previously failing builds for unicore32
> > and score now pass, as well as alpha:allmodconfig.
> 
> Yes, I spent a little while digging out build fixes.
> 
> I tried to fix the mips allmodconfig build, but failed - it needs
> d3ce88431892, but that depends on 20082595d341, bef9ae3d883c, and
> further changes I couldn't identify. 
> 
> I was unable to reproduce the sparc64 allmodconfig build failure, which
> is in samples/hidraw - it built for me without warnings or errors.
> Could you give me a bit more detail about the test setup?
> 
Nothing special, really - Ubuntu 14.4 (previously 13.10), with gcc 4.6.3
from kernel.org.

This seems to be related to patch cbf1ef6 (sparc: use asm-generic version of
types.h). After backporting it, the build passes for me. The backport is
attached in case you want to give it a try.

Guenter
---
>From 69d878a92dc4bcec560e070f4f019563fa3af10a Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 31 Mar 2013 07:01:47 +0000
Subject: [PATCH] sparc: use asm-generic version of types.h

In sparc headers we use the following pattern:

    #if defined(__sparc__) && defined(__arch64__)

    sparc64 specific stuff

    #else

    sparc32 specific stuff

    #endif

In types.h this pattern was not followed and here
we only checked for __sparc__ for no good reason.
It was a left-over from long time ago.

I checked other architectures - and most of them
do not have any such checks. And all the recently
merged versions uses the asm-generic version.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
(cherry picked from commit cbf1ef6b3345d2cc7e62407eec6a6f72a8b1346f)
Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Conflicts:
	arch/sparc/include/asm/Kbuild
	arch/sparc/include/uapi/asm/Kbuild
---
 arch/sparc/include/asm/Kbuild  |  1 +
 arch/sparc/include/asm/types.h | 23 -----------------------
 2 files changed, 1 insertion(+), 23 deletions(-)
 delete mode 100644 arch/sparc/include/asm/types.h

diff --git a/arch/sparc/include/asm/Kbuild b/arch/sparc/include/asm/Kbuild
index 2c2e388..39a0b4f 100644
--- a/arch/sparc/include/asm/Kbuild
+++ b/arch/sparc/include/asm/Kbuild
@@ -21,3 +21,4 @@ generic-y += div64.h
 generic-y += local64.h
 generic-y += irq_regs.h
 generic-y += local.h
+generic-y += types.h
diff --git a/arch/sparc/include/asm/types.h b/arch/sparc/include/asm/types.h
deleted file mode 100644
index 91e5a03..0000000
--- a/arch/sparc/include/asm/types.h
+++ /dev/null
@@ -1,23 +0,0 @@
-#ifndef _SPARC_TYPES_H
-#define _SPARC_TYPES_H
-/*
- * This file is never included by application software unless
- * explicitly requested (e.g., via linux/types.h) in which case the
- * application is Linux specific so (user-) name space pollution is
- * not a major issue.  However, for interoperability, libraries still
- * need to be careful to avoid a name clashes.
- */
-
-#if defined(__sparc__)
-
-#include <asm-generic/int-ll64.h>
-
-#ifndef __ASSEMBLY__
-
-typedef unsigned short umode_t;
-
-#endif /* __ASSEMBLY__ */
-
-#endif /* defined(__sparc__) */
-
-#endif /* defined(_SPARC_TYPES_H) */
-- 
1.9.1


