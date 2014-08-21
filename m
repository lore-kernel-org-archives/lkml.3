Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbaHURSr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 13:18:47 -0400
Received: from smtprelay0104.hostedemail.com ([216.40.44.104]:45734 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751982AbaHURSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 13:18:45 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3653:3865:3866:3867:3868:3870:3872:3873:3874:4321:4641:5007:6119:7652:9010:10004:10400:10848:11232:11658:11914:12043:12296:12517:12519:12679:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: desk93_4bea70b17cc1f
X-Filterd-Recvd-Size: 2729
Message-ID: <1408641520.23250.71.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch: look for common misspellings
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>
Date: Thu, 21 Aug 2014 10:18:40 -0700
In-Reply-To: <20140821162050.GA1323@www.outflux.net>
References: <20140821162050.GA1323@www.outflux.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-21 at 09:20 -0700, Kees Cook wrote:
> Check for misspellings, based on Debian's lintian list. Several false
> positives were removed, and several additional words added that were
> common in the kernel:
[]
> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -2311,6 +2311,7 @@ M:	Andy Whitcroft <apw@canonical.com>
>  M:	Joe Perches <joe@perches.com>
>  S:	Maintained
>  F:	scripts/checkpatch.pl
> +F:	scripts/spelling.txt

I don't want to be responsible for misspellings.

Maybe this should be moved to another section
and you could be added as a maintainer for that.
 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> +# Check for several spelling mistakes.
> +		if ($rawline =~ $spelling_re) {

$spelling_re has a rather hidden ( ... ) use so I think
it'd be better to not use spelling_re at all and have a
variable like:
our $misspellings = join('|', @spelling_list);

and also use while so all misspellings are found so this
could be:

		while ($rawline =~ /(?:^|$edge)($misspellings)(?:\$|$edge)/g) {

> +			my $typo = "The word '$1' may be misspelled";
> +			$typo .= " (perhaps you want '$spelling_fix{$1}'?)\n";
> +			WARN("TYPO_SPELLING", $typo . $herecurr);
> +		}
>  	}

Seems sensible, but this checks only .c and .h files.
Any of the Kconfig/.txt files are skipped.

I'd probably leave out "The word "

Maybe add a $fix too?

Maybe:

		while ($rawline =~ /(?:^|$edge)($misspellings)(?:\$|$edge)/g) {
			my $typo = $1;
			if (WARN("TYPO_SPELLING",
				 "$typo may be misspelled - Use '$spelling_fix($typo)'?\n" . $herecurr) &&
			    $fix) {
				$fixed[$fixlinenr] =~ s/(?:^|$edge)($typo)(?:\$|$edge)/$spelling_fix($typo)/;
			}
		}


