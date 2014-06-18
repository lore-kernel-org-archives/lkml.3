Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027AbaFRRot (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 13:44:49 -0400
Received: from smtprelay0008.hostedemail.com ([216.40.44.8]:60169 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752731AbaFRRos (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 13:44:48 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3353:3865:3866:3868:3870:3872:3874:4321:4605:5007:6119:7652:10004:10400:10848:11232:11658:11914:12295:12517:12519:12555:12679:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: fan15_46bc107b4ae4e
X-Filterd-Recvd-Size: 2487
Message-ID: <1403113484.3839.13.camel@joe-AO725>
Subject: [PATCH V2] checkpatch: Warn on unnecessary void function return
 statements
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Anish Bhatt <anish@chelsio.com>
Date: Wed, 18 Jun 2014 10:44:44 -0700
In-Reply-To: <1401728316.5770.9.camel@joe-AO725>
References: <1401728316.5770.9.camel@joe-AO725>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With some exceptions, warn on void functions that end with a
"return;", because it's unnecessary.

Check the closing brace at the start of a line.
If the line before that has a single tab, then return;
look at the line before that.  If it's not a label,
emit a warning.

So, emit a warning on:

void function(...)
{
	[...]
	return;
}

but do not emit a warning on the below because
gcc requires any statement (including a bare
semicolon) before the closing function brace:

void function(...)
{
	[...]
		goto label;
	[...]

label:
	return;
}

Signed-off-by: Joe Perches <joe@perches.com>
---

V2: The previous patch had a few too many false positives
    on styles that should be acceptable.

 scripts/checkpatch.pl | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 862cc7a..b191c88 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3470,6 +3470,18 @@ sub process {
 			}
 		}
 
+# unnecessary return in a void function
+# at end-of-function, with the previous line a single leading tab, then return;
+# and the line before that not a goto label target like "out:"
+		if ($sline =~ /^[ \+]}\s*$/ &&
+		    $prevline =~ /^\+\treturn\s*;\s*$/ &&
+		    $linenr >= 3 &&
+		    $lines[$linenr - 3] =~ /^[ +]/ &&
+		    $lines[$linenr - 3] !~ /^[ +]\s*$Ident\s*:/) {
+			WARN("RETURN_VOID",
+			     "void function return statements are not generally useful\n" . $hereprev);
+               }
+
 # if statements using unnecessary parentheses - ie: if ((foo == bar))
 		if ($^V && $^V ge 5.10.0 &&
 		    $line =~ /\bif\s*((?:\(\s*){2,})/) {


