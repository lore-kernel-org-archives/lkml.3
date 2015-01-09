Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbbAIV64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 16:58:56 -0500
Received: from smtprelay0133.hostedemail.com ([216.40.44.133]:41419 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751760AbbAIV6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 16:58:55 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:69:355:379:541:800:960:968:973:982:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2538:2559:2562:2828:3138:3139:3140:3141:3142:3352:3653:3865:3866:3867:3868:3871:3872:3874:4250:4321:4605:5007:6119:6261:10004:10400:10848:11026:11232:11473:11658:11914:12043:12050:12291:12517:12519:12555:12683:12698:12737:13095:13161:13229:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: pie94_6aa41051bff01
X-Filterd-Recvd-Size: 3948
Message-ID: <1420840730.32628.13.camel@perches.com>
Subject: [PATCH] checkpatch: Update git commit message
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, Prarit Bhargava <prarit@redhat.com>,
        Daniel Baluta <daniel.baluta@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 09 Jan 2015 13:58:50 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The git commit message can be confusing,

Try to clarify the message a bit to reduce
the confusion when emitted.

Show the correct form using
	Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")'
and if the git commit sha1 is unique, show
the right sha1 to use with the actual title

Signed-off-by: Joe Perches <joe@perches.com>
Original-patch-by: Prarit Bhargava <prarit@redhat.com>
---
 scripts/checkpatch.pl | 45 ++++++++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 13 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 6afc24b..5d8c1f1 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -634,6 +634,8 @@ sub git_commit_info {
 	$output =~ s/^\s*//gm;
 	my @lines = split("\n", $output);
 
+	return ($id, $desc) if ($#lines < 0);
+
 	if ($lines[0] =~ /^error: short SHA1 $commit is ambiguous\./) {
 # Maybe one day convert this block of bash into something that returns
 # all matching commit ids, but it's very slow...
@@ -2173,21 +2175,38 @@ sub process {
 			      "Remove Gerrit Change-Id's before submitting upstream.\n" . $herecurr);
 		}
 
-# Check for improperly formed commit descriptions
-		if ($in_commit_log &&
-		    $line =~ /\bcommit\s+[0-9a-f]{5,}/i &&
-		    !($line =~ /\b[Cc]ommit [0-9a-f]{12,40} \("/ ||
-		      ($line =~ /\b[Cc]ommit [0-9a-f]{12,40}\s*$/ &&
-		       defined $rawlines[$linenr] &&
-		       $rawlines[$linenr] =~ /^\s*\("/))) {
-			$line =~ /\b(c)ommit\s+([0-9a-f]{5,})/i;
+# Check for git id commit length and improperly formed commit descriptions
+		if ($in_commit_log && $line =~ /\b(c)ommit\s+([0-9a-f]{5,})/i) {
 			my $init_char = $1;
 			my $orig_commit = lc($2);
-			my $id = '01234567890ab';
-			my $desc = 'commit description';
-		        ($id, $desc) = git_commit_info($orig_commit, $id, $desc);
-			ERROR("GIT_COMMIT_ID",
-			      "Please use 12 or more chars for the git commit ID like: '${init_char}ommit $id (\"$desc\")'\n" . $herecurr);
+			my $short = 1;
+			my $long = 0;
+			my $case = 1;
+			my $space = 1;
+			my $hasdesc = 0;
+			my $id = '0123456789ab';
+			my $orig_desc = "commit description";
+			my $description = "";
+
+			$short = 0 if ($line =~ /\bcommit\s+[0-9a-f]{12,40}/i);
+			$long = 1 if ($line =~ /\bcommit\s+[0-9a-f]{41,}/i);
+			$space = 0 if ($line =~ /\bcommit [0-9a-f]/i);
+			$case = 0 if ($line =~ /\b[Cc]ommit\s+[0-9a-f]{5,40}[^A-F]/);
+			if ($line =~ /\bcommit\s+[0-9a-f]{5,}\s+\("([^"]+)"\)/i) {
+				$orig_desc = $1;
+			} elsif ($line =~ /\bcommit\s+[0-9a-f]{5,}\s*$/i &&
+				 defined $rawlines[$linenr] &&
+				 $rawlines[$linenr] =~ /^\s*\("([^"]+)"\)/) {
+				$orig_desc = $1;
+			}
+
+			($id, $description) = git_commit_info($orig_commit,
+							      $id, $orig_desc);
+
+			if ($short || $long || $space || $case || ($orig_desc ne $description)) {
+				ERROR("GIT_COMMIT_ID",
+				      "Please use git commit description style 'commit <12+ chars of sha1> (\"<title line>\")' - ie: '${init_char}ommit $id (\"$description\")'\n" . $herecurr);
+			}
 		}
 
 # Check for added, moved or deleted files


