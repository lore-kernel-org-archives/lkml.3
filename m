Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756840AbaHHBMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 21:12:24 -0400
Received: from regular1.263xmail.com ([211.150.99.130]:45006 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756256AbaHHBMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 21:12:22 -0400
X-263anti-spam: BIG:0;KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 1
X-KSVirus-check: 0
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: linux-kernel@vger.kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <0a47ed347c0baf87e311e957b9035af4>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
Message-ID: <53E423EC.6090309@rock-chips.com>
Date: Fri, 08 Aug 2014 09:12:12 +0800
From: Kever Yang <kever.yang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>
CC: Dinh Nguyen <dinguyen@altera.com>, Sonny Rao <sonnyrao@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>, linux-arm-kernel@lists.infradead.org,
        paulz@synopsys.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: dwc2: Read GNPTXFSIZ when in forced HOST mode.
References: <1407440891-29295-1-git-send-email-dianders@chromium.org>
In-Reply-To: <1407440891-29295-1-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug:

On 08/08/2014 03:48 AM, Doug Anderson wrote:
> The documentation for GNPTXFSIZ says that "For host mode, this field
> is always valid."  Since we're already switching to host mode for
> HPTXFSIZ, let's also read GNPTXFSIZ in host mode.
>
> On an rk3288 SoC, without this change we see this at bootup:
>    dwc2 ff580000.usb: gnptxfsiz=00100400
>    dwc2 ff580000.usb: 128 invalid for host_nperio_tx_fifo_size. Check HW configuration.
>
> After this change we see:
>    dwc2 ff580000.usb: gnptxfsiz=04000400
Yeap, that is the problem cause the log you shown in rk3288-evb and 
further more
cause fifo setting fail.

I was plan to commit this patch just the same as you did.
It's great that you also find out the problem and send this patch.
>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>   drivers/usb/dwc2/core.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/usb/dwc2/core.c b/drivers/usb/dwc2/core.c
> index 27d2c9b..c184ed43 100644
> --- a/drivers/usb/dwc2/core.c
> +++ b/drivers/usb/dwc2/core.c
> @@ -2674,23 +2674,23 @@ int dwc2_get_hwparams(struct dwc2_hsotg *hsotg)
>   	hwcfg2 = readl(hsotg->regs + GHWCFG2);
>   	hwcfg3 = readl(hsotg->regs + GHWCFG3);
>   	hwcfg4 = readl(hsotg->regs + GHWCFG4);
> -	gnptxfsiz = readl(hsotg->regs + GNPTXFSIZ);
>   	grxfsiz = readl(hsotg->regs + GRXFSIZ);
>   
>   	dev_dbg(hsotg->dev, "hwcfg1=%08x\n", hwcfg1);
>   	dev_dbg(hsotg->dev, "hwcfg2=%08x\n", hwcfg2);
>   	dev_dbg(hsotg->dev, "hwcfg3=%08x\n", hwcfg3);
>   	dev_dbg(hsotg->dev, "hwcfg4=%08x\n", hwcfg4);
> -	dev_dbg(hsotg->dev, "gnptxfsiz=%08x\n", gnptxfsiz);
>   	dev_dbg(hsotg->dev, "grxfsiz=%08x\n", grxfsiz);
>   
> -	/* Force host mode to get HPTXFSIZ exact power on value */
> +	/* Force host mode to get HPTXFSIZ / GNPTXFSIZ exact power on value */
>   	gusbcfg = readl(hsotg->regs + GUSBCFG);
>   	gusbcfg |= GUSBCFG_FORCEHOSTMODE;
>   	writel(gusbcfg, hsotg->regs + GUSBCFG);
>   	usleep_range(100000, 150000);
>   
> +	gnptxfsiz = readl(hsotg->regs + GNPTXFSIZ);
>   	hptxfsiz = readl(hsotg->regs + HPTXFSIZ);
> +	dev_dbg(hsotg->dev, "gnptxfsiz=%08x\n", gnptxfsiz);
>   	dev_dbg(hsotg->dev, "hptxfsiz=%08x\n", hptxfsiz);
>   	gusbcfg = readl(hsotg->regs + GUSBCFG);
>   	gusbcfg &= ~GUSBCFG_FORCEHOSTMODE;
There may be a potential problem still need to fix, the grxfsiz may have 
being changed,
the bootrom and uboot will change this value if they use the dwc2 
controller.
The way we get the register value here can not make sure this is the 
power-on
value which we actually need.

Let me do more test for that, and maybe we need another patch.

Anyway, this patch works and reasonable.

Reviewed-by: Kever Yang <kever.yang@rock-chips.com>



