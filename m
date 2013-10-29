Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274Ab3J2QU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:20:29 -0400
Received: from smtprelay0084.hostedemail.com ([216.40.44.84]:41763 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753817Ab3J2QU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:20:27 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:2919:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3871:3872:3873:4321:4384:4389:4395:5007:7652:10004:10400:10848:11026:11232:11658:11914:12296:12517:12519:12740:13019:13069:13071:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ants46_5af3bc51da948
X-Filterd-Recvd-Size: 2574
Message-ID: <1383063623.2713.12.camel@joe-AO722>
Subject: Re: [PATCH v3] dynamic_debug: add wildcard support to filter
 files/functions/modules
From: Joe Perches <joe@perches.com>
To: "Du, Changbin" <changbin.du@gmail.com>
Cc: jbaron@akamai.com, linux-kernel@vger.kernel.org
Date: Tue, 29 Oct 2013 09:20:23 -0700
In-Reply-To: <1383053609-2895-1-git-send-email-changbin.du@gmail.com>
References: <CABgQ-Ti0aaxqVGF0R-huQur=EGCTyXM0w-gyz9TenC=msucJqA@mail.gmail.com>
	 <1383053609-2895-1-git-send-email-changbin.du@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-29 at 21:33 +0800, Du, Changbin wrote:
> This patch add wildcard '*'(matches zero or more characters) and '?'
> (matches one character) support when qurying debug flags.

Hi again.  Some trivial notes and a possible logic error:

> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
[]
> @@ -127,6 +127,43 @@ static void vpr_info_dq(const struct ddebug_query *query, const char *msg)
>  		 query->first_lineno, query->last_lineno);
>  }
>  
> +/* check if the string matches given pattern which includes wildcards */
> +static bool match_pattern(const char *pattern, const char *string)
> +{
> +	const char *s = string,
> +		   *p = pattern;

This sort of alignment is pretty unusual.
Most kernel uses just repeat the type like:

	const char *s = string;
	const char *p = pattern;

> +	bool star = 0;

	bool star = false;

> +
> +	while (*s) {
> +		switch (*p) {
> +		case '?':
> +			++s, ++p;
> +			break;
> +		case '*':
> +			star = true;
> +			string = s;
> +			if (!*++p)
> +				return true;
> +			pattern = p;;

repeated ;
Running your patches through checkpatch should find
this sort of defect.

> +			break;
> +		default:
> +			if (*s != *p) {
> +				if (!star)
> +					return false;
> +				string++;
> +				s = string;
> +				p = pattern;
> +				break;
> +			}
> +			++s, ++p;

Maybe nicer with an if/else, I think you're still
missing a reset of "star = false;" and I also think
it's better to use a break here too.

		if (*s == *p) {
			s++;
			p++;
			star = false;
		} else {
			if (!star)
				return false;
			string++;
			s = string;
			p = pattern;
		}
		break;



