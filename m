Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbaEZUem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 16:34:42 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:35702 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142AbaEZUd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 16:33:58 -0400
Message-Id: <20140526203356.233948409@networkplumber.org>
User-Agent: quilt/0.63-1
Date: Mon, 26 May 2014 13:33:12 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH 3/4] get_maintainer: use array for defining available version control
References: <20140526203309.782169359@networkplumber.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=get-maintainer-array.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes which cleanup how multiple version control systems are
handled:
 * Rather than hardcoding the test for version control, use an array
   of available version control systems and label each one.
 * Instead of copying the hash of current version control, use a reference to
   get the current version control.
 * Remove unnecessary quoting on the label of the hash

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>


--- a/scripts/get_maintainer.pl	2014-05-26 13:14:14.264500168 -0700
+++ b/scripts/get_maintainer.pl	2014-05-26 13:27:47.000000000 -0700
@@ -53,7 +53,7 @@ my $pattern_depth = 0;
 my $version = 0;
 my $help = 0;
 
-my $vcs_used = 0;
+my $vcs_used;	# undef
 
 my $exit = 0;
 
@@ -90,10 +90,8 @@ my $rfc822_lwsp = "(?:(?:\\r\\n)?[ \\t])
 my $rfc822_char = '[\\000-\\377]';
 
 # VCS command support: class-like functions and strings
