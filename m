Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138AbaKRQ6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:58:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33177 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbaKRQ6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:58:02 -0500
Date: Tue, 18 Nov 2014 08:58:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Peter Hung <hpeter@gmail.com>
Cc: jslaby@suse.cz, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hung <hpeter+linux_kernel@gmail.com>
Subject: Re: [PATCH] Fix IO address calculation with Multi-Fintek PCI-to-UART
 Product
Message-ID: <20141118165800.GA3708@kroah.com>
References: <1416304088-6049-1-git-send-email-hpeter+linux_kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416304088-6049-1-git-send-email-hpeter+linux_kernel@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 05:48:08PM +0800, Peter Hung wrote:
> Signed-off-by: Peter Hung <hpeter+linux_kernel@gmail.com>

We need some kind of information in the body of the changelog here.

> ---
>  drivers/tty/serial/8250/8250_pci.c | 37 ++++++++++++++++++++++++-------------
>  1 file changed, 24 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
> index 0468e15..255bc56 100644
> --- a/drivers/tty/serial/8250/8250_pci.c
> +++ b/drivers/tty/serial/8250/8250_pci.c
> @@ -1551,28 +1551,31 @@ static int pci_fintek_setup(struct serial_private *priv,
>  {
>  	struct pci_dev *pdev = priv->dev;
>  	unsigned long base;
> -	unsigned long iobase;
> +	unsigned long iobase = 0;
>  	unsigned long ciobase = 0;
>  	u8 config_base;
> +	u32 bar_data[3];
> +	
>  

_ALWAYS_ run your patches through checkpatch.pl and fix up the issues it
reports so that a grumpy maintainer doesn't reject your patch for
obvious issues :(



>  	/*
>  	 * We are supposed to be able to read these from the PCI config space,
>  	 * but the values there don't seem to match what we need to use, so
>  	 * just use these hard-coded values for now, as they are correct.
>  	 */
> +
>  	switch (idx) {
> -	case 0: iobase = 0xe000; config_base = 0x40; break;
> -	case 1: iobase = 0xe008; config_base = 0x48; break;
> -	case 2: iobase = 0xe010; config_base = 0x50; break;
> -	case 3: iobase = 0xe018; config_base = 0x58; break;
> -	case 4: iobase = 0xe020; config_base = 0x60; break;
> -	case 5: iobase = 0xe028; config_base = 0x68; break;
> -	case 6: iobase = 0xe030; config_base = 0x70; break;
> -	case 7: iobase = 0xe038; config_base = 0x78; break;
> -	case 8: iobase = 0xe040; config_base = 0x80; break;
> -	case 9: iobase = 0xe048; config_base = 0x88; break;
> -	case 10: iobase = 0xe050; config_base = 0x90; break;
> -	case 11: iobase = 0xe058; config_base = 0x98; break;
> +	case 0: config_base = 0x40; break;
> +	case 1: config_base = 0x48; break;
> +	case 2: config_base = 0x50; break;
> +	case 3: config_base = 0x58; break;
> +	case 4: config_base = 0x60; break;
> +	case 5: config_base = 0x68; break;
> +	case 6: config_base = 0x70; break;
> +	case 7: config_base = 0x78; break;
> +	case 8: config_base = 0x80; break;
> +	case 9: config_base = 0x88; break;
> +	case 10: config_base = 0x90; break;
> +	case 11: config_base = 0x98; break;
>  	default:
>  		/* Unknown number of ports, get out of here */
>  		return -EINVAL;
> @@ -1583,9 +1586,17 @@ static int pci_fintek_setup(struct serial_private *priv,
>  		ciobase = (int)(base + (0x8 * idx));
>  	}
>  
> +	pci_read_config_dword(pdev, 0x24, &bar_data[0]);
> +	pci_read_config_dword(pdev, 0x20, &bar_data[1]);
> +	pci_read_config_dword(pdev, 0x1c, &bar_data[2]);
> +
> +	/* Calculate Real IO Port */
> +	iobase = (bar_data[idx/4] & 0xffffffE0) + (idx % 4) * 8;
> +
>  	dev_dbg(&pdev->dev, "%s: idx=%d iobase=0x%lx ciobase=0x%lx config_base=0x%2x\n",
>  		__func__, idx, iobase, ciobase, config_base);
>  
> +

New line added for no reason?

thanks,

greg k-h
