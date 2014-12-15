Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbaLOBvr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 20:51:47 -0500
Received: from smtprelay0073.hostedemail.com ([216.40.44.73]:59221 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750840AbaLOBvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 20:51:41 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:968:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3871:3872:4250:4321:5007:6261:6742:7903:10004:10400:10471:10848:11026:11232:11657:11658:11914:12043:12438:12517:12519:12740:13069:13161:13229:13255:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: star53_2b71cd67fc736
X-Filterd-Recvd-Size: 3028
Message-ID: <1418608297.2674.4.camel@perches.com>
Subject: Re: [PATCH] staging: lustre: lustre: obdclass: lprocfs_status.c: 
 Fix for possible null pointer dereference
From: Joe Perches <joe@perches.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>, Greg Donald <gdonald@gmail.com>,
        "John L. Hammond" <john.hammond@intel.com>,
        Andriy Skulysh <Andriy_Skulysh@xyratex.com>,
        Fabian Frederick <fabf@skynet.be>, James Simmons <uja.ornl@gmail.com>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Sun, 14 Dec 2014 17:51:37 -0800
In-Reply-To: <1418597547-25086-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1418597547-25086-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-12-14 at 23:52 +0100, Rickard Strandqvist wrote:
> There is otherwise a risk of a possible null pointer dereference.
> 
> Was largely found by using a static code analysis program called cppcheck.

Perhaps the tool could use a little work.
It's not possible for end to be NULL no?

unsigned long long simple_strtoull(const char *cp, char **endp, unsigned int base)
{
	unsigned long long result;
	unsigned int rv;

	cp = _parse_integer_fixup_radix(cp, &base);
	rv = _parse_integer(cp, base, &result);
	/* FIXME */
	cp += (rv & ~KSTRTOX_OVERFLOW);

	if (endp)
		*endp = (char *)cp;

	return result;
}
EXPORT_SYMBOL(simple_strtoull);


> diff --git a/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
[]

Above this:

	whole = simple_strtoull(pbuf, &end, 10);

> +++ b/drivers/staging/lustre/lustre/obdclass/lprocfs_status.c
> @@ -1897,17 +1897,19 @@ int lprocfs_write_frac_u64_helper(const char *buffer, unsigned long count,
>  	}
>  
>  	units = 1;
> -	switch (*end) {
> -	case 'p': case 'P':
> -		units <<= 10;
> -	case 't': case 'T':
> -		units <<= 10;
> -	case 'g': case 'G':
> -		units <<= 10;
> -	case 'm': case 'M':
> -		units <<= 10;
> -	case 'k': case 'K':
> -		units <<= 10;
> +	if (end) {
> +		switch (*end) {
> +		case 'p': case 'P':
> +			units <<= 10;
> +		case 't': case 'T':
> +			units <<= 10;
> +		case 'g': case 'G':
> +			units <<= 10;
> +		case 'm': case 'M':
> +			units <<= 10;
> +		case 'k': case 'K':
> +			units <<= 10;
> +		}

The only thing I might do is

	switch (tolower(*end)) {

and remove the second case entry for each line

