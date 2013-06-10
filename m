Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab3FJWWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 18:22:10 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58114 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754368Ab3FJWWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 18:22:08 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 09/12] checkpatch: Add a --strict test for comparison to true/false
Date: Mon, 10 Jun 2013 15:20:47 -0700
Message-Id: <ba0caa4e2117b0d7773b3157911a005dfeb51950.1370902448.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1370902448.git.joe@perches.com>
References: <cover.1370902448.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Comparing to true or false is error prone.

Add tests for the various forms of (foo == true) && (false != bar)
that are only reported with --strict.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index c43be81..c2d223c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3588,6 +3588,33 @@ sub process {
 			     "Using yield() is generally wrong. See yield() kernel-doc (sched/core.c)\n"  . $herecurr);
 		}
 
+# check for comparisons against true and false
+		if ($line =~ /\+\s*(.*?)\b(true|false|$Lval)\s*(==|\!=)\s*(true|false|$Lval)\b(.*)$/i) {
+			my $lead = $1;
+			my $arg = $2;
+			my $test = $3;
+			my $otype = $4;
+			my $trail = $5;
+			my $op = "!";
+
+			($arg, $otype) = ($otype, $arg) if ($arg =~ /^(?:true|false)$/i);
+
+			my $type = lc($otype);
+			if ($type =~ /^(?:true|false)$/) {
+				if (("$test" eq "==" && "$type" eq "true") ||
+				    ("$test" eq "!=" && "$type" eq "false")) {
+					$op = "";
+				}
+
+				CHK("BOOL_COMPARISON",
+				    "Using comparison to $otype is error prone\n" . $herecurr);
+
+## maybe suggesting a correct construct would better
+##				    "Using comparison to $otype is error prone.  Perhaps use '${lead}${op}${arg}${trail}'\n" . $herecurr);
+
+			}
+		}
+
 # check for semaphores initialized locked
 		if ($line =~ /^.\s*sema_init.+,\W?0\W?\)/) {
 			WARN("CONSIDER_COMPLETION",
-- 
1.8.1.2.459.gbcd45b4.dirty

