Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359AbaDVNor (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:44:47 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:46540 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756015AbaDVNog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:44:36 -0400
Date: Tue, 22 Apr 2014 14:43:45 +0100
From: Will Deacon <will.deacon@arm.com>
To: Sam Ravnborg <sam@ravnborg.org>
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
Message-ID: <20140422134345.GD9820@arm.com>
References: <1397742261-15621-1-git-send-email-will.deacon@arm.com>
 <20140417153638.GA7317@ravnborg.org>
 <20140417154714.GD30553@arm.com>
 <20140417191555.GA11970@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140417191555.GA11970@ravnborg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sam,

On Thu, Apr 17, 2014 at 08:15:55PM +0100, Sam Ravnborg wrote:
> On Thu, Apr 17, 2014 at 04:47:15PM +0100, Will Deacon wrote:
> > On Thu, Apr 17, 2014 at 04:36:38PM +0100, Sam Ravnborg wrote:
> > > On Thu, Apr 17, 2014 at 02:44:03PM +0100, Will Deacon wrote:
> > > > This RFC series attempts to define a portable (i.e. cross-architecture)
> > > > definition of the {readX,writeX}_relaxed MMIO accessor functions. These
> > > > functions are already in widespread use amongst drivers (mainly those supporting
> > > > devices embedded in ARM SoCs), but lack any well-defined semantics and,
> > > > subsequently, any portable definitions to allow these drivers to be compiled for
> > > > other architectures.
> > > 
> > > Could this be made in such a way that only architectures that need
> > > to provide their own versions actually have to add them?
> > > 
> > > The current patch-set adds the same dummy defines all over,
> > > and will put this burden also on new architectures.
> > 
> > It shouldn't be a burden for new architectures, as they will use
> > asm-generic/io.h and get the definitions from there.
> 
> Why is it then necesary to do this for sparc:
> diff --git a/arch/sparc/include/asm/io.h b/arch/sparc/include/asm/io.h
> index f6902cf3cbe9..493f22c4684f 100644
> --- a/arch/sparc/include/asm/io.h
> +++ b/arch/sparc/include/asm/io.h
> @@ -10,6 +10,15 @@
>   * Defines used for both SPARC32 and SPARC64
>   */
> 
> +/* Relaxed accessors for MMIO */
> +#define readb_relaxed(__addr)          readb(__addr)
> +#define readw_relaxed(__addr)          readw(__addr)
> +#define readl_relaxed(__addr)          readl(__addr)
> +
> +#define writeb_relaxed(__b, __addr)    writeb(__b, __addr)
> +#define writew_relaxed(__w, __addr)    writew(__w, __addr)
> +#define writel_relaxed(__l, __addr)    writel(__l, __addr)
> 
> And similar for several other architectures.

This is because Sparc (and the other architectures I had to modify) don't
make use of asm-generic/io.h. Furthermore, it's not as simple as adding an
include, since you'll pull in the generic definitions of things like readw
and inb as it stands.

We could make a new asm-generic file purely for the relaxed accessors, but
I really don't think it's worth the hassle.

> For asm-generic/io.h:
> +#ifndef readb_relaxed
> +#define readb_relaxed  readb
> +#endif
> 
> This has same effect as the above.
> Only difference is that the implementation in asm-generic lacks the arguments.

I just followed the existing style in asm-generic/io.h.

> The patch also breaks the pattern that the #define foobar foobar is
> on the line just above the static inline that implements the function.
> 
> -#define readw readw
> +#define readw          readw
> 
> +#ifndef readw_relaxed
> +#define readw_relaxed  readw
> +#endif
> Move this blow below the static inline would make this easier to understand.
> 
>  static inline u16 readw(const volatile void __iomem *addr)
>  {
>         return __le16_to_cpu(__raw_readw(addr));
>  }

Sure, I can fix that.

Will
