Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881Ab3GVSQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 14:16:33 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37897 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932264Ab3GVSQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 14:16:31 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] checkpatch: Check CamelCase by word, not by $Lval
Date: Mon, 22 Jul 2013 11:16:21 -0700
Message-Id: <1374516981-23049-2-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$Lval is a test for complete name (ie: foo->bar.Baz[1])

If any of this is CamelCase, then the current test uses
the entire $Lval.  This isn't optimal because it can
emit messages with foo->bar.Baz and bar.Baz when Baz is
a variable specified in an include file.

So instead, break the $Lval into words and check each
word for CamelCase uses.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 7dc00fd..5cfef19 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3302,11 +3302,15 @@ sub process {
 			    $var !~ /^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
 #Ignore SI style variants like nS, mV and dB (ie: max_uV, regulator_min_uA_show)
 			    $var !~ /^(?:[a-z_]*?)_?[a-z][A-Z](?:_[a-z_]+)?$/) {
-				seed_camelcase_includes() if ($check);
-				if (!defined $camelcase{$var}) {
-					$camelcase{$var} = 1;
-					CHK("CAMELCASE",
-					    "Avoid CamelCase: <$var>\n" . $herecurr);
+				while ($var =~ m{($Ident)}g) {
+					my $word = $1;
+					next if ($word !~ /[A-Z][a-z]|[a-z][A-Z]/);
+					seed_camelcase_includes() if ($check);
+					if (!defined $camelcase{$word}) {
+						$camelcase{$word} = 1;
+						CHK("CAMELCASE",
+						    "Avoid CamelCase: <$word>\n" . $herecurr);
+					}
 				}
 			}
 		}
-- 
1.8.1.2.459.gbcd45b4.dirty

