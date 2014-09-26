Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbaIZLPD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 07:15:03 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:61877 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbaIZLPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 07:15:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: linux-next: build failure after merge of the asm-generic tree
Date: Fri, 26 Sep 2014 13:14:45 +0200
Message-ID: <6184197.FUKmdXcAaQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140926105333.GG22293@arm.com>
References: <20140926200251.78f0d713@canb.auug.org.au> <20140926105333.GG22293@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:gRWF0YfbPBkbiLdVx5hWcuATgx7eUWkXyX9zrBIi3XW
 vdV6n+UByavobmwdeLOSh8su0XYQ7qai8ucG/3wu6xnyHZVOgx
 +jsWpIyjiBKQq8FmidSZvEU2L0OvhRayNbSxoJraie9Jej8/bl
 06Cysm7qrPMbSq3XhNSf1wTv7sXAM2L+PU05atJBq1k7hNMR5H
 RaosPo8tQpFnc7S/iKRv7eWFKUPbaJBfLoANHB+cpRloun1rlG
 6Wjrw6XnPaX8DVN7TgiFumLZEePrcx58J3ZPagVymrZDlj08p6
 Uchn5OaHcResqDAYt3GyLWUblDSJDGdDsg+hZ2DJ6T/a4zuqJs
 DnGHLqMrEymd/5WPItSg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 September 2014 11:53:33 Will Deacon wrote:
> > From: Stephen Rothwell <sfr@canb.auug.org.au>
> > Date: Fri, 26 Sep 2014 19:57:03 +1000
> > Subject: [PATCH] sparc: io: fix for asm-generic: io: implement relaxed
> >  accessor macros as conditional wrappers
> > 
> > Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > ---
> >  arch/sparc/include/asm/io.h | 11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> > 
> > diff --git a/arch/sparc/include/asm/io.h b/arch/sparc/include/asm/io.h
> > index 493f22c4684f..79b167674010 100644
> > --- a/arch/sparc/include/asm/io.h
> > +++ b/arch/sparc/include/asm/io.h
> > @@ -1,10 +1,5 @@
> >  #ifndef ___ASM_SPARC_IO_H
> >  #define ___ASM_SPARC_IO_H
> > -#if defined(__sparc__) && defined(__arch64__)
> > -#include <asm/io_64.h>
> > -#else
> > -#include <asm/io_32.h>
> > -#endif
> >  
> >  /*
> >   * Defines used for both SPARC32 and SPARC64
> > @@ -19,6 +14,12 @@
> >  #define writew_relaxed(__w, __addr)  writew(__w, __addr)
> >  #define writel_relaxed(__l, __addr)  writel(__l, __addr)
> >  
> > +#if defined(__sparc__) && defined(__arch64__)
> > +#include <asm/io_64.h>
> > +#else
> > +#include <asm/io_32.h>
> > +#endif
> > +
> 
> This patch looks fine to me. Arnd, can you pick this up please?
> 

Thanks, applied on top with Stephen's full report in the commit
message and your Ack.

If David and Sam prefer, I could also do the patch below instead.
As sparc32 already uses the asm-generic header, it doesn't really
need the extra definitions, and they essentially become sparc64-only.

I've picked Stephen's version for now, since it's known to build
in the configurations he tests and has Will's Ack.

	Arnd

diff --git a/arch/sparc/include/asm/io.h b/arch/sparc/include/asm/io.h
index 493f22c4684f..f6902cf3cbe9 100644
--- a/arch/sparc/include/asm/io.h
+++ b/arch/sparc/include/asm/io.h
@@ -10,15 +10,6 @@
  * Defines used for both SPARC32 and SPARC64
  */
 
-/* Relaxed accessors for MMIO */
-#define readb_relaxed(__addr)		readb(__addr)
-#define readw_relaxed(__addr)		readw(__addr)
-#define readl_relaxed(__addr)		readl(__addr)
-
-#define writeb_relaxed(__b, __addr)	writeb(__b, __addr)
-#define writew_relaxed(__w, __addr)	writew(__w, __addr)
-#define writel_relaxed(__l, __addr)	writel(__l, __addr)
-
 /* Big endian versions of memory read/write routines */
 #define readb_be(__addr)	__raw_readb(__addr)
 #define readw_be(__addr)	__raw_readw(__addr)
diff --git a/arch/sparc/include/asm/io_64.h b/arch/sparc/include/asm/io_64.h
index d50e6127325d..e03df49e0dd8 100644
--- a/arch/sparc/include/asm/io_64.h
+++ b/arch/sparc/include/asm/io_64.h
@@ -412,6 +412,15 @@ static inline void iounmap(volatile void __iomem *addr)
 #define iowrite32(val,X)		writel(val,X)
 #define iowrite32be(val,X)		__raw_writel(val,X)
 
+/* Relaxed accessors for MMIO */
+#define readb_relaxed(__addr)		readb(__addr)
+#define readw_relaxed(__addr)		readw(__addr)
+#define readl_relaxed(__addr)		readl(__addr)
+
+#define writeb_relaxed(__b, __addr)	writeb(__b, __addr)
+#define writew_relaxed(__w, __addr)	writew(__w, __addr)
+#define writel_relaxed(__l, __addr)	writel(__l, __addr)
+
 /* Create a virtual mapping cookie for an IO port range */
 void __iomem *ioport_map(unsigned long port, unsigned int nr);
 void ioport_unmap(void __iomem *);

