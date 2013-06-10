Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab3FJUkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 16:40:21 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:34689 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab3FJUkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 16:40:20 -0400
MIME-Version: 1.0
In-Reply-To: <1370892556-14503-1-git-send-email-khoroshilov@ispras.ru>
References: <1370892556-14503-1-git-send-email-khoroshilov@ispras.ru>
Date: Mon, 10 Jun 2013 22:40:19 +0200
Message-ID: <CAAfyv348JfJs-FbL3zvQgQ1i=MONVJWdhgfmqzdYOvGxcPAK0Q@mail.gmail.com>
Subject: Re: [PATCH] staging: ft1000: fix memory leak on error path in ft1000_probe()
From: Belisko Marek <marek.belisko@gmail.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, LKML <linux-kernel@vger.kernel.org>,
        ldv-project@linuxtesting.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

On Mon, Jun 10, 2013 at 9:29 PM, Alexey Khoroshilov
<khoroshilov@ispras.ru> wrote:
> ft1000dev->tx_urb and ft1000dev->rx_urb are not deallocated
> if something goes wrong in ft1000_probe(). Also there is no
> check for success of urb allocation. The patch fixes the both issues.
>
> By the way, there is no sense in GFP_ATOMIC for urb allocation here,
> so it is changed to GFP_KERNEL.
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/staging/ft1000/ft1000-usb/ft1000_usb.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
> index 614db55..29a7cd2 100644
> --- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
> +++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
> @@ -79,8 +79,12 @@ static int ft1000_probe(struct usb_interface *interface,
>         ft1000dev->dev = dev;
>         ft1000dev->status = 0;
>         ft1000dev->net = NULL;
> -       ft1000dev->tx_urb = usb_alloc_urb(0, GFP_ATOMIC);
> -       ft1000dev->rx_urb = usb_alloc_urb(0, GFP_ATOMIC);
> +       ft1000dev->tx_urb = usb_alloc_urb(0, GFP_KERNEL);
Can we check return value for tx here? If allocation fails it makes no sense to
try allocate also rx. Otherwise looks good. Thanks.
> +       ft1000dev->rx_urb = usb_alloc_urb(0, GFP_KERNEL);
Same for rx here.
> +       if (!ft1000dev->tx_urb || !ft1000dev->rx_urb) {
> +               ret = -ENOMEM;
> +               goto err_fw;
> +       }
>
>         DEBUG("ft1000_probe is called\n");
>         numaltsetting = interface->num_altsetting;
> @@ -209,6 +213,8 @@ err_thread:
>  err_load:
>         kfree(pFileStart);
>  err_fw:
> +       usb_free_urb(ft1000dev->rx_urb);
> +       usb_free_urb(ft1000dev->tx_urb);
>         kfree(ft1000dev);
>         return ret;
>  }
> --
> 1.8.1.2
>

marek

--
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
