Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752415Ab3LJSmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 13:42:32 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:32785 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab3LJSm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 13:42:27 -0500
X-Auth-Info: fa2oyrMQVCX0oJuLYkify0t77jMXIcmfgNQFxaEt7H8=
From: Marek Vasut <marex@denx.de>
To: Daniel Mack <zonque@gmail.com>
Subject: Re: [PATCH] ARM: pxa: prevent PXA270 occasional reboot freezes
Date: Tue, 10 Dec 2013 19:31:34 +0100
User-Agent: KMail/1.13.7 (Linux/3.10-2-amd64; KDE/4.10.5; x86_64; ; )
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Sergei Ianovich <ynvich@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Igor Grinberg <grinberg@compulab.co.il>
References: <1386650355-2503-1-git-send-email-ynvich@gmail.com> <52A6D44C.1010504@gmail.com> <52A6F19B.8090309@gmail.com>
In-Reply-To: <52A6F19B.8090309@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201312101931.34108.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 10, 2013 at 11:48:59 AM, Daniel Mack wrote:
> On 12/10/2013 09:43 AM, Haojian Zhuang wrote:
> > On 12/10/2013 12:39 PM, Sergei Ianovich wrote:
> >> Erratum 71 of PXA270M Processor Family Specification Update
> >> (April 19, 2010) explains that watchdog reset time is just
> >> 8us insead of 10ms in EMTS.
> >> 
> >> If SDRAM is not reset, it causes memory bus congestion and
> >> the device hangs. We put SDRAM in selfresh mode before watchdog
> >> reset, removing potential freezes.
> >> 
> >> Without this patch PXA270-based ICP DAS LP-8x4x hangs after up to 40
> >> reboots. With this patch it has successfully rebooted 500 times.
> >> 
> >> Signed-off-by: Sergei Ianovich <ynvich@gmail.com>
> >> ---
> >> 
> >>   arch/arm/mach-pxa/reset.c | 8 +++++++-
> >>   1 file changed, 7 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/arch/arm/mach-pxa/reset.c b/arch/arm/mach-pxa/reset.c
> >> index 0d5dd64..263b152 100644
> >> --- a/arch/arm/mach-pxa/reset.c
> >> +++ b/arch/arm/mach-pxa/reset.c
> >> @@ -13,6 +13,7 @@
> >> 
> >>   #include <mach/regs-ost.h>
> >>   #include <mach/reset.h>
> >> 
> >> +#include <mach/smemc.h>
> >> 
> >>   unsigned int reset_status;
> >>   EXPORT_SYMBOL(reset_status);
> >> 
> >> @@ -81,6 +82,12 @@ static void do_hw_reset(void)
> >> 
> >>   	writel_relaxed(OSSR_M3, OSSR);
> >>   	/* ... in 100 ms */
> >>   	writel_relaxed(readl_relaxed(OSCR) + 368640, OSMR3);
> >> 
> >> +	/*
> >> +	 * SDRAM hangs on watchdog reset on Marvell PXA270 (erratum 71)
> >> +	 * we put SDRAM into self-refresh to prevent that
> >> +	 */
> >> +	while (1)
> >> +		writel_relaxed(MDREFR_SLFRSH, MDREFR);
> >> 
> >>   }
> >>   
> >>   void pxa_restart(enum reboot_mode mode, const char *cmd)
> >> 
> >> @@ -104,4 +111,3 @@ void pxa_restart(enum reboot_mode mode, const char
> >> *cmd)
> >> 
> >>   		break;
> >>   	
> >>   	}
> >>   
> >>   }
> >> 
> >> -
> > 
> > Hi Daniel/Marek/Igor,
> > 
> > Could you help to try this patch? I'm lack of PXA27x board.
> 
> I don't have any either right now ...

On VPAC270

Tested-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut
