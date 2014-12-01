Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaLAIhf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 03:37:35 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:62869 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbaLAIhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 03:37:32 -0500
MIME-Version: 1.0
In-Reply-To: <1417213750-8856-1-git-send-email-khoroshilov@ispras.ru>
References: <1417213750-8856-1-git-send-email-khoroshilov@ispras.ru>
Date: Mon, 1 Dec 2014 10:37:31 +0200
Message-ID: <CABdoFFcNkT=ixz+H3pJJdMrOd2g73GHsXXmrESt6ex9fC9Y+Aw@mail.gmail.com>
Subject: Re: [PATCH] usbip: fix error handling in stub_probe()
From: Valentina Manea <valentina.manea.m@gmail.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Shuah Khan <shuah.kh@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        ldv-project@linuxtesting.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 29, 2014 at 12:29 AM, Alexey Khoroshilov
<khoroshilov@ispras.ru> wrote:
> If usb_hub_claim_port() fails, no resources are deallocated and
> if stub_add_files() fails, port is not released.
>
> The patch fixes these issues and rearranges error handling code.
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/usb/usbip/stub_dev.c | 26 +++++++++++++++-----------
>  1 file changed, 15 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/usb/usbip/stub_dev.c b/drivers/usb/usbip/stub_dev.c
> index fac20e0434c0..a3ec49bdc1e6 100644
> --- a/drivers/usb/usbip/stub_dev.c
> +++ b/drivers/usb/usbip/stub_dev.c
> @@ -311,7 +311,6 @@ static int stub_probe(struct usb_device *udev)
>  {
>         struct stub_device *sdev = NULL;
>         const char *udev_busid = dev_name(&udev->dev);
> -       int err = 0;
>         struct bus_id_priv *busid_priv;
>         int rc;
>
> @@ -372,23 +371,28 @@ static int stub_probe(struct usb_device *udev)
>                         (struct usb_dev_state *) udev);
>         if (rc) {
>                 dev_dbg(&udev->dev, "unable to claim port\n");
> -               return rc;
> +               goto err_port;
>         }
>
> -       err = stub_add_files(&udev->dev);
> -       if (err) {
> +       rc = stub_add_files(&udev->dev);
> +       if (rc) {
>                 dev_err(&udev->dev, "stub_add_files for %s\n", udev_busid);
> -               dev_set_drvdata(&udev->dev, NULL);
> -               usb_put_dev(udev);
> -               kthread_stop_put(sdev->ud.eh);
> -
> -               busid_priv->sdev = NULL;
> -               stub_device_free(sdev);
> -               return err;
> +               goto err_files;
>         }
>         busid_priv->status = STUB_BUSID_ALLOC;
>
>         return 0;
> +err_files:
> +       usb_hub_release_port(udev->parent, udev->portnum,
> +                            (struct usb_dev_state *) udev);
> +err_port:
> +       dev_set_drvdata(&udev->dev, NULL);
> +       usb_put_dev(udev);
> +       kthread_stop_put(sdev->ud.eh);
> +
> +       busid_priv->sdev = NULL;
> +       stub_device_free(sdev);
> +       return rc;
>  }
>
>  static void shutdown_busid(struct bus_id_priv *busid_priv)
> --
> 1.9.1
>

Nice catch.

Acked-by: Valentina Manea <valentina.manea.m@gmail.com>
