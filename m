Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab3J1Vdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 17:33:50 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:44789 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756240Ab3J1Vds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 17:33:48 -0400
From: Rashika Kheria <rashika.kheria@gmail.com>
To: opw-kernel@googlegroups.com, gregkh@linuxfoundation.org,
        Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Scripts: checkpatch.pl: Fix incorrect warning in multi-line seq_printf()
Date: Tue, 29 Oct 2013 03:02:42 +0530
Message-Id: <1382995962-7023-1-git-send-email-rashika.kheria@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes the following incorrect warning given by checkpatch.pl
in case of multi-line seq_printf() statements-

"WARNING: Prefer seq_puts to seq_printf"

The previous code block producing the above warning was evaluating on line
by line basis and hence was printing a warning if the format specifier
was absent in the first line.

In this patch, we maintain a state flag $is_seq_printf_block indicating
that the same seq_printf() statement is continuing in the next line and
throw a warning if no format specifier is found in any of the lines as
indicated by flag $has_format_specifier. 

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
---
 scripts/checkpatch.pl |   24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 66cad50..954568f 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -13,6 +13,9 @@ $P =~ s@.*/@@g;
 
 my $V = '0.32';
 
+my $is_seq_printf_block = 0;
+my $has_format_specifier = 0;
+
 use Getopt::Long qw(:config no_auto_abbrev);
 
 my $quiet = 0;
@@ -3903,14 +3906,23 @@ sub string_find_replace {
 		}
 
 # check for seq_printf uses that could be seq_puts
-		if ($line =~ /\bseq_printf\s*\(/) {
+		if ($line =~ /\bseq_printf\s*\(/ || $is_seq_printf_block) {
 			my $fmt = get_quoted_string($line, $rawline);
-			if ($fmt !~ /[^\\]\%/) {
-				if (WARN("PREFER_SEQ_PUTS",
-					 "Prefer seq_puts to seq_printf\n" . $herecurr) &&
-				    $fix) {
-					$fixed[$linenr - 1] =~ s/\bseq_printf\b/seq_puts/;
+			if ($fmt =~ /[^\\]\%/) {
+				$has_format_specifier = 1;
+			}
+			if ($line =~ m/\;$/) {
+				$is_seq_printf_block = 0;
+				if ($has_format_specifier == 0) {
+					if (WARN("PREFER_SEQ_PUTS",
+						 "Prefer seq_puts to seq_printf\n" . $herecurr) &&
+					    $fix) {
+						$fixed[$linenr - 1] =~ s/\bseq_printf\b/seq_puts/;
+					}
 				}
+				$has_format_specifier = 0;
+			} else {
+				$is_seq_printf_block = 1;
 			}
 		}
 
-- 
1.7.9.5

