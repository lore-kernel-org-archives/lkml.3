Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790AbaDHNZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 09:25:21 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:42409 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369AbaDHNZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 09:25:18 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <robh@kernel.org>, Florian Vaussard <florian.vaussard@epfl.ch>,
        Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] checkpatch: fix wildcard DT compatible string checking
Date: Tue,  8 Apr 2014 08:25:04 -0500
Message-Id: <1396963505-11119-1-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <robh@kernel.org>

We attempt to search for compatible strings which use a variable
token in the documented name such as <chip> or <soc>. While this
was attempted to be handled, it's utterly broken.

The desired forms of matching are:

vendor,<chip>-*
vendor,name<part#>-*

For <chip>, lower case characters and numbers are permitted. For
<part#>, only numeric values are allowed.

With this change, the number of missing compatible strings reported in
arch/arm/boot/dts is reduced from 1071 to 960.

Reported-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Cc: Florian Vaussard <florian.vaussard@epfl.ch>
Cc: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 scripts/checkpatch.pl | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 34eb216..0e960b1 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2093,8 +2093,11 @@ sub process {
 
 			foreach my $compat (@compats) {
 				my $compat2 = $compat;
-				$compat2 =~ s/\,[a-z]*\-/\,<\.\*>\-/;
-				`grep -Erq "$compat|$compat2" $dt_path`;
+				$compat2 =~ s/\,[a-zA-Z0-9]*\-/\,<\.\*>\-/;
+				my $compat3 = $compat;
+				$compat3 =~ s/\,([a-z]*)[0-9]*\-/\,$1<\.\*>\-/;
+				print "$compat3\n";
+				`grep -Erq "$compat|$compat2|$compat3" $dt_path`;
 				if ( $? >> 8 ) {
 					WARN("UNDOCUMENTED_DT_STRING",
 					     "DT compatible string \"$compat\" appears un-documented -- check $dt_path\n" . $herecurr);
-- 
1.9.1

