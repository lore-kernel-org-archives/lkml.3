Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbaDSLdX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 07:33:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.24]:62654 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaDSLdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 07:33:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Rob Herring <robherring2@gmail.com>
Subject: Re: [PATCH 4/8] tty/serial: add generic serial earlycon
Date: Sat, 19 Apr 2014 13:32:24 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "x86@kernel.org" <x86@kernel.org>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Jiri Slaby <jslaby@suse.cz>
References: <1395436128-11244-1-git-send-email-robherring2@gmail.com> <21117957.8m9iUdR1VN@wuerfel> <CAL_JsqJwKQ_KuWWQNZHrMh8NwwiubB2jR+g-Y2n_dH4kJ5zVow@mail.gmail.com>
In-Reply-To: <CAL_JsqJwKQ_KuWWQNZHrMh8NwwiubB2jR+g-Y2n_dH4kJ5zVow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201404191332.24392.arnd@arndb.de>
X-Provags-ID: V02:K0:aaAi2lVSv1JxDGs8gRyhJeqohqn9xyWDkvaY1vxn3lQ
 sssAfq2cF3ayVpTCFS0i+gkIQwwrE25PT/PzA5PUI6K+QpUj4Z
 YsyC7XoVCx7MzQZZowOujkzZIhEWVQILVirCPSI01GaR0z+zum
 c2ogzOJ3IV3a1TbM4YpKWkMulkGgYlwfxloyT3Ou31FKoeK33e
 Rh1TUn4gAUKqC1XIbCFyegEWlGkTQB0uJd84RAIdArUDwLdu9M
 a0n/MMi/V3HgqAXk3uM2ZaRfl5QXDn+7x/9CUIpen4abF/6O5y
 N/KlMCShc7PINn3/gsPpWivAz/2khdPuP2p8Y/YwLJTeXqATkM
 7fsPUJWJpavr6C9R7N2Gj1Sd5jJNBhxa9LxTqPFP9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 17 April 2014, Rob Herring wrote:
> On Mon, Mar 24, 2014 at 10:42 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Monday 24 March 2014 08:36:46 Rob Herring wrote:
> >> On Mon, Mar 24, 2014 at 6:29 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> >> > On Monday 24 March 2014 11:22:03 Catalin Marinas wrote:
> >> >> On Fri, Mar 21, 2014 at 09:08:44PM +0000, Rob Herring wrote:
> >> >> > diff --git a/drivers/tty/serial/earlycon.c b/drivers/tty/serial/earlycon.c
> >> >> > new file mode 100644
> >> >> > index 0000000..241757a
> >> >> > --- /dev/null
> >> >> > +++ b/drivers/tty/serial/earlycon.c
> >> >> [...]
> >> >> > +static void __iomem * __init earlycon_map(unsigned long paddr, size_t size)
> >> >> > +{
> >> >> > +   void __iomem *base;
> >> >> > +#ifdef CONFIG_FIX_EARLYCON_MEM
> >> >> > +   set_fixmap_nocache(FIX_EARLYCON_MEM_BASE, paddr & PAGE_MASK);
> >> >> > +   base = (void __iomem *)__fix_to_virt(FIX_EARLYCON_MEM_BASE);
> >> >> > +   base += paddr & ~PAGE_MASK;
> >> >> > +#else
> >> >> > +   base = ioremap_nocache(paddr, size);
> >> >> > +#endif
> >> >>
> >> >> Just curious why not set_fixmap_io (and plain ioremap)?
> >> >
> >> > Good point. Note that ioremap_nocache() is the same as ioremap()
> >> > on *all* architectures.
> 
> Did you mean "not the same"?

No

> Why are there 2 flavors if they are
> always the same.

I assume it's just a mistake someone made a long time ago and nobody
ever changed it because they didn't want to break obscure code.

x86 seems to be a bit odd here, because is has both page-table
and MTRR method of setting up whether an access can be cached or not.
This may have led to the introduction of the _nocache variant, when
the regular ioremap was already uncached on all other architectures
but cached on x86.

	Arnd
