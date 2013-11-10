Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab3KJV4v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 16:56:51 -0500
Received: from smtprelay0143.hostedemail.com ([216.40.44.143]:51684 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752171Ab3KJV4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 16:56:44 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:305:355:379:541:800:960:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3354:3653:3865:3866:3867:3868:3870:3871:3872:4321:4419:5007:6119:7652:7903:7974:8603:10004:10400:10848:11026:11658:11914:12043:12048:12517:12519:12555:13019:13255,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: grade76_57a47cc734644
X-Filterd-Recvd-Size: 4033
Message-ID: <1384120604.3081.19.camel@joe-AO722>
Subject: [PATCH] checkpatch: Don't require kernel style __attribute__
 shortcuts in uapi paths
From: Joe Perches <joe@perches.com>
To: "Dixit, Ashutosh" <ashutosh.dixit@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Sun, 10 Nov 2013 13:56:44 -0800
In-Reply-To: <6DC2528F945B4149AB6566DFB5F22ED38AAA18B7@ORSMSX109.amr.corp.intel.com>
References: <527D5646.9010005@intel.com>
	 <6DC2528F945B4149AB6566DFB5F22ED38AAA18B7@ORSMSX109.amr.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid proscribing kernel styled shortcuts for
gcc extensions of __attribute__((foo)) in the
uapi include paths.

Fix $realfile filename when using -f/--file to not
remove first level directory as if the filename
was used in a -P1 patch.  Only strip the first
level directory (typically a or b) for P1 patches.

Signed-off-by: Joe Perches <joe@perches.com>
---

(resending to cc lkml)

 scripts/checkpatch.pl | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 13ec69a..61090e0 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1769,11 +1769,11 @@ sub process {
 		# extract the filename as it passes
 		if ($line =~ /^diff --git.*?(\S+)$/) {
 			$realfile = $1;
-			$realfile =~ s@^([^/]*)/@@;
+			$realfile =~ s@^([^/]*)/@@ if (!$file);
 			$in_commit_log = 0;
 		} elsif ($line =~ /^\+\+\+\s+(\S+)/) {
 			$realfile = $1;
-			$realfile =~ s@^([^/]*)/@@;
+			$realfile =~ s@^([^/]*)/@@ if (!$file);
 			$in_commit_log = 0;
 
 			$p1_prefix = $1;
@@ -3877,7 +3877,8 @@ sub process {
 		}
 
 # Check for __inline__ and __inline, prefer inline
-		if ($line =~ /\b(__inline__|__inline)\b/) {
+		if ($realfile !~ m@\binclude/uapi/@ &&
+		    $line =~ /\b(__inline__|__inline)\b/) {
 			if (WARN("INLINE",
 				 "plain inline is preferred over $1\n" . $herecurr) &&
 			    $fix) {
@@ -3887,19 +3888,22 @@ sub process {
 		}
 
 # Check for __attribute__ packed, prefer __packed
-		if ($line =~ /\b__attribute__\s*\(\s*\(.*\bpacked\b/) {
+		if ($realfile !~ m@\binclude/uapi/@ &&
+		    $line =~ /\b__attribute__\s*\(\s*\(.*\bpacked\b/) {
 			WARN("PREFER_PACKED",
 			     "__packed is preferred over __attribute__((packed))\n" . $herecurr);
 		}
 
 # Check for __attribute__ aligned, prefer __aligned
-		if ($line =~ /\b__attribute__\s*\(\s*\(.*aligned/) {
+		if ($realfile !~ m@\binclude/uapi/@ &&
+		    $line =~ /\b__attribute__\s*\(\s*\(.*aligned/) {
 			WARN("PREFER_ALIGNED",
 			     "__aligned(size) is preferred over __attribute__((aligned(size)))\n" . $herecurr);
 		}
 
 # Check for __attribute__ format(printf, prefer __printf
-		if ($line =~ /\b__attribute__\s*\(\s*\(\s*format\s*\(\s*printf/) {
+		if ($realfile !~ m@\binclude/uapi/@ &&
+		    $line =~ /\b__attribute__\s*\(\s*\(\s*format\s*\(\s*printf/) {
 			if (WARN("PREFER_PRINTF",
 				 "__printf(string-index, first-to-check) is preferred over __attribute__((format(printf, string-index, first-to-check)))\n" . $herecurr) &&
 			    $fix) {
@@ -3909,7 +3913,8 @@ sub process {
 		}
 
 # Check for __attribute__ format(scanf, prefer __scanf
-		if ($line =~ /\b__attribute__\s*\(\s*\(\s*format\s*\(\s*scanf\b/) {
+		if ($realfile !~ m@\binclude/uapi/@ &&
+		    $line =~ /\b__attribute__\s*\(\s*\(\s*format\s*\(\s*scanf\b/) {
 			if (WARN("PREFER_SCANF",
 				 "__scanf(string-index, first-to-check) is preferred over __attribute__((format(scanf, string-index, first-to-check)))\n" . $herecurr) &&
 			    $fix) {



