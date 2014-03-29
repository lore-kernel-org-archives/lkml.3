Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbaC2UOt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 16:14:49 -0400
Received: from smtprelay0024.hostedemail.com ([216.40.44.24]:34159 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751929AbaC2UOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 16:14:48 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2198:2199:2200:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3653:3865:3866:3867:3868:3872:4321:5007:7652:10004:10400:10848:11026:11658:11914:12043:12296:12346:12517:12519:12555:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wire61_ca21c3e0c24a
X-Filterd-Recvd-Size: 2678
Message-ID: <1396124085.10606.18.camel@joe-AO722>
Subject: [PATCH] checkpatch: Expand parenthesis alignment test to
 declarations, functions and assignments
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 29 Mar 2014 13:14:45 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the parenthesis alignment test works only on
misalignments of if statements like

	if (foo(bar,
			baz)

Expand the test to find misalignments like:

static inline int foo(int bar,
			int baz)

and

	foo(bar,
			baz);

and

	foo = bar(baz,
			qux);

Expand the $Inline keyword for __inline and __inline__ too.
Add $Inline to $Declare so it also matches "static inline <foo>".

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 889929d..1e63973 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -281,7 +281,7 @@ our $Attribute	= qr{
 			__weak
 		  }x;
 our $Modifier;
-our $Inline	= qr{inline|__always_inline|noinline};
+our $Inline	= qr{inline|__always_inline|noinline|__inline|__inline__};
 our $Member	= qr{->$Ident|\.$Ident|\[[^]]*\]};
 our $Lval	= qr{$Ident(?:$Member)*};
 
@@ -435,7 +435,7 @@ sub build_types {
 			(?:(?:\s|\*|\[\])+\s*const|(?:\s|\*|\[\])+|(?:\s*\[\s*\])+)?
 			(?:\s+$Inline|\s+$Modifier)*
 		  }x;
-	$Declare	= qr{(?:$Storage\s+)?$Type};
+	$Declare	= qr{(?:$Storage\s+(?:$Inline\s+)?)?$Type};
 }
 build_types();
 
@@ -1613,7 +1613,7 @@ sub pos_last_openparen {
 		}
 	}
 
-	return $last_openparen + 1;
+	my $ts = length(expand_tabs(substr($line, 0, $last_openparen))) + 1;
 }
 
 sub process {
@@ -2200,7 +2200,7 @@ sub process {
 
 # check multi-line statement indentation matches previous line
 		if ($^V && $^V ge 5.10.0 &&
-		    $prevline =~ /^\+(\t*)(if \(|$Ident\().*(\&\&|\|\||,)\s*$/) {
+		    $prevline =~ /^\+([ \t]*)((?:$c90_Keywords(?:\s+if)\s*)|(?:$Declare\s*)?(?:$Ident|\(\s*\*\s*$Ident\s*\))\s*|$Ident\s*=\s*$Ident\s*)\(.*(\&\&|\|\||,)\s*$/) {
 			$prevline =~ /^\+(\t*)(.*)$/;
 			my $oldindent = $1;
 			my $rest = $2;


