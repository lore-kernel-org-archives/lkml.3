Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352AbaIOSoP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 14:44:15 -0400
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:8866 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753598AbaIOSoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 14:44:13 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtcNAEwyF1RXQ6tE/2dsb2JhbABhgw1TV7NLAQUBb5Ynh1aBFxd4hGAjMmgWIYhCAawaj0kYhXyJUR2ENQWRJYRfhwSBX5Ngg2A7L4JKAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Subject: [PATCH 1/1] checkpatch: check for subject uniqueness in git repository.
Date: Mon, 15 Sep 2014 20:43:57 +0200
Message-Id: <1410806637-3510-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding patch subject uniqueness check in checkpatch --strict mode.
See Documentation/SubmittingPatches/globally-unique identifier.

Inspired-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 scripts/checkpatch.pl | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 0c520f7..2be06c9 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1810,6 +1810,7 @@ sub process {
 
 	our $clean = 1;
 	my $signoff = 0;
+	my $git_samesubjects = 0;
 	my $is_patch = 0;
 
 	my $in_header_lines = $file ? 0 : 1;
@@ -2047,6 +2048,15 @@ sub process {
 			}
 		}
 
+# Check patch subject on subjective/strict check mode
+		if ($check && $line =~ /^Subject: \[(.*)\](.*)/) {
+			my $subject = $2;
+			if ($quiet == 0) {
+				print "Looking for patches with the same subject in git repository ...\n";
+			}
+			$git_samesubjects = `git log --oneline | grep -m1 "$subject\$" | wc  -l`;
+		}
+
 # Check the patch for a signoff:
 		if ($line =~ /^\s*signed-off-by:/i) {
 			$signoff++;
@@ -5091,6 +5101,10 @@ sub process {
 		ERROR("MISSING_SIGN_OFF",
 		      "Missing Signed-off-by: line(s)\n");
 	}
+	if ($is_patch && $git_samesubjects > 0)  {
+		WARN("NOT_UNIQUE_SUBJECT",
+		     "similar subjects found in git repository\n");
+	}
 
 	print report_dump();
 	if ($summary && !($clean == 1 && $quiet == 1)) {
-- 
1.9.1

