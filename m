Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaJOTcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 15:32:21 -0400
Received: from smtprelay0008.hostedemail.com ([216.40.44.8]:52559 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751020AbaJOTcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 15:32:19 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:3138:3139:3140:3141:3142:3353:3653:3865:3867:3868:3871:3874:5007:6119:6261:10004:10848:11658:11914:12291:12517:12519:12555:13141:13230:13311:13357:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: meat35_4e28d764ed063
X-Filterd-Recvd-Size: 2270
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] checkpatch: Add an error test for no space before comma
Date: Wed, 15 Oct 2014 12:32:07 -0700
Message-Id: <6d065f731dea8d7fc2204cbb4db9377f26eb568a.1413400022.git.joe@perches.com>
X-Mailer: git-send-email 2.1.2.443.g670a3c1
In-Reply-To: <cover.1413400022.git.joe@perches.com>
References: <cover.1413400022.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using code like:

	int foo , bar;

is not preferred to:

	int foo, bar;

so emit an error on this style.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 374abf4..696254e 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3563,14 +3563,33 @@ sub process {
 						}
 					}
 
-				# , must have a space on the right.
+				# , must not have a space before and must have a space on the right.
 				} elsif ($op eq ',') {
+					my $rtrim_before = 0;
+					my $space_after = 0;
+					if ($ctx =~ /Wx./) {
+						if (ERROR("SPACING",
+							  "space prohibited before that '$op' $at\n" . $hereptr)) {
+							$line_fixed = 1;
+							$rtrim_before = 1;
+						}
+					}
 					if ($ctx !~ /.x[WEC]/ && $cc !~ /^}/) {
 						if (ERROR("SPACING",
 							  "space required after that '$op' $at\n" . $hereptr)) {
-							$good = $fix_elements[$n] . trim($fix_elements[$n + 1]) . " ";
 							$line_fixed = 1;
 							$last_after = $n;
+							$space_after = 1;
+						}
+					}
+					if ($rtrim_before || $space_after) {
+						if ($rtrim_before) {
+							$good = rtrim($fix_elements[$n]) . trim($fix_elements[$n + 1]);
+						} else {
+							$good = $fix_elements[$n] . trim($fix_elements[$n + 1]);
+						}
+						if ($space_after) {
+							$good .= " ";
 						}
 					}
 
-- 
2.1.0

