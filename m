Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab3JNRcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 13:32:17 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:58687 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757201Ab3JNRcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 13:32:14 -0400
X-Originating-IP: 173.246.103.110
Date: Mon, 14 Oct 2013 10:32:08 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Nandini Hanumanthagowda <nandu.hgowda@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Subject: [PATCH] checkpatch: Allow spaces before the ':' of a bitfield
Message-ID: <20131014173207.GE16517@jtriplet-mobl1>
References: <20131013121635.GA29395@nandinih-Inspiron-5521>
 <20131013153943.GA27861@kroah.com>
 <687af3bd-edc6-40cf-b994-0d0fdb7cd30d@googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <687af3bd-edc6-40cf-b994-0d0fdb7cd30d@googlegroups.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch warns about spaces both before and after the ':' separating a
bitfield name from its width.  However, many drivers do put space before
the : to line up the widths, which makes the definition significantly
more readable; checkpatch should not warn about that.  Remove the
warning for space before the ':' of a bitfield.

Reported-by: Nandini Hanumanthagowda <nandu.hgowda@gmail.com>
Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

Nandini and Greg observed this issue as part of checkpatch warnings on a
staging driver (octeon-usb), and both agreed that checkpatch should not
issue this warning; patching accordingly.

 scripts/checkpatch.pl | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index ed16a68..9e36345 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2934,8 +2934,7 @@ sub process {
 
 				# No spaces for:
 				#   ->
-				#   :   when part of a bitfield
-				} elsif ($op eq '->' || $opv eq ':B') {
+				} elsif ($op eq '->') {
 					if ($ctx =~ /Wx.|.xW/) {
 						if (ERROR("SPACING",
 							  "spaces prohibited around that '$op' $at\n" . $hereptr)) {
@@ -2947,6 +2946,19 @@ sub process {
 						}
 					}
 
+				#   :   when part of a bitfield
+				} elsif ($opv eq ':B') {
+					if ($ctx =~ /.xW/) {
+						if (ERROR("SPACING",
+							  "spaces prohibited after that '$op' $at\n" . $hereptr)) {
+							$good = $fix_elements[$n] . rtrim($fix_elements[$n + 1]);
+							if (defined $fix_elements[$n + 2]) {
+								$fix_elements[$n + 2] =~ s/^\s+//;
+							}
+							$line_fixed = 1;
+						}
+					}
+
 				# , must have a space on the right.
 				} elsif ($op eq ',') {
 					if ($ctx !~ /.x[WEC]/ && $cc !~ /^}/) {
-- 
1.8.4.rc3

