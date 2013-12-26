Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab3LZUHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 15:07:35 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:38178 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab3LZUHd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 15:07:33 -0500
X-Originating-IP: 50.43.14.201
Date: Thu, 26 Dec 2013 12:07:23 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] checkpatch: Add tests for function pointer style
 misuses
Message-ID: <20131226200723.GA7267@leaf>
References: <cover.1388085015.git.joe@perches.com>
 <4c5453ce99c368d91032e2a6614fe270fa94d122.1388085015.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4c5453ce99c368d91032e2a6614fe270fa94d122.1388085015.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 26, 2013 at 11:20:28AM -0800, Joe Perches wrote:
> Kernel style uses function pointers in this form:
>         "type (*funcptr)(args...)"
> 
> Emit warnings when this function pointer form isn't used.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Two comments below.

>  scripts/checkpatch.pl | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 59 insertions(+)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 0fcbc5f..f5d4560 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2810,6 +2810,65 @@ sub process {
>  			}
>  		}
>  
> +# Function pointer declarations
> +# check spacing between type, funcptr, and args
> +# canonical declaration is "type (*funcptr)(args...)"
> +#
> +# the $Declare variable will capture all spaces after the type
> +# so check it for multiple spaces
> +		if ($line =~ /^.\s*($Declare)\((\s*)\*(\s*)$Ident(\s*)\)(\s*)\(/) {
> +			my $declare = $1;
> +			my $pre_pointer_space = $2;
> +			my $post_pointer_space = $3;
> +			my $funcname = $4;
> +			my $post_funcname_space = $5;
> +			my $pre_args_space = $6;
> +
> +			if ($declare !~ /\s$/) {
> +				WARN("SPACING",
> +				     "missing space after return type\n" . $herecurr);
> +			}
> +
> +# unnecessary space "type  (*funcptr)(args...)"
> +			elsif ($declare =~ /\s{2,}$/) {
> +				WARN("SPACING",
> +				     "Multiple spaces after return type\n" . $herecurr);
> +			}
> +
> +# unnecessary space "type ( *funcptr)(args...)"
> +			if (defined $pre_pointer_space &&
> +			    $pre_pointer_space =~ /^\s/) {
> +				WARN("SPACING",
> +				     "Unnecessary space after function pointer open parenthesis\n" . $herecurr);

There are two parentheticals in a proper function pointer declaration,
so this is slightly ambiguous.  Perhaps "between open parenthesis and
'*' in function pointer declaration"?

> +# unnecessary space "type (* funcptr)(args...)"
> +			if (defined $post_pointer_space &&
> +			    $post_pointer_space =~ /^\s/) {
> +				WARN("SPACING",
> +				     "Unnecessary space before function pointer name\n" . $herecurr);
> +			}
> +
> +# unnecessary space "type (*funcptr )(args...)"
> +			if (defined $post_funcname_space &&
> +			    $post_funcname_space =~ /^\s/) {
> +				WARN("SPACING",
> +				     "Unnecessary space after function pointer name\n" . $herecurr);
> +			}
> +
> +# unnecessary space "type (*funcptr) (args...)"
> +			if (defined $pre_args_space &&
> +			    $pre_args_space =~ /^\s/) {
> +				WARN("SPACING",
> +				     "Unnecessary space before function pointer name\n" . $herecurr);

Copy/paste problem here?  I think this should be "Unnecessary space
before function pointer argument types" or similar.

With both of the above two issues fixed:

Reviewed-by: Josh Triplett <josh@joshtriplett.org>
