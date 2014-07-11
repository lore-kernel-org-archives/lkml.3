Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbaGKXda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 19:33:30 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:60347 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbaGKXd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 19:33:28 -0400
MIME-Version: 1.0
In-Reply-To: <1405059756-11983-2-git-send-email-gavin.guo@canonical.com>
References: <1405059756-11983-1-git-send-email-gavin.guo@canonical.com>
	<1405059756-11983-2-git-send-email-gavin.guo@canonical.com>
Date: Sat, 12 Jul 2014 07:33:26 +0800
Message-ID: <CA+eFSM08xnOnZUf=ChaqtiN8ZJsn=ZRft9rVZWSaewWK9HT6Wg@mail.gmail.com>
Subject: Re: [PATCH 1/1] usb: Check if port status is equal to RxDetect
From: Gavin Guo <gavin.guo@canonical.com>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        "Nyman, Mathias" <mathias.nyman@intel.com>, linux-usb@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org
Cc: YK <yk@canonical.com>, Anthony Wong <anthony.wong@canonical.com>,
        Gerald Yang <gerald.yang@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Fri, Jul 11, 2014 at 2:22 PM, Gavin Guo <gavin.guo@canonical.com> wrote:
> When using USB 3.0 pen drive with the [AMD] FCH USB XHCI Controller
> [1022:7814], the second hotplugging will experience the USB 3.0 pen
> drive is recognized as high-speed device. After bisecting the kernel,
> I found the commit number 41e7e056cdc662f704fa9262e5c6e213b4ab45dd
> (USB: Allow USB 3.0 ports to be disabled.) causes the bug. After doing
> some experiments, the bug can be fixed by avoiding executing the function
> hub_usb3_port_disable(). Because the port status with [AMD] FCH USB
> XHCI Controlleris [1022:7814] is already in RxDetect
> (I tried printing out the port status before setting to Disabled state),
> it's reasonable to check the port status before really executing
> hub_usb3_port_disable().
>
> Fixes: 41e7e056cdc6 (USB: Allow USB 3.0 ports to be disabled.)
> Signed-off-by: Gavin Guo <gavin.guo@canonical.com>
> ---
>  drivers/usb/core/hub.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
>
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index 21b99b4..e02ab62 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -889,6 +889,25 @@ static int hub_usb3_port_disable(struct usb_hub *hub, int port1)
>         if (!hub_is_superspeed(hub->hdev))
>                 return -EINVAL;
>
> +       ret = hub_port_status(hub, port1, &portstatus, &portchange);
> +       if (ret < 0)
> +               return ret;
> +
> +       /*
> +        * USB controller Advanced Micro Devices,
> +        * Inc. [AMD] FCH USB XHCI Controller [1022:7814] will have spurious result
> +        * making the following usb 3.0 device hotplugging route to the 2.0 root hub
> +        * and recognized as high-speed device if we set the usb 3.0 port link state
> +        *  to Disabled. Since it's already in USB_SS_PORT_LS_RX_DETECT state, we
> +        *  check the state here to avoid the bug.
> +        */
> +       if ((portstatus & USB_PORT_STAT_LINK_STATE) ==
> +                               USB_SS_PORT_LS_RX_DETECT) {
> +               dev_dbg(&hub->ports[port1 - 1]->dev,
> +                        "The link state is already in USB_SS_PORT_LS_RX_DETECT\n");
> +               return ret;
> +       }
> +
>         ret = hub_set_port_link_state(hub, port1, USB_SS_PORT_LS_SS_DISABLED);
>         if (ret)
>                 return ret;
> --
> 2.0.0
>

Add Greg k-h to the list.
