Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbaIPDWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 23:22:53 -0400
Received: from smtprelay0040.hostedemail.com ([216.40.44.40]:53379 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754465AbaIPDWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 23:22:52 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2197:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3165:3353:3622:3653:3865:3868:3870:4321:4605:5007:7652:7903:8957:9140:9545:10004:10400:10848:11026:11232:11473:11658:11914:12043:12291:12296:12438:12517:12519:12555:12683:12740:14110:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: wire40_701a0ad660714
X-Filterd-Recvd-Size: 3094
Message-ID: <1410837769.18787.40.camel@joe-AO725>
Subject: Re: [PATCH 1/1] checkpatch: check for subject uniqueness in git
 repository.
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 15 Sep 2014 20:22:49 -0700
In-Reply-To: <1410806637-3510-1-git-send-email-fabf@skynet.be>
References: <1410806637-3510-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-09-15 at 20:43 +0200, Fabian Frederick wrote:
> Adding patch subject uniqueness check in checkpatch --strict mode.
> See Documentation/SubmittingPatches/globally-unique identifier.

Perhaps something like this?
---
 scripts/checkpatch.pl | 52 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 0c520f7..e19c40b 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -622,6 +622,27 @@ sub git_commit_info {
 	return ($id, $desc);
 }
 
+my @git_commits = ();
+my @previous_subjects = ();
+
+sub check_subject_duplication {
+	my ($subject) = @_;
+
+	if ($check && $#git_commits < 1 && which("git") && -e ".git") {
+		my $output = `git log --no-color --format='%H %s' 2>&1`;
+		$output =~ s/^\s*//gm;
+		@git_commits = split("\n", $output);
+	}
+
+	return 1 if (grep(/^[a-f0-9]{40,40} $subject$/, @git_commits));
+
+	return 2 if (grep(/^$subject$/, @previous_subjects));
+
+	push(@previous_subjects, $subject);
+
+	return 0;
+}
+
 $chk_signoff = 0 if ($file);
 
 my @rawlines = ();
@@ -1264,6 +1285,20 @@ sub raw_line {
 	return $line;
 }
 
+sub get_complete_header {
+	my ($linenr) = @_;
+
+	my $offset = $linenr - 1;
+
+	my $line = $rawlines[$offset++];
+	while (defined $rawlines[$offset] &&
+	       $rawlines[$offset] =~ /\s(\S.*)$/) {
+		$line .= $rawlines[$offset++];
+	}
+
+	return $line;
+}
+
 sub cat_vet {
 	my ($vet) = @_;
 	my ($res, $coded);
@@ -2047,6 +2082,23 @@ sub process {
 			}
 		}
 
+# Check git commit and patch subject duplication
+		if ($in_header_lines && $line =~ /^Subject:/) {
+			my $subject = get_complete_header($linenr);
+			if ($subject =~ /^Subject:\s*(?:\[[^\]]*\])?\s*(.*)$/) {
+				$subject = $1;
+			}
+
+			my $subject_dup = check_subject_duplication($subject);
+			if ($subject_dup == 1) {
+				CHK("NOT_UNIQUE_SUBJECT",
+				    "Identical git commit subject found\n" . $herecurr);
+			} elsif ($subject_dup == 2) {
+				CHK("NOT_UNIQUE_SUBJECT",
+				    "Identical patch commit subject found\n" . $herecurr);
+			}
+		}
+
 # Check the patch for a signoff:
 		if ($line =~ /^\s*signed-off-by:/i) {
 			$signoff++;


