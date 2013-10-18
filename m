Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481Ab3JRERH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 00:17:07 -0400
Received: from smtprelay0180.hostedemail.com ([216.40.44.180]:44642 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750872Ab3JRERF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 00:17:05 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:2:41:355:379:541:599:800:960:968:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1535:1593:1594:1730:1747:1777:1792:2197:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3354:3622:3653:3865:3866:3867:3868:3870:3871:3872:3874:4051:4120:4321:4605:5007:6119:7652:7903:8957:9010:9545:10004:10848:10967:11026:11232:11658:11914:12043:12291:12296:12438:12517:12519:12555:12679:12683:12740,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: honey33_77b1afc645c0f
X-Filterd-Recvd-Size: 9933
Message-ID: <1382069821.22110.168.camel@joe-AO722>
Subject: Re: [bug] get_maintainer.pl incomplete output
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Michal Hocko <mhocko@suse.cz>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Date: Thu, 17 Oct 2013 21:17:01 -0700
In-Reply-To: <20131017121215.826ab6cced73118f3dba8d4f@linux-foundation.org>
References: <alpine.DEB.2.02.1310161738410.10147@chino.kir.corp.google.com>
	 <alpine.DEB.2.02.1310162046090.30995@chino.kir.corp.google.com>
	 <20131017121215.826ab6cced73118f3dba8d4f@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-17 at 12:12 -0700, Andrew Morton wrote:
> On Wed, 16 Oct 2013 20:51:18 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:
> 
> > I haven't looked closely at scripts/get_maintainer.pl, but I recently 
> > wrote a patch touching mm/vmpressure.c and it doesn't list the file's 
> > author, Anton Vorontsov <anton.vorontsov@linaro.org>.
> > 
> > Even when I do scripts/get_maintainer.pl -f mm/vmpressure.c, his entry is 
> > missing and git blame attributs >90% of the lines to his authorship.
> > 
> > $ ./scripts/get_maintainer.pl -f mm/vmpressure.c 
> > Tejun Heo <tj@kernel.org> (commit_signer:6/7=86%)
> > Michal Hocko <mhocko@suse.cz> (commit_signer:5/7=71%)
> > Andrew Morton <akpm@linux-foundation.org> (commit_signer:4/7=57%)
> > Li Zefan <lizefan@huawei.com> (commit_signer:3/7=43%)
> > "Kirill A. Shutemov" <kirill@shutemov.name> (commit_signer:1/7=14%)
> > linux-mm@kvack.org (open list:MEMORY MANAGEMENT)
> > linux-kernel@vger.kernel.org (open list)
> 
> get_maintainer should, by default, answer the question "who should I
> email about this file".  It clearly isn't doing this, and that's a
> pretty big fail.
> 
> I've learned not to trust it, so when I use it I always have to check
> its homework with "git log | grep Author" :(
> 
> Joe, pretty please?

Try this:

It adds authored/lines_added/lines_deleted to rolestats

For instance:

$ ./scripts/get_maintainer.pl -f mm/vmpressure.c
Tejun Heo <tj@kernel.org> (commit_signer:6/7=86%,authored:3/7=43%,removed_lines:15/21=71%)
Michal Hocko <mhocko@suse.cz> (commit_signer:5/7=71%,authored:3/7=43%,added_lines:22/408=5%,removed_lines:6/21=29%)
Andrew Morton <akpm@linux-foundation.org> (commit_signer:4/7=57%)
Li Zefan <lizefan@huawei.com> (commit_signer:3/7=43%)
"Kirill A. Shutemov" <kirill@shutemov.name> (commit_signer:1/7=14%)
Anton Vorontsov <anton.vorontsov@linaro.org> (authored:1/7=14%,added_lines:374/408=92%)
linux-mm@kvack.org (open list:MEMORY MANAGEMENT)
linux-kernel@vger.kernel.org (open list)

I haven't tested it much.

---

 scripts/get_maintainer.pl | 90 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 84 insertions(+), 6 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 5e4fb14..ee9adb8 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -98,6 +98,7 @@ my %VCS_cmds_git = (
     "available" => '(which("git") ne "") && (-d ".git")',
     "find_signers_cmd" =>
 	"git log --no-color --follow --since=\$email_git_since " .
+	    '--numstat --no-merges ' .
 	    '--format="GitCommit: %H%n' .
 		      'GitAuthor: %an <%ae>%n' .
 		      'GitDate: %aD%n' .
@@ -106,6 +107,7 @@ my %VCS_cmds_git = (
 	    " -- \$file",
     "find_commit_signers_cmd" =>
 	"git log --no-color " .
+	    '--numstat ' .
 	    '--format="GitCommit: %H%n' .
 		      'GitAuthor: %an <%ae>%n' .
 		      'GitDate: %aD%n' .
@@ -114,6 +116,7 @@ my %VCS_cmds_git = (
 	    " -1 \$commit",
     "find_commit_author_cmd" =>
 	"git log --no-color " .
+	    '--numstat ' .
 	    '--format="GitCommit: %H%n' .
 		      'GitAuthor: %an <%ae>%n' .
 		      'GitDate: %aD%n' .
@@ -125,6 +128,7 @@ my %VCS_cmds_git = (
     "blame_commit_pattern" => "^([0-9a-f]+) ",
     "author_pattern" => "^GitAuthor: (.*)",
     "subject_pattern" => "^GitSubject: (.*)",
+    "stat_pattern" => "(\\d+)\\t(\\d+)\\t\$file",
 );
 
 my %VCS_cmds_hg = (
@@ -152,6 +156,7 @@ my %VCS_cmds_hg = (
     "blame_commit_pattern" => "^([ 0-9a-f]+):",
     "author_pattern" => "^HgAuthor: (.*)",
     "subject_pattern" => "^HgSubject: (.*)",
+    "stat_pattern" => "(\\d+)\t(\\d+)\t\$file",
 );
 
 my $conf = which_conf(".get_maintainer.conf");
@@ -1269,20 +1274,30 @@ sub extract_formatted_signatures {
 }
 
 sub vcs_find_signers {
-    my ($cmd) = @_;
+    my ($cmd, $file) = @_;
     my $commits;
     my @lines = ();
     my @signatures = ();
+    my @authors = ();
+    my @stats = ();
 
     @lines = &{$VCS_cmds{"execute_cmd"}}($cmd);
 
     my $pattern = $VCS_cmds{"commit_pattern"};
+    my $author_pattern = $VCS_cmds{"author_pattern"};
+    my $stat_pattern = $VCS_cmds{"stat_pattern"};
+
+    $stat_pattern =~ s/(\$\w+)/$1/eeg;		#interpolate $stat_pattern
 
     $commits = grep(/$pattern/, @lines);	# of commits
 
+    @authors = grep(/$author_pattern/, @lines);
     @signatures = grep(/^[ \t]*${signature_pattern}.*\@.*$/, @lines);
+    @stats = grep(/$stat_pattern/, @lines);
+
+#    print("stats: <@stats>\n");
 
-    return (0, @signatures) if !@signatures;
+    return (0, @signatures, @authors) if !@signatures;
 
     save_commits_by_author(@lines) if ($interactive);
     save_commits_by_signer(@lines) if ($interactive);
@@ -1291,9 +1306,10 @@ sub vcs_find_signers {
 	@signatures = grep(!/${penguin_chiefs}/i, @signatures);
     }
 
+    my ($author_ref, $authors_ref) = extract_formatted_signatures(@authors);
     my ($types_ref, $signers_ref) = extract_formatted_signatures(@signatures);
 
-    return ($commits, @$signers_ref);
+    return ($commits, $signers_ref, $authors_ref, \@stats);
 }
 
 sub vcs_find_author {
@@ -1849,7 +1865,12 @@ sub vcs_assign {
 sub vcs_file_signoffs {
     my ($file) = @_;
 
+    my $authors_ref;
+    my $signers_ref;
+    my $stats_ref;
+    my @authors = ();
     my @signers = ();
+    my @stats = ();
     my $commits;
 
     $vcs_used = vcs_exists();
@@ -1858,13 +1879,58 @@ sub vcs_file_signoffs {
     my $cmd = $VCS_cmds{"find_signers_cmd"};
     $cmd =~ s/(\$\w+)/$1/eeg;		# interpolate $cmd
 
-    ($commits, @signers) = vcs_find_signers($cmd);
+    ($commits, $signers_ref, $authors_ref, $stats_ref) = vcs_find_signers($cmd, $file);
+    @signers = @{$signers_ref};
+    @authors = @{$authors_ref};
+    @stats = @{$stats_ref};
+
+#    print("commits: <$commits>\nsigners:<@signers>\nauthors: <@authors>\nstats: <@stats>\n");
 
     foreach my $signer (@signers) {
 	$signer = deduplicate_email($signer);
     }
 
     vcs_assign("commit_signer", $commits, @signers);
+    vcs_assign("authored", $commits, @authors);
+    if ($#authors == $#stats) {
+	my $stat_pattern = $VCS_cmds{"stat_pattern"};
+	$stat_pattern =~ s/(\$\w+)/$1/eeg;	#interpolate $stat_pattern
+
+	my $added = 0;
+	my $deleted = 0;
+	for (my $i = 0; $i <= $#stats; $i++) {
+	    if ($stats[$i] =~ /$stat_pattern/) {
+		$added += $1;
+		$deleted += $2;
+	    }
+	}
+	my @tmp_authors = uniq(@authors);
+	foreach my $author (@tmp_authors) {
+	    $author = deduplicate_email($author);
+	}
+	@tmp_authors = uniq(@tmp_authors);
+	my @list_added = ();
+	my @list_deleted = ();
+	foreach my $author (@tmp_authors) {
+	    my $auth_added = 0;
+	    my $auth_deleted = 0;
+	    for (my $i = 0; $i <= $#stats; $i++) {
+		if ($author eq deduplicate_email($authors[$i]) &&
+		    $stats[$i] =~ /$stat_pattern/) {
+		    $auth_added += $1;
+		    $auth_deleted += $2;
+		}
+	    }
+	    for (my $i = 0; $i < $auth_added; $i++) {
+		push(@list_added, $author);
+	    }
+	    for (my $i = 0; $i < $auth_deleted; $i++) {
+		push(@list_deleted, $author);
+	    }
+	}
+	vcs_assign("added_lines", $added, @list_added);
+	vcs_assign("removed_lines", $deleted, @list_deleted);
+    }
 }
 
 sub vcs_file_blame {
@@ -1887,6 +1953,10 @@ sub vcs_file_blame {
     if ($email_git_blame_signatures) {
 	if (vcs_is_hg()) {
 	    my $commit_count;
+	    my $commit_authors_ref;
+	    my $commit_signers_ref;
+	    my $stats_ref;
+	    my @commit_authors = ();
 	    my @commit_signers = ();
 	    my $commit = join(" -r ", @commits);
 	    my $cmd;
@@ -1894,19 +1964,27 @@ sub vcs_file_blame {
 	    $cmd = $VCS_cmds{"find_commit_signers_cmd"};
 	    $cmd =~ s/(\$\w+)/$1/eeg;	#substitute variables in $cmd
 
-	    ($commit_count, @commit_signers) = vcs_find_signers($cmd);
+	    ($commit_count, $commit_signers_ref, $commit_authors_ref, $stats_ref) = vcs_find_signers($cmd, $file);
+	    @commit_authors = @{$commit_authors_ref};
+	    @commit_signers = @{$commit_signers_ref};
 
 	    push(@signers, @commit_signers);
 	} else {
 	    foreach my $commit (@commits) {
 		my $commit_count;
+		my $commit_authors_ref;
+		my $commit_signers_ref;
+		my $stats_ref;
+		my @commit_authors = ();
 		my @commit_signers = ();
 		my $cmd;
 
 		$cmd = $VCS_cmds{"find_commit_signers_cmd"};
 		$cmd =~ s/(\$\w+)/$1/eeg;	#substitute variables in $cmd
 
-		($commit_count, @commit_signers) = vcs_find_signers($cmd);
+		($commit_count, $commit_signers_ref, $commit_authors_ref, $stats_ref) = vcs_find_signers($cmd, $file);
+		@commit_authors = @{$commit_authors_ref};
+		@commit_signers = @{$commit_signers_ref};
 
 		push(@signers, @commit_signers);
 	    }


