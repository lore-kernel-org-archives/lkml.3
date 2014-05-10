Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751479AbaEJElz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 00:41:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:41345 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871AbaEJEly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 00:41:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1022,1389772800"; 
   d="scan'208";a="538006261"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: joe@perches.com, akpm@linux-foundation.org
Cc: David Ertman <davidx.m.ertman@intel.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH] checkpatch.pl: Fix checkpatch false positive due to ternary operator break
Date: Fri,  9 May 2014 21:41:51 -0700
Message-Id: <1399696911-6550-1-git-send-email-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ertman <davidx.m.ertman@intel.com>

Using the intuitive breaking of a ternary operator used in the
initialization of a variable in its declaration:

type var = FOO ?
           BAR :
           FEE;

is causing a checkpatch warning:
"WARNING:SPACING: networking uses a blank line after declarations"

Checkpatch is checking for the ternary operators at the beginning of the
lines after the initial break like the following:

type var = FOO
           ? BAR
           : FEE;

Change checkpatch so that it is checking fot the correct breaking of ternary
operators used in networking variable declaration/initialization.

Signed-off-by: Dave Ertman <davidx.m.ertman@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 scripts/checkpatch.pl | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 34eb216..baabf1c 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2269,12 +2269,13 @@ sub process {
 		if ($realfile =~ m@^(drivers/net/|net/)@ &&
 		    $prevline =~ /^\+\s+$Declare\s+$Ident/ &&
 		    !($prevline =~ /(?:$Compare|$Assignment|$Operators)\s*$/ ||
-		      $prevline =~ /(?:\{\s*|\\)$/) &&		#extended lines
+		      $prevline =~ /(?:\{\s*|\\)$/ ||		#extended lines
+		      $prevline =~ /(?:[\?\:])$/) &&		#ternary ops
 		    $sline =~ /^\+\s+/ &&			#Not at char 1
 		    !($sline =~ /^\+\s+$Declare/ ||
 		      $sline =~ /^\+\s+$Ident\s+$Ident/ ||	#eg: typedef foo
 		      $sline =~ /^\+\s+(?:union|struct|enum|typedef)\b/ ||
-		      $sline =~ /^\+\s+(?:$|[\{\}\.\#\"\?\:\(])/ ||
+		      $sline =~ /^\+\s+(?:$|[\{\}\.\#\"\(])/ ||
 		      $sline =~ /^\+\s+\(?\s*(?:$Compare|$Assignment|$Operators)/)) {
 			WARN("SPACING",
 			     "networking uses a blank line after declarations\n" . $hereprev);
-- 
1.9.0

