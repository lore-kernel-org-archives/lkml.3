Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbaB0T1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:27:17 -0500
Received: from smtprelay0214.hostedemail.com ([216.40.44.214]:38451 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751263AbaB0T1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:27:15 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:305:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2197:2198:2199:2200:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3653:3865:3867:3868:3870:3871:3872:3874:4321:4605:5007:7652:8957:9592:10004:10400:10848:11232:11658:11914:12043:12517:12519:12555:13141:13149:13161:13229:13230,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bead61_21b66969e2250
X-Filterd-Recvd-Size: 3471
Message-ID: <1393529230.24588.114.camel@joe-AO722>
Subject: [PATCH] checkpatch: Make "return is not a function" test quieter
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Julia Lawall <julia.lawall@lip6.fr>, Josh Triplett <josh@joshtriplett.org>,
        Monam Agarwal <monamagarwal123@gmail.com>, opw-kernel@googlegroups.com,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 27 Feb 2014 11:27:10 -0800
In-Reply-To: <20140227184723.GA3905@kroah.com>
References: <alpine.DEB.2.10.1402261908070.2159@hadrien>
	 <20140226182832.GA23053@cloud> <20140227164152.GA26266@kroah.com>
	 <20140227170811.GA28796@thin> <alpine.DEB.2.10.1402271811010.4439@hadrien>
	 <20140227172017.GA29133@thin> <alpine.DEB.2.10.1402271822540.4439@hadrien>
	 <1393523563.24588.101.camel@joe-AO722>
	 <alpine.DEB.2.10.1402271856530.4439@hadrien>
	 <1393524256.24588.103.camel@joe-AO722> <20140227184723.GA3905@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This test is a bit noisy and opinions seem to agree that
it should not warn in a lot more situations.

It seems people agree that:

	return (foo || bar);
and
	return foo || bar;

are both acceptable style and checkpatch should be silent
about them.

For now, it warns on parentheses around a simple constant
or a single function or a ternary.

	return (foo);
	return (foo(bar));
	return (foo ? bar : baz);

The last ternary test may be quieted in the future.

Modify the deparenthesize function to only strip balanced
leading and trailing parentheses.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 91308be..be4be81 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -439,9 +439,14 @@ our $FuncArg = qr{$Typecast{0,1}($LvalOrFunc|$Constant)};
 sub deparenthesize {
 	my ($string) = @_;
 	return "" if (!defined($string));
-	$string =~ s@^\s*\(\s*@@g;
-	$string =~ s@\s*\)\s*$@@g;
+
+	while ($string =~ /^\s*\(.*\)\s*$/) {
+		$string =~ s@^\s*\(\s*@@;
+		$string =~ s@\s*\)\s*$@@;
+	}
+
 	$string =~ s@\s+@ @g;
+
 	return $string;
 }
 
@@ -3362,14 +3367,17 @@ sub process {
 			}
 		}
 
-# Return is not a function.
+# return is not a function
 		if (defined($stat) && $stat =~ /^.\s*return(\s*)\(/s) {
 			my $spacing = $1;
 			if ($^V && $^V ge 5.10.0 &&
-			    $stat =~ /^.\s*return\s*$balanced_parens\s*;\s*$/) {
-				ERROR("RETURN_PARENTHESES",
-				      "return is not a function, parentheses are not required\n" . $herecurr);
-
+			    $stat =~ /^.\s*return\s*($balanced_parens)\s*;\s*$/) {
+				my $value = $1;
+				$value = deparenthesize($value);
+				if ($value =~ m/^\s*$FuncArg\s*(?:\?|$)/) {
+					ERROR("RETURN_PARENTHESES",
+					      "return is not a function, parentheses are not required\n" . $herecurr);
+				}
 			} elsif ($spacing !~ /\s+/) {
 				ERROR("SPACING",
 				      "space required before the open parenthesis '('\n" . $herecurr);


