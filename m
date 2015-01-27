Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbbA0SMF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 13:12:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735AbbA0SMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 13:12:03 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Satoru Takeuchi <satoru.takeuchi@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ktest: restore tty settings after closing console
Date: Tue, 27 Jan 2015 12:10:04 -0600
Message-Id: <1bb89abc0025cf1d6da657c7ba58bbeb4381a515.1422382008.git.jpoimboe@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When ktest runs the console program as a child process, the parent and
child share the same tty for stdin and stderr.  This is problematic when
using a libvirt target.  The "virsh console" program makes a lot of
changes to the tty settings, making ktest's output hard to read
(carriage returns don't work).  After ktest exits, the terminal is
unusable (CRs broken, stdin isn't echoed).

I think the best way to fix this issue would be to create a
pseudoterminal (pty pair) so the child process would have a dedicated
tty, and then use pipes to connect the two ttys.  I'm not sure if that's
overkill, but it's far beyond my current Perl abilities.

This patch is a much easier way to (partially) fix this issue.  It saves
the tty settings before opening the console and restores them after
closing it.  There are still a few places where ktest prints mangled
output while the console is open, but the output is much more legible
overall, and the terminal works just fine after ktest exits.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 tools/testing/ktest/ktest.pl | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index b9cd036..ba20f89 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -178,6 +178,7 @@ my $checkout;
 my $localversion;
 my $iteration = 0;
 my $successes = 0;
+my $stty;
 
 my $bisect_good;
 my $bisect_bad;
@@ -1349,6 +1350,9 @@ sub open_console {
 
     my $flags;
 
+    # save terminal settings
+    $stty = `stty -g`;
+
     my $pid = open($fp, "$console|") or
 	dodie "Can't open console $console";
 
@@ -1368,6 +1372,9 @@ sub close_console {
 
     print "closing!\n";
     close($fp);
+
+    # restore terminal settings
+    system("stty $stty");
 }
 
 sub start_monitor {
-- 
2.1.0

