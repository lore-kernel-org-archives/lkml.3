Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbaB0WoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 17:44:09 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:37049 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbaB0WoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 17:44:07 -0500
Date: Thu, 27 Feb 2014 14:44:01 -0800
From: josh@joshtriplett.org
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia.lawall@lip6.fr>,
        Monam Agarwal <monamagarwal123@gmail.com>, opw-kernel@googlegroups.com,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [OPW kernel] [PATCH] checkpatch: Make "return is not a
 function" test quieter
Message-ID: <20140227224401.GA30335@cloud>
References: <20140227164152.GA26266@kroah.com>
 <20140227170811.GA28796@thin>
 <alpine.DEB.2.10.1402271811010.4439@hadrien>
 <20140227172017.GA29133@thin>
 <alpine.DEB.2.10.1402271822540.4439@hadrien>
 <1393523563.24588.101.camel@joe-AO722>
 <alpine.DEB.2.10.1402271856530.4439@hadrien>
 <1393524256.24588.103.camel@joe-AO722>
 <20140227184723.GA3905@kroah.com>
 <1393529230.24588.114.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393529230.24588.114.camel@joe-AO722>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 11:27:10AM -0800, Joe Perches wrote:
> This test is a bit noisy and opinions seem to agree that
> it should not warn in a lot more situations.
> 
> It seems people agree that:
> 
> 	return (foo || bar);
> and
> 	return foo || bar;
> 
> are both acceptable style and checkpatch should be silent
> about them.
> 
> For now, it warns on parentheses around a simple constant
> or a single function or a ternary.
> 
> 	return (foo);
> 	return (foo(bar));
> 	return (foo ? bar : baz);
> 
> The last ternary test may be quieted in the future.
> 
> Modify the deparenthesize function to only strip balanced
> leading and trailing parentheses.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

I'd suggest dropping the warning for parenthesized ternaries as well,
but in any case:

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  scripts/checkpatch.pl | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 91308be..be4be81 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -439,9 +439,14 @@ our $FuncArg = qr{$Typecast{0,1}($LvalOrFunc|$Constant)};
>  sub deparenthesize {
>  	my ($string) = @_;
>  	return "" if (!defined($string));
> -	$string =~ s@^\s*\(\s*@@g;
> -	$string =~ s@\s*\)\s*$@@g;
> +
> +	while ($string =~ /^\s*\(.*\)\s*$/) {
> +		$string =~ s@^\s*\(\s*@@;
> +		$string =~ s@\s*\)\s*$@@;
> +	}
> +
>  	$string =~ s@\s+@ @g;
> +
>  	return $string;
>  }
>  
> @@ -3362,14 +3367,17 @@ sub process {
>  			}
>  		}
>  
> -# Return is not a function.
> +# return is not a function
>  		if (defined($stat) && $stat =~ /^.\s*return(\s*)\(/s) {
>  			my $spacing = $1;
>  			if ($^V && $^V ge 5.10.0 &&
> -			    $stat =~ /^.\s*return\s*$balanced_parens\s*;\s*$/) {
> -				ERROR("RETURN_PARENTHESES",
> -				      "return is not a function, parentheses are not required\n" . $herecurr);
> -
> +			    $stat =~ /^.\s*return\s*($balanced_parens)\s*;\s*$/) {
> +				my $value = $1;
> +				$value = deparenthesize($value);
> +				if ($value =~ m/^\s*$FuncArg\s*(?:\?|$)/) {
> +					ERROR("RETURN_PARENTHESES",
> +					      "return is not a function, parentheses are not required\n" . $herecurr);
> +				}
>  			} elsif ($spacing !~ /\s+/) {
>  				ERROR("SPACING",
>  				      "space required before the open parenthesis '('\n" . $herecurr);
> 
> 
> -- 
> You received this message because you are subscribed to the Google Groups "opw-kernel" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to opw-kernel+unsubscribe@googlegroups.com.
> For more options, visit https://groups.google.com/groups/opt_out.
