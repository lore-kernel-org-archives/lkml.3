Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547AbaETHeO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 03:34:14 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:59849 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752402AbaETHeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 03:34:12 -0400
MIME-Version: 1.0
In-Reply-To: <1400535540-5959-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1400535540-5959-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Tue, 20 May 2014 09:34:11 +0200
Message-ID: <CAJSP0QViU7OKuQ9JoX8OrDv_o8xTzHkTDVbxehEBfJdG2_Ps_A@mail.gmail.com>
Subject: Re: [PATCH] staging: line6: toneport.c: Fix for possible null pointer dereference
From: Stefan Hajnoczi <stefanha@gmail.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2014 at 11:39 PM, Rickard Strandqvist
<rickard_strandqvist@spectrumdigital.se> wrote:
> There is otherwise a risk of a possible null pointer dereference.
>
> Was largely found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>  drivers/staging/line6/toneport.c |   14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/staging/line6/toneport.c b/drivers/staging/line6/toneport.c
> index af2e7e5..36fe76d 100644
> --- a/drivers/staging/line6/toneport.c
> +++ b/drivers/staging/line6/toneport.c
> @@ -431,11 +431,15 @@ void line6_toneport_disconnect(struct usb_interface *interface)
>  {
>         struct usb_line6_toneport *toneport;
>         u16 idProduct;
> +       struct snd_line6_pcm *line6pcm;
>
>         if (interface == NULL)
>                 return;
>
>         toneport = usb_get_intfdata(interface);
> +       if (toneport == NULL)
> +               return;
> +
>         del_timer_sync(&toneport->timer);
>         idProduct = le16_to_cpu(toneport->line6.usbdev->descriptor.idProduct);
>
> @@ -444,13 +448,11 @@ void line6_toneport_disconnect(struct usb_interface *interface)
>                 device_remove_file(&interface->dev, &dev_attr_led_green);
>         }
>
> -       if (toneport != NULL) {
> -               struct snd_line6_pcm *line6pcm = toneport->line6.line6pcm;

Didn't look into this but it's the traditional "use before NULL
check".  Can't hurt to fix it.

Reviewed-by: Stefan Hajnoczi <stefanha@gmail.com>
