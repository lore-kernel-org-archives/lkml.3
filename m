Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297Ab3C1PQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:16:22 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:44045 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab3C1PQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:16:06 -0400
Message-ID: <51545EB0.7020600@suse.cz>
Date: Thu, 28 Mar 2013 16:16:00 +0100
From: Jiri Slaby <jslaby@suse.cz>
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

Hi, back from Rome, I suppose ;).

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
> 
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

To me, it seems that v1 of the patch was merged. Could you fix this up?

[Coverity revealed this.]

thanks,
-- 
js
suse labs
