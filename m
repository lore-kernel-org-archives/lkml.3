Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbaBLMqy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 07:46:54 -0500
Received: from smtprelay0177.hostedemail.com ([216.40.44.177]:56921 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751105AbaBLMqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 07:46:53 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3653:3865:3866:3871:5007:6691:7652:10004:10400:10848:11026:11658:11914:12043:12296:12438:12517:12519:12555:12740:13069:13101:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: skate87_1eb83baf14649
X-Filterd-Recvd-Size: 2269
Message-ID: <1392209209.1868.16.camel@joe-AO722>
Subject: [PATCH] checkpatch: Warn on uses of __constant_<foo> functions
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: Simon Wunderlich <sw@simonwunderlich.de>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 12 Feb 2014 04:46:49 -0800
In-Reply-To: <1392205783.1868.5.camel@joe-AO722>
References: <1392202386-8826-1-git-send-email-sw@simonwunderlich.de>
	 <1392202386-8826-4-git-send-email-sw@simonwunderlich.de>
	 <1392205783.1868.5.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Emit a warning when using any of these __constant_<foo> forms:

	__constant_cpu_to_be[x]
	__constant_cpu_to_le[x]
	__constant_be[x]_to_cpu
	__constant_le[x]_to_cpu
	__constant_htons
	__constant_ntohs

Using any of these outside of include/uapi/ isn't preferred
as using the function without __constant_ is identical when
the argument is a constant.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 464dcef..8a5c49b 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3910,6 +3910,19 @@ sub process {
 			}
 		}
 
+# don't use __constant_<foo> functions outside of include/uapi/
+		if ($realfile !~ m@^include/uapi/@ &&
+		    $line =~ /(__constant_(?:htons|ntohs|[bl]e(?:16|32|64)_to_cpu|cpu_to_[bl]e(?:16|32|64)))\s*\(/) {
+			my $constant_func = $1;
+			my $func = $constant_func;
+			$func =~ s/^__constant_//;
+			if (WARN("CONSTANT_CONVERSION",
+				 "$constant_func should be $func\n" . $herecurr) &&
+			    $fix) {
+				$fixed[$linenr - 1] =~ s/\b$constant_func\b/$func/g;
+			}
+		}
+
 # prefer usleep_range over udelay
 		if ($line =~ /\budelay\s*\(\s*(\d+)\s*\)/) {
 			# ignore udelay's < 10, however