-
-my %VCS_cmds;
-
 my %VCS_cmds_git = (
+    name	=> 'git',
     execute_cmd => \&git_execute_cmd,
     available   => '(which("git") ne "") && (-e ".git")',
 
@@ -129,6 +127,7 @@ my %VCS_cmds_git = (
 );
 
 my %VCS_cmds_hg = (
+    name	=> 'hg',
     execute_cmd => \&hg_execute_cmd,
     available   => '(which("hg") ne "" ) && ( -d ".hg" )',
     find_signers_cmd => "hg log --date=\$email_hg_since "
@@ -152,6 +151,7 @@ my %VCS_cmds_hg = (
     subject_pattern      => "^HgSubject: (.*)",
     stat_pattern         => "^(\\d+)\t(\\d+)\t\$file\$",
 );
+my @VCS_avail = ( \%VCS_cmds_git, \%VCS_cmds_hg );
 
 my $conf = which_conf(".get_maintainer.conf");
 if (-f $conf) {
@@ -1275,11 +1275,11 @@ sub vcs_find_signers {
     my @authors = ();
     my @stats = ();
 
-    @lines = &{$VCS_cmds{"execute_cmd"}}($cmd);
+    @lines = &{$vcs_used->{execute_cmd}}($cmd);
 
-    my $pattern = $VCS_cmds{"commit_pattern"};
-    my $author_pattern = $VCS_cmds{"author_pattern"};
-    my $stat_pattern = $VCS_cmds{"stat_pattern"};
+    my $pattern = $vcs_used->{commit_pattern};
+    my $author_pattern = $vcs_used->{author_pattern};
+    my $stat_pattern = $vcs_used->{stat_pattern};
 
     $stat_pattern =~ s/(\$\w+)/$1/eeg;		#interpolate $stat_pattern
 
@@ -1310,7 +1310,7 @@ sub vcs_find_author {
     my ($cmd) = @_;
     my @lines = ();
 
-    @lines = &{$VCS_cmds{"execute_cmd"}}($cmd);
+    @lines = &{$vcs_used->{execute_cmd}}($cmd);
 
     if (!$email_git_penguin_chiefs) {
 	@lines = grep(!/${penguin_chiefs}/i, @lines);
@@ -1320,7 +1320,7 @@ sub vcs_find_author {
 
     my @authors = ();
     foreach my $line (@lines) {
-	if ($line =~ m/$VCS_cmds{"author_pattern"}/) {
+	if ($line =~ m/$vcs_used->{author_pattern}/) {
 	    my $author = $1;
 	    my ($name, $address) = parse_email($author);
 	    $author = format_email($name, $address, 1);
@@ -1339,10 +1339,10 @@ sub vcs_save_commits {
     my @lines = ();
     my @commits = ();
 
-    @lines = &{$VCS_cmds{"execute_cmd"}}($cmd);
+    @lines = &{$vcs_used->{execute_cmd}}($cmd);
 
     foreach my $line (@lines) {
-	if ($line =~ m/$VCS_cmds{"blame_commit_pattern"}/) {
+	if ($line =~ m/$vcs_used->{blame_commit_pattern}/) {
 	    push(@commits, $1);
 	}
     }
@@ -1357,10 +1357,10 @@ sub vcs_blame {
 
     return @commits if (!(-f $file));
 
-    if (@range && $VCS_cmds{"blame_range_cmd"} eq "") {
+    if (@range && $vcs_used->{blame_range_cmd} eq "") {
 	my @all_commits = ();
 
-	$cmd = $VCS_cmds{"blame_file_cmd"};
+	$cmd = $vcs_used->{blame_file_cmd};
 	$cmd =~ s/(\$\w+)/$1/eeg;		#interpolate $cmd
 	@all_commits = vcs_save_commits($cmd);
 
@@ -1381,12 +1381,12 @@ sub vcs_blame {
 	    my $diff_start = $2;
 	    my $diff_length = $3;
 	    next if ("$file" ne "$diff_file");
-	    $cmd = $VCS_cmds{"blame_range_cmd"};
+	    $cmd = $vcs_used->{blame_range_cmd};
 	    $cmd =~ s/(\$\w+)/$1/eeg;		#interpolate $cmd
 	    push(@commits, vcs_save_commits($cmd));
 	}
     } else {
-	$cmd = $VCS_cmds{"blame_file_cmd"};
+	$cmd = $vcs_used->{blame_file_cmd};
 	$cmd =~ s/(\$\w+)/$1/eeg;		#interpolate $cmd
 	@commits = vcs_save_commits($cmd);
     }
@@ -1400,11 +1400,10 @@ sub vcs_blame {
 
 my $printed_novcs = 0;
 sub vcs_exists {
-    %VCS_cmds = %VCS_cmds_git;
-    return 1 if eval $VCS_cmds{"available"};
-    %VCS_cmds = %VCS_cmds_hg;
-    return 2 if eval $VCS_cmds{"available"};
-    %VCS_cmds = ();
+    foreach my $vc (@VCS_avail) {
+	return $vc if eval $vc->{available};
+    }
+
     if (!$printed_novcs) {
 	warn("$P: No supported VCS found.  Add --nogit to options?\n");
 	warn("Using a git repository produces better results.\n");
@@ -1412,16 +1411,17 @@ sub vcs_exists {
 	warn("git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git\n");
 	$printed_novcs = 1;
     }
-    return 0;
+
+    return; #undef
 }
 
 sub vcs_is_git {
-    vcs_exists();
-    return $vcs_used == 1;
+    $vcs_used = vcs_exists();
+    return defined($vcs_used) && ($vcs_used->{name} eq 'git');
 }
 
 sub vcs_is_hg {
-    return $vcs_used == 2;
+    return defined($vcs_used) && ($vcs_used->{name} eq 'hg');
 }
 
 sub interactive_get_maintainers {
@@ -1752,13 +1752,13 @@ sub save_commits_by_author {
     my @subjects = ();
 
     foreach my $line (@lines) {
-	if ($line =~ m/$VCS_cmds{"author_pattern"}/) {
+	if ($line =~ m/$vcs_used->{author_pattern}/) {
 	    my $author = $1;
 	    $author = deduplicate_email($author);
 	    push(@authors, $author);
 	}
-	push(@commits, $1) if ($line =~ m/$VCS_cmds{"commit_pattern"}/);
-	push(@subjects, $1) if ($line =~ m/$VCS_cmds{"subject_pattern"}/);
+	push(@commits, $1) if ($line =~ m/$vcs_used->{commit_pattern}/);
+	push(@subjects, $1) if ($line =~ m/$vcs_used->{subject_pattern}/);
     }
 
     for (my $i = 0; $i < @authors; $i++) {
@@ -1784,8 +1784,8 @@ sub save_commits_by_signer {
     my $subject = "";
 
     foreach my $line (@lines) {
-	$commit = $1 if ($line =~ m/$VCS_cmds{"commit_pattern"}/);
-	$subject = $1 if ($line =~ m/$VCS_cmds{"subject_pattern"}/);
+	$commit = $1 if ($line =~ m/$vcs_used->{commit_pattern}/);
+	$subject = $1 if ($line =~ m/$vcs_used->{subject_pattern}/);
 	if ($line =~ /^[ \t]*${signature_pattern}.*\@.*$/) {
 	    my @signatures = ($line);
 	    my ($types_ref, $signers_ref) = extract_formatted_signatures(@signatures);
@@ -1870,7 +1870,7 @@ sub vcs_file_signoffs {
     $vcs_used = vcs_exists();
     return if (!$vcs_used);
 
-    my $cmd = $VCS_cmds{"find_signers_cmd"};
+    my $cmd = $vcs_used->{find_signers_cmd};
     $cmd =~ s/(\$\w+)/$1/eeg;		# interpolate $cmd
 
     ($commits, $signers_ref, $authors_ref, $stats_ref) = vcs_find_signers($cmd, $file);
@@ -1888,7 +1888,7 @@ sub vcs_file_signoffs {
     vcs_assign("commit_signer", $commits, @signers);
     vcs_assign("authored", $commits, @authors);
     if ($#authors == $#stats) {
-	my $stat_pattern = $VCS_cmds{"stat_pattern"};
+	my $stat_pattern = $vcs_used->{stat_pattern};
 	$stat_pattern =~ s/(\$\w+)/$1/eeg;	#interpolate $stat_pattern
 
 	my $added = 0;
@@ -1956,7 +1956,7 @@ sub vcs_file_blame {
 	    my $commit = join(" -r ", @commits);
 	    my $cmd;
 
-	    $cmd = $VCS_cmds{"find_commit_signers_cmd"};
+	    $cmd = $vcs_used->{find_commit_signers_cmd};
 	    $cmd =~ s/(\$\w+)/$1/eeg;	#substitute variables in $cmd
 
 	    ($commit_count, $commit_signers_ref, $commit_authors_ref, $stats_ref) = vcs_find_signers($cmd, $file);
@@ -1974,7 +1974,7 @@ sub vcs_file_blame {
 		my @commit_signers = ();
 		my $cmd;
 
-		$cmd = $VCS_cmds{"find_commit_signers_cmd"};
+		$cmd = $vcs_used->{find_commit_signers_cmd};
 		$cmd =~ s/(\$\w+)/$1/eeg;	#substitute variables in $cmd
 
 		($commit_count, $commit_signers_ref, $commit_authors_ref, $stats_ref) = vcs_find_signers($cmd, $file);
@@ -1997,12 +1997,12 @@ sub vcs_file_blame {
 		my $commit = join(" -r ", @commits);
 		my $cmd;
 
-		$cmd = $VCS_cmds{"find_commit_author_cmd"};
+		$cmd = $vcs_used->{find_commit_author_cmd};
 		$cmd =~ s/(\$\w+)/$1/eeg;	#substitute variables in $cmd
 
 		my @lines = ();
 
-		@lines = &{$VCS_cmds{"execute_cmd"}}($cmd);
+		@lines = &{$vcs_used->{execute_cmd}}($cmd);
 
 		if (!$email_git_penguin_chiefs) {
 		    @lines = grep(!/${penguin_chiefs}/i, @lines);
@@ -2012,7 +2012,7 @@ sub vcs_file_blame {
 
 		my @authors = ();
 		foreach my $line (@lines) {
-		    if ($line =~ m/$VCS_cmds{"author_pattern"}/) {
+		    if ($line =~ m/$vcs_used->{author_pattern}/) {
 			my $author = $1;
 			$author = deduplicate_email($author);
 			push(@authors, $author);
@@ -2027,7 +2027,7 @@ sub vcs_file_blame {
 	    else {
 		foreach my $commit (@commits) {
 		    my $i;
-		    my $cmd = $VCS_cmds{"find_commit_author_cmd"};
+		    my $cmd = $vcs_used->{find_commit_author_cmd};
 		    $cmd =~ s/(\$\w+)/$1/eeg;	#interpolate $cmd
 		    my @author = vcs_find_author($cmd);
 		    next if !@author;

