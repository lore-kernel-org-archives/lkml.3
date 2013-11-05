Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab3KEKmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 05:42:19 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:33643 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851Ab3KEKmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 05:42:18 -0500
From: Jamie Iles <jamie.iles@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jamie Iles <jamie.iles@oracle.com>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCHv2] recordmcount.pl: add support for __fentry__
Date: Tue,  5 Nov 2013 10:42:09 +0000
Message-Id: <1383648129-10724-1-git-send-email-jamie.iles@oracle.com>
X-Mailer: git-send-email 1.8.4.2
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With gcc 4.6.0 the -mfentry feature places the function profiling call
at the start of the function. When this is used, the call is to
__fentry__ and not mcount.  This is required for Ksplice as the C
version of recordmcount doesn't insert section symbols for the
__mcount_loc section so we fall back to the perl version.

Based on 48bb5dc6cd9d30fe0d594947563da1f8bd9abada (ftrace: Make
recordmcount.c handle __fentry__).

Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jamie Iles <jamie.iles@oracle.com>
---

v2: describe the problem for Ksplice and include a hunk for x86_64 where the
regex is overridden.

 scripts/recordmcount.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index a674fd5..d0da663 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -214,13 +214,13 @@ $local_regex = "^[0-9a-fA-F]+\\s+t\\s+(\\S+)";
 $weak_regex = "^[0-9a-fA-F]+\\s+([wW])\\s+(\\S+)";
 $section_regex = "Disassembly of section\\s+(\\S+):";
 $function_regex = "^([0-9a-fA-F]+)\\s+<(.*?)>:";
-$mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount\$";
+$mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s(mcount|__fentry__)\$";
 $section_type = '@progbits';
 $mcount_adjust = 0;
 $type = ".long";
 
 if ($arch eq "x86_64") {
-    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\smcount([+-]0x[0-9a-zA-Z]+)?\$";
+    $mcount_regex = "^\\s*([0-9a-fA-F]+):.*\\s(mcount|__fentry__)([+-]0x[0-9a-zA-Z]+)?\$";
     $type = ".quad";
     $alignment = 8;
     $mcount_adjust = -1;
-- 
1.8.4.2

