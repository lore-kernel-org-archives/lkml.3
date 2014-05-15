Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145AbaEOMyE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 08:54:04 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:34527 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbaEOMyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 08:54:01 -0400
MIME-Version: 1.0
In-Reply-To: <1400076025-5103-2-git-send-email-holler@ahsoftware.de>
References: <1400076025-5103-1-git-send-email-holler@ahsoftware.de>
	<1400076025-5103-2-git-send-email-holler@ahsoftware.de>
Date: Thu, 15 May 2014 15:54:00 +0300
Message-ID: <CABBYNZLFutVy=Msz7=AAwXmo4wDHjv59GcLCedEzSrWjkLQ3cw@mail.gmail.com>
Subject: Re: [PATCH 2/2] bluetooth: raise HCI_CMD_TIMEOUT from 2s to 8s
From: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander,

On Wed, May 14, 2014 at 5:00 PM, Alexander Holler <holler@ahsoftware.de> wrote:
> The reasoning to do this is the following:
>
> - If a timeout occurs, the HCI-communication is broken afterwards and the
>   dongle isn't usable anymore.
> - If it works after e.g. waiting 4s everyone is still happy but if it
>   just breaks after only waiting 2s nothing is gained.
> - Having to wait some more seconds until an error occurs doesn't change
>   anything.
>
> So there is no disadvantage in rasing the timeout but a great advantage
> in case the dongle needs more than 2s to process an HCI command.
> E.g. I had sometimes HCI command timeouts at boot (but never after the BT stack
> was successfull started). I assume the reason might be the USB-probing which
> happend before through the bootloader, which might have confused the dongle
> such that it needs a bit more time, but I'm not sure.
>
> Together with the patch which limits the timeout only to the actual time the
> dongle needs to process an HCI command (and doesn't include the time the
> kernel needs to process the answer to an HCI command), my problems were gone.
>
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> ---
>  include/net/bluetooth/hci.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> index be150cf..d50fd34 100644
> --- a/include/net/bluetooth/hci.h
> +++ b/include/net/bluetooth/hci.h
> @@ -180,7 +180,7 @@ enum {
>  #define HCI_DISCONN_TIMEOUT    msecs_to_jiffies(2000)  /* 2 seconds */
>  #define HCI_PAIRING_TIMEOUT    msecs_to_jiffies(60000) /* 60 seconds */
>  #define HCI_INIT_TIMEOUT       msecs_to_jiffies(10000) /* 10 seconds */
> -#define HCI_CMD_TIMEOUT                msecs_to_jiffies(2000)  /* 2 seconds */
> +#define HCI_CMD_TIMEOUT                msecs_to_jiffies(8000)  /* 8 seconds */
>  #define HCI_ACL_TX_TIMEOUT     msecs_to_jiffies(45000) /* 45 seconds */
>  #define HCI_AUTO_OFF_TIMEOUT   msecs_to_jiffies(2000)  /* 2 seconds */
>  #define HCI_POWER_OFF_TIMEOUT  msecs_to_jiffies(5000)  /* 5 seconds */
> --
> 1.8.3.1

This timeout seems arbitrary so I suppose we can increase it if we
feel it is necessary but we used already different timeout for
different commands like HCI_POWER_OFF_TIMEOUT, so perhaps if we can
identify which command is more likely to timeout.

We could perhaps auto reset if a command timeout if there is really no
other way to recover.


-- 
Luiz Augusto von Dentz
