Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934416AbaGQPwR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:52:17 -0400
Received: from smtprelay0075.hostedemail.com ([216.40.44.75]:34439 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757502AbaGQPwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:52:14 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:560:800:960:973:982:988:989:1260:1345:1359:1437:1535:1544:1711:1730:1747:1777:1792:2197:2198:2199:2200:2393:2553:2559:2562:2731:2898:3138:3139:3140:3141:3142:3355:3653:3865:3866:3867:3868:3870:3871:3872:3874:4321:4605:5007:6119:6261:7903:8957:10004:10026:10848:11026:11473:11658:11914:12043:12291:12296:12346:12438:12517:12519:12555:12683:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: story58_3038e94c8c711
X-Filterd-Recvd-Size: 5039
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>,
        Hartley Sweeten <HartleyS@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] checkpatch: Add test for native c90 types in unusual order
Date: Thu, 17 Jul 2014 08:52:03 -0700
Message-Id: <190d92737ec320e720804b7cda82f1fcd88ba95d.1405609481.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1405609481.git.joe@perches.com>
References: <cover.1405609481.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

c90 section "6.7.2 Type Specifiers" says:
    "type specifiers may occur in any order"

That means that:
    short int is the same as int short
    unsigned short int is the same as int unsigned short
    etc...

checkpatch currently parses only a subset of these allowed types.

For instance: "unsigned short" and "signed short" are found by checkpatch
as a specific type, but none of the or "int short" or "int signed short"
variants are found.

Add another table for the "kernel style misordered" variants.

Add this misordered table to the findable types.

Warn when the misordered style is used.

This improves the "Missing a blank line after declarations" test as
it depends on the correct parsing of the $Declare variable which
looks for "$Type $Ident;" (ie: declarations like "int foo;").

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 1bfe2fc..d21b890 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -309,9 +309,12 @@ our $Operators	= qr{
 our $c90_Keywords = qr{do|for|while|if|else|return|goto|continue|switch|default|case|break}x;
 
 our $NonptrType;
+our $NonptrTypeMisordered;
 our $NonptrTypeWithAttr;
 our $Type;
+our $TypeMisordered;
 our $Declare;
+our $DeclareMisordered;
 
 our $NON_ASCII_UTF8	= qr{
 	[\xC2-\xDF][\x80-\xBF]               # non-overlong 2-byte
@@ -353,6 +356,25 @@ our $signature_tags = qr{(?xi:
 	Cc:
 )};
 
+our @typeListMisordered = (
+	qr{char\s+(?:un)?signed},
+	qr{int\s+(?:(?:un)?signed\s+)?short\s},
+	qr{int\s+short(?:\s+(?:un)?signed)},
+	qr{short\s+int(?:\s+(?:un)?signed)},
+	qr{(?:un)?signed\s+int\s+short},
+	qr{short\s+(?:un)?signed},
+	qr{long\s+int\s+(?:un)?signed},
+	qr{int\s+long\s+(?:un)?signed},
+	qr{long\s+(?:un)?signed\s+int},
+	qr{int\s+(?:un)?signed\s+long},
+	qr{int\s+(?:un)?signed},
+	qr{int\s+long\s+long\s+(?:un)?signed},
+	qr{long\s+long\s+int\s+(?:un)?signed},
+	qr{long\s+long\s+(?:un)?signed\s+int},
+	qr{long\s+long\s+(?:un)?signed},
+	qr{long\s+(?:un)?signed},
+);
+
 our @typeList = (
 	qr{void},
 	qr{(?:(?:un)?signed\s+)?char},
@@ -373,6 +395,7 @@ our @typeList = (
 	qr{${Ident}_t},
 	qr{${Ident}_handler},
 	qr{${Ident}_handler_fn},
+	@typeListMisordered,
 );
 our @typeListWithAttr = (
 	@typeList,
@@ -414,6 +437,7 @@ our $allowed_asm_includes = qr{(?x:
 sub build_types {
 	my $mods = "(?x:  \n" . join("|\n  ", @modifierList) . "\n)";
 	my $all = "(?x:  \n" . join("|\n  ", @typeList) . "\n)";
+	my $Misordered = "(?x:  \n" . join("|\n  ", @typeListMisordered) . "\n)";
 	my $allWithAttr = "(?x:  \n" . join("|\n  ", @typeListWithAttr) . "\n)";
 	$Modifier	= qr{(?:$Attribute|$Sparse|$mods)};
 	$NonptrType	= qr{
@@ -425,6 +449,13 @@ sub build_types {
 			)
 			(?:\s+$Modifier|\s+const)*
 		  }x;
+	$NonptrTypeMisordered	= qr{
+			(?:$Modifier\s+|const\s+)*
+			(?:
+				(?:${Misordered}\b)
+			)
+			(?:\s+$Modifier|\s+const)*
+		  }x;
 	$NonptrTypeWithAttr	= qr{
 			(?:$Modifier\s+|const\s+)*
 			(?:
@@ -439,7 +470,13 @@ sub build_types {
 			(?:(?:\s|\*|\[\])+\s*const|(?:\s|\*\s*(?:const\s*)?|\[\])+|(?:\s*\[\s*\])+)?
 			(?:\s+$Inline|\s+$Modifier)*
 		  }x;
+	$TypeMisordered	= qr{
+			$NonptrTypeMisordered
+			(?:(?:\s|\*|\[\])+\s*const|(?:\s|\*\s*(?:const\s*)?|\[\])+|(?:\s*\[\s*\])+)?
+			(?:\s+$Inline|\s+$Modifier)*
+		  }x;
 	$Declare	= qr{(?:$Storage\s+(?:$Inline\s+)?)?$Type};
+	$DeclareMisordered	= qr{(?:$Storage\s+(?:$Inline\s+)?)?$TypeMisordered};
 }
 build_types();
 
@@ -2994,6 +3031,13 @@ sub process {
 			}
 		}
 
+# check for misordered declarations of char/short/int/long with signed/unsigned
+		while ($sline =~ m{(\b$TypeMisordered\b)}g) {
+			my $tmp = trim($1);
+			WARN("MISORDERED_TYPE",
+			     "type '$tmp' should be specified in [[un]signed] [short|int|long|long long] order\n" . $herecurr);
+		}
+
 # check for static const char * arrays.
 		if ($line =~ /\bstatic\s+const\s+char\s*\*\s*(\w+)\s*\[\s*\]\s*=\s*/) {
 			WARN("STATIC_CONST_CHAR_ARRAY",
-- 
1.8.1.2.459.gbcd45b4.dirty

