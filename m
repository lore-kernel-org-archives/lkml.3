Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbaGORXd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:23:33 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:44380 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932728AbaGORWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:22:35 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Horia Geanta <horia.geanta@freescale.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 78/94] scripts/kernel-doc: handle object-like macros
Date: Tue, 15 Jul 2014 20:01:33 +0300
Message-Id: <1405443709-15288-78-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Horia Geanta <horia.geanta@freescale.com>

Object-like macros are different than function-like macros:
https://gcc.gnu.org/onlinedocs/cpp/Object-like-Macros.html
https://gcc.gnu.org/onlinedocs/cpp/Function-like-Macros.html

They are not parsed correctly, generating invalid intermediate
files (xmls) for cases like:
    #define BIT_MASK    (0xFF << BIT_SHIFT)
where "OxFF <<" is considered to be parameter type.

When parsing, we can differentiate beween these two types of macros by
checking whether there is at least one whitespace b/w "#define" and
first opening parenthesis.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 scripts/kernel-doc |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index da058da..16a07cf 100755
--- a/scripts/kernel-doc
+++ b/scripts/kernel-doc
@@ -2073,6 +2073,7 @@ sub check_return_section {
 sub dump_function($$) {
     my $prototype = shift;
     my $file = shift;
+    my $noret = 0;
 
     $prototype =~ s/^static +//;
     $prototype =~ s/^extern +//;
@@ -2086,7 +2087,7 @@ sub dump_function($$) {
     $prototype =~ s/__init_or_module +//;
     $prototype =~ s/__must_check +//;
     $prototype =~ s/__weak +//;
-    $prototype =~ s/^#\s*define\s+//; #ak added
+    my $define = $prototype =~ s/^#\s*define\s+//; #ak added
     $prototype =~ s/__attribute__\s*\(\([a-z,]*\)\)//;
 
     # Yes, this truly is vile.  We are looking for:
@@ -2105,7 +2106,15 @@ sub dump_function($$) {
     # - atomic_set (macro)
     # - pci_match_device, __copy_to_user (long return type)
 
-    if ($prototype =~ m/^()([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
+    if ($define && $prototype =~ m/^()([a-zA-Z0-9_~:]+)\s+/) {
+        # This is an object-like macro, it has no return type and no parameter
+        # list.
+        # Function-like macros are not allowed to have spaces between
+        # declaration_name and opening parenthesis (notice the \s+).
+        $return_type = $1;
+        $declaration_name = $2;
+        $noret = 1;
+    } elsif ($prototype =~ m/^()([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
 	$prototype =~ m/^(\w+)\s+([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
 	$prototype =~ m/^(\w+\s*\*)\s*([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
 	$prototype =~ m/^(\w+\s+\w+)\s+([a-zA-Z0-9_~:]+)\s*\(([^\(]*)\)/ ||
@@ -2140,7 +2149,7 @@ sub dump_function($$) {
         # of warnings goes sufficiently down, the check is only performed in
         # verbose mode.
         # TODO: always perform the check.
-        if ($verbose) {
+        if ($verbose && !$noret) {
                 check_return_section($file, $declaration_name, $return_type);
         }
 
-- 
1.7.10.4

