Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934358Ab3DHHSk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 03:18:40 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:58403 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934336Ab3DHHSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 03:18:39 -0400
Message-ID: <51626F4E.1000005@suse.cz>
Date: Mon, 08 Apr 2013 09:18:38 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] tty: mxser: fix cycle termination condition in mxser_probe()
 and mxser_module_init()
References: <51545EB0.7020600@suse.cz> <1365364007-6298-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1365364007-6298-1-git-send-email-khoroshilov@ispras.ru>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2013 09:46 PM, Alexey Khoroshilov wrote:
> There is a bug in resources deallocation code in mxser_probe() and mxser_module_init().
> As soon as variable 'i' is unsigned int, cycle termination condition i >= 0 is always true.
> The patch fixes the issue.
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Yes, thanks.

Acked-by: Jiri Slaby <jslaby@suse.cz>

> ---
>  drivers/tty/mxser.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
> index 484b6a3..302909c 100644
> --- a/drivers/tty/mxser.c
> +++ b/drivers/tty/mxser.c
> @@ -2643,9 +2643,9 @@ static int mxser_probe(struct pci_dev *pdev,
>  				mxvar_sdriver, brd->idx + i, &pdev->dev);
>  		if (IS_ERR(tty_dev)) {
>  			retval = PTR_ERR(tty_dev);
> -			for (i--; i >= 0; i--)
> +			for (; i > 0; i--)
>  				tty_unregister_device(mxvar_sdriver,
> -					brd->idx + i);
> +					brd->idx + i - 1);
>  			goto err_relbrd;
>  		}
>  	}
> @@ -2751,9 +2751,9 @@ static int __init mxser_module_init(void)
>  			tty_dev = tty_port_register_device(&brd->ports[i].port,
>  					mxvar_sdriver, brd->idx + i, NULL);
>  			if (IS_ERR(tty_dev)) {
> -				for (i--; i >= 0; i--)
> +				for (; i > 0; i--)
>  					tty_unregister_device(mxvar_sdriver,
> -						brd->idx + i);
> +						brd->idx + i - 1);
>  				for (i = 0; i < brd->info->nports; i++)
>  					tty_port_destroy(&brd->ports[i].port);
>  				free_irq(brd->irq, brd);
> 


-- 
js
suse labs
