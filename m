Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbaIIPnH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:43:07 -0400
Received: from smtprelay0165.hostedemail.com ([216.40.44.165]:43167 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753443AbaIIPnF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:43:05 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:4321:4605:5007:7652:8660:9108:10004:10400:10848:11232:11658:11914:12296:12517:12519:12663:12740:13019:13069:13148:13161:13229:13230:13311:13357:14093:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: girl83_37a1200b97c29
X-Filterd-Recvd-Size: 2508
Message-ID: <1410277380.12560.38.camel@joe-AO725>
Subject: Re: [PATCH] scripts: checkpatch.pl add warning for dummy label
From: Joe Perches <joe@perches.com>
To: Nitin Kuppelur <nitinkuppelur@gmail.com>
Cc: akpm@linux-foundation.org, josh@joshtriplett.org, robh@kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 09 Sep 2014 08:43:00 -0700
In-Reply-To: <1410270855-6639-1-git-send-email-nitinkuppelur@gmail.com>
References: <1410270855-6639-1-git-send-email-nitinkuppelur@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-09 at 15:54 +0200, Nitin Kuppelur wrote:
> Added new warning DUMMY_LABEL in checkpatch.pl. This warns
> if return statement is encountered just after goto label target
> like "out:". In such scenario it is best to call "return;" directly
> instead of "goto out;"

I'm not sure this is desired/correct.

There are many functions written like:

return_type foo(...)
{
	[some initialization...]

	err = some_test(...);
	if (err)
		goto out;

	[...]

out:
	[some cleanup...]
	return err;
}

In many cases, a void function is a simple
variant of a non-void function and many people
like to see the same code "shape" in functions,
just without the init and cleanup bits.

> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -3798,10 +3798,14 @@ sub process {
>  		if ($sline =~ /^[ \+]}\s*$/ &&
>  		    $prevline =~ /^\+\treturn\s*;\s*$/ &&
>  		    $linenr >= 3 &&
> -		    $lines[$linenr - 3] =~ /^[ +]/ &&
> -		    $lines[$linenr - 3] !~ /^[ +]\s*$Ident\s*:/) {
> -			WARN("RETURN_VOID",
> -			     "void function return statements are not generally useful\n" . $hereprev);
> +		    $lines[$linenr - 3] =~ /^[ +]/) {
> +			if ($lines[$linenr - 3] !~ /^[ +]\s*$Ident\s*:/) {
> +				WARN("RETURN_VOID",
> +				     "void function return statements are not generally useful\n" . $hereprev);
> +			} elsif ($lines[$linenr - 3] =~ /^[ +]\s*$Ident\s*:/) {
> +				WARN("DUMMY_LABEL",
> +				     "labels doing nothing are not generally useful\n" . $hereprev);
> +			}
>                 }
>  
>  # if statements using unnecessary parentheses - ie: if ((foo == bar))



