Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab3KZQBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 11:01:44 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:40780 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab3KZQBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 11:01:39 -0500
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@linaro.org>,
        Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Subject: [PATCH] checkpatch: add DT compatible string documentation check
Date: Tue, 26 Nov 2013 10:01:15 -0600
Message-Id: <1385481675-26675-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

This adds a simple check that any compatible strings in DeviceTree dts
files are present in Documentation/devicetree/bindings. This should be a
temporary check until we have more sophisticated binding schema checking.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9c98100..3fc3517 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2034,6 +2034,21 @@ sub process {
 			     "Use of $flag is deprecated, please use \`$replacement->{$flag} instead.\n" . $herecurr) if ($replacement->{$flag});
 		}
 
+# check for compatible documentation
+		if ($realfile =~ /\.dts/ && $rawline =~ /\+\s*compatible\s*=/) {
+			my @compats = $rawline =~ /\"([a-zA-Z0-9\-\,]+)\"/g;
+
+			foreach my $compat (@compats) {
+				my $compat2 = $compat;
+				$compat2 =~ s/\,[a-z]*\-/\,<\.\*>\-/;
+				`egrep -rq "$compat|$compat2" "Documentation/devicetree/bindings/"`;
+				if ( $? >> 8 ) {
+					WARN("UNDOCUMENTED_DT_BINDING",
+					     "DT compatible string \"$compat\" appears un-documented -- check Documentation/devicetree/bindings/\n" . $herecurr);
+				}
+			}
+		}
+
 # check we are in a valid source file if not then ignore this hunk
 		next if ($realfile !~ /\.(h|c|s|S|pl|sh)$/);
 
-- 
1.8.3.2

