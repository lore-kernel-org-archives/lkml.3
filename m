Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957AbaEIQWn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 12:22:43 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:47995 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520AbaEIQWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 12:22:42 -0400
Date: Fri, 9 May 2014 10:22:36 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: peterhuewe@gmx.de, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [tpmdd-devel] [PATCH] tpm: missing tpm_chip_put in
 tpm_get_random()
Message-ID: <20140509162235.GA16647@obsidianresearch.com>
References: <1399634590-8360-1-git-send-email-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399634590-8360-1-git-send-email-jarkko.sakkinen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 02:23:10PM +0300, Jarkko Sakkinen wrote:
> Regression in 41ab999c. Call to tpm_chip_put is missing. This
> will cause TPM device driver not to unload if tmp_get_random()
> is called.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Reviewed-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>

>  drivers/char/tpm/tpm-interface.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
> index 62e10fd..4ea4d52 100644
> +++ b/drivers/char/tpm/tpm-interface.c
> @@ -991,13 +991,13 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
>  	int err, total = 0, retries = 5;
>  	u8 *dest = out;
>  
> +	if (!out || !num_bytes || max > TPM_MAX_RNG_DATA)
> +		return -EINVAL;
> +
>  	chip = tpm_chip_find_get(chip_num);
>  	if (chip == NULL)
>  		return -ENODEV;
>  
> -	if (!out || !num_bytes || max > TPM_MAX_RNG_DATA)
> -		return -EINVAL;
> -
>  	do {
>  		tpm_cmd.header.in = tpm_getrandom_header;
>  		tpm_cmd.params.getrandom_in.num_bytes = cpu_to_be32(num_bytes);
> @@ -1016,6 +1016,7 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
>  		num_bytes -= recd;
>  	} while (retries-- && total < max);
>  
> +	tpm_chip_put(chip);
>  	return total ? total : -EIO;
>  }
>  EXPORT_SYMBOL_GPL(tpm_get_random);
