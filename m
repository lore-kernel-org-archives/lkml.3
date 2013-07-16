Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab3GPOWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 10:22:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36912 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754423Ab3GPOWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 10:22:00 -0400
Subject: Re: [PATCH 2/3] kconfig: avoid multiple calls to strlen
From: Jean Delvare <jdelvare@suse.de>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
In-Reply-To: <1373738905-23396-3-git-send-email-yann.morin.1998@free.fr>
References: <1373738905-23396-1-git-send-email-yann.morin.1998@free.fr>
	 <1373738905-23396-3-git-send-email-yann.morin.1998@free.fr>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Tue, 16 Jul 2013 16:21:41 +0200
Message-ID: <1373984501.4513.8.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Saturday 13 July 2013 à 20:08 +0200, Yann E. MORIN a écrit :
> From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> 
> Calls to strlen are costly, so avoid calling strln as much as we can.

Typo: strln -> strlen.

> Reported-by: Jean Delvare <jdelvare@suse.de>
> Signed-off-by: "Yann E. MORIN" <yann.morin.1998@free.fr>
> Cc: Jean Delvare <jdelvare@suse.de>
> ---
>  scripts/kconfig/symbol.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
> index d550300..020a0ac 100644
> --- a/scripts/kconfig/symbol.c
> +++ b/scripts/kconfig/symbol.c
> @@ -967,7 +967,7 @@ static int sym_rel_comp( const void *sym1, const void *sym2 )
>  {
>  	struct sym_match *s1 = *(struct sym_match **)sym1;
>  	struct sym_match *s2 = *(struct sym_match **)sym2;
> -	int l1, l2;
> +	int exact1, exact2;
>  
>  	/* Exact match:
>  	 * - if matched length on symbol s1 is the length of that symbol,
> @@ -978,11 +978,11 @@ static int sym_rel_comp( const void *sym1, const void *sym2 )
>  	 * exactly; if this is the case, we can't decide which comes first,
>  	 * and we fallback to sorting alphabetically.
>  	 */
> -	l1 = s1->eo - s1->so;
> -	l2 = s2->eo - s2->so;
> -	if (l1 == strlen(s1->sym->name) && l2 != strlen(s2->sym->name))
> +	exact1 = (s1->eo - s1->so) == strlen(s1->sym->name);
> +	exact2 = (s2->eo - s2->so) == strlen(s2->sym->name);
> +	if (exact1 && !exact2)
>  		return -1;
> -	if (l1 != strlen(s1->sym->name) && l2 == strlen(s2->sym->name))
> +	if (!exact1 && exact2)
>  		return 1;
>  
>  	/* As a fallback, sort symbols alphabetically */

Looks good and tested OK.

Reviewed-by: Jean Delvare <jdelvare@suse.de>

-- 
Jean Delvare
Suse L3

