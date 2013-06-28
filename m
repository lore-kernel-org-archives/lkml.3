Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab3F1BV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 21:21:29 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33240 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753743Ab3F1BV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 21:21:28 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] checkpatch: Cache last camelcase hash as .checkpatch-camelcase.<commit>
Date: Thu, 27 Jun 2013 18:21:25 -0700
Message-Id: <6314ebb53e519e1c39bfd41228c094db74843f04.1372382278.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a file to cache the CamelCase variables found by <commit>
to reduce the time it takes to scan the include/ directory.

Filename is '.checkpatch-camelcase.<commit>' and it is created
only only if a .git directory exists.

<commit> is determined by the last non-merge commit id in the
include/ path.

Reduces checkpatch run time by ~12 cpu seconds on my little netbook.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 70e7f7c..5cf6608 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -399,7 +399,23 @@ sub seed_camelcase_includes {
 	return if ($camelcase_seeded);
 
 	my $files;
+	my $camelcase_git_file = "";
+
 	if (-d ".git") {
+		my $git_last_include_commit = `git log --no-merges --pretty=format:"%h%n" -1 -- include`;
+		chomp $git_last_include_commit;
+		$camelcase_git_file = ".checkpatch-camelcase.$git_last_include_commit";
+		if (-f $camelcase_git_file) {
+			open(my $camelcase_file, '<', "$camelcase_git_file")
+			    or warn "$P: Can't read '$camelcase_git_file' $!\n";
+			while (<$camelcase_file>) {
+				chomp;
+				$camelcase{$_} = 1;
+			}
+			close($camelcase_file);
+
+			return;
+		}
 		$files = `git ls-files include`;
 	} else {
 		$files = `find $root/include -name "*.h"`;
@@ -409,6 +425,16 @@ sub seed_camelcase_includes {
 		seed_camelcase_file($file);
 	}
 	$camelcase_seeded = 1;
+
+	if ($camelcase_git_file ne "") {
+		unlink glob ".checkpatch-camelcase.*";
+		open(my $camelcase_file, '>', "$camelcase_git_file")
+		    or warn "$P: Can't write '$camelcase_git_file' $!\n";
+		foreach (sort { lc($a) cmp lc($b) } keys(%camelcase)) {
+			print $camelcase_file ("$_\n");
+		}
+		close($camelcase_file);
+	}
 }
 
 $chk_signoff = 0 if ($file);
-- 
1.8.1.2.459.gbcd45b4.dirty

