Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbaFRT7Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 15:59:16 -0400
Received: from 99-65-72-227.uvs.sntcca.sbcglobal.net ([99.65.72.227]:33757
	"EHLO stargate3.asicdesigners.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755257AbaFRT7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 15:59:14 -0400
Message-ID: <53A1EF8D.20300@chelsio.com>
Date: Wed, 18 Jun 2014 12:59:09 -0700
From: Anish Bhatt <anish@chelsio.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH V2] checkpatch: Warn on unnecessary void function return
 statements
References: <1401728316.5770.9.camel@joe-AO725> <1403113484.3839.13.camel@joe-AO725>
In-Reply-To: <1403113484.3839.13.camel@joe-AO725>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 18 Jun 2014 10:44:44 AM PDT, Joe Perches wrote:
> With some exceptions, warn on void functions that end with a
> "return;", because it's unnecessary.
>
> Check the closing brace at the start of a line.
> If the line before that has a single tab, then return;
> look at the line before that.  If it's not a label,
> emit a warning.
>
> So, emit a warning on:
>
> void function(...)
> {
> 	[...]
> 	return;
> }
>
> but do not emit a warning on the below because
> gcc requires any statement (including a bare
> semicolon) before the closing function brace:
>
> void function(...)
> {
> 	[...]
> 		goto label;
> 	[...]
>
> label:
> 	return;
> }
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>
> V2: The previous patch had a few too many false positives
>     on styles that should be acceptable.
>
>  scripts/checkpatch.pl | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 862cc7a..b191c88 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -3470,6 +3470,18 @@ sub process {
>  			}
>  		}
>
> +# unnecessary return in a void function
> +# at end-of-function, with the previous line a single leading tab, then return;
> +# and the line before that not a goto label target like "out:"
> +		if ($sline =~ /^[ \+]}\s*$/ &&
> +		    $prevline =~ /^\+\treturn\s*;\s*$/ &&
> +		    $linenr >= 3 &&
> +		    $lines[$linenr - 3] =~ /^[ +]/ &&
> +		    $lines[$linenr - 3] !~ /^[ +]\s*$Ident\s*:/) {
> +			WARN("RETURN_VOID",
> +			     "void function return statements are not generally useful\n" . $hereprev);
> +               }
> +
>  # if statements using unnecessary parentheses - ie: if ((foo == bar))
>  		if ($^V && $^V ge 5.10.0 &&
>  		    $line =~ /\bif\s*((?:\(\s*){2,})/) {
>
>

Confirming, no longer hitting previous false positives for me.
-Anish

--
As long as the music's loud enough, we won't hear the world falling 
apart.

