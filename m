Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbbAURXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 12:23:37 -0500
Received: from smtprelay0083.hostedemail.com ([216.40.44.83]:46475 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753678AbbAURX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 12:23:29 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3653:3867:3868:3870:4605:5007:6117:6119:6261:7903:8957:10004:10400:10848:11026:11473:11658:11914:12043:12296:12517:12519:12555:12740:13069:13161:13229:13311:13357:14093:14097:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: nerve95_db6da3c1e05
X-Filterd-Recvd-Size: 2645
Message-ID: <1421861003.10574.19.camel@perches.com>
Subject: [PATCH] checkpatch: Add types for other OS typedefs
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: devel@driverdev.osuosl.org, Larry.Finger@lwfinger.net,
        gregkh@linuxfoundation.org, gulsah.1004@gmail.com, shack@linux.com,
        thomas@grouk.net, linux-kernel@vger.kernel.org
Date: Wed, 21 Jan 2015 09:23:23 -0800
In-Reply-To: <1421859873.10574.17.camel@perches.com>
References: <20150121144129.GA7195@lin-535U4C>
	 <1421859873.10574.17.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bsd and sysv use different typedefs for unsigned types.

These are in types.h but not in checkpatch, so add them
to checkpatch's ability to know types.

This can avoid false positives for code like:

void foo(void)
{
	int x;
	uint y;

	[...];
}

where checkpatch incorrectly emits a warning for
"missing a blank line after declarations".

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 41223c9..fadb47d 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -339,6 +339,11 @@ our $UTF8	= qr{
 	| $NON_ASCII_UTF8
 }x;
 
+our $typeOtherOSTypedefs = qr{(?x:
+	u_(?:char|short|int|long) |          # bsd
+	u(?:nchar|short|int|long)            # sysv
+)};
+
 our $typeTypedefs = qr{(?x:
 	(?:__)?(?:u|s|be|le)(?:8|16|32|64)|
 	atomic_t
@@ -475,6 +480,7 @@ sub build_types {
 			(?:$Modifier\s+|const\s+)*
 			(?:
 				(?:typeof|__typeof__)\s*\([^\)]*\)|
+				(?:$typeOtherOSTypedefs\b)|
 				(?:$typeTypedefs\b)|
 				(?:${all}\b)
 			)
@@ -492,6 +498,7 @@ sub build_types {
 			(?:
 				(?:typeof|__typeof__)\s*\([^\)]*\)|
 				(?:$typeTypedefs\b)|
+				(?:$typeOtherOSTypedefs\b)|
 				(?:${allWithAttr}\b)
 			)
 			(?:\s+$Modifier|\s+const)*
@@ -3152,6 +3159,7 @@ sub process {
 		    $line !~ /\btypedef\s+$Type\s*\(\s*\*?$Ident\s*\)\s*\(/ &&
 		    $line !~ /\btypedef\s+$Type\s+$Ident\s*\(/ &&
 		    $line !~ /\b$typeTypedefs\b/ &&
+		    $line !~ /\b$typeOtherOSTypedefs\b/ &&
 		    $line !~ /\b__bitwise(?:__|)\b/) {
 			WARN("NEW_TYPEDEFS",
 			     "do not add new typedefs\n" . $herecurr);


