Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760239Ab3EGCtj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:49:39 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:32480 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758590Ab3EGCti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:49:38 -0400
Message-ID: <51886B90.8060502@huawei.com>
Date: Tue, 7 May 2013 10:48:48 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Li Zefan <lizefan@huawei.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Michal Marek <mmarek@suse.cz>,
        Weng Meiling <wengmeiling.weng@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>, <linux-kbuild@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] menuconfig: fix NULL pointer dereference when searching
 a symbol
References: <518869BB.2020808@huawei.com>
In-Reply-To: <518869BB.2020808@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/7 10:40, Li Zefan wrote:
> Searching PPC_EFIKA results segmentation fault, and it's because
> get_symbol_prop() returns NULL.
> 
> In this case CONFIG_PPC_EFIKA is defined in arch/powerpc/platforms/
> 52xx/Kconfig, so it won't be parsed if ARCH!=PPC, but menuconfig
> knows this symbol when it parses sound/soc/fsl/Kconfig:
> 
> config SND_MPC52xx_SOC_EFIKA
>         tristate "SoC AC97 Audio support for bbplan Efika and STAC9766"
>         depends on PPC_EFIKA
> 
> This bug was introduced by commit bcdedcc1afd6 ("menuconfig: print more
> info for symbol without prompts").


It works!

Tested-by: Libo Chen <libo.chen@huawei.com>

> 
> Reported-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> ---
>  scripts/kconfig/menu.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
> index 826da66..b5c7d90 100644
> --- a/scripts/kconfig/menu.c
> +++ b/scripts/kconfig/menu.c
> @@ -600,14 +600,18 @@ void get_symbol_str(struct gstr *r, struct symbol *sym,
>  	}
>  	for_all_prompts(sym, prop)
>  		get_prompt_str(r, prop, head);
> +
>  	prop = get_symbol_prop(sym);
> -	str_printf(r, _("  Defined at %s:%d\n"), prop->menu->file->name,
> -		prop->menu->lineno);
> -	if (!expr_is_yes(prop->visible.expr)) {
> -		str_append(r, _("  Depends on: "));
> -		expr_gstr_print(prop->visible.expr, r);
> -		str_append(r, "\n");
> +	if (prop) {
> +		str_printf(r, _("  Defined at %s:%d\n"), prop->menu->file->name,
> +			prop->menu->lineno);
> +		if (!expr_is_yes(prop->visible.expr)) {
> +			str_append(r, _("  Depends on: "));
> +			expr_gstr_print(prop->visible.expr, r);
> +			str_append(r, "\n");
> +		}
>  	}
> +
>  	hit = false;
>  	for_all_properties(sym, prop, P_SELECT) {
>  		if (!hit) {
> 


