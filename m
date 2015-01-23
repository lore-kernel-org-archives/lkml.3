Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbbAWXvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 18:51:17 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:60644 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbbAWXvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 18:51:14 -0500
Date: Fri, 23 Jan 2015 17:51:11 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Federico <federicotg@gmail.com>, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH v2] pci: Fix infinite loop with ROM image of size 0
Message-ID: <20150123235111.GX29776@google.com>
References: <CAFUqUc6JPgSK4tTP7KuJ8TmVLZR6Abaf9uHUTRZA+OJhv8DoBA@mail.gmail.com>
 <1421657600-31561-1-git-send-email-michel@daenzer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1421657600-31561-1-git-send-email-michel@daenzer.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 05:53:20PM +0900, Michel Dänzer wrote:
> From: Michel Dänzer <michel.daenzer@amd.com>
> 
> If the image size would ever read as 0, pci_get_rom_size could keep
> processing the same image over and over again.
> 
> Reported-by: Federico <federicotg@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Michel Dänzer <michel.daenzer@amd.com>

Applied with Alex's ack to pci/resource for v3.20, thanks!

> ---
> 
> v2:
> * Use unsigned instead of u16 for the local length variable (not sure if
>   the multiplication by 512 could overflow otherwise)
> * Integrate length condition into while statement
> * Add stable tag
> 
>  drivers/pci/rom.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/pci/rom.c b/drivers/pci/rom.c
> index f955edb..eb0ad53 100644
> --- a/drivers/pci/rom.c
> +++ b/drivers/pci/rom.c
> @@ -71,6 +71,7 @@ size_t pci_get_rom_size(struct pci_dev *pdev, void __iomem *rom, size_t size)
>  {
>  	void __iomem *image;
>  	int last_image;
> +	unsigned length;
>  
>  	image = rom;
>  	do {
> @@ -93,9 +94,9 @@ size_t pci_get_rom_size(struct pci_dev *pdev, void __iomem *rom, size_t size)
>  		if (readb(pds + 3) != 'R')
>  			break;
>  		last_image = readb(pds + 21) & 0x80;
> -		/* this length is reliable */
> -		image += readw(pds + 16) * 512;
> -	} while (!last_image);
> +		length = readw(pds + 16);
> +		image += length * 512;
> +	} while (length && !last_image);
>  
>  	/* never return a size larger than the PCI resource window */
>  	/* there are known ROMs that get the size wrong */
> -- 
> 2.1.4
> 
