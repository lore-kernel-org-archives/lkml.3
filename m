Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab3KDVzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 16:55:04 -0500
Received: from smtprelay0094.hostedemail.com ([216.40.44.94]:48704 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751056Ab3KDVzC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 16:55:02 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:69:355:379:541:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3354:3653:3865:3867:3868:3870:3871:3872:3874:5007:6119:7652:7903:8957:9545:10004:10400:10848:11026:11658:11914:12043:12438:12517:12519:12555:13161:13229,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: women73_e4363c3c832a
X-Filterd-Recvd-Size: 4394
Message-ID: <1383602096.28651.8.camel@joe-AO722>
Subject: [PATCH -next] get_maintainer: Improve "Author:" rolestats
From: Joe Perches <joe@perches.com>
To: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
Cc: Chen Gang <gang.chen@asianux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 04 Nov 2013 13:54:56 -0800
In-Reply-To: <52750739.6040706@gmail.com>
References: <52738E90.6040104@asianux.com>
	 <1383330777.3042.2.camel@joe-AO722> <52750739.6040706@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add this to "try this"...

Chen Gang's defect is because his git repository branch
had a commit he authored but where did not add his signature.

Also, there's a defect in function vcs_find_signers.
It should only return the commit count and array references.

If there are no signers in the commit history interval specified,
then the "authors" array is added to the "signers" array and
returned as a single array.

Use references instead.

Make sure that references are defined in the places
that vcs_find_signers is called.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index ee9adb8..9c3986f 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -128,7 +128,7 @@ my %VCS_cmds_git = (
     "blame_commit_pattern" => "^([0-9a-f]+) ",
     "author_pattern" => "^GitAuthor: (.*)",
     "subject_pattern" => "^GitSubject: (.*)",
-    "stat_pattern" => "(\\d+)\\t(\\d+)\\t\$file",
+    "stat_pattern" => "^(\\d+)\\t(\\d+)\\t\$file\$",
 );
 
 my %VCS_cmds_hg = (
@@ -156,7 +156,7 @@ my %VCS_cmds_hg = (
     "blame_commit_pattern" => "^([ 0-9a-f]+):",
     "author_pattern" => "^HgAuthor: (.*)",
     "subject_pattern" => "^HgSubject: (.*)",
-    "stat_pattern" => "(\\d+)\t(\\d+)\t\$file",
+    "stat_pattern" => "^(\\d+)\t(\\d+)\t\$file\$",
 );
 
 my $conf = which_conf(".get_maintainer.conf");
@@ -1297,7 +1297,7 @@ sub vcs_find_signers {
 
 #    print("stats: <@stats>\n");
 
-    return (0, @signatures, @authors) if !@signatures;
+    return (0, \@signatures, \@authors, \@stats) if !@signatures;
 
     save_commits_by_author(@lines) if ($interactive);
     save_commits_by_signer(@lines) if ($interactive);
@@ -1880,9 +1880,10 @@ sub vcs_file_signoffs {
     $cmd =~ s/(\$\w+)/$1/eeg;		# interpolate $cmd
 
     ($commits, $signers_ref, $authors_ref, $stats_ref) = vcs_find_signers($cmd, $file);
-    @signers = @{$signers_ref};
-    @authors = @{$authors_ref};
-    @stats = @{$stats_ref};
+
+    @signers = @{$signers_ref} if defined $signers_ref;
+    @authors = @{$authors_ref} if defined $authors_ref;
+    @stats = @{$stats_ref} if defined $stats_ref;
 
 #    print("commits: <$commits>\nsigners:<@signers>\nauthors: <@authors>\nstats: <@stats>\n");
 
@@ -1965,8 +1966,8 @@ sub vcs_file_blame {
 	    $cmd =~ s/(\$\w+)/$1/eeg;	#substitute variables in $cmd
 
 	    ($commit_count, $commit_signers_ref, $commit_authors_ref, $stats_ref) = vcs_find_signers($cmd, $file);
-	    @commit_authors = @{$commit_authors_ref};
-	    @commit_signers = @{$commit_signers_ref};
+	    @commit_authors = @{$commit_authors_ref} if defined $commit_authors_ref;
+	    @commit_signers = @{$commit_signers_ref} if defined $commit_signers_ref;
 
 	    push(@signers, @commit_signers);
 	} else {
@@ -1983,8 +1984,8 @@ sub vcs_file_blame {
 		$cmd =~ s/(\$\w+)/$1/eeg;	#substitute variables in $cmd
 
 		($commit_count, $commit_signers_ref, $commit_authors_ref, $stats_ref) = vcs_find_signers($cmd, $file);
-		@commit_authors = @{$commit_authors_ref};
-		@commit_signers = @{$commit_signers_ref};
+		@commit_authors = @{$commit_authors_ref} if defined $commit_authors_ref;
+		@commit_signers = @{$commit_signers_ref} if defined $commit_signers_ref;
 
 		push(@signers, @commit_signers);
 	    }


