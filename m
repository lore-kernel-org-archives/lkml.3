Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbaKETNC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 14:13:02 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:43922 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750891AbaKETM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 14:12:58 -0500
Message-ID: <545A76B7.1060801@hurleysoftware.com>
Date: Wed, 05 Nov 2014 14:12:55 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Add --strict test for function pointer calling
 style
References: <1415208392-16189-1-git-send-email-peter@hurleysoftware.com>	 <1415208392-16189-3-git-send-email-peter@hurleysoftware.com> <1415212917.6634.17.camel@perches.com>
In-Reply-To: <1415212917.6634.17.camel@perches.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/05/2014 01:41 PM, Joe Perches wrote:
> Peter Hurley wrote:
> 
> The use of older function ptr calling style, (*fn)(), makes static
> analysis more error-prone; replace with modern fn() style.
> 
> So make checkpatch emit a --strict test for that condition.
> 
> Update the unnecessary parentheses test for dereferencing
> objects at the same time and create a $fix mechanism too.

Cool.

perl's not my thing; how does it know not to trip up on

	initcall_t *call;

	(*call)();

[which I verified it properly does not flag in drivers/tty/tty_io.c]

Regards,
Peter Hurley


> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  scripts/checkpatch.pl | 24 +++++++++++++++++++++---
>  1 file changed, 21 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 24d6702..552e5dd 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -3838,9 +3838,27 @@ sub process {
>  # ie: &(foo->bar) should be &foo->bar and *(foo->bar) should be *foo->bar
>  
>  		while ($line =~ /(?:[^&]&\s*|\*)\(\s*($Ident\s*(?:$Member\s*)+)\s*\)/g) {
> -			CHK("UNNECESSARY_PARENTHESES",
> -			    "Unnecessary parentheses around $1\n" . $herecurr);
> -		    }
> +			my $var = $1;
> +			if (CHK("UNNECESSARY_PARENTHESES",
> +				"Unnecessary parentheses around $var\n" . $herecurr) &&
> +			    $fix) {
> +				$fixed[$fixlinenr] =~ s/\(\s*\Q$var\E\s*\)/$var/;
> +			}
> +		}
> +
> +# check for unnecessary parentheses around function pointer uses
> +# ie: (foo->bar)(); should be foo->bar();
> +# but not "if (foo->bar) (" to avoid some false positives
> +		if ($line =~ /(\bif\s*|)(\(\s*$Ident\s*(?:$Member\s*)+\))[ \t]*\(/ && $1 !~ /^if/) {
> +			my $var = $2;
> +			if (CHK("UNNECESSARY_PARENTHESES",
> +				"Unnecessary parentheses around function pointer $var\n" . $herecurr) &&
> +			    $fix) {
> +				my $var2 = deparenthesize($var);
> +				$var2 =~ s/\s//g;
> +				$fixed[$fixlinenr] =~ s/\Q$var\E/$var2/;
> +			}
> +		}
>  
>  #goto labels aren't indented, allow a single space however
>  		if ($line=~/^.\s+[A-Za-z\d_]+:(?![0-9]+)/ and
> 
> 

