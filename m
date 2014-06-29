Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaF2JXS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2014 05:23:18 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:19334 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752383AbaF2JXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2014 05:23:16 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvgYAEvar1NbsmJR/2dsb2JhbABZgw1Sq2IBAQEBAQEFAW4BmUICAgGBBhd1hAMBAQQBOhwPFAULCAMYLjkeBhOIOgwBxgUXhWSDaIU7B4RDAQSaXQGBRol5iD6CAIFEOw
Date: Sun, 29 Jun 2014 11:21:56 +0200
From: Fabian Frederick <fabf@skynet.be>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] scripts/checkpatch.pl: update kmalloc_array/kcalloc
 conversion warning
Message-Id: <20140629112156.6a14ad3599a016a1c05c4771@skynet.be>
In-Reply-To: <1403905024.9064.16.camel@joe-AO725>
References: <1403899823-4461-1-git-send-email-fabf@skynet.be>
	<1403905024.9064.16.camel@joe-AO725>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2014 14:37:04 -0700
Joe Perches <joe@perches.com> wrote:

> On Fri, 2014-06-27 at 22:10 +0200, Fabian Frederick wrote:
> > Avoid automatic k[mz]alloc with multiplies conversions
> []
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> []
> > @@ -4427,7 +4427,7 @@ sub process {
> >  			$newfunc = "kcalloc" if ($oldfunc eq "kzalloc");
> >  			if ($a1 =~ /^sizeof\s*\S/ || $a2 =~ /^sizeof\s*\S/) {
> >  				if (WARN("ALLOC_WITH_MULTIPLY",
> > -					 "Prefer $newfunc over $oldfunc with multiply\n" . $herecurr) &&
> > +					 "Prefer $newfunc over $oldfunc with multiply when arguments are not fixed or come from unvalidated source\n" . $herecurr) &&
> >  				    $fix) {
> >  					my $r1 = $a1;
> >  					my $r2 = $a2;
> 
> I'm not sure of the value of this as I think at some point
> if not already today, the compiler will optimize the multiply
> away.
> 
> But it's probably better to look at the non-sizeof variable
> and emit the warning only when it's not $Constant or some
> upper-case only macro #define like "\b[A-Z_]+\b" is used.
> 
> Maybe something like this:
> 
>  scripts/checkpatch.pl | 17 +++++++++--------
>  1 file changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 6c7cbaf..e0d0ead 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -4486,22 +4486,23 @@ sub process {
>  
>  # check for k[mz]alloc with multiplies that could be kmalloc_array/kcalloc
>  		if ($^V && $^V ge 5.10.0 &&
> -		    $line =~ /\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/) {
> +		    $line =~ /\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)\s*,/) {
>  			my $oldfunc = $3;
>  			my $a1 = $4;
>  			my $a2 = $10;
>  			my $newfunc = "kmalloc_array";
>  			$newfunc = "kcalloc" if ($oldfunc eq "kzalloc");
> -			if ($a1 =~ /^sizeof\s*\S/ || $a2 =~ /^sizeof\s*\S/) {
> +			my $r1 = $a1;
> +			my $r2 = $a2;
> +			if ($a1 =~ /^sizeof\s*\S/) {
> +				$r1 = $a2;
> +				$r2 = $a1;
> +			}
> +			if ($r1 !~ /^sizeof\b/ && $r2 =~ /^sizeof\s*\S/ &&
> +			    !($r1 =~ /^$Constant$/ || $r1 =~ /^[A-Z_]+$/)) {
>  				if (WARN("ALLOC_WITH_MULTIPLY",
>  					 "Prefer $newfunc over $oldfunc with multiply\n" . $herecurr) &&
>  				    $fix) {
> -					my $r1 = $a1;
> -					my $r2 = $a2;
> -					if ($a1 =~ /^sizeof\s*\S/) {
> -						$r1 = $a2;
> -						$r2 = $a1;
> -					}
>  					$fixed[$linenr - 1] =~ s/\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/$1 . ' = ' . "$newfunc(" . trim($r1) . ', ' . trim($r2)/e;
>  
>  				}
> 
> 
Hello Joe,

   Thanks, it looks great. Already tested ? If not I can do it and give you some feedback ...

Fabian
