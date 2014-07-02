Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752340AbaGBWAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 18:00:53 -0400
Received: from smtprelay0111.hostedemail.com ([216.40.44.111]:48106 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751303AbaGBWAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 18:00:52 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2538:2559:2562:2828:3138:3139:3140:3141:3142:3354:3653:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:4605:5007:6119:7522:7652:7903:9010:10004:10400:10848:11026:11473:11658:11914:12043:12050:12291:12296:12438:12517:12519:12555:12683:12698:12737:13095:13161:13229:14093:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: plate89_418553a216c44
X-Filterd-Recvd-Size: 3846
Message-ID: <1404338448.14741.8.camel@joe-AO725>
Subject: [PATCH] checkpatch: Add test for commit id formatting style in
 commit log
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Wed, 02 Jul 2014 15:00:48 -0700
In-Reply-To: <20140702131534.c613f55f79519b3862f79e40@linux-foundation.org>
References: <20140702130210.fd40d67f0819cfb5f3e9e5ca@linux-foundation.org>
	 <1404331746.14624.95.camel@joe-AO725>
	 <20140702131534.c613f55f79519b3862f79e40@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit logs have various forms of commit id references.

Try to standardize on a 12 character long lower case
commit id along with a description of parentheses and
the quoted subject line

ie: commit 0123456789ab ("commit description")

If git and a git tree exists, look up the commit id an
emit the appropriate line as part of the message.

Signed-off-by: Joe Perches <joe@perches.com>
Requested-by: Andrew Morton <akpm@linux-foundation.org>
---
 scripts/checkpatch.pl | 54 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 6c7cbaf..9b0734b 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -550,6 +550,34 @@ sub seed_camelcase_includes {
 	}
 }
 
+sub git_commit_info {
+	my ($commit, $id, $desc) = @_;
+
+	return ($id, $desc) if ((which("git") eq "") || !(-e ".git"));
+
+	my $output = `git log --no-color --format='%H %s' -1 $commit 2>&1`;
+	$output =~ s/^\s*//gm;
+	my @lines = split("\n", $output);
+
+	if ($lines[0] =~ /^error: short SHA1 $commit is ambiguous\./) {
+# Maybe one day convert this block of bash into something that returns
+# all matching commit ids, but it's very slow...
+#
+#		echo "checking commits $1..."
+#		git rev-list --remotes | grep -i "^$1" |
+#		while read line ; do
+#		    git log --format='%H %s' -1 $line |
+#		    echo "commit $(cut -c 1-12,41-)"
+#		done
+	} elsif ($lines[0] =~ /^fatal: ambiguous argument '$commit': unknown revision or path not in the working tree\./) {
+	} else {
+		$id = substr($lines[0], 0, 12);
+		$desc = substr($lines[0], 41);
+	}
+
+	return ($id, $desc);
+}
+
 $chk_signoff = 0 if ($file);
 
 my @rawlines = ();
@@ -674,6 +702,18 @@ sub format_email {
 	return $formatted_email;
 }
 
+sub which {
+    my ($bin) = @_;
+
+    foreach my $path (split(/:/, $ENV{PATH})) {
+	if (-e "$path/$bin") {
+	    return "$path/$bin";
+	}
+    }
+
+    return "";
+}
+
 sub which_conf {
 	my ($conf) = @_;
 
@@ -1958,6 +1998,20 @@ sub process {
 			      "Remove Gerrit Change-Id's before submitting upstream.\n" . $herecurr);
 		}
 
+# Check for improperly formed commit descriptions
+		if ($in_commit_log &&
+		    $line =~ /\bcommit\s+[0-9a-f]{5,}/i &&
+		    $line !~ /\b[Cc]ommit [0-9a-f]{12,16} \("/) {
+			$line =~ /\b(c)ommit\s+([0-9a-f]{5,})/i;
+			my $init_char = $1;
+			my $orig_commit = lc($2);
+			my $id = '01234567890ab';
+			my $desc = 'commit description';
+		        ($id, $desc) = git_commit_info($orig_commit, $id, $desc);
+			ERROR("GIT_COMMIT_ID",
+			      "Please use 12 to 16 chars for the git commit ID like: '${init_char}ommit $id (\"$desc\")'\n" . $herecurr);
+		}
+
 # Check for wrappage within a valid hunk of the file
 		if ($realcnt != 0 && $line !~ m{^(?:\+|-| |\\ No newline|$)}) {
 			ERROR("CORRUPTED_PATCH",


