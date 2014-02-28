Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249AbaB1VGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 16:06:17 -0500
Received: from smtprelay0135.hostedemail.com ([216.40.44.135]:56872 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751665AbaB1VGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 16:06:15 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:69:355:379:541:599:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1567:1593:1594:1711:1714:1730:1747:1777:1792:2197:2198:2199:2200:2393:2559:2562:2828:3138:3139:3140:3141:3142:3653:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:5007:6119:6691:7652:7875:7903:9010:9592:10004:10400:10848:11026:11473:11658:11914:12043:12295:12438:12517:12519:12555:12663:12679:13071:13161:13229:14093:14097:21060:21063,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cloth78_535d0f2802a0c
X-Filterd-Recvd-Size: 4750
Message-ID: <1393621571.10280.49.camel@joe-AO722>
Subject: Re: [PATCH v2 2/2] checkpatch: fix spurious vendor compatible
 warnings
From: Joe Perches <joe@perches.com>
To: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: Andy Whitcroft <apw@canonical.com>, Rob Herring <robh@kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 28 Feb 2014 13:06:11 -0800
In-Reply-To: <1393604742-14317-3-git-send-email-florian.vaussard@epfl.ch>
References: <1393604742-14317-1-git-send-email-florian.vaussard@epfl.ch>
	 <1393604742-14317-3-git-send-email-florian.vaussard@epfl.ch>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

A couple of suggestions and a couple of questions.

I made the patch below against your patches to.

o Look for ".compatible = "foo" strings in .c and .h files too
o Improve the vendor name match in vendor-prefix.txt by only
  matching the exact vendor name at the beginning of lines.

I then produced a file of all the compatible uses in dts
and used checkpatch on it.  It's a long list and a longer
checkpatch warning list.

$ git ls-files | grep -E "\.dtsi?$" | \
  xargs grep -hE "^\s*compatible\s*="| \
  sed -r -e 's/^\s*//' -e 's/\s*=\s*/ = /'| sort | uniq > tmp.dts
$ .scripts/checkpatch.pl -f tmp.dts

A couple of questions:

How does the $compat2 variable actually work?
What is it supposed to do?

				my $compat2 = $compat;
				$compat2 =~ s/\,[a-z]*\-/\,<\.\*>\-/;

For instance:
WARNING: DT compatible string "marvell,tauros2-cache" appears un-documented -- check ./Documentation/devicetree/bindings/

The prefix "tauros2-" doesn't match '=~ s/[a-z]*-/

Should it?  Should the '[a-z]*' be '[a-zA-Z0-9-]+'
like the other test?

Also the grep used when $compat2 is different than $compat
has <.*>

There aren't any descriptions I see in binding/ that have
any <foo> like uses with the angle brackets.

Are the angle brackets "<" and ">" necessary?

I think the code block should look more like:

				my $compat2 = $compat;
				$compat2 =~ s/\,[a-zA-Z0-9]*\-/\,\.\*\-/g;
				my $grepfor = "\Q$compat\E";
				$grepfor .= "|\Q$compat2\E" if ($compat2 ne $compat);
				`grep -Erq "$grepfor" $dt_path`;

so that there's only 1 grep pattern when
$compat2 is the same as $compat and the
strings are escape quoted.

There are a _lot_ of missing entries:

o 164 vendor names
o 2408 device names (maybe due to bad compat2 greps?)

What, if anything, should be done about them?

---
 scripts/checkpatch.pl | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 4b5e7b3..7a9eed9 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2051,29 +2051,29 @@ sub process {
 		}
 
 # check for DT compatible documentation
-		if (defined $root && $realfile =~ /\.dts/ &&
-		    $rawline =~ /^\+\s*compatible\s*=/) {
+		if (defined $root &&
+		    (($realfile =~ /\.dtsi?$/ && $line =~ /^\+\s*compatible\s*=\s*\"/) ||
+		     ($realfile =~ /\.[ch]$/ && $line =~ /^\+.*\.compatible\s*=\s*\"/))) {
+
 			my @compats = $rawline =~ /\"([a-zA-Z0-9\-\,\.\+_]+)\"/g;
 
+			my $dt_path = $root . "/Documentation/devicetree/bindings/";
+			my $vp_file = $root . "/Documentation/devicetree/bindings/vendor-prefixes.txt";
+
 			foreach my $compat (@compats) {
 				my $compat2 = $compat;
-				my $dt_path =  $root . "/Documentation/devicetree/bindings/";
 				$compat2 =~ s/\,[a-z]*\-/\,<\.\*>\-/;
 				`grep -Erq "$compat|$compat2" $dt_path`;
 				if ( $? >> 8 ) {
 					WARN("UNDOCUMENTED_DT_STRING",
 					     "DT compatible string \"$compat\" appears un-documented -- check $dt_path\n" . $herecurr);
 				}
-
-				my $vendor = $compat;
-				my $vendor_path = $dt_path . "vendor-prefixes.txt";
-				next if (! -f $vendor_path);
-				next if not $vendor =~ /^[a-zA-Z0-9\-]+\,.*/;
-				$vendor =~ s/^([a-zA-Z0-9\-]+)\,.*/$1/;
-				`grep -Eq "$vendor" $vendor_path`;
+				next if $compat !~ /^([a-zA-Z0-9\-]+)\,/;
+				my $vendor = $1;
+				`grep -Eq "^$vendor\\b" $vp_file`;
 				if ( $? >> 8 ) {
 					WARN("UNDOCUMENTED_DT_STRING",
-					     "DT compatible string vendor \"$vendor\" appears un-documented -- check $vendor_path\n" . $herecurr);
+					     "DT compatible string vendor \"$vendor\" appears un-documented -- check $vp_file\n" . $herecurr);
 				}
 			}
 		}
---


