Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaEZUeD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 16:34:03 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:35887 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaEZUd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 16:33:56 -0400
Message-Id: <20140526203354.618701914@networkplumber.org>
User-Agent: quilt/0.63-1
Date: Mon, 26 May 2014 13:33:11 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 2/4] get_maintainer: remove quoting on hash label
References: <20140526203309.782169359@networkplumber.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=get_maintainer-label.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't need to quote hash labels, especially when initializing.
Code is cleaner if unquoted.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>

--- a/scripts/get_maintainer.pl	2014-05-26 13:09:47.000000000 -0700
+++ b/scripts/get_maintainer.pl	2014-05-26 13:27:49.000000000 -0700
@@ -94,69 +94,63 @@ my $rfc822_char = '[\\000-\\377]';
 my %VCS_cmds;
 
 my %VCS_cmds_git = (
-    "execute_cmd" => \&git_execute_cmd,
-    "available" => '(which("git") ne "") && (-e ".git")',
-    "find_signers_cmd" =>
-	"git log --no-color --follow --since=\$email_git_since " .
-	    '--numstat --no-merges ' .
-	    '--format="GitCommit: %H%n' .
-		      'GitAuthor: %an <%ae>%n' .
-		      'GitDate: %aD%n' .
-		      'GitSubject: %s%n' .
-		      '%b%n"' .
-	    " -- \$file",
-    "find_commit_signers_cmd" =>
-	"git log --no-color " .
-	    '--numstat ' .
-	    '--format="GitCommit: %H%n' .
-		      'GitAuthor: %an <%ae>%n' .
-		      'GitDate: %aD%n' .
-		      'GitSubject: %s%n' .
-		      '%b%n"' .
-	    " -1 \$commit",
-    "find_commit_author_cmd" =>
-	"git log --no-color " .
-	    '--numstat ' .
-	    '--format="GitCommit: %H%n' .
-		      'GitAuthor: %an <%ae>%n' .
-		      'GitDate: %aD%n' .
-		      'GitSubject: %s%n"' .
-	    " -1 \$commit",
-    "blame_range_cmd" => "git blame -l -L \$diff_start,+\$diff_length \$file",
-    "blame_file_cmd" => "git blame -l \$file",
-    "commit_pattern" => "^GitCommit: ([0-9a-f]{40,40})",
-    "blame_commit_pattern" => "^([0-9a-f]+) ",
-    "author_pattern" => "^GitAuthor: (.*)",
-    "subject_pattern" => "^GitSubject: (.*)",
-    "stat_pattern" => "^(\\d+)\\t(\\d+)\\t\$file\$",
+    execute_cmd => \&git_execute_cmd,
+    available   => '(which("git") ne "") && (-e ".git")',
+
+    find_signers_cmd =>
+      "git log --no-color --follow --since=\$email_git_since "
+      . '--numstat --no-merges '
+      . '--format="GitCommit: %H%n'
+      . 'GitAuthor: %an <%ae>%n'
+      . 'GitDate: %aD%n'
+      . 'GitSubject: %s%n' . '%b%n"'
+      . " -- \$file",
+    find_commit_signers_cmd => "git log --no-color "
+      . '--numstat '
+      . '--format="GitCommit: %H%n'
+      . 'GitAuthor: %an <%ae>%n'
+      . 'GitDate: %aD%n'
+      . 'GitSubject: %s%n' . '%b%n"'
+      . " -1 \$commit",
+    find_commit_author_cmd => "git log --no-color "
+      . '--numstat '
+      . '--format="GitCommit: %H%n'
+      . 'GitAuthor: %an <%ae>%n'
+      . 'GitDate: %aD%n'
+      . 'GitSubject: %s%n"'
+      . " -1 \$commit",
+    blame_range_cmd => "git blame -l -L \$diff_start,+\$diff_length \$file",
+    blame_file_cmd  => "git blame -l \$file",
+    commit_pattern  => "^GitCommit: ([0-9a-f]{40,40})",
+    blame_commit_pattern => "^([0-9a-f]+) ",
+    author_pattern       => "^GitAuthor: (.*)",
+    subject_pattern      => "^GitSubject: (.*)",
+    stat_pattern         => "^(\\d+)\\t(\\d+)\\t\$file\$",
 );
 
 my %VCS_cmds_hg = (
-    "execute_cmd" => \&hg_execute_cmd,
-    "available" => '(which("hg") ne "") && (-d ".hg")',
-    "find_signers_cmd" =>
-	"hg log --date=\$email_hg_since " .
-	    "--template='HgCommit: {node}\\n" .
-	                "HgAuthor: {author}\\n" .
-			"HgSubject: {desc}\\n'" .
-	    " -- \$file",
-    "find_commit_signers_cmd" =>
-	"hg log " .
-	    "--template='HgSubject: {desc}\\n'" .
-	    " -r \$commit",
-    "find_commit_author_cmd" =>
-	"hg log " .
-	    "--template='HgCommit: {node}\\n" .
-		        "HgAuthor: {author}\\n" .
-			"HgSubject: {desc|firstline}\\n'" .
-	    " -r \$commit",
-    "blame_range_cmd" => "",		# not supported
-    "blame_file_cmd" => "hg blame -n \$file",
-    "commit_pattern" => "^HgCommit: ([0-9a-f]{40,40})",
-    "blame_commit_pattern" => "^([ 0-9a-f]+):",
-    "author_pattern" => "^HgAuthor: (.*)",
-    "subject_pattern" => "^HgSubject: (.*)",
-    "stat_pattern" => "^(\\d+)\t(\\d+)\t\$file\$",
+    execute_cmd => \&hg_execute_cmd,
+    available   => '(which("hg") ne "" ) && ( -d ".hg" )',
+    find_signers_cmd => "hg log --date=\$email_hg_since "
+      . "--template='HgCommit: {node}\\n"
+      . "HgAuthor: {author}\\n"
+      . "HgSubject: {desc}\\n'"
+      . " -- \$file",
+    find_commit_signers_cmd => "hg log "
+      . "--template='HgSubject: {desc}\\n'"
+      . " -r \$commit",
+    find_commit_author_cmd => "hg log "
+      . "--template='HgCommit: {node}\\n"
+      . "HgAuthor: {author}\\n"
+      . "HgSubject: {desc|firstline}\\n'"
+      . " -r \$commit",
+    blame_range_cmd      => "",                               # not supported
+    blame_file_cmd       => "hg blame -n \$file",
+    commit_pattern       => "^HgCommit: ([0-9a-f]{40,40})",
+    blame_commit_pattern => "^([ 0-9a-f]+):",
+    author_pattern       => "^HgAuthor: (.*)",
+    subject_pattern      => "^HgSubject: (.*)",
+    stat_pattern         => "^(\\d+)\t(\\d+)\t\$file\$",
 );
 
 my $conf = which_conf(".get_maintainer.conf");

