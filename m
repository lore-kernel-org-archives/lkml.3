Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597Ab3LYFVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 00:21:35 -0500
Received: from smtprelay0214.hostedemail.com ([216.40.44.214]:35137 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750733Ab3LYFVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 00:21:34 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3354:3653:3865:3866:3868:3870:3871:3872:4321:5007:7652:10004:10400:10848:11026:11658:11914:12043:12291:12517:12519:12555:12683,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bead04_81bbb2a979c59
X-Filterd-Recvd-Size: 3551
Message-ID: <1387948889.2259.62.camel@joe-AO722>
Subject: [PATCH] checkpatch: Add tests for function pointer style misuses
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@shadowen.org>
Cc: linux-kernel@vger.kernel.org, Derek Perrin <d.roc16@gmail.com>
Date: Tue, 24 Dec 2013 21:21:29 -0800
In-Reply-To: <1387966783-3404-1-git-send-email-d.roc16@gmail.com>
References: <1387867432.2259.2.camel@joe-AO722>
	 <1387966783-3404-1-git-send-email-d.roc16@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel style uses function pointers in this form:
	"type (*funcptr)(args...)"

Emit warnings when this function pointer form isn't used.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 0fcbc5f..f5d4560 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2810,6 +2810,65 @@ sub process {
 			}
 		}
 
+# Function pointer declarations
+# check spacing between type, funcptr, and args
+# canonical declaration is "type (*funcptr)(args...)"
+#
+# the $Declare variable will capture all spaces after the type
+# so check it for trailing missing spaces or multiple spaces
+		if ($line =~ /^.\s*($Declare)\((\s*)\*(\s*)$Ident(\s*)\)(\s*)\(/) {
+			my $declare = $1;
+			my $pre_pointer_space = $2;
+			my $post_pointer_space = $3;
+			my $funcname = $4;
+			my $post_funcname_space = $5;
+			my $pre_args_space = $6;
+
+			if ($declare !~ /\s$/) {
+				WARN("SPACING",
+				     "missing space after return type\n" . $herecurr);
+			}
+
+# unnecessary space "type  (*funcptr)(args...)"
+			elsif ($declare =~ /\s{2,}$/) {
+				WARN("SPACING",
+				     "Multiple spaces after return type\n" . $herecurr);
+			}
+
+# unnecessary space "type ( *funcptr)(args...)"
+			if (defined $pre_pointer_space &&
+			    $pre_pointer_space =~ /^\s/) {
+				WARN("SPACING",
+				     "Unnecessary space after function pointer open parenthesis\n" . $herecurr);
+			}
+
+# unnecessary space "type (* funcptr)(args...)"
+			if (defined $post_pointer_space &&
+			    $post_pointer_space =~ /^\s/) {
+				WARN("SPACING",
+				     "Unnecessary space before function pointer name\n" . $herecurr);
+			}
+
+# unnecessary space "type (*funcptr )(args...)"
+			if (defined $post_funcname_space &&
+			    $post_funcname_space =~ /^\s/) {
+				WARN("SPACING",
+				     "Unnecessary space after function pointer name\n" . $herecurr);
+			}
+
+# unnecessary space "type (*funcptr) (args...)"
+			if (defined $pre_args_space &&
+			    $pre_args_space =~ /^\s/) {
+				WARN("SPACING",
+				     "Unnecessary space before function pointer arguments\n" . $herecurr);
+			}
+
+			if (show_type("SPACING") && $fix) {
+				$fixed[$linenr - 1] =~
+				    s/^(.\s*$Declare)\(\s*\*\s*($Ident)\s*\)\s*\(/rtrim($1) . " " . "\(\*$2\)\("/ex;
+			}
+		}
+
 # check for spacing round square brackets; allowed:
 #  1. with a type on the left -- int [] a;
 #  2. at the beginning of a line for slice initialisers -- [0...10] = 5,


