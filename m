Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934751Ab3BTKoa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 05:44:30 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:56385 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932912Ab3BTKo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 05:44:27 -0500
Date: Wed, 20 Feb 2013 12:44:18 +0200
From: Ido Yariv <ido@wizery.com>
To: sjur.brandeland@stericsson.com
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>, sjur@brendeland.net
Subject: Re: [PATCH 2/9] remoteproc: Refactor function
 rproc_elf_find_rsc_table
Message-ID: <20130220104418.GB16388@WorkStation.localnet>
References: <1360496352-29482-1-git-send-email-sjur.brandeland@stericsson.com>
 <1360496352-29482-3-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1360496352-29482-3-git-send-email-sjur.brandeland@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

Sorry for the (very) late reply.

On Sun, Feb 10, 2013 at 12:39:05PM +0100, sjur.brandeland@stericsson.com wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
> 
> Refactor rproc_elf_find_rsc_table and split out the scanning
> for the section header named resource table. This is done to
> prepare for loading firmware once.
> 
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> ---
>  drivers/remoteproc/remoteproc_elf_loader.c |   79 ++++++++++++++++++----------
>  1 files changed, 52 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/remoteproc/remoteproc_elf_loader.c b/drivers/remoteproc/remoteproc_elf_loader.c
> index 0d36f94..a958950 100644
> --- a/drivers/remoteproc/remoteproc_elf_loader.c
> +++ b/drivers/remoteproc/remoteproc_elf_loader.c
> @@ -208,38 +208,19 @@ rproc_elf_load_segments(struct rproc *rproc, const struct firmware *fw)
>  	return ret;
>  }
>  
> -/**
> - * rproc_elf_find_rsc_table() - find the resource table
> - * @rproc: the rproc handle
> - * @fw: the ELF firmware image
> - * @tablesz: place holder for providing back the table size
> - *
> - * This function finds the resource table inside the remote processor's
> - * firmware. It is used both upon the registration of @rproc (in order
> - * to look for and register the supported virito devices), and when the
> - * @rproc is booted.
> - *
> - * Returns the pointer to the resource table if it is found, and write its
> - * size into @tablesz. If a valid table isn't found, NULL is returned
> - * (and @tablesz isn't set).
> - */
> -static struct resource_table *
> -rproc_elf_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
> -							int *tablesz)
> +static struct elf32_shdr *
> +find_rsc_shdr(struct device *dev, struct elf32_hdr *ehdr, size_t fw_size)
>  {
> -	struct elf32_hdr *ehdr;
>  	struct elf32_shdr *shdr;
> +	int i;
>  	const char *name_table;
> -	struct device *dev = &rproc->dev;
>  	struct resource_table *table = NULL;
> -	int i;
> -	const u8 *elf_data = fw->data;
> +	const u8 *elf_data = (void *)ehdr;
>  
> -	ehdr = (struct elf32_hdr *)elf_data;
> +	/* look for the resource table and handle it */
>  	shdr = (struct elf32_shdr *)(elf_data + ehdr->e_shoff);
>  	name_table = elf_data + shdr[ehdr->e_shstrndx].sh_offset;
>  
> -	/* look for the resource table and handle it */
>  	for (i = 0; i < ehdr->e_shnum; i++, shdr++) {
>  		int size = shdr->sh_size;
>  		int offset = shdr->sh_offset;
> @@ -250,7 +231,7 @@ rproc_elf_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
>  		table = (struct resource_table *)(elf_data + offset);
>  
>  		/* make sure we have the entire table */
> -		if (offset + size > fw->size) {
> +		if (offset + size > fw_size) {

While we're at it, perhaps also verify that there aren't any integer overflows
here?

>  			dev_err(dev, "resource table truncated\n");
>  			return NULL;
>  		}
> @@ -280,10 +261,54 @@ rproc_elf_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
>  			return NULL;
>  		}
>  
> -		*tablesz = shdr->sh_size;
> -		break;
> +		return shdr;
>  	}
>  
> +	return NULL;
> +}
> +
> +/**
> + * rproc_elf_find_rsc_table() - find the resource table
> + * @rproc: the rproc handle
> + * @fw: the ELF firmware image
> + * @tablesz: place holder for providing back the table size
> + *
> + * This function finds the resource table inside the remote processor's
> + * firmware. It is used both upon the registration of @rproc (in order
> + * to look for and register the supported virito devices), and when the
> + * @rproc is booted.
> + *
> + * Returns the pointer to the resource table if it is found, and write its
> + * size into @tablesz. If a valid table isn't found, NULL is returned
> + * (and @tablesz isn't set).
> + */
> +static struct resource_table *
> +rproc_elf_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
> +							int *tablesz)
> +{
> +	struct elf32_hdr *ehdr;
> +	struct elf32_shdr *shdr;
> +
> +	struct device *dev = &rproc->dev;
> +	struct resource_table *table = NULL;
> +
> +	const u8 *elf_data = fw->data;
> +

Mind removing empty lines here?

> +	ehdr = (struct elf32_hdr *)elf_data;
> +
> +	shdr = find_rsc_shdr(dev, ehdr, fw->size);
> +	if (!shdr)
> +		return NULL;
> +
> +	/* make sure we have the entire table */
> +	if (shdr->sh_offset + shdr->sh_size > fw->size) {
> +		dev_err(dev, "resource table truncated\n");
> +		return NULL;
> +	}

Any reason for this explicit assertion? It seemed to be checked in
find_rsc_shdr.

> +
> +	table = (struct resource_table *)(elf_data + shdr->sh_offset);
> +	*tablesz = shdr->sh_size;
> +
>  	return table;
>  }
>  
> -- 
> 1.7.5.4
> 

Thanks,
Ido.
