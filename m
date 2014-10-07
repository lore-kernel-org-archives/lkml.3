Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755328AbaJGVRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 17:17:09 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:17116 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753346AbaJGVRB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 17:17:01 -0400
Message-Id: <20141007211659.900214748@goodmis.org>
User-Agent: quilt/0.61-1
Date: Tue, 07 Oct 2014 17:16:32 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/4] ktest: Add PATCHCHECK_CHERRY
References: <20141007211631.365194240@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-ktest-Add-PATCHCHECK_CHERRY.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Add a way to run a patchcheck test on the commits that are in one branch
but not in another. This uses git cherry to find a list of commits to
test each one with.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl    | 35 +++++++++++++++++++++++++++++------
 tools/testing/ktest/sample.conf | 10 ++++++++++
 2 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 55ab700f6ba5..3b7a180d9c0d 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -194,6 +194,7 @@ my $config_bisect_check;
 
 my $patchcheck_type;
 my $patchcheck_start;
+my $patchcheck_cherry;
 my $patchcheck_end;
 
 # set when a test is something other that just building or install
@@ -320,6 +321,7 @@ my %option_map = (
 
     "PATCHCHECK_TYPE"		=> \$patchcheck_type,
     "PATCHCHECK_START"		=> \$patchcheck_start,
+    "PATCHCHECK_CHERRY"		=> \$patchcheck_cherry,
     "PATCHCHECK_END"		=> \$patchcheck_end,
 );
 
@@ -3181,9 +3183,16 @@ sub patchcheck {
 
     my $start = $patchcheck_start;
 
+    my $cherry = $patchcheck_cherry;
+    if (!defined($cherry)) {
+	$cherry = 0;
+    }
+
     my $end = "HEAD";
     if (defined($patchcheck_end)) {
 	$end = $patchcheck_end;
+    } elsif ($cherry) {
+	die "PATCHCHECK_END must be defined with PATCHCHECK_CHERRY\n";
     }
 
     # Get the true sha1's since we can use things like HEAD~3
@@ -3197,24 +3206,38 @@ sub patchcheck {
 	$type = "boot";
     }
 
-    open (IN, "git log --pretty=oneline $end|") or
-	dodie "could not get git list";
+    if ($cherry) {
+	open (IN, "git cherry -v $start $end|") or
+	    dodie "could not get git list";
+    } else {
+	open (IN, "git log --pretty=oneline $end|") or
+	    dodie "could not get git list";
+    }
 
     my @list;
 
     while (<IN>) {
 	chomp;
+	# git cherry adds a '+' we want to remove
+	s/^\+ //;
 	$list[$#list+1] = $_;
 	last if (/^$start/);
     }
     close(IN);
 
-    if ($list[$#list] !~ /^$start/) {
-	fail "SHA1 $start not found";
+    if (!$cherry) {
+	if ($list[$#list] !~ /^$start/) {
+	    fail "SHA1 $start not found";
+	}
+
+	# go backwards in the list
+	@list = reverse @list;
     }
 
-    # go backwards in the list
-    @list = reverse @list;
+    doprint("Going to test the following commits:\n");
+    foreach my $l (@list) {
+	doprint "$l\n";
+    }
 
     my $save_clean = $noclean;
     my %ignored_warnings;
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index 911e45ad657a..6c58cd8bbbae 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -906,6 +906,16 @@
 #
 #  PATCHCHECK_END is the last patch to check (default HEAD)
 #
+#  PATCHCHECK_CHERRY if set to non zero, then git cherry will be
+#      performed against PATCHCHECK_START and PATCHCHECK_END. That is
+#
+#      git cherry ${PATCHCHECK_START} ${PATCHCHECK_END}
+#
+#      Then the changes found will be tested.
+#
+#      Note, PATCHCHECK_CHERRY requires PATCHCHECK_END to be defined.
+#      (default 0)
+#
 #  PATCHCHECK_TYPE is required and is the type of test to run:
 #      build, boot, test.
 #
-- 
2.0.1


