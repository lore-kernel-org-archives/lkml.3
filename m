Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbaFZKKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 06:10:09 -0400
Received: from smtprelay0074.hostedemail.com ([216.40.44.74]:52731 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755646AbaFZKJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 06:09:10 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 40,2.5,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3653:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4605:4823:5007:7652:7808:7903:8531:10011:10400:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12663:12740:13069:13146:13230:13311:13357:13870:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:1:0
X-HE-Tag: money91_3274fa655fc1a
X-Filterd-Recvd-Size: 2648
Message-ID: <1403777345.7977.36.camel@joe-AO725>
Subject: Re: [PATCH] scripts/checkpatch.pl: Improve guidance for LONG_LINE
From: Joe Perches <joe@perches.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andy Whitcroft <apw@canonical.com>, gregkh@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Thu, 26 Jun 2014 03:09:05 -0700
In-Reply-To: <20140626060136.GA2528@thin>
References: <20140626060136.GA2528@thin>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-25 at 23:01 -0700, Josh Triplett wrote:
> Currently, LONG_LINE just informs the user about the line length,
> leaving them to shorten the line.  Too many users run checkpatch and
> blindly follow its recommendation by splitting long lines, which almost
> invariably results in worse code.  On rare occasions, the line-width
> limit encourages sensible refactoring of nested code into functions, but
> more frequently it just results in painfully over-wrapped code.
> 
> Improve the guidance by detecting long lines that start with 4+ tabs and
> explicitly suggesting simplification or refactoring in that case.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -2146,8 +2146,16 @@ sub process {
>  		    $line =~ /^\+\s*"[^"]*"\s*(?:\s*|,|\)\s*;)\s*$/) &&
>  		    $length > $max_line_length)
>  		{
> -			WARN("LONG_LINE",
> -			     "line over $max_line_length characters\n" . $herecurr);
> +			if ($line =~ /^\+\t{4,}/) {
> +				WARN("LONG_LINE_DEEP_NESTING",
> +				     "line over $max_line_length characters with excessive nesting (4+ tabs)\n"
> +				     . "Consider simplifying or refactoring to eliminate excessive nesting.\n"
> +				     . $herecurr);

This is not the test you want.

This is also emitting on lines that are
merely continued like
			pr_warning(format,
				   arg1,
				   arg2,
				   arg3
				   ...
				   argN);

Better would be to test only for the lines
that increase indents (like the DEEP_INDENTATION test)

$line =~ /^\+\t{4,}(?:if|for|while|do|switch)\b/

This is the treewide distribution I get for the lines
that generally produce extra indentation:

 608432 1
 242180 2
  71260 3
  16953 4
   3688 5
    758 6
    187 7
     74 8
     23 9
     17 10
      8 11
      4 12
      1 13


