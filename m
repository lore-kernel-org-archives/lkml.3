Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257AbaCGN0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:26:30 -0500
Received: from smtp0.epfl.ch ([128.178.224.218]:38701 "EHLO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752749AbaCGN01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:26:27 -0500
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/4] checkpatch: fix spurious vendor compatible warnings
Date: Fri,  7 Mar 2014 14:26:09 +0100
Message-Id: <1394198771-25913-3-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1394198771-25913-1-git-send-email-florian.vaussard@epfl.ch>
References: <1394198771-25913-1-git-send-email-florian.vaussard@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a compatible string like

compatible = "foo";

checkpatch will currently try to find "foo" in  vendor-prefixes.txt,
which is wrong since the vendor prefix is empty in this specific case.

Skip the vendor test if the compatible is not like

compatible = "vendor,something";

Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
[joe@perches.com: cleaned the implementation]
Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e304e77..96f10ba 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2055,10 +2055,10 @@ sub process {
 					     "DT compatible string \"$compat\" appears un-documented -- check $dt_path\n" . $herecurr);
 				}
 
-				my $vendor = $compat;
 				my $vendor_path = $dt_path . "vendor-prefixes.txt";
 				next if (! -f $vendor_path);
-				$vendor =~ s/^([a-zA-Z0-9\-]+)\,.*/$1/;
+				next if $compat !~ /^([a-zA-Z0-9\-]+)\,/;
+				my $vendor = $1;
 				`grep -Eq "$vendor" $vendor_path`;
 				if ( $? >> 8 ) {
 					WARN("UNDOCUMENTED_DT_STRING",
-- 
1.8.5.3

