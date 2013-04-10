Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965106Ab3DJIt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 04:49:59 -0400
Received: from drsnuggles.stderr.nl ([94.142.244.14]:38454 "EHLO
	drsnuggles.stderr.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936380Ab3DJItA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 04:49:00 -0400
Date: Wed, 10 Apr 2013 10:48:54 +0200
From: Matthijs Kooijman <matthijs@stdin.nl>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] checkpatch: Don't suggest clean scripts when all related
 errors are suppressed
Message-ID: <20130410084854.GQ13691@login.drsnuggles.stderr.nl>
Mail-Followup-To: Matthijs Kooijman <matthijs@stdin.nl>,
	Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-PGP-Fingerprint: 7F6A 9F44 2820 18E2 18DE  24AA CF49 D0E6 8A2F AFBC
X-PGP-Key: http://www.stderr.nl/static/files/gpg_pubkey.asc
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Spam-Score: -2.6 (--)
X-Spam-Report: Spamchecked on "mail.drsnuggles.stderr.nl"
	pts  rule name              description
	---- ---------------------- -------------------------------------------
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before, the message "whitespace errors detected, you may wish to use
scripts/cleanpatch or scripts/cleanfile" was emitted when two specific
errors were detected, even when they were suppressed with --ignore or
--test-only.

Now, the message is only emitted if any of the related errors were
actually emitted as well.

Signed-off-by: Matthijs Kooijman <matthijs@stdin.nl>
---
 scripts/checkpatch.pl | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 64021da..532c41b 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1278,19 +1278,25 @@ sub ERROR {
 	if (report("ERROR", $_[0], $_[1])) {
 		our $clean = 0;
 		our $cnt_error++;
+		return 1;
 	}
+	return 0;
 }
 sub WARN {
 	if (report("WARNING", $_[0], $_[1])) {
 		our $clean = 0;
 		our $cnt_warn++;
+		return 1;
 	}
+	return 0;
 }
 sub CHK {
 	if ($check && report("CHECK", $_[0], $_[1])) {
 		our $clean = 0;
 		our $cnt_chk++;
+		return 1;
 	}
+	return 0;
 }
 
 sub check_absolute_file {
@@ -1701,9 +1707,10 @@ sub process {
 
 		} elsif ($rawline =~ /^\+.*\S\s+$/ || $rawline =~ /^\+\s+$/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
-			ERROR("TRAILING_WHITESPACE",
-			      "trailing whitespace\n" . $herevet);
-			$rpt_cleaners = 1;
+			if (ERROR("TRAILING_WHITESPACE",
+				  "trailing whitespace\n" . $herevet)) {
+				$rpt_cleaners = 1;
+			}
 		}
 
 # check for Kconfig help text having a real description
@@ -1829,9 +1836,10 @@ sub process {
 		if ($rawline =~ /^\+\s* \t\s*\S/ ||
 		    $rawline =~ /^\+\s*        \s*/) {
 			my $herevet = "$here\n" . cat_vet($rawline) . "\n";
-			ERROR("CODE_INDENT",
-			      "code indent should use tabs where possible\n" . $herevet);
-			$rpt_cleaners = 1;
+			if (ERROR("CODE_INDENT",
+				  "code indent should use tabs where possible\n" . $herevet)) {
+				$rpt_cleaners = 1;
+			}
 		}
 
 # check for space before tabs.
-- 
1.8.0

