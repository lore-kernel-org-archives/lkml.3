Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040AbaIVBiO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 21:38:14 -0400
Received: from mail-yk0-f171.google.com ([209.85.160.171]:46259 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbaIVBiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 21:38:13 -0400
From: Greg Donald <gdonald@gmail.com>
To: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org
Cc: Greg Donald <gdonald@gmail.com>
Subject: [PATCH] scripts: checkpatch.pl: Fix existing typedef false positive warning
Date: Sun, 21 Sep 2014 20:32:24 -0500
Message-Id: <1411349544-7479-1-git-send-email-gdonald@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing an "open brace '{' following struct go on the same line" error causes a
false positive warning "do not add new typedefs". Fix existing typedef false
positive warning.

Signed-off-by: Greg Donald <gdonald@gmail.com>
---
 scripts/checkpatch.pl | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 4d08b39..eafe5e7 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3081,14 +3081,24 @@ sub process {
 		}
 
 # check for new typedefs, only function parameters and sparse annotations
-# make sense.
+# and existing typedefs make sense.
 		if ($line =~ /\btypedef\s/ &&
 		    $line !~ /\btypedef\s+$Type\s*\(\s*\*?$Ident\s*\)\s*\(/ &&
 		    $line !~ /\btypedef\s+$Type\s+$Ident\s*\(/ &&
 		    $line !~ /\b$typeTypedefs\b/ &&
 		    $line !~ /\b__bitwise(?:__|)\b/) {
-			WARN("NEW_TYPEDEFS",
-			     "do not add new typedefs\n" . $herecurr);
+			# check if $line is diff-like
+			if (substr($rawlines[$linenr - 3], 0, 1) eq '-') {
+				my $oldline3 = substr($rawlines[$linenr - 3], 1);
+				# check if typedef already existed
+				if ($line !~ /$oldline3/) {
+					WARN("NEW_TYPEDEFS",
+					     "do not add new typedefs\n" . $herecurr);
+				}
+			} else {
+				WARN("NEW_TYPEDEFS",
+				     "do not add new typedefs\n" . $herecurr);
+			}
 		}
 
 # * goes on variable not on type
-- 
1.9.1

