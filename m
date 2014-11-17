Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbaKQVV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 16:21:28 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:42723 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaKQVV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 16:21:26 -0500
MIME-Version: 1.0
In-Reply-To: <1416230077-17535-1-git-send-email-kever.yang@rock-chips.com>
References: <1416230077-17535-1-git-send-email-kever.yang@rock-chips.com>
Date: Mon, 17 Nov 2014 13:21:25 -0800
X-Google-Sender-Auth: Y-NQdvJAQrXKV50-h1ShGqn5PL8
Message-ID: <CAODwPW8r0cq2aozVjY9o9wOwqa4Nn1Oom9+Td8e-H0FoDf-LfQ@mail.gmail.com>
Subject: Re: [PATCH] usb: dwc2: resume root hub when device detect with
 suspend state
From: Julius Werner <jwerner@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Paul Zimmerman <paulz@synopsys.com>, Felipe Balbi <balbi@ti.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Romain Perier <romain.perier@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Douglas Anderson <dianders@chromium.org>,
        Sonny Rao <sonnyrao@chromium.org>, addy ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, wulf <wulf@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        Roy Li <roy.li@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 5:14 AM, Kever Yang <kever.yang@rock-chips.com> wrote:
> After we implement the bus_suspend/resume, auto suspend id enabled.
> The root hub will be auto suspend if there is no device connected,
> we need to resume the root hub when a device connect detect.
>
> This patch tested on rk3288.
>
> Signed-off-by: Roy Li <roy.li@rock-chips.com>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> ---
>
>  drivers/usb/dwc2/hcd_intr.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/drivers/usb/dwc2/hcd_intr.c b/drivers/usb/dwc2/hcd_intr.c
> index 551ba87..c8299fd 100644
> --- a/drivers/usb/dwc2/hcd_intr.c
> +++ b/drivers/usb/dwc2/hcd_intr.c
> @@ -355,6 +355,13 @@ static void dwc2_port_intr(struct dwc2_hsotg *hsotg)
>                 hprt0_modify |= HPRT0_CONNDET;
>
>                 /*
> +                * Check if root hub is in suspend state
> +                * if root hub in suspend, resume it.
> +                */
> +               if ((bus->root_hub) && (hcd->state == HC_STATE_SUSPENDED))

What is bus->root_hub checking for? Is there any chance that this
could be NULL here?

> +                       usb_hcd_resume_root_hub(hcd);
> +
> +               /*
>                  * The Hub driver asserts a reset when it sees port connect
>                  * status change flag
>                  */
> --
> 1.9.1

Seems sensible in general. Does this actually fix the problem Doug was
reporting?
