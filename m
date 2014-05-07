Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbaEGSNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 14:13:32 -0400
Received: from smtprelay0159.hostedemail.com ([216.40.44.159]:44204 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751172AbaEGSN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 14:13:29 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1345:1431:1437:1534:1541:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:3138:3139:3140:3141:3142:3353:3653:3865:3867:3870:3872:4321:4605:5007:6261:7903:8957:10004:10026:10848:11026:11473:11658:11914:12438:12517:12519:12555:13311:13357:13851,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: side53_3b585b9818f37
X-Filterd-Recvd-Size: 2352
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andy Whitcroft <apw@canonical.com>
Subject: [PATCH] checkpatch: Make --strict a default for files in drivers/net and net/
Date: Wed,  7 May 2014 11:13:26 -0700
Message-Id: <487acde009f61607863704e5dd9da7f151cf5be8.1399486274.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Networking files are generally more strictly conformant to
linux-kernel style so make checkpatch more verbose by default for
patches to files or when checking files in these directories.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 85fc923..633e9f6 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -24,6 +24,7 @@ my $emacs = 0;
 my $terse = 0;
 my $file = 0;
 my $check = 0;
+my $check_orig = 0;
 my $summary = 1;
 my $mailback = 0;
 my $summary_file = 0;
@@ -146,6 +147,7 @@ GetOptions(
 help(0) if ($help);
 
 $fix = 1 if ($fix_inplace);
+$check_orig = $check;
 
 my $exit = 0;
 
@@ -1813,11 +1815,13 @@ sub process {
 		$here = "#$linenr: " if (!$file);
 		$here = "#$realline: " if ($file);
 
+		my $found_file = 0;
 		# extract the filename as it passes
 		if ($line =~ /^diff --git.*?(\S+)$/) {
 			$realfile = $1;
 			$realfile =~ s@^([^/]*)/@@ if (!$file);
 			$in_commit_log = 0;
+			$found_file = 1;
 		} elsif ($line =~ /^\+\+\+\s+(\S+)/) {
 			$realfile = $1;
 			$realfile =~ s@^([^/]*)/@@ if (!$file);
@@ -1834,6 +1838,15 @@ sub process {
 				ERROR("MODIFIED_INCLUDE_ASM",
 				      "do not modify files in include/asm, change architecture specific files in include/asm-<architecture>\n" . "$here$rawline\n");
 			}
+			$found_file = 1;
+		}
+
+		if ($found_file) {
+			if ($realfile =~ m@^(drivers/net/|net/)@) {
+				$check = 1;
+			} else {
+				$check = $check_orig;
+			}
 			next;
 		}
 
-- 
1.8.1.2.459.gbcd45b4.dirty

