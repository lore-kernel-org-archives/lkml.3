Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbaDQTQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 15:16:22 -0400
Received: from asavdk4.altibox.net ([109.247.116.15]:36400 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaDQTQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 15:16:14 -0400
Date: Thu, 17 Apr 2014 21:15:55 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "monstr@monstr.eu" <monstr@monstr.eu>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/18] Cross-architecture definitions of relaxed MMIO
 accessors
Message-ID: <20140417191555.GA11970@ravnborg.org>
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
 <20140417153638.GA7317@ravnborg.org>
 <20140417154714.GD30553@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140417154714.GD30553@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 04:47:15PM +0100, Will Deacon wrote:
> Hi Sam,
> 
> On Thu, Apr 17, 2014 at 04:36:38PM +0100, Sam Ravnborg wrote:
> > On Thu, Apr 17, 2014 at 02:44:03PM +0100, Will Deacon wrote:
> > > Hello,
> > > 
> > > This RFC series attempts to define a portable (i.e. cross-architecture)
> > > definition of the {readX,writeX}_relaxed MMIO accessor functions. These
> > > functions are already in widespread use amongst drivers (mainly those supporting
> > > devices embedded in ARM SoCs), but lack any well-defined semantics and,
> > > subsequently, any portable definitions to allow these drivers to be compiled for
> > > other architectures.
> > 
> > Could this be made in such a way that only architectures that need
> > to provide their own versions actually have to add them?
> > 
> > The current patch-set adds the same dummy defines all over,
> > and will put this burden also on new architectures.
> 
> It shouldn't be a burden for new architectures, as they will use
> asm-generic/io.h and get the definitions from there.

Why is it then necesary to do this for sparc:
diff --git a/arch/sparc/include/asm/io.h b/arch/sparc/include/asm/io.h
index f6902cf3cbe9..493f22c4684f 100644
--- a/arch/sparc/include/asm/io.h
+++ b/arch/sparc/include/asm/io.h
@@ -10,6 +10,15 @@
  * Defines used for both SPARC32 and SPARC64
  */

+/* Relaxed accessors for MMIO */
+#define readb_relaxed(__addr)          readb(__addr)
+#define readw_relaxed(__addr)          readw(__addr)
+#define readl_relaxed(__addr)          readl(__addr)
+
+#define writeb_relaxed(__b, __addr)    writeb(__b, __addr)
+#define writew_relaxed(__w, __addr)    writew(__w, __addr)
+#define writel_relaxed(__l, __addr)    writel(__l, __addr)

And similar for several other architectures.

For asm-generic/io.h:
+#ifndef readb_relaxed
+#define readb_relaxed  readb
+#endif

This has same effect as the above.
Only difference is that the implementation in asm-generic lacks the arguments.

The patch also breaks the pattern that the #define foobar foobar is
on the line just above the static inline that implements the function.

-#define readw readw
+#define readw          readw

+#ifndef readw_relaxed
+#define readw_relaxed  readw
+#endif
Move this blow below the static inline would make this easier to understand.

 static inline u16 readw(const volatile void __iomem *addr)
 {
        return __le16_to_cpu(__raw_readw(addr));
 }


	Sam
