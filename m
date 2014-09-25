Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbaIYJeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 05:34:14 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55982 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751985AbaIYJeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 05:34:11 -0400
Date: Thu, 25 Sep 2014 10:33:09 +0100
From: Will Deacon <will.deacon@arm.com>
To: Greg Ungerer <gerg@uclinux.org>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "chris@zankel.net" <chris@zankel.net>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "deller@gmx.de" <deller@gmx.de>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "geert@linux-m68k.org" <geert@linux-m68k.org>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jcmvbkbc@gmail.com" <jcmvbkbc@gmail.com>,
        "jesper.nilsson@axis.com" <jesper.nilsson@axis.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "monstr@monstr.eu" <monstr@monstr.eu>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "sam@ravnborg.org" <sam@ravnborg.org>,
        "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>,
        "starvik@axis.com" <starvik@axis.com>,
        "takata@linux-m32r.org" <takata@linux-m32r.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "daniel.thompson@linaro.org" <daniel.thompson@linaro.org>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v3 09/17] m68k: io: implement dummy relaxed accessor
 macros for writes
Message-ID: <20140925093309.GG20043@arm.com>
References: <1411579056-16966-1-git-send-email-will.deacon@arm.com>
 <1411579056-16966-10-git-send-email-will.deacon@arm.com>
 <54236A67.90001@uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54236A67.90001@uclinux.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 02:05:43AM +0100, Greg Ungerer wrote:
> Hi Will

Hi Greg,

Thanks for taking a look.

> On 25/09/14 03:17, Will Deacon wrote:
> > write{b,w,l}_relaxed are implemented by some architectures in order to
> > permit memory-mapped I/O accesses with weaker barrier semantics than the
> > non-relaxed variants.
> > 
> > This patch adds dummy macros for the write accessors to m68k, in the
> > same vein as the dummy definitions for the relaxed read accessors.
> > Additionally, the existing relaxed read accessors are moved into
> > asm/io.h, so that they can be used by m68k targets with an MMU.
> > 
> > Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> > Signed-off-by: Will Deacon <will.deacon@arm.com>
> > ---
> >  arch/m68k/include/asm/io.h    | 8 ++++++++
> >  arch/m68k/include/asm/io_no.h | 4 ----
> >  2 files changed, 8 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/m68k/include/asm/io.h b/arch/m68k/include/asm/io.h
> > index c70cc9155003..bccd5a914eb6 100644
> > --- a/arch/m68k/include/asm/io.h
> > +++ b/arch/m68k/include/asm/io.h
> > @@ -3,3 +3,11 @@
> >  #else
> >  #include <asm/io_mm.h>
> >  #endif
> > +
> > +#define readb_relaxed(addr)	readb(addr)
> > +#define readw_relaxed(addr)	readw(addr)
> > +#define readl_relaxed(addr)	readl(addr)
> > +
> > +#define writeb_relaxed(b, addr)	writeb(b, addr)
> > +#define writew_relaxed(b, addr)	writew(b, addr)
> > +#define writel_relaxed(b, addr)	writel(b, addr)
> 
> Putting them here means they won't have any multiple include protection
> (there is no "#ifndef _IO_H" around them). Doesn't seem to lead to
> any problems in practice. Just flagging it...

That's easy enough to fix, and actually, we should have __KERNEL__ checks
here too. Fixup below.

Will

--->8

diff --git a/arch/m68k/include/asm/io.h b/arch/m68k/include/asm/io.h
index bccd5a914eb6..ded201916560 100644
--- a/arch/m68k/include/asm/io.h
+++ b/arch/m68k/include/asm/io.h
@@ -1,9 +1,14 @@
+#ifndef _M68K_IO_H
+#define _M68K_IO_H
+
 #ifdef __uClinux__
 #include <asm/io_no.h>
 #else
 #include <asm/io_mm.h>
 #endif
 
+#ifdef __KERNEL__
+
 #define readb_relaxed(addr)    readb(addr)
 #define readw_relaxed(addr)    readw(addr)
 #define readl_relaxed(addr)    readl(addr)
@@ -11,3 +16,6 @@
 #define writeb_relaxed(b, addr)        writeb(b, addr)
 #define writew_relaxed(b, addr)        writew(b, addr)
 #define writel_relaxed(b, addr)        writel(b, addr)
+
+#endif /* __KERNEL__ */
+#endif /* _M68K_IO_H */
