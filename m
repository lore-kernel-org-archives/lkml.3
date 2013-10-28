Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212Ab3J1QaS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:30:18 -0400
Received: from smtprelay0142.hostedemail.com ([216.40.44.142]:48836 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756656Ab3J1QaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:30:16 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3868:3870:3872:4321:4384:4389:4395:5007:7514:7576:7652:7904:10004:10400:10848:11026:11232:11658:11914:12296:12517:12519:12740:13069:13161:13229:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: tax34_768257755b223
X-Filterd-Recvd-Size: 2274
Message-ID: <1382977811.30941.33.camel@joe-AO722>
Subject: Re: [PATCH v2] dynamic_debug: add wildcard support to filter
 files/functions/modules
From: Joe Perches <joe@perches.com>
To: "Du, Changbin" <changbin.du@gmail.com>
Cc: jbaron@akamai.com, linux-kernel@vger.kernel.org
Date: Mon, 28 Oct 2013 09:30:11 -0700
In-Reply-To: <1382974150-7392-1-git-send-email-changbin.du@gmail.com>
References: <51F73A17.2090208@akamai.com>
	 <1382974150-7392-1-git-send-email-changbin.du@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-10-28 at 23:29 +0800, Du, Changbin wrote:
> From: "Du, Changbin" <changbin.du@gmail.com>

trivial notes:

> This patch add wildcard '*'(matches zero or more characters) and '?'
> (matches one character) support when qurying debug flags.

> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
[]
> @@ -127,6 +127,41 @@ static void vpr_info_dq(const struct ddebug_query *query, const char *msg)
>  		 query->first_lineno, query->last_lineno);
>  }
>  
> +/* check if the string matches given pattern which includes wildcards */
> +static int match_pattern(const char *pattern, const char *string)

bool match_pattern

> +{
> +	const char *s, *p;
> +	int star = 0;

bool star = false;

> +
> +loop:
> +	for (s = string, p = pattern; *s; ++s, ++p) {
> +		switch (*p) {
> +		case '?':
> +			break;
> +		case '*':
> +			star = 1;
> +			string = s;
> +			pattern = p;
> +			if (!*++pattern)
> +				return 1;
> +			goto loop;
> +		default:
> +			if (*s != *p)
> +				goto star_check;

			star = false;

> +			break;
> +		}
> +	}
> +	if (*p == '*')
> +		++p;
> +	return (!*p);

Don't need parentheses.

> +
> +star_check:
> +	if (!star)
> +		return 0;
> +	string++;
> +	goto loop;
> +}

The star_check: label block seems like it'd be
better in the switch case as it's only used once.

Maybe the thing would be more readable with a
while loop

