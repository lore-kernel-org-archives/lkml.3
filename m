Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410AbaFZGBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 02:01:51 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:42771 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765AbaFZGBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 02:01:50 -0400
X-Originating-IP: 50.43.32.211
Date: Wed, 25 Jun 2014 23:01:42 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        gregkh@linux-foundation.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] scripts/checkpatch.pl: Improve guidance for LONG_LINE
Message-ID: <20140626060136.GA2528@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, LONG_LINE just informs the user about the line length,
leaving them to shorten the line.  Too many users run checkpatch and
blindly follow its recommendation by splitting long lines, which almost
invariably results in worse code.  On rare occasions, the line-width
limit encourages sensible refactoring of nested code into functions, but
more frequently it just results in painfully over-wrapped code.

Improve the guidance by detecting long lines that start with 4+ tabs and
explicitly suggesting simplification or refactoring in that case.

This does not introduce or remove any warnings; it just changes the text
of a warning that checkpatch would already emit, to emphasize a
preference for simplifying or refactoring complex, deeply nested code,
rather than just wrapping it but leaving it complex.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

Of the ~267000 80+ character lines in the current kernel source, this
new guidance would trigger on ~67000 of them.

Other things I tested, but did not include in this patch, to minimize
controversy or subjectivity: flagging long lines with 2 or more logical
operations (&& or ||) to suggest wrapping at the operators, and flagging
long lines with 30+ character identifiers to suggest consideration of
whether the identifier could remain self-documenting if shortened.

 scripts/checkpatch.pl | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 010b18e..6e82f19 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2146,8 +2146,16 @@ sub process {
 		    $line =~ /^\+\s*"[^"]*"\s*(?:\s*|,|\)\s*;)\s*$/) &&
 		    $length > $max_line_length)
 		{
-			WARN("LONG_LINE",
-			     "line over $max_line_length characters\n" . $herecurr);
+			if ($line =~ /^\+\t{4,}/) {
+				WARN("LONG_LINE_DEEP_NESTING",
+				     "line over $max_line_length characters with excessive nesting (4+ tabs)\n"
+				     . "Consider simplifying or refactoring to eliminate excessive nesting.\n"
+				     . $herecurr);
+			} else {
+				WARN("LONG_LINE",
+				     "line over $max_line_length characters\n"
+				     . $herecurr);
+			}
 		}
 
 # Check for user-visible strings broken across lines, which breaks the ability
-- 
2.0.0

