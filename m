Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757150AbbA1VH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:07:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754261AbbA1Uzu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:55:50 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Satoru Takeuchi <satoru.takeuchi@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/2] ktest: give console process a dedicated tty
Date: Wed, 28 Jan 2015 13:38:38 -0600
Message-Id: <37b0127f9efad09ff4fc994334db998141e4f6ca.1422473610.git.jpoimboe@redhat.com>
In-Reply-To: <cover.1422473610.git.jpoimboe@redhat.com>
References: <cover.1422473610.git.jpoimboe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a pseudoterminal (pty pair) to give the console a dedicated tty
so it doesn't mess with ktest's terminal settings.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 tools/testing/ktest/ktest.pl | 66 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 57 insertions(+), 9 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index ba20f89..10b8825 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1345,23 +1345,71 @@ sub dodie {
     die @_, "\n";
 }
 
-sub open_console {
-    my ($fp) = @_;
+sub create_pty {
+    my ($ptm, $pts) = @_;
+    my $tmp;
+    my $TIOCSPTLCK = 0x40045431;
+    my $TIOCGPTN = 0x80045430;
+
+    sysopen($ptm, "/dev/ptmx", O_RDWR | O_NONBLOCK) or
+	dodie "Cant open /dev/ptmx";
+
+    # unlockpt()
+    $tmp = pack("i", 0);
+    ioctl($ptm, $TIOCSPTLCK, $tmp) or
+	dodie "ioctl TIOCSPTLCK for /dev/ptmx failed";
+
+    # ptsname()
+    ioctl($ptm, $TIOCGPTN, $tmp) or
+	dodie "ioctl TIOCGPTN for /dev/ptmx failed";
+    $tmp = unpack("i", $tmp);
+
+    sysopen($pts, "/dev/pts/$tmp", O_RDWR | O_NONBLOCK) or
+	dodie "Can't open /dev/pts/$tmp";
+}
+
+sub exec_console {
+    my ($ptm, $pts) = @_;
+
+    close($ptm);
+
+    close(\*STDIN);
+    close(\*STDOUT);
+    close(\*STDERR);
 
-    my $flags;
+    open(\*STDIN, '<&', $pts);
+    open(\*STDOUT, '>&', $pts);
+    open(\*STDERR, '>&', $pts);
+
+    close($pts);
+
+    exec $console or
+	dodie "Can't open console $console";
+}
+
+sub open_console {
+    my ($ptm) = @_;
+    my $pts = \*PTSFD;
+    my $pid;
 
     # save terminal settings
     $stty = `stty -g`;
 
-    my $pid = open($fp, "$console|") or
-	dodie "Can't open console $console";
+    create_pty($ptm, $pts);
 
-    $flags = fcntl($fp, F_GETFL, 0) or
-	dodie "Can't get flags for the socket: $!";
-    $flags = fcntl($fp, F_SETFL, $flags | O_NONBLOCK) or
-	dodie "Can't set flags for the socket: $!";
+    $pid = fork;
+
+    if (!$pid) {
+	# child
+	exec_console($ptm, $pts)
+    }
+
+    # parent
+    close($pts);
 
     return $pid;
+
+    open(PTSFD, "Stop perl from warning about single use of PTSFD");
 }
 
 sub close_console {
-- 
2.1.0

