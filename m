Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404Ab3BXQVc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 11:21:32 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:62967 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758227Ab3BXQVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 11:21:31 -0500
Date: Sun, 24 Feb 2013 18:21:24 +0200
From: Ido Yariv <ido@wizery.com>
To: sjur.brandeland@stericsson.com
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Erwan Yvin <erwan.yvin@stericsson.com>, sjur@brendeland.net
Subject: Re: [PATCHv2 04/10] remoteproc: Parse ELF file to find resource
 table address
Message-ID: <20130224162124.GB19603@WorkStation.localnet>
References: <1361466940-6813-1-git-send-email-sjur.brandeland@stericsson.com>
 <1361466940-6813-5-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1361466940-6813-5-git-send-email-sjur.brandeland@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Thu, Feb 21, 2013 at 06:15:34PM +0100, sjur.brandeland@stericsson.com wrote:
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
> index ed12c16..3d6ec76 100644
> --- a/drivers/remoteproc/remoteproc_elf_loader.c
> +++ b/drivers/remoteproc/remoteproc_elf_loader.c
> @@ -304,9 +304,24 @@ rproc_elf_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
>  	return table;
>  }
>  
> +static struct resource_table *rproc_elf_get_rsctab_va(struct rproc *rproc,
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
> +	.get_rsctab_va = rproc_elf_get_rsctab_addr

There's a typo here, fixed in the next patch instead of this one, which
will break bisect.

Other than that this patch set looks good. This issue can be fixed when
the patches are merged, so I don't think there's a need to resend
another revision.

Thanks,
Ido.
