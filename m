Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab3GCXjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 19:39:12 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52725 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753935Ab3GCXjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 19:39:11 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] checkpatch: Make the CamelCase cache work for non-git trees too
Date: Wed,  3 Jul 2013 16:39:07 -0700
Message-Id: <c6ec3afb475da240dfdcb2b918e8b048e7c9cdfa.1372894341.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Might as well check include timestamps and cache the
include file CamelCase uses for the non-git case too.

The camelcase cache file is now named:

for git:	.checkpatch-camelcase.git.<commit_id>
for non-git:	.checkpatch-camelcase.date.<YYYYMMDDhhmm>

All .checkpatch-camelcase* files are deleted if not current.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 54 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 35 insertions(+), 19 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 5cf6608..a220104 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -6,6 +6,7 @@
 # Licensed under the terms of the GNU GPL License version 2
 
 use strict;
+use POSIX;
 
 my $P = $0;
 $P =~ s@.*/@@g;
@@ -399,37 +400,52 @@ sub seed_camelcase_includes {
 	return if ($camelcase_seeded);
 
 	my $files;
-	my $camelcase_git_file = "";
+	my $camelcase_cache = "";
+	my @include_files = ();
+
+	$camelcase_seeded = 1;
 
 	if (-d ".git") {
 		my $git_last_include_commit = `git log --no-merges --pretty=format:"%h%n" -1 -- include`;
 		chomp $git_last_include_commit;
-		$camelcase_git_file = ".checkpatch-camelcase.$git_last_include_commit";
-		if (-f $camelcase_git_file) {
-			open(my $camelcase_file, '<', "$camelcase_git_file")
-			    or warn "$P: Can't read '$camelcase_git_file' $!\n";
-			while (<$camelcase_file>) {
-				chomp;
-				$camelcase{$_} = 1;
-			}
-			close($camelcase_file);
-
-			return;
-		}
-		$files = `git ls-files include`;
+		$camelcase_cache = ".checkpatch-camelcase.git.$git_last_include_commit";
 	} else {
+		my $last_mod_date = 0;
 		$files = `find $root/include -name "*.h"`;
+		@include_files = split('\n', $files);
+		foreach my $file (@include_files) {
+			my $date = POSIX::strftime("%Y%m%d%H%M",
+						   localtime((stat $file)[9]));
+			$last_mod_date = $date if ($last_mod_date < $date);
+		}
+		$camelcase_cache = ".checkpatch-camelcase.date.$last_mod_date";
+	}
+
+	if ($camelcase_cache ne "" && -f $camelcase_cache) {
+		open(my $camelcase_file, '<', "$camelcase_cache")
+		    or warn "$P: Can't read '$camelcase_cache' $!\n";
+		while (<$camelcase_file>) {
+			chomp;
+			$camelcase{$_} = 1;
+		}
+		close($camelcase_file);
+
+		return;
+	}
+
+	if (-d ".git") {
+		$files = `git ls-files "include/*.h"`;
+		@include_files = split('\n', $files);
 	}
-	my @include_files = split('\n', $files);
+
 	foreach my $file (@include_files) {
 		seed_camelcase_file($file);
 	}
-	$camelcase_seeded = 1;
 
-	if ($camelcase_git_file ne "") {
+	if ($camelcase_cache ne "") {
 		unlink glob ".checkpatch-camelcase.*";
-		open(my $camelcase_file, '>', "$camelcase_git_file")
-		    or warn "$P: Can't write '$camelcase_git_file' $!\n";
+		open(my $camelcase_file, '>', "$camelcase_cache")
+		    or warn "$P: Can't write '$camelcase_cache' $!\n";
 		foreach (sort { lc($a) cmp lc($b) } keys(%camelcase)) {
 			print $camelcase_file ("$_\n");
 		}
-- 
1.8.1.2.459.gbcd45b4.dirty

