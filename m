Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaASBAH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 20:00:07 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:49526 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751539AbaASBAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 20:00:04 -0500
Date: Sat, 18 Jan 2014 20:00:02 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [for-next][PATCH] ktest: Add BISECT_TRIES to bisect test
Message-ID: <20140118200002.2320abe4@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-ktest.git
for-next

Head SHA1: 961d9caceea2d5350a15c17b7d3ffc24c08c9b09


Steven Rostedt (Red Hat) (1):
      ktest: Add BISECT_TRIES to bisect test

----
 tools/testing/ktest/ktest.pl    | 24 ++++++++++++++++++++++--
 tools/testing/ktest/sample.conf | 14 ++++++++++++++
 2 files changed, 36 insertions(+), 2 deletions(-)
---------------------------
commit 961d9caceea2d5350a15c17b7d3ffc24c08c9b09
Author: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
Date:   Sat Jan 18 19:52:13 2014 -0500

    ktest: Add BISECT_TRIES to bisect test
    
    For those cases that it takes several tries to hit a bug, it would be
    useful for ktest.pl to try a test multiple times before it considers
    the test as a pass. To accomplish this, BISECT_TRIES ktest config
    option has been added. It is default to one, as most of the time a
    bisect only needs to try a test once. But the user can now up this
    to make ktest run a given test multiple times. The first failure
    that is detected will set a bisect bad. It only repeats on success.
    
    Note, as with all race bugs, there's no guarantee that if it succeeds,
    it is really a good bisect. But it helps in case the bug is somewhat
    reliable.
    
    You can set BISECT_TRIES to zero, and all tests will be considered
    good, unless you also set BISECT_MANUAL.
    
    Suggested-by: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 82006c2..a511d4a 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -41,6 +41,7 @@ my %default = (
     "CLEAR_LOG"			=> 0,
     "BISECT_MANUAL"		=> 0,
     "BISECT_SKIP"		=> 1,
+    "BISECT_TRIES"		=> 1,
     "MIN_CONFIG_TYPE"		=> "boot",
     "SUCCESS_LINE"		=> "login:",
     "DETECT_TRIPLE_FAULT"	=> 1,
@@ -139,6 +140,7 @@ my $bisect_bad_commit = "";
 my $reverse_bisect;
 my $bisect_manual;
 my $bisect_skip;
+my $bisect_tries;
 my $config_bisect_good;
 my $bisect_ret_good;
 my $bisect_ret_bad;
@@ -276,6 +278,7 @@ my %option_map = (
     "IGNORE_ERRORS"		=> \$ignore_errors,
     "BISECT_MANUAL"		=> \$bisect_manual,
     "BISECT_SKIP"		=> \$bisect_skip,
+    "BISECT_TRIES"		=> \$bisect_tries,
     "CONFIG_BISECT_GOOD"	=> \$config_bisect_good,
     "BISECT_RET_GOOD"		=> \$bisect_ret_good,
     "BISECT_RET_BAD"		=> \$bisect_ret_bad,
@@ -2584,12 +2587,29 @@ sub run_bisect {
 	$buildtype = "useconfig:$minconfig";
     }
 
-    my $ret = run_bisect_test $type, $buildtype;
+    # If the user sets bisect_tries to less than 1, then no tries
+    # is a success.
+    my $ret = 1;
 
-    if ($bisect_manual) {
+    # Still let the user manually decide that though.
+    if ($bisect_tries < 1 && $bisect_manual) {
 	$ret = answer_bisect;
     }
 
+    for (my $i = 0; $i < $bisect_tries; $i++) {
+	if ($bisect_tries > 1) {
+	    my $t = $i + 1;
+	    doprint("Running bisect trial $t of $bisect_tries:\n");
+	}
+	$ret = run_bisect_test $type, $buildtype;
+
+	if ($bisect_manual) {
+	    $ret = answer_bisect;
+	}
+
+	last if (!$ret);
+    }
+
     # Are we looking for where it worked, not failed?
     if ($reverse_bisect && $ret >= 0) {
 	$ret = !$ret;
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index 2eb4bd2..172eec4 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -1028,6 +1028,20 @@
 #   BISECT_BAD with BISECT_CHECK = good or
 #   BISECT_CHECK = bad, respectively.
 #
+# BISECT_TRIES = 5 (optional, default 1)
+#
+#   For those cases that it takes several tries to hit a bug,
+#   the BISECT_TRIES is useful. It is the number of times the
+#   test is ran before it says the kernel is good. The first failure
+#   will stop trying and mark the current SHA1 as bad.
+#
+#   Note, as with all race bugs, there's no guarantee that if
+#   it succeeds, it is really a good bisect. But it helps in case
+#   the bug is some what reliable.
+#
+#   You can set BISECT_TRIES to zero, and all tests will be considered
+#   good, unless you also set BISECT_MANUAL.
+#
 # BISECT_RET_GOOD = 0 (optional, default undefined)
 #
 #   In case the specificed test returns something other than just
