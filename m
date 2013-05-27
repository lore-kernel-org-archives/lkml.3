Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab3E0KCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 06:02:08 -0400
Received: from intranet.asianux.com ([58.214.24.6]:14094 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862Ab3E0KCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 06:02:04 -0400
X-Spam-Score: -100.8
Message-ID: <51A32EE9.1030704@asianux.com>
Date: Mon, 27 May 2013 18:01:13 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        zhangyanfei@cn.fujitsu.com, Jiri Kosina <jkosina@suse.cz>,
        Michael Ellerman <michael@ellerman.id.au>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH v2] PowerPC: kernel: need return the related error code
 when failure occurs
References: <519B0ACA.6090008@asianux.com> <20130521081031.GA29303@iris.ozlabs.ibm.com> <519B3855.6050201@asianux.com> <519B3C72.9060405@asianux.com>
In-Reply-To: <519B3C72.9060405@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

Please help check this patch whether is OK, when you have time.

Thanks.

On 05/21/2013 05:20 PM, Chen Gang wrote:
> 
> When error occurs, need return the related error code to let upper
> caller know about it.
> 
> ppc_md.nvram_size() can return the error code (e.g. core99_nvram_size()
> in 'arch/powerpc/platforms/powermac/nvram.c').
> 
> Also set ret value when only need it, so can save structions for normal
> cases.
> 
> The original related patch: "f9ce299 [PATCH] powerpc: fix large nvram
> access".
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/powerpc/kernel/nvram_64.c |   20 ++++++++++++++------
>  1 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/nvram_64.c b/arch/powerpc/kernel/nvram_64.c
> index 48fbc2b..8213ee1 100644
> --- a/arch/powerpc/kernel/nvram_64.c
> +++ b/arch/powerpc/kernel/nvram_64.c
> @@ -84,22 +84,30 @@ static ssize_t dev_nvram_read(struct file *file, char __user *buf,
>  	char *tmp = NULL;
>  	ssize_t size;
>  
> -	ret = -ENODEV;
> -	if (!ppc_md.nvram_size)
> +	if (!ppc_md.nvram_size) {
> +		ret = -ENODEV;
>  		goto out;
> +	}
>  
> -	ret = 0;
>  	size = ppc_md.nvram_size();
> -	if (*ppos >= size || size < 0)
> +	if (size < 0) {
> +		ret = size;
> +		goto out;
> +	}
> +
> +	if (*ppos >= size) {
> +		ret = 0;
>  		goto out;
> +	}
>  
>  	count = min_t(size_t, count, size - *ppos);
>  	count = min(count, PAGE_SIZE);
>  
> -	ret = -ENOMEM;
>  	tmp = kmalloc(count, GFP_KERNEL);
> -	if (!tmp)
> +	if (!tmp) {
> +		ret = -ENOMEM;
>  		goto out;
> +	}
>  
>  	ret = ppc_md.nvram_read(tmp, count, ppos);
>  	if (ret <= 0)
> 


-- 
Chen Gang

Asianux Corporation
