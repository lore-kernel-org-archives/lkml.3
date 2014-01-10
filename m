Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbaAJRBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 12:01:24 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:55822 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758020AbaAJRBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 12:01:21 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <robh@kernel.org>, Joe Perches <joe@perches.com>,
        Grant Likely <grant.likely@linaro.org>,
        Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v4 RESEND] checkpatch: add DT compatible string documentation checks
Date: Fri, 10 Jan 2014 11:00:58 -0600
Message-Id: <1389373258-19493-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

This adds a simple check that any compatible strings in DeviceTree dts
files are present in Documentation/devicetree/bindings. Vendor prefixes
are also checked for existing in vendor-prefixes.txt These should be
temporary checks until we have more sophisticated binding schema checking.

Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
Andrew,

Can you please apply this or I can take it via the DT tree.

Rob

v4:
- Fix handling of no source tree or user-specified source tree
- Check for presence of vendor-prefixes.txt

v3:
- Use a single message type UNDOCUMENTED_DT_STRING
- Ensure '+' is at beginning of the line
- Move vendor-prefixes.txt to variable

v2:
- Add vendor string checking against vendor-prefixes.txt
- Add '_', '.' and '+' as valid compatible string characters
- Use 'grep -E' instead of egrep

 scripts/checkpatch.pl | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9c98100..e6635bb 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2034,6 +2034,33 @@ sub process {
 			     "Use of $flag is deprecated, please use \`$replacement->{$flag} instead.\n" . $herecurr) if ($replacement->{$flag});
 		}
 
+# check for DT compatible documentation
+		if (defined $root && $realfile =~ /\.dts/ &&
+		    $rawline =~ /^\+\s*compatible\s*=/) {
+			my @compats = $rawline =~ /\"([a-zA-Z0-9\-\,\.\+_]+)\"/g;
+
+			foreach my $compat (@compats) {
+				my $compat2 = $compat;
+				my $dt_path =  $root . "/Documentation/devicetree/bindings/";
+				$compat2 =~ s/\,[a-z]*\-/\,<\.\*>\-/;
+				`grep -Erq "$compat|$compat2" $dt_path`;
+				if ( $? >> 8 ) {
+					WARN("UNDOCUMENTED_DT_STRING",
+					     "DT compatible string \"$compat\" appears un-documented -- check $dt_path\n" . $herecurr);
+				}
+
+				my $vendor = $compat;
+				my $vendor_path = $dt_path . "vendor-prefixes.txt";
+				next if (! -f $vendor_path);
+				$vendor =~ s/^([a-zA-Z0-9]+)\,.*/$1/;
+				`grep -Eq "$vendor" $vendor_path`;
+				if ( $? >> 8 ) {
+					WARN("UNDOCUMENTED_DT_STRING",
+					     "DT compatible string vendor \"$vendor\" appears un-documented -- check $vendor_path\n" . $herecurr);
+				}
+			}
+		}
+
 # check we are in a valid source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
 
-- 
1.8.3.2

