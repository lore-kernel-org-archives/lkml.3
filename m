Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760104Ab3GSJwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 05:52:16 -0400
Received: from smtp.citrix.com ([66.165.176.89]:40414 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197Ab3GSJwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 05:52:14 -0400
X-IronPort-AV: E=Sophos;i="4.89,700,1367971200"; 
   d="scan'208";a="38014231"
Date: Fri, 19 Jul 2013 10:52:00 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Julien Grall <julien.grall@linaro.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <linux@arm.linux.org.uk>, Patch Tracking <patches@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] arm: choose debug/uncompress.h include when uncompress
 debug is disabled
In-Reply-To: <1374222736.26728.128.camel@kazak.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1307191049070.8258@kaball.uk.xensource.com>
References: <1373897706-15331-1-git-send-email-julien.grall@linaro.org>  <alpine.DEB.2.02.1307171420350.8258@kaball.uk.xensource.com>  <CAPnVf8yH7PBOSSC57qJv+pWmsinRUxGr81QUPH9GoOkKw2oo3Q@mail.gmail.com> <1374222736.26728.128.camel@kazak.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Jul 2013, Ian Campbell wrote:
> On Thu, 2013-07-18 at 17:15 +0100, Julien Grall wrote:
> > On 17 July 2013 14:25, Stefano Stabellini
> > <stefano.stabellini@eu.citrix.com> wrote:
> > > On Mon, 15 Jul 2013, Julien Grall wrote:
> > >> Even if uncompress debug is disabled, some board will continue to print
> > >> information during uncompress step.
> > >
> > > Are you talking about DEBUG_UNCOMPRESS?
> > > Should I read the sentence as "even if DEBUG_UNCOMPRESS is not selected,
> > > some board will continue to print information during the uncompress step"?
> > 
> > Yes. On the arndale, uncompress log are directly output on UART-2.
> > This is annoying because Xen doesn't expose the UART to dom0.
> 
> This is because Xen wants/tries to use the UART as its own console,
> right?
> 
> There are at least two other options: Either Xen uses a different UART
> to that configured statically into the kernel image (depends on how many
> UARTs the platform exposes) or Xen uses no serial console at all.
> 
> Of course long term we just need to wait for the exynos stuff to get
> integrated into the multiplatform kernel.
> 
> Having no Xen serial console is not as bad as it seems for actual
> deployment, it is actually already the default on x86 (a serial console
> needs to be explicitly configured). The Xen console would still be
> available via the "xl dmesg" command and for debug environments people
> can just hack around the issue for now (until MP kernels arrive for the
> platform).
> 
> Perhaps a useful compromise would be for Xen to initially use the
> console but to hand it over to dom0 once it starts (similar to how we
> handle VGA where it is present), Xen could also steal it back on panic
> (since dom0 isn't going to be using it after that...).

I like this last option, it looks like the best compromise.


> Alternatively, since these early UART routines tend to be pretty simple
> polled affairs, we could also consider extending the existing vpl011
> code to have platform configurable addresses for the output and status
> registers and a configurable fixed value for the read of the status
> register. I'm not keen to have this code turn into a full "emulator" but
> so long as it stays within the remit given in vpl011.c:
>         /*
>          * This is not intended to be a full emulation of a PL011
>          * device. Rather it is intended to provide a sufficient veneer of one
>          * that early code (such as Linux's boot time decompressor) which
>          * hardcodes output directly to such a device are able to make progress.
>          *
>          * This device is not intended to be enumerable or exposed to the OS
>          * (e.g. via Device Tree).
>          */
> then I think I could live with it getting a bit more flexible about
> where the registers live in order to be able to handle more UART
> variants.
 
We could end up emulating way too many devices and not all the platforms
expect a pl011 uart.
