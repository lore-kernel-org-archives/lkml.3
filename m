Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751289AbaALWBq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 17:01:46 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:52754 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaALWBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 17:01:19 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: linux-kernel@lists.codethink.co.uk,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Linus SH list <linux-sh@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] ARM: shmobile: compile drivers/sh for CONFIG_ARCH_SHMOBILE_MULTI
Date: Sun, 12 Jan 2014 23:01:59 +0100
Message-ID: <4441342.H8MHOLBobb@avalon>
User-Agent: KMail/4.10.5 (Linux/3.10.25-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <2820428.J065BbN1jW@avalon>
References: <1389445589-21502-1-git-send-email-ben.dooks@codethink.co.uk> <2820428.J065BbN1jW@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Sunday 12 January 2014 22:54:15 Laurent Pinchart wrote:
> Hi Ben,
> 
> Thank you for the patch.
> 
> On Saturday 11 January 2014 13:06:29 Ben Dooks wrote:
> > If the kernel is built to support multi-arm configurmation with shmobile
> > support built in, then the drivers/sh is not built. This contains drivers
> > that are essential to devices support by that configuration, including the
> > PM runtime code in drivers/sh/pm_runtime.c (which implicitly enables the
> > bus clocks for all devices).

Thinking a bit more about this, I think the approach taken in 
drivers/sh/pm_runtime.c isn't good. The code enables device clocks when 
devices are bound to a driver, increasing power consumption when devices are 
idle. Instead of enabling it for ARCH_SHMOBILE_MULTI I'd like to either add 
explicit clock support to drivers, or to integrate clocks with runtime PM 
only.

> > If CONFIG_ARCH_SHMOBILE_MULTI then build the drivers/sh directory,
> > but ensure that bits that may conflict (drivers/sh/clk if the common
> > clock framework is not enabled) are built.
> > 
> > The ARCH_SHMOBILE_MULTI was added by efacfce5f8a ("ARM: shmobile:
> > Introduce ARCH_SHMOBILE_MULTI") but this has only just recently been found
> > due to building device-tree only kernels.
> > 
> > Cc: Linux Kernel list <linux-kernel@vger.kernel.org>
> > Cc: Linus SH list <linux-sh@vger.kernel.org>
> > Cc: Simon Horman <horms@verge.net.au>
> > Cc: Magnus Damm <magnus.damm@gmail.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> > ---
> > 
> >  drivers/Makefile    | 1 +
> >  drivers/sh/Makefile | 3 +++
> >  2 files changed, 4 insertions(+)
> > 
> > diff --git a/drivers/Makefile b/drivers/Makefile
> > index 8e3b8b0..abc4744 100644
> > --- a/drivers/Makefile
> > +++ b/drivers/Makefile
> > @@ -118,6 +118,7 @@ obj-$(CONFIG_SGI_SN)		+= sn/
> > 
> >  obj-y				+= firmware/
> >  obj-$(CONFIG_CRYPTO)		+= crypto/
> >  obj-$(CONFIG_SUPERH)		+= sh/
> > 
> > +obj-$(CONFIG_ARCH_SHMOBILE_MULTI)	+= sh/
> > 
> >  obj-$(CONFIG_ARCH_SHMOBILE_LEGACY)	+= sh/
> >  ifndef CONFIG_ARCH_USES_GETTIMEOFFSET
> >  obj-y				+= clocksource/
> > 
> > diff --git a/drivers/sh/Makefile b/drivers/sh/Makefile
> > index fc67f56..86604a5 100644
> > --- a/drivers/sh/Makefile
> > +++ b/drivers/sh/Makefile
> > @@ -3,7 +3,10 @@
> > 
> >  #
> >  obj-y	:= intc/
> 
> Is intc needed as well ?
> 
> > +ifeq ($(CONFIG_COMMON_CLK),n)
> > 
> >  obj-$(CONFIG_HAVE_CLK)		+= clk/
> > 
> > +endif
> > +
> > 
> >  obj-$(CONFIG_MAPLE)		+= maple/
> >  obj-$(CONFIG_SUPERHYWAY)	+= superhyway/
-- 
Regards,

Laurent Pinchart

