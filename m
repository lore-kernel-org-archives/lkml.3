Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589Ab3LDERp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 23:17:45 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:38633 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab3LDERm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 23:17:42 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Subject: [PATCH v2] checkpatch: add DT compatible string documentation checks
Date: Tue,  3 Dec 2013 22:17:23 -0600
Message-Id: <1386130643-19449-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

This adds a simple check that any compatible strings in DeviceTree dts
files are present in Documentation/devicetree/bindings. Vendor prefixes
are also checked for existing in vendor-prefixes.txt These should be
temporary checks until we have more sophisticated binding schema checking.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
---
v2:
- Add vendor string checking against vendor-prefixes.txt
- Add '_', '.' and '+' as valid compatible string characters
- Use 'grep -E' instead of egrep

 scripts/checkpatch.pl | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9c98100..5eea031 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2034,6 +2034,29 @@ sub process {
 			     "Use of $flag is deprecated, please use \`$replacement->{$flag} instead.\n" . $herecurr) if ($replacement->{$flag});
 		}
 
+# check for DT compatible documentation
+		if ($realfile =~ /\.dts/ && $rawline =~ /\+\s*compatible\s*=/) {
+			my @compats = $rawline =~ /\"([a-zA-Z0-9\-\,\.\+_]+)\"/g;
+
+			foreach my $compat (@compats) {
+				my $compat2 = $compat;
+				my $dt_path = "Documentation/devicetree/bindings/";
+				$compat2 =~ s/\,[a-z]*\-/\,<\.\*>\-/;
+				`grep -Erq "$compat|$compat2" $dt_path`;
+				if ( $? >> 8 ) {
+					WARN("UNDOCUMENTED_DT_BINDING",
+					     "DT compatible string \"$compat\" appears un-documented -- check $dt_path\n" . $herecurr);
+				}
+				my $vendor = $compat;
+				$vendor =~ s/^([a-zA-Z0-9]+)\,.*/$1/;
+				`grep -Eq "$vendor" "${dt_path}vendor-prefixes.txt"`;
+				if ( $? >> 8 ) {
+					WARN("UNDOCUMENTED_DT_VENDOR",
+					     "DT compatible string vendor \"$vendor\" appears un-documented -- check ${dt_path}vendor-prefixes.txt\n" . $herecurr);
+				}
+			}
+		}
+
 # check we are in a valid source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
 
-- 
1.8.3.2

