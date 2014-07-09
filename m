Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbaGIVJF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 17:09:05 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:58140 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaGIVIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 17:08:50 -0400
X-Auth-Info: b0XHPdGcdfRyJhcHCSMzOU/bRkdVpVxVH5C+VZDV2bs=
From: Marek Vasut <marex@denx.de>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v1 1/5] seq_file: provide an analogue of print_hex_dump()
Date: Wed, 9 Jul 2014 22:39:30 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>, linux390@de.ibm.com,
        Alexander Viro <viro@zeniv.linux.org.uk>, qat-linux@intel.com,
        linux-crypto@vger.kernel.org, linux-media@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1404919470-26668-1-git-send-email-andriy.shevchenko@linux.intel.com> <1404919470-26668-2-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1404919470-26668-2-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201407092239.30561.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 09, 2014 at 05:24:26 PM, Andy Shevchenko wrote:
> The new seq_hex_dump() is a complete analogue of print_hex_dump().
> 
> We have few users of this functionality already. It allows to reduce their
> codebase.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  fs/seq_file.c            | 35 +++++++++++++++++++++++++++++++++++
>  include/linux/seq_file.h |  4 ++++
>  2 files changed, 39 insertions(+)
> 
> diff --git a/fs/seq_file.c b/fs/seq_file.c
> index 3857b72..fec4a6b 100644
> --- a/fs/seq_file.c
> +++ b/fs/seq_file.c
> @@ -12,6 +12,7 @@
>  #include <linux/slab.h>
>  #include <linux/cred.h>
>  #include <linux/mm.h>
> +#include <linux/printk.h>
> 
>  #include <asm/uaccess.h>
>  #include <asm/page.h>
> @@ -794,6 +795,40 @@ void seq_pad(struct seq_file *m, char c)
>  }
>  EXPORT_SYMBOL(seq_pad);
> 
> +/* Analogue of print_hex_dump() */
> +void seq_hex_dump(struct seq_file *m, const char *prefix_str, int
> prefix_type, +		  int rowsize, int groupsize, const void *buf, 
size_t len,
> +		  bool ascii)
> +{
> +	const u8 *ptr = buf;
> +	int i, linelen, remaining = len;
> +	unsigned char linebuf[32 * 3 + 2 + 32 + 1];
> +
> +	if (rowsize != 16 && rowsize != 32)
> +		rowsize = 16;
> +
> +	for (i = 0; i < len; i += rowsize) {
> +		linelen = min(remaining, rowsize);
> +		remaining -= rowsize;
> +
> +		hex_dump_to_buffer(ptr + i, linelen, rowsize, groupsize,
> +				   linebuf, sizeof(linebuf), ascii);
> +
> +		switch (prefix_type) {
> +		case DUMP_PREFIX_ADDRESS:
> +			seq_printf(m, "%s%p: %s\n", prefix_str, ptr + i, 
linebuf);
> +			break;
> +		case DUMP_PREFIX_OFFSET:
> +			seq_printf(m, "%s%.8x: %s\n", prefix_str, i, linebuf);
> +			break;
> +		default:
> +			seq_printf(m, "%s%s\n", prefix_str, linebuf);
> +			break;
> +		}
> +	}
> +}
> +EXPORT_SYMBOL(seq_hex_dump);

The above function looks like almost verbatim copy of print_hex_dump(). The only 
difference I can spot is that it's calling seq_printf() instead of printk(). Can 
you not instead generalize print_hex_dump() and based on it's invocation, make 
it call either seq_printf() or printk() ?

Best regards,
