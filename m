Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaFWMQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 08:16:33 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:39473
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750820AbaFWMQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 08:16:31 -0400
From: Horia Geanta <horia.geanta@freescale.com>
To: Randy Dunlap <rdunlap@infradead.org>
CC: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Horia Geanta <horia.geanta@freescale.com>
Subject: [PATCH] scripts/kernel-doc: handle object-like macros
Date: Mon, 23 Jun 2014 15:15:32 +0300
Message-ID: <1403525732-7653-1-git-send-email-horia.geanta@freescale.com>
X-Mailer: git-send-email 1.8.3.1
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:192.88.168.50;CTRY:US;IPV:CAL;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(199002)(189002)(76482001)(87286001)(26826002)(79102001)(47776003)(64706001)(44976005)(77156001)(4396001)(20776003)(104166001)(68736004)(74502001)(36756003)(88136002)(89996001)(102836001)(50226001)(33646001)(19580405001)(99396002)(46102001)(21056001)(83322001)(81342001)(77982001)(19580395003)(106466001)(87936001)(48376002)(92726001)(62966002)(85852003)(85306003)(6806004)(84676001)(81542001)(97736001)(83072002)(92566001)(15975445006)(95666004)(31966008)(93916002)(50986999)(105606002)(50466002)(104016002)(86362001)(80022001)(74662001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR03MB394;H:tx30smr01.am.freescale.net;FPR:;MLV:ovrnspm;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
MIME-Version: 1.0
Content-Type: text/plain
X-Microsoft-Antispam: BL:0;ACTION:Default;RISK:Low;SCL:0;SPMLVL:NotSpam;PCL:0;RULEID:
X-Forefront-PRVS: 025100C802
Authentication-Results: spf=fail (sender IP is 192.88.168.50)
 smtp.mailfrom=Horia.Geanta@freescale.com; 
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Object-like macros are different than function-like macros:
https://gcc.gnu.org/onlinedocs/cpp/Object-like-Macros.html
https://gcc.gnu.org/onlinedocs/cpp/Function-like-Macros.html

They are not parsed correctly, generating invalid intermediate
files (xmls) for cases like:
    #define BIT_MASK    (0xFF << BIT_SHIFT)
where "OxFF <<" is considered to be parameter type.

When parsing, we can differentiate beween these two types of macros by
checking whether there is at least one whitespace b/w "#define" and
first opening paranthesis.

Signed-off-by: Horia Geanta <horia.geanta@freescale.com>
---
 scripts/kernel-doc | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/scripts/kernel-doc b/scripts/kernel-doc
index da058da413e7..ffd35c9d616a 100755
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
+        # declaration_name and opening paranthesis (notice the \s+).
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
1.8.3.1

