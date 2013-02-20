Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934838Ab3BTKoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 05:44:54 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:49202 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932714Ab3BTKox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 05:44:53 -0500
Date: Wed, 20 Feb 2013 12:44:46 +0200
From: Ido Yariv <ido@wizery.com>
To: sjur.brandeland@stericsson.com
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>, sjur@brendeland.net
Subject: Re: [PATCH 3/9] remoteproc: Parse ELF file to find resource table
 address
Message-ID: <20130220104446.GC16388@WorkStation.localnet>
References: <1360496352-29482-1-git-send-email-sjur.brandeland@stericsson.com>
 <1360496352-29482-4-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1360496352-29482-4-git-send-email-sjur.brandeland@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Sun, Feb 10, 2013 at 12:39:06PM +0100, sjur.brandeland@stericsson.com wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
> 
> Add function find_rsc_table_va to firmware ops. This function
> returns the location of the resource table in shared memory
> after loading.
> 
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> ---
>  drivers/remoteproc/remoteproc_elf_loader.c |   17 ++++++++++++++++-
>  drivers/remoteproc/remoteproc_internal.h   |   13 +++++++++++++
>  2 files changed, 29 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/remoteproc/remoteproc_elf_loader.c b/drivers/remoteproc/remoteproc_elf_loader.c
> index a958950..3137fba 100644
> --- a/drivers/remoteproc/remoteproc_elf_loader.c
> +++ b/drivers/remoteproc/remoteproc_elf_loader.c
> @@ -312,9 +312,24 @@ rproc_elf_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
>  	return table;
>  }
>  
> +struct resource_table *rproc_elf_get_rsctab_addr(struct rproc *rproc,
> +						 const struct firmware *fw)
> +{
> +	struct elf32_shdr *shdr;
> +
> +	shdr = find_rsc_shdr(&rproc->dev, (struct elf32_hdr *)fw->data,
> +				fw->size);
> +	if (!shdr)
> +		return NULL;
> +
> +	/* Find resource table in loaded segments */
> +	return rproc_da_to_va(rproc, shdr->sh_addr, shdr->sh_size);
> +}
> +
>  const struct rproc_fw_ops rproc_elf_fw_ops = {
>  	.load = rproc_elf_load_segments,
>  	.find_rsc_table = rproc_elf_find_rsc_table,
>  	.sanity_check = rproc_elf_sanity_check,
> -	.get_boot_addr = rproc_elf_get_boot_addr
> +	.get_boot_addr = rproc_elf_get_boot_addr,
> +	.get_rsctab_addr = rproc_elf_get_rsctab_addr

Since this new op returns a VA (unlike get_boot_addr), it would probably be
better to use an indicative name like get_rsctab_va.

>  };
> diff --git a/drivers/remoteproc/remoteproc_internal.h b/drivers/remoteproc/remoteproc_internal.h
> index 7bb6648..3a5cb7d 100644
> --- a/drivers/remoteproc/remoteproc_internal.h
> +++ b/drivers/remoteproc/remoteproc_internal.h
> @@ -32,6 +32,7 @@ struct rproc;
>   *			expects to find it
>   * @sanity_check:	sanity check the fw image
>   * @get_boot_addr:	get boot address to entry point specified in firmware
> + * @get_rsctab_addr:	get resouce table address as specified in firmware
>   */
>  struct rproc_fw_ops {
>  	struct resource_table *(*find_rsc_table) (struct rproc *rproc,
> @@ -40,6 +41,8 @@ struct rproc_fw_ops {
>  	int (*load)(struct rproc *rproc, const struct firmware *fw);
>  	int (*sanity_check)(struct rproc *rproc, const struct firmware *fw);
>  	u32 (*get_boot_addr)(struct rproc *rproc, const struct firmware *fw);
> +	struct resource_table *(*get_rsctab_addr)(struct rproc *rproc,
> +						const struct firmware *fw);
>  };
>  
>  /* from remoteproc_core.c */
> @@ -102,6 +105,16 @@ struct resource_table *rproc_find_rsc_table(struct rproc *rproc,
>  	return NULL;
>  }
>  
> +static inline
> +struct resource_table *rproc_get_rsctab_addr(struct rproc *rproc,
> +				const struct firmware *fw)
> +{
> +	if (rproc->fw_ops->get_rsctab_addr)
> +		return rproc->fw_ops->get_rsctab_addr(rproc, fw);
> +
> +	return NULL;
> +}
> +
>  extern const struct rproc_fw_ops rproc_elf_fw_ops;
>  
>  #endif /* REMOTEPROC_INTERNAL_H */
> -- 
> 1.7.5.4
> 

Thanks,
Ido.
