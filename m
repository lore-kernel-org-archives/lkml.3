Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926AbaIPHLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 03:11:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:10290 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752360AbaIPHLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 03:11:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,533,1406617200"; 
   d="scan'208";a="603435447"
Message-ID: <1410851466.7023.44.camel@linux.intel.com>
Subject: Re: [PATCH v4 05/12] seq_file: provide an analogue of
 print_hex_dump()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Marek Vasut <marex@denx.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
        Benjamin Romer <benjamin.romer@unisys.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>
Date: Tue, 16 Sep 2014 10:11:06 +0300
In-Reply-To: <1409840819-18976-6-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1409840819-18976-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1409840819-18976-6-git-send-email-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.5-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-09-04 at 17:26 +0300, Andy Shevchenko wrote:
> The new seq_hex_dump() is a complete analogue of print_hex_dump().
> 
> We have few users of this functionality already. It allows to reduce their
> codebase.

Al, what do you think about this version?

> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  fs/seq_file.c            | 50 ++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/seq_file.h |  4 ++++
>  2 files changed, 54 insertions(+)
> 
> diff --git a/fs/seq_file.c b/fs/seq_file.c
> index 3857b72..66c721f4 100644
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
> @@ -794,6 +795,55 @@ void seq_pad(struct seq_file *m, char c)
>  }
>  EXPORT_SYMBOL(seq_pad);
>  
> +/* Analogue of print_hex_dump() */
> +int seq_hex_dump(struct seq_file *m, const char *prefix_str, int prefix_type,
> +		 int rowsize, int groupsize, const void *buf, size_t len,
> +		 bool ascii)
> +{
> +	const u8 *ptr = buf;
> +	int i, linelen, remaining = len;
> +	int ret;
> +
> +	if (rowsize != 16 && rowsize != 32)
> +		rowsize = 16;
> +
> +	for (i = 0; i < len; i += rowsize) {
> +		linelen = min(remaining, rowsize);
> +		remaining -= rowsize;
> +
> +		/* Prefix string */
> +		ret = seq_printf(m, "%s", prefix_str);
> +		if (ret < 0)
> +			return ret;
> +
> +		/* Counter if asked */
> +		if (prefix_type == DUMP_PREFIX_ADDRESS)
> +			ret = seq_printf(m, "%p: ", ptr + i);
> +		else if (prefix_type == DUMP_PREFIX_OFFSET)
> +			ret = seq_printf(m, "%.8x: ", i);
> +		if (ret < 0)
> +			return ret;
> +
> +		/* Hex dump */
> +		ret = hex_dump_to_buffer(ptr + i, linelen, rowsize, groupsize,
> +					 m->buf + m->count, m->size - m->count,
> +					 ascii);
> +		if (m->count + ret >= m->size) {
> +			seq_set_overflow(m);
> +			return -1;
> +		}
> +		m->count += ret;
> +
> +		/* EOL */
> +		ret = seq_putc(m, '\n');
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(seq_hex_dump);
> +
>  struct list_head *seq_list_start(struct list_head *head, loff_t pos)
>  {
>  	struct list_head *lh;
> diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
> index 52e0097..5de290c 100644
> --- a/include/linux/seq_file.h
> +++ b/include/linux/seq_file.h
> @@ -107,6 +107,10 @@ int seq_write(struct seq_file *seq, const void *data, size_t len);
>  __printf(2, 3) int seq_printf(struct seq_file *, const char *, ...);
>  __printf(2, 0) int seq_vprintf(struct seq_file *, const char *, va_list args);
>  
> +int seq_hex_dump(struct seq_file *m, const char *prefix_str, int prefix_type,
> +		 int rowsize, int groupsize, const void *buf, size_t len,
> +		 bool ascii);
> +
>  int seq_path(struct seq_file *, const struct path *, const char *);
>  int seq_dentry(struct seq_file *, struct dentry *, const char *);
>  int seq_path_root(struct seq_file *m, const struct path *path,


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

