Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbbA1Uy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:54:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49284 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753504AbbA1UyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:54:19 -0500
Date: Wed, 28 Jan 2015 08:59:23 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Satoru Takeuchi <satoru.takeuchi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ktest: restore tty settings after closing console
Message-ID: <20150128145923.GA26843@treble.redhat.com>
References: <1bb89abc0025cf1d6da657c7ba58bbeb4381a515.1422382008.git.jpoimboe@redhat.com>
 <20150127170129.7db53047@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150127170129.7db53047@gandalf.local.home>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 05:01:29PM -0500, Steven Rostedt wrote:
> On Tue, 27 Jan 2015 12:10:04 -0600
> Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> 
> > When ktest runs the console program as a child process, the parent and
> > child share the same tty for stdin and stderr.  This is problematic when
> > using a libvirt target.  The "virsh console" program makes a lot of
> > changes to the tty settings, making ktest's output hard to read
> > (carriage returns don't work).  After ktest exits, the terminal is
> > unusable (CRs broken, stdin isn't echoed).
> > 
> > I think the best way to fix this issue would be to create a
> > pseudoterminal (pty pair) so the child process would have a dedicated
> > tty, and then use pipes to connect the two ttys.  I'm not sure if that's
> > overkill, but it's far beyond my current Perl abilities.
> 
> And beyond mine too. I tried to get that right a few times, and it
> never worked out. Maybe someone with more oyster skilz can fix this.

I decided to level up my oyster skilz.  I came up with this (to be
applied instead of the original patch).  It's working well for me.
Right now, stdin isn't hooked up, so the user can't mess with the
console.  Is stdin needed?

---8<---

Subject: [PATCH] ktest: give console process a dedicated tty

ktest's sharing of its tty with its child console monitoring process
creates problems when the console program changes tty settings.  In the
case of "virsh console", it makes ktest's output unreadable and makes
the post-ktest terminal unusable (carriage returns broken, stdin not
echoed).

Create a pseudoterminal (pty pair) to give the console a dedicated tty
so it doesn't mess up ktest's tty.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 tools/testing/ktest/ktest.pl | 64 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 56 insertions(+), 8 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index b9cd036..5886169 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1344,20 +1344,68 @@ sub dodie {
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
 
-    my $flags;
+    close(\*STDIN);
+    close(\*STDOUT);
+    close(\*STDERR);
 
-    my $pid = open($fp, "$console|") or
+    open(\*STDIN, '<&', $pts);
+    open(\*STDOUT, '>&', $pts);
+    open(\*STDERR, '>&', $pts);
+
+    close($pts);
+
+    exec $console or
 	dodie "Can't open console $console";
+}
 
-    $flags = fcntl($fp, F_GETFL, 0) or
-	dodie "Can't get flags for the socket: $!";
-    $flags = fcntl($fp, F_SETFL, $flags | O_NONBLOCK) or
-	dodie "Can't set flags for the socket: $!";
+sub open_console {
+    my ($ptm) = @_;
+    my $pts = \*PTSFD;
+    my $pid;
+
+    create_pty($ptm, $pts);
+
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


