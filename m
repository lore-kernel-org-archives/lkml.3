Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbaF0VhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 17:37:09 -0400
Received: from smtprelay0120.hostedemail.com ([216.40.44.120]:36656 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753290AbaF0VhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 17:37:08 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2197:2199:2375:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3354:3622:3653:3865:3866:3867:3868:3871:3872:3874:4321:5007:7652:8957:10004:10400:10848:11026:11232:11473:11658:11914:12043:12049:12050:12517:12519:12555:12663:12740:13255:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bee67_3cdcdc8e1837
X-Filterd-Recvd-Size: 3384
Message-ID: <1403905024.9064.16.camel@joe-AO725>
Subject: Re: [PATCH 1/1] scripts/checkpatch.pl: update kmalloc_array/kcalloc
 conversion warning
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 27 Jun 2014 14:37:04 -0700
In-Reply-To: <1403899823-4461-1-git-send-email-fabf@skynet.be>
References: <1403899823-4461-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-27 at 22:10 +0200, Fabian Frederick wrote:
> Avoid automatic k[mz]alloc with multiplies conversions
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -4427,7 +4427,7 @@ sub process {
>  			$newfunc = "kcalloc" if ($oldfunc eq "kzalloc");
>  			if ($a1 =~ /^sizeof\s*\S/ || $a2 =~ /^sizeof\s*\S/) {
>  				if (WARN("ALLOC_WITH_MULTIPLY",
> -					 "Prefer $newfunc over $oldfunc with multiply\n" . $herecurr) &&
> +					 "Prefer $newfunc over $oldfunc with multiply when arguments are not fixed or come from unvalidated source\n" . $herecurr) &&
>  				    $fix) {
>  					my $r1 = $a1;
>  					my $r2 = $a2;

I'm not sure of the value of this as I think at some point
if not already today, the compiler will optimize the multiply
away.

But it's probably better to look at the non-sizeof variable
and emit the warning only when it's not $Constant or some
upper-case only macro #define like "\b[A-Z_]+\b" is used.

Maybe something like this:

 scripts/checkpatch.pl | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 6c7cbaf..e0d0ead 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4486,22 +4486,23 @@ sub process {
 
 # check for k[mz]alloc with multiplies that could be kmalloc_array/kcalloc
 		if ($^V && $^V ge 5.10.0 &&
-		    $line =~ /\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/) {
+		    $line =~ /\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)\s*,/) {
 			my $oldfunc = $3;
 			my $a1 = $4;
 			my $a2 = $10;
 			my $newfunc = "kmalloc_array";
 			$newfunc = "kcalloc" if ($oldfunc eq "kzalloc");
-			if ($a1 =~ /^sizeof\s*\S/ || $a2 =~ /^sizeof\s*\S/) {
+			my $r1 = $a1;
+			my $r2 = $a2;
+			if ($a1 =~ /^sizeof\s*\S/) {
+				$r1 = $a2;
+				$r2 = $a1;
+			}
+			if ($r1 !~ /^sizeof\b/ && $r2 =~ /^sizeof\s*\S/ &&
+			    !($r1 =~ /^$Constant$/ || $r1 =~ /^[A-Z_]+$/)) {
 				if (WARN("ALLOC_WITH_MULTIPLY",
 					 "Prefer $newfunc over $oldfunc with multiply\n" . $herecurr) &&
 				    $fix) {
-					my $r1 = $a1;
-					my $r2 = $a2;
-					if ($a1 =~ /^sizeof\s*\S/) {
-						$r1 = $a2;
-						$r2 = $a1;
-					}
 					$fixed[$linenr - 1] =~ s/\b($Lval)\s*\=\s*(?:$balanced_parens)?\s*(k[mz]alloc)\s*\(\s*($FuncArg)\s*\*\s*($FuncArg)/$1 . ' = ' . "$newfunc(" . trim($r1) . ', ' . trim($r2)/e;
 
 				}


