Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758437Ab3BSNCj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 08:02:39 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:52100 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758382Ab3BSNCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 08:02:37 -0500
Message-ID: <512377E9.4020704@gmail.com>
Date: Tue, 19 Feb 2013 14:02:33 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH v2] tty: mxser: improve error handling in mxser_probe()
 and mxser_module_init()
References: <51228a02.BjrxclRZRRerxqem%fengguang.wu@intel.com> <1361253463-30627-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1361253463-30627-1-git-send-email-khoroshilov@ispras.ru>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 06:57 AM, Alexey Khoroshilov wrote:
> 1. Currently mxser_probe() and mxser_module_init() ignore errors
> that can happen in tty_port_register_device().
> 2. mxser_module_init() does not deallocate resources allocated in mxser_get_ISA_conf()
> if mxser_initbrd() failed.
> 
> The patch adds proper error handling in all the cases.
> Also it moves free_irq() from mxser_release_ISA_res() to mxser_board_remove(),
> since it makes mxser_release_ISA_res() a counterpart for mxser_get_ISA_conf(),
> while free_irq() is relevant to both ISA and PCI boards.
> 
> Found by Linux Driver Verification project (linuxtesting.org).

Looks good to me, thanks.

> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> ---
>  drivers/tty/mxser.c |   42 +++++++++++++++++++++++++++++++++++-------
>  1 file changed, 35 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
> index 4011386..deeb5ad 100644
> --- a/drivers/tty/mxser.c
> +++ b/drivers/tty/mxser.c
> @@ -2364,7 +2364,6 @@ static void mxser_release_vector(struct mxser_board *brd)
>  
>  static void mxser_release_ISA_res(struct mxser_board *brd)
>  {
> -	free_irq(brd->irq, brd);
>  	release_region(brd->ports[0].ioaddr, 8 * brd->info->nports);
>  	mxser_release_vector(brd);
>  }
> @@ -2430,6 +2429,7 @@ static void mxser_board_remove(struct mxser_board *brd)
>  		tty_unregister_device(mxvar_sdriver, brd->idx + i);
>  		tty_port_destroy(&brd->ports[i].port);
>  	}
> +	free_irq(brd->irq, brd);
>  }
>  
>  static int __init mxser_get_ISA_conf(int cap, struct mxser_board *brd)
> @@ -2554,6 +2554,7 @@ static int mxser_probe(struct pci_dev *pdev,
>  	struct mxser_board *brd;
>  	unsigned int i, j;
>  	unsigned long ioaddress;
> +	struct device *tty_dev;
>  	int retval = -EINVAL;
>  
>  	for (i = 0; i < MXSER_BOARDS; i++)
> @@ -2637,13 +2638,25 @@ static int mxser_probe(struct pci_dev *pdev,
>  	if (retval)
>  		goto err_rel3;
>  
> -	for (i = 0; i < brd->info->nports; i++)
> -		tty_port_register_device(&brd->ports[i].port, mxvar_sdriver,
> -				brd->idx + i, &pdev->dev);
> +	for (i = 0; i < brd->info->nports; i++) {
> +		tty_dev = tty_port_register_device(&brd->ports[i].port,
> +				mxvar_sdriver, brd->idx + i, &pdev->dev);
> +		if (IS_ERR(tty_dev)) {
> +			retval = PTR_ERR(tty_dev);
> +			for (; i > 0; i--)
> +				tty_unregister_device(mxvar_sdriver,
> +					brd->idx + i - 1);
> +			goto err_relbrd;
> +		}
> +	}
>  
>  	pci_set_drvdata(pdev, brd);
>  
>  	return 0;
> +err_relbrd:
> +	for (i = 0; i < brd->info->nports; i++)
> +		tty_port_destroy(&brd->ports[i].port);
> +	free_irq(brd->irq, brd);
>  err_rel3:
>  	pci_release_region(pdev, 3);
>  err_zero:
> @@ -2665,7 +2678,6 @@ static void mxser_remove(struct pci_dev *pdev)
>  
>  	mxser_board_remove(brd);
>  
> -	free_irq(pdev->irq, brd);
>  	pci_release_region(pdev, 2);
>  	pci_release_region(pdev, 3);
>  	pci_disable_device(pdev);
> @@ -2683,6 +2695,7 @@ static struct pci_driver mxser_driver = {
>  static int __init mxser_module_init(void)
>  {
>  	struct mxser_board *brd;
> +	struct device *tty_dev;
>  	unsigned int b, i, m;
>  	int retval;
>  
> @@ -2728,14 +2741,29 @@ static int __init mxser_module_init(void)
>  
>  		/* mxser_initbrd will hook ISR. */
>  		if (mxser_initbrd(brd, NULL) < 0) {
> +			mxser_release_ISA_res(brd);
>  			brd->info = NULL;
>  			continue;
>  		}
>  
>  		brd->idx = m * MXSER_PORTS_PER_BOARD;
> -		for (i = 0; i < brd->info->nports; i++)
> -			tty_port_register_device(&brd->ports[i].port,
> +		for (i = 0; i < brd->info->nports; i++) {
> +			tty_dev = tty_port_register_device(&brd->ports[i].port,
>  					mxvar_sdriver, brd->idx + i, NULL);
> +			if (IS_ERR(tty_dev)) {
> +				for (; i > 0; i--)
> +					tty_unregister_device(mxvar_sdriver,
> +						brd->idx + i - 1);
> +				for (i = 0; i < brd->info->nports; i++)
> +					tty_port_destroy(&brd->ports[i].port);
> +				free_irq(brd->irq, brd);
> +				mxser_release_ISA_res(brd);
> +				brd->info = NULL;
> +				break;
> +			}
> +		}
> +		if (brd->info == NULL)
> +			continue;
>  
>  		m++;
>  	}
> 


-- 
js
