Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab3HEXaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 19:30:22 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38727 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755148Ab3HEXaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 19:30:21 -0400
Message-ID: <1375745420.1968.13.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: add a rule to check devinitconst mistakes
From: Joe Perches <joe@perches.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: apw@canonical.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Date: Mon, 05 Aug 2013 16:30:20 -0700
In-Reply-To: <1375740651-7716-1-git-send-email-andi@firstfloor.org>
References: <1375740651-7716-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-05 at 15:10 -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Check for const __devinitdata and non const __devinitconst
> 
> People get this regularly wrong and it breaks the LTO builds,
> as it causes a section attribute conflict.
> 
> This doesn't catch all mistakes -- spreading over multiple lines,
> getting const pointers wrong, but hopefully the common ones.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  scripts/checkpatch.pl | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 2ee9eb7..5d68d9c 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2676,6 +2676,15 @@ sub process {
>  			}
>  		}
>  
> +# check for __devinitdata with const or const without __devintconst
> +# XXX should scan multiple lines and handle misplaced consts for pointers
> +		if ($line =~ /const/ && $line =~ /__(dev)?initdata/) {
> +		    ERROR("DEVINITCONST", "const init definition must use __devinitconst");
> +		}
> +		if ($line =~ /__(dev)?initconst/ && $line !~ /\Wconst\W/) {

There are no more uses of __devinitconst and
__devinitdata in the tree.

Shouldn't these be "\bconst\b", "\b__initdata\b"
and "\b__initconst\b"

I think also there'll be a few too many false
positives for function arguments.

It seems that every use of __initconst is of
the form

[static] const <type> [name] __initconst so

	if ($line =~ /\b__initconst\b/ &&
	    $line !~ /^\+\s*(?:static\b)?\s*const\s+$Type\s*(?:$Ident)?\s*__initconst\b/) {
		etc...
	}

should work reasonably well.

