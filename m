Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787AbaJEPgi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 11:36:38 -0400
Received: from smtprelay0056.hostedemail.com ([216.40.44.56]:44471 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751625AbaJEPgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 11:36:35 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:4321:5007:6119:7652:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: thing54_3943153cebc22
X-Filterd-Recvd-Size: 1816
Message-ID: <1412523392.2916.3.camel@joe-AO725>
Subject: Re: [PATCH] lib: string.c:  A speed optimized for strncpy
From: Joe Perches <joe@perches.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2014 08:36:32 -0700
In-Reply-To: <1412515757-19689-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1412515757-19689-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	 <1412515757-19689-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-10-05 at 15:29 +0200, Rickard Strandqvist wrote:
> This variant is in my tests about 7-10% faster, and also think
> it is perhaps even clearer code than before.
[]
> diff --git a/lib/string.c b/lib/string.c
[]
> @@ -123,12 +123,12 @@ char *strncpy(char *dest, const char *src, size_t count)
>  {
>  	char *tmp = dest;
>  
> -	while (count) {
> -		if ((*tmp = *src) != 0)
> -			src++;
> -		tmp++;
> -		count--;
> -	}
> +	while (count && (*tmp++ = *src++))
> +		--count;
> +
> +	while (count--)
> +		*tmp++ = '\0';

Perhaps it could be faster to use memset.
It might depend on the value of count.

{
	while (count && (*tmp++ = *src++))
		count--;

	if (count > 0)
		memset(tmp, 0, count);
}

