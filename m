Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174AbaGVVd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 17:33:57 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:56476 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563AbaGVVdz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 17:33:55 -0400
MIME-Version: 1.0
In-Reply-To: <1404901036-27682-2-git-send-email-antoine.tenart@free-electrons.com>
References: <1404901036-27682-1-git-send-email-antoine.tenart@free-electrons.com>
	<1404901036-27682-2-git-send-email-antoine.tenart@free-electrons.com>
Date: Tue, 22 Jul 2014 16:33:54 -0500
Message-ID: <CADYTM3ZijsqSUTvBEscJCP94aWCPahPJ1se+g0+ssqwcE_yAxg@mail.gmail.com>
Subject: Re: [PATCH 1/4] usb: move the OTG state from the USB PHY to the OTG structure
From: Bin Liu <binmlist@gmail.com>
To: =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@free-electrons.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, Peter.Chen@freescale.com,
        kishon@ti.com, stern@rowland.harvard.edu,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jul 9, 2014 at 5:17 AM, Antoine Ténart
<antoine.tenart@free-electrons.com> wrote:
> Before using the PHY framework instead of the USB PHY one, we need to
> move the OTG state into another place, since it won't be available when
> USB PHY isn't used. This patch moves the OTG state into the OTG
> structure, and makes all the needed modifications in the drivers
> using the OTG state.
>
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>  drivers/phy/phy-omap-usb2.c         |  8 +---
>  drivers/usb/chipidea/debug.c        |  3 +-
>  drivers/usb/chipidea/otg_fsm.c      | 12 ++---
>  drivers/usb/common/usb-otg-fsm.c    |  8 ++--
>  drivers/usb/host/ohci-omap.c        |  2 +-
>  drivers/usb/musb/am35x.c            | 28 +++++------
>  drivers/usb/musb/blackfin.c         | 18 +++----
>  drivers/usb/musb/da8xx.c            | 28 +++++------
>  drivers/usb/musb/davinci.c          | 18 +++----
>  drivers/usb/musb/musb_core.c        | 94 ++++++++++++++++++-------------------
>  drivers/usb/musb/musb_dsps.c        | 26 +++++-----
>  drivers/usb/musb/musb_gadget.c      | 36 +++++++-------
>  drivers/usb/musb/musb_host.c        |  8 ++--
>  drivers/usb/musb/musb_virthub.c     | 22 ++++-----
>  drivers/usb/musb/omap2430.c         | 30 ++++++------
>  drivers/usb/musb/tusb6010.c         | 40 ++++++++--------
>  drivers/usb/musb/ux500.c            | 10 ++--
>  drivers/usb/phy/phy-ab8500-usb.c    | 10 ++--
>  drivers/usb/phy/phy-fsl-usb.c       | 10 ++--
>  drivers/usb/phy/phy-generic.c       |  4 +-
>  drivers/usb/phy/phy-gpio-vbus-usb.c | 10 ++--
>  drivers/usb/phy/phy-msm-usb.c       | 34 +++++++-------
>  drivers/usb/phy/phy-mv-usb.c        | 46 +++++++++---------
>  include/linux/usb/otg.h             |  2 +
>  include/linux/usb/phy.h             |  1 -
>  25 files changed, 252 insertions(+), 256 deletions(-)
>
> diff --git a/drivers/phy/phy-omap-usb2.c b/drivers/phy/phy-omap-usb2.c
> index 7007c11fe07d..1f444f91ed7d 100644
> --- a/drivers/phy/phy-omap-usb2.c
> +++ b/drivers/phy/phy-omap-usb2.c
> @@ -80,11 +80,9 @@ static int omap_usb_start_srp(struct usb_otg *otg)
>
>  static int omap_usb_set_host(struct usb_otg *otg, struct usb_bus *host)
>  {
> -       struct usb_phy  *phy = otg->phy;
> -
>         otg->host = host;
>         if (!host)
> -               phy->state = OTG_STATE_UNDEFINED;
> +               otg->state = OTG_STATE_UNDEFINED;
>
>         return 0;
>  }
> @@ -92,11 +90,9 @@ static int omap_usb_set_host(struct usb_otg *otg, struct usb_bus *host)
>  static int omap_usb_set_peripheral(struct usb_otg *otg,
>                 struct usb_gadget *gadget)
>  {
> -       struct usb_phy  *phy = otg->phy;
> -
>         otg->gadget = gadget;
>         if (!gadget)
> -               phy->state = OTG_STATE_UNDEFINED;
> +               otg->state = OTG_STATE_UNDEFINED;
>
>         return 0;
>  }
> diff --git a/drivers/usb/chipidea/debug.c b/drivers/usb/chipidea/debug.c
> index 7cccab6ff308..9a9702773e43 100644
> --- a/drivers/usb/chipidea/debug.c
> +++ b/drivers/usb/chipidea/debug.c
> @@ -219,8 +219,7 @@ int ci_otg_show(struct seq_file *s, void *unused)
>         fsm = &ci->fsm;
>
>         /* ------ State ----- */
> -       seq_printf(s, "OTG state: %s\n\n",

Is this line removed by accident?

> -               usb_otg_state_string(ci->transceiver->state));
> +               usb_otg_state_string(ci->transceiver->otg.state));
>
>         /* ------ State Machine Variables ----- */

<snip>

Regards,
-Bin.
