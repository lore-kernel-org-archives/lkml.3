Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758966Ab3HMUC5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:02:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37843 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758861Ab3HMUCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:02:55 -0400
Message-ID: <520A90E9.7080206@suse.cz>
Date: Tue, 13 Aug 2013 22:02:49 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] Handle non ABS crc symbols
References: <1376077524-27573-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1376077524-27573-1-git-send-email-andi@firstfloor.org>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added Rusty to CC.

Dne 9.8.2013 21:45, Andi Kleen napsal(a):
> From: Andi Kleen <ak@linux.intel.com>
> 
> For some reason I managed to trick gcc into create CRC symbols that
> are not absolute anymore, but weak.
> 
> Make modpost handle this case.
> 
> Andrew, this should fix the bizarre warning. Seems like a toolchain
> bug to me.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  scripts/mod/modpost.c | 15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
> index 6216434..b3dd735 100644
> --- a/scripts/mod/modpost.c
> +++ b/scripts/mod/modpost.c
> @@ -599,18 +599,17 @@ static void handle_modversions(struct module *mod, struct elf_info *info,
>  	else
>  		export = export_from_sec(info, get_secindex(info, sym));
>  
> +	/* CRC'd symbol */
> +	if (strncmp(symname, CRC_PFX, strlen(CRC_PFX)) == 0) {
> +		crc = (unsigned int) sym->st_value;
> +		sym_update_crc(symname + strlen(CRC_PFX), mod, crc,
> +				export);
> +	}
> +
>  	switch (sym->st_shndx) {
>  	case SHN_COMMON:
>  		warn("\"%s\" [%s] is COMMON symbol\n", symname, mod->name);
>  		break;
> -	case SHN_ABS:
> -		/* CRC'd symbol */
> -		if (strncmp(symname, CRC_PFX, strlen(CRC_PFX)) == 0) {
> -			crc = (unsigned int) sym->st_value;
> -			sym_update_crc(symname + strlen(CRC_PFX), mod, crc,
> -					export);
> -		}
> -		break;
>  	case SHN_UNDEF:
>  		/* undefined symbol */
>  		if (ELF_ST_BIND(sym->st_info) != STB_GLOBAL &&
> 

