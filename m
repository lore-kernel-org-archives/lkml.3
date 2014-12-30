Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaL3VEL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 16:04:11 -0500
Received: from smtprelay0084.hostedemail.com ([216.40.44.84]:46965 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751788AbaL3VEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 16:04:06 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3653:3865:3871:3874:4321:4605:5007:6261:8957:10004:10400:10848:11026:11473:11658:11914:12043:12438:12517:12519:12555:13069:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: roll31_404918f065634
X-Filterd-Recvd-Size: 2400
Message-ID: <1419973437.13502.2.camel@perches.com>
Subject: [PATCH] checkpatch: Improve octal permissions tests
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 30 Dec 2014 13:03:57 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add world writable permissions tests for the various
functions like debugfs etc...

Add $String type for $FuncArg so that string constants
are matched.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index f0bb6d6..d1fd444 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -298,6 +298,7 @@ our $Binary	= qr{(?i)0b[01]+$Int_type?};
 our $Hex	= qr{(?i)0x[0-9a-f]+$Int_type?};
 our $Int	= qr{[0-9]+$Int_type?};
 our $Octal	= qr{0[0-7]+$Int_type?};
+our $String	= qr{"[X\t]*"};
 our $Float_hex	= qr{(?i)0x[0-9a-f]+p-?[0-9]+[fl]?};
 our $Float_dec	= qr{(?i)(?:[0-9]+\.[0-9]*|[0-9]*\.[0-9]+)(?:e-?[0-9]+)?[fl]?};
 our $Float_int	= qr{(?i)[0-9]+e-?[0-9]+[fl]?};
@@ -517,7 +518,7 @@ our $Typecast	= qr{\s*(\(\s*$NonptrType\s*\)){0,1}\s*};
 
 our $balanced_parens = qr/(\((?:[^\(\)]++|(?-1))*\))/;
 our $LvalOrFunc	= qr{((?:[\&\*]\s*)?$Lval)\s*($balanced_parens{0,1})\s*};
-our $FuncArg = qr{$Typecast{0,1}($LvalOrFunc|$Constant)};
+our $FuncArg = qr{$Typecast{0,1}($LvalOrFunc|$Constant|$String)};
 
 our $declaration_macros = qr{(?x:
 	(?:$Storage\s+)?(?:[A-Z_][A-Z0-9]*_){0,2}(?:DEFINE|DECLARE)(?:_[A-Z0-9]+){1,2}\s*\(|
@@ -5255,6 +5256,9 @@ sub process {
 					     length($val) ne 4)) {
 						ERROR("NON_OCTAL_PERMISSIONS",
 						      "Use 4 digit octal (0777) not decimal permissions\n" . $herecurr);
+					} elsif ($val =~ /^$Octal$/ && (oct($val) & 02)) {
+						ERROR("EXPORTED_WORLD_WRITABLE",
+						      "Exporting writable files is usually an error. Consider more restrictive permissions.\n" . $herecurr);
 					}
 				}
 			}


