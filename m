Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbaHZThW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 15:37:22 -0400
Received: from mout.gmx.net ([212.227.15.18]:50725 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbaHZThU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 15:37:20 -0400
Message-ID: <53FCE1DB.5070900@gmx.de>
Date: Tue, 26 Aug 2014 21:36:59 +0200
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v3 4/5] parisc: use seq_hex_dump() to dump buffers
References: <1408957395-404-1-git-send-email-andriy.shevchenko@linux.intel.com> <1408957395-404-5-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1408957395-404-5-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:ooupcm9Xtrk4BrbilrqxMKfHPc6sTs1lmQYvIQgXU+6oT/VpIUH
 ZfHW4fRBmyQoR8IRVGmhJBQ4zxhh6nS0gQoqxp75JACig0k30ZsOmbG53maKXVo2jTORxOk
 aYbcIwBT5RX5OFbG7Vf0zTyj99/5mJ1rBnXEXtz86jENmMQD9wFwtMALZAKSewBSRqqBYKH
 KwK2IY7WWLkUpEfRqXjow==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andy,

On 08/25/2014 11:03 AM, Andy Shevchenko wrote:
> Instead of custom approach let's use recently introduced seq_hex_dump() helper.
>
> In one case it changes the output from
> 	1111111122222222333333334444444455555555666666667777777788888888
> to
> 	11111111 22222222 33333333 44444444 55555555 66666666 77777777 88888888
>
> though it seems it prints same data (by meaning) in both cases. I decide to
> choose to use the space divided one.

That's OK.

> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

I compile-tested the patch on parisc and runtime-checked the changes to the
sba_iommu.c driver. Everything seems OK. Please add my Acked-by.

Acked-by: Helge Deller <deller@gmx.de>

Thanks!
Helge

> ---
>   drivers/parisc/ccio-dma.c  | 14 +++-----------
>   drivers/parisc/sba_iommu.c | 11 +++--------
>   2 files changed, 6 insertions(+), 19 deletions(-)
>
> diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
> index 8b490d7..9d353d2 100644
> --- a/drivers/parisc/ccio-dma.c
> +++ b/drivers/parisc/ccio-dma.c
> @@ -1101,20 +1101,12 @@ static const struct file_operations ccio_proc_info_fops = {
>
>   static int ccio_proc_bitmap_info(struct seq_file *m, void *p)
>   {
> -	int len = 0;
>   	struct ioc *ioc = ioc_list;
>
>   	while (ioc != NULL) {
> -		u32 *res_ptr = (u32 *)ioc->res_map;
> -		int j;
> -
> -		for (j = 0; j < (ioc->res_size / sizeof(u32)); j++) {
> -			if ((j & 7) == 0)
> -				len += seq_puts(m, "\n   ");
> -			len += seq_printf(m, "%08x", *res_ptr);
> -			res_ptr++;
> -		}
> -		len += seq_puts(m, "\n\n");
> +		seq_hex_dump(m, "   ", DUMP_PREFIX_NONE, 32, 4, ioc->res_map,
> +			     ioc->res_size, false);
> +		seq_putc(m, '\n');
>   		ioc = ioc->next;
>   		break; /* XXX - remove me */
>   	}
> diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
> index 1ff1b67..fbc4db9 100644
> --- a/drivers/parisc/sba_iommu.c
> +++ b/drivers/parisc/sba_iommu.c
> @@ -1857,15 +1857,10 @@ sba_proc_bitmap_info(struct seq_file *m, void *p)
>   {
>   	struct sba_device *sba_dev = sba_list;
>   	struct ioc *ioc = &sba_dev->ioc[0];	/* FIXME: Multi-IOC support! */
> -	unsigned int *res_ptr = (unsigned int *)ioc->res_map;
> -	int i, len = 0;
>
> -	for (i = 0; i < (ioc->res_size/sizeof(unsigned int)); ++i, ++res_ptr) {
> -		if ((i & 7) == 0)
> -			len += seq_printf(m, "\n   ");
> -		len += seq_printf(m, " %08x", *res_ptr);
> -	}
> -	len += seq_printf(m, "\n");
> +	seq_hex_dump(m, "   ", DUMP_PREFIX_NONE, 32, 4, ioc->res_map,
> +		     ioc->res_size, false);
> +	seq_printf(m, "\n");
>
>   	return 0;
>   }
>

