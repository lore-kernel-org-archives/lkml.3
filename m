Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbbA1U54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:57:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53892 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbbA1U5x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:57:53 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Satoru Takeuchi <satoru.takeuchi@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] ktest: enable user input to the console
Date: Wed, 28 Jan 2015 13:38:39 -0600
Message-Id: <bb1bbe7d202c95a3ce7894cfffdd8c725875978e.1422473610.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1422473610.git.jpoimboe@redhat.com>
References: <cover.1422473610.git.jpoimboe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow the user to send input to the console by putting the terminal in
cbreak mode (to allow reading stdin one character at a time) and copying
all stdin data to the console's pty.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 tools/testing/ktest/ktest.pl | 51 +++++++++++++++++++++++++++++++-------------
 1 file changed, 36 insertions(+), 15 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 10b8825..acaf05b 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -178,7 +178,7 @@ my $checkout;
 my $localversion;
 my $iteration = 0;
 my $successes = 0;
-my $stty;
+my $stty_orig;
 
 my $bisect_good;
 my $bisect_bad;
@@ -1393,7 +1393,11 @@ sub open_console {
     my $pid;
 
     # save terminal settings
-    $stty = `stty -g`;
+    $stty_orig = `stty -g`;
+
+    # place terminal in cbreak mode so that stdin can be read one character at
+    # a time without having to wait for a newline
+    system("stty -icanon -echo -icrnl");
 
     create_pty($ptm, $pts);
 
@@ -1422,7 +1426,7 @@ sub close_console {
     close($fp);
 
     # restore terminal settings
-    system("stty $stty");
+    system("stty $stty_orig");
 }
 
 sub start_monitor {
@@ -1749,7 +1753,9 @@ sub wait_for_input
 {
     my ($fp, $time) = @_;
     my $rin;
-    my $ready;
+    my $rout;
+    my $nr;
+    my $buf;
     my $line;
     my $ch;
 
@@ -1759,21 +1765,36 @@ sub wait_for_input
 
     $rin = '';
     vec($rin, fileno($fp), 1) = 1;
-    ($ready, $time) = select($rin, undef, undef, $time);
+    vec($rin, fileno(\*STDIN), 1) = 1;
 
-    $line = "";
+    while (1) {
+	$nr = select($rout=$rin, undef, undef, $time);
 
-    # try to read one char at a time
-    while (sysread $fp, $ch, 1) {
-	$line .= $ch;
-	last if ($ch eq "\n");
-    }
+	if ($nr <= 0) {
+	    return undef;
+	}
 
-    if (!length($line)) {
-	return undef;
-    }
+	# copy data from stdin to the console
+	if (vec($rout, fileno(\*STDIN), 1) == 1) {
+	    sysread(\*STDIN, $buf, 1000);
+	    syswrite($fp, $buf, 1000);
+	    next;
+	}
 
-    return $line;
+	$line = "";
+
+	# try to read one char at a time
+	while (sysread $fp, $ch, 1) {
+	    $line .= $ch;
+	    last if ($ch eq "\n");
+	}
+
+	if (!length($line)) {
+	    return undef;
+	}
+
+	return $line;
+    }
 }
 
 sub reboot_to {
-- 
2.1.0

