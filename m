Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbaCGXjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 18:39:51 -0500
Received: from smtp0.epfl.ch ([128.178.224.218]:47884 "EHLO smtp0.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbaCGXjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 18:39:02 -0500
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rob Herring <robh@kernel.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/4] checkpatch: fix spurious vendor compatible warnings
Date: Sat,  8 Mar 2014 00:38:45 +0100
Message-Id: <1394235527-8999-3-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1394235527-8999-1-git-send-email-florian.vaussard@epfl.ch>
References: <1394235527-8999-1-git-send-email-florian.vaussard@epfl.ch>
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

