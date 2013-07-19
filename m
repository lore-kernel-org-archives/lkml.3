Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964929Ab3GSKMP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 06:12:15 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:17980 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab3GSKMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 06:12:13 -0400
X-IronPort-AV: E=Sophos;i="4.89,700,1367971200"; 
   d="scan'208";a="6869501"
Message-ID: <1374228731.13645.45.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH] arm: choose debug/uncompress.h include when uncompress
 debug is disabled
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Julien Grall <julien.grall@linaro.org>, <linux@arm.linux.org.uk>,
        "Patch Tracking" <patches@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, "Olof Johansson" <olof@lixom.net>
Date: Fri, 19 Jul 2013 11:12:11 +0100
In-Reply-To: <alpine.DEB.2.02.1307191103520.8258@kaball.uk.xensource.com>
References: <1373897706-15331-1-git-send-email-julien.grall@linaro.org>
	   <alpine.DEB.2.02.1307171420350.8258@kaball.uk.xensource.com>
	   <CAPnVf8yH7PBOSSC57qJv+pWmsinRUxGr81QUPH9GoOkKw2oo3Q@mail.gmail.com>
	  <1374222736.26728.128.camel@kazak.uk.xensource.com>
	 <alpine.DEB.2.02.1307191049070.8258@kaball.uk.xensource.com>
	 <1374228043.13645.44.camel@kazak.uk.xensource.com>
	 <alpine.DEB.2.02.1307191103520.8258@kaball.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-19 at 11:06 +0100, Stefano Stabellini wrote:
> On Fri, 19 Jul 2013, Ian Campbell wrote:
> > On Fri, 2013-07-19 at 10:52 +0100, Stefano Stabellini wrote:
> > > On Fri, 19 Jul 2013, Ian Campbell wrote:
> > > > On Thu, 2013-07-18 at 17:15 +0100, Julien Grall wrote:
> > > > > On 17 July 2013 14:25, Stefano Stabellini
> > > > > <stefano.stabellini@eu.citrix.com> wrote:
> > > > > > On Mon, 15 Jul 2013, Julien Grall wrote:
> > > > > >> Even if uncompress debug is disabled, some board will continue to print
> > > > > >> information during uncompress step.
> > > > > >
> > > > > > Are you talking about DEBUG_UNCOMPRESS?
> > > > > > Should I read the sentence as "even if DEBUG_UNCOMPRESS is not selected,
> > > > > > some board will continue to print information during the uncompress step"?
> > > > > 
> > > > > Yes. On the arndale, uncompress log are directly output on UART-2.
> > > > > This is annoying because Xen doesn't expose the UART to dom0.
> > > > 
> > > > This is because Xen wants/tries to use the UART as its own console,
> > > > right?
> > > > 
> > > > There are at least two other options: Either Xen uses a different UART
> > > > to that configured statically into the kernel image (depends on how many
> > > > UARTs the platform exposes) or Xen uses no serial console at all.
> > > > 
> > > > Of course long term we just need to wait for the exynos stuff to get
> > > > integrated into the multiplatform kernel.
> > > > 
> > > > Having no Xen serial console is not as bad as it seems for actual
> > > > deployment, it is actually already the default on x86 (a serial console
> > > > needs to be explicitly configured). The Xen console would still be
> > > > available via the "xl dmesg" command and for debug environments people
> > > > can just hack around the issue for now (until MP kernels arrive for the
> > > > platform).
> > > > 
> > > > Perhaps a useful compromise would be for Xen to initially use the
> > > > console but to hand it over to dom0 once it starts (similar to how we
> > > > handle VGA where it is present), Xen could also steal it back on panic
> > > > (since dom0 isn't going to be using it after that...).
> > > 
> > > I like this last option, it looks like the best compromise.
> > > 
> > > 
> > > > Alternatively, since these early UART routines tend to be pretty simple
> > > > polled affairs, we could also consider extending the existing vpl011
> > > > code to have platform configurable addresses for the output and status
> > > > registers and a configurable fixed value for the read of the status
> > > > register. I'm not keen to have this code turn into a full "emulator" but
> > > > so long as it stays within the remit given in vpl011.c:
> > > >         /*
> > > >          * This is not intended to be a full emulation of a PL011
> > > >          * device. Rather it is intended to provide a sufficient veneer of one
> > > >          * that early code (such as Linux's boot time decompressor) which
> > > >          * hardcodes output directly to such a device are able to make progress.
> > > >          *
> > > >          * This device is not intended to be enumerable or exposed to the OS
> > > >          * (e.g. via Device Tree).
> > > >          */
> > > > then I think I could live with it getting a bit more flexible about
> > > > where the registers live in order to be able to handle more UART
> > > > variants.
> > >  
> > > We could end up emulating way too many devices and not all the platforms
> > > expect a pl011 uart.
> > 
> > My point was that all of these debug routines expect exactly two things:
> >   * An output register where they can write a character
> >   * A status register which when read indicates that a new byte can be 
> >     sent
> > 
> > The existing pl011.c could be extended to provide this level of
> > functionality for *any* UART, at least to the degree required by this
> > code, almost trivially, by simply making the two addresses and the
> > static status register value configurable.
> > 
> > The status register value is static for us because we have no FIFOs and
> > just accumulate into a buffer to be sent to the real console, so it is
> > always possible to send another byte.
> > 
> > ISTR some talk of doing something similar for the early-printk stuff via
> > DT, might have imagined that though...
>  
> That's interesting but what about the meaning of the various bits of the
> status register? It's not going to be always the same for the various
> uarts, we would need to take into account at least that.

Yes, hence making the static value read from the status register
configurable too.

Ian.


