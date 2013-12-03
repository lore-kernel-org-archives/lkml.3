Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab3LCI46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:56:58 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:54867 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752375Ab3LCI4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:56:53 -0500
X-Originating-IP: 50.43.14.201
Date: Tue, 3 Dec 2013 00:56:46 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] checkpatch: More comprehensive split strings warning
Message-ID: <20131203085646.GA24252@leaf>
References: <1386019438.2680.32.camel@joe-AO722>
 <20131202213358.GA15802@jtriplet-mobl1>
 <1386049457.15309.23.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386049457.15309.23.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 02, 2013 at 09:44:17PM -0800, Joe Perches wrote:
> The current checkpatch test for split strings does
> not find several cases that should be found.
> 
> For instance:
> 
> diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
> []
> @@ -1868,7 +1865,8 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
>  		/* Else poor success; go back to mode in "active" table */
>  		} else {
>  			IWL_DEBUG_RATE(mvm,
> -				       "LQ: GOING BACK TO THE OLD TABLE suc=%d cur-tpt=%d old-tpt=%d\n",
> +				       "GOING BACK TO THE OLD TABLE: SR %d "
> +				       "cur-tpt %d old-tpt %d\n",
>  				       window->success_ratio,
>  				       window->average_tpt,
>  				      lq_sta->last_tpt);
> 
> does not currently emit a warning.
> 
> Improve the test to find these cases.
> 
> Add more exceptions to reduce false positives for
> assembly and octal/hex string constants.

Nice choice of exceptions; that should work quite well.

> Signed-off-by: Joe Perches <joe@perches.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  scripts/checkpatch.pl | 12 ++++--------
>  1 file changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 38be5d5..1d0d5ac 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2049,16 +2049,12 @@ sub process {
>  		}
>  
>  # Check for user-visible strings broken across lines, which breaks the ability
> -# to grep for the string.  Limited to strings used as parameters (those
> -# following an open parenthesis), which almost completely eliminates false
> -# positives, as well as warning only once per parameter rather than once per
> -# line of the string.  Make an exception when the previous string ends in a
> -# newline (multiple lines in one string constant) or \n\t (common in inline
> -# assembly to indent the instruction on the following line).
> +# to grep for the string.  Make exceptions when the previous string ends in a
> +# newline (multiple lines in one string constant) or '\t', '\r', ';', or '{'
> +# (common in inline assembly) or is a octal \123 or hexadecimal \xaf value
>  		if ($line =~ /^\+\s*"/ &&
>  		    $prevline =~ /"\s*$/ &&
> -		    $prevline =~ /\(/ &&
> -		    $prevrawline !~ /\\n(?:\\t)*"\s*$/) {
> +		    $prevrawline !~ /(?:\\(?:[ntr]|[0-7]{1,3}|x[0-9a-fA-F]{1,2})|;\s*|\{\s*)"\s*$/) {
>  			WARN("SPLIT_STRING",
>  			     "quoted string split across lines\n" . $hereprev);
>  		}
> 
> 
