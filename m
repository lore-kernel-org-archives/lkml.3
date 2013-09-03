Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847Ab3ICRZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 13:25:24 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42754 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758568Ab3ICRZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 13:25:22 -0400
Message-ID: <1378229121.7347.12.camel@joe-AO722>
Subject: [PATCH] checkpatch: Extend CamelCase types and ignore existing
 CamelCase uses in a patch
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Wang Shilong <wangshilong1991@gmail.com>, kumargauravgupta3@gmail.com,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 03 Sep 2013 10:25:21 -0700
In-Reply-To: <20130903155857.GA2657@xanatos>
References: <5223383f.hCMXrpqEq1AlVw9b%wangshilong1991@gmail.com>
	 <20130903155857.GA2657@xanatos>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend the CamelCase words found to include structure members.

In https://lkml.org/lkml/2013/9/3/318 Sarah Sharp (mostly) wrote: 

"In general, if checkpatch.pl complains about a variable a patch
introduces that's CamelCase, you should pay attention to it.
Otherwise, [] ignore it."

So, if checking a patch, scan the original patched file if it's
available and add any preexisting CamelCase types so reuses do
not generate CamelCase messages.

That also means Andrew's not so cruelly spurned anymore.
https://lkml.org/lkml/2013/2/22/426

Signed-off-by: Joe Perches <joe@perches.com>
Suggested-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
---
 scripts/checkpatch.pl | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 9ba4fc4..b98a996 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -424,7 +424,7 @@ sub seed_camelcase_file {
 		if ($line =~ /^[ \t]*(?:#[ \t]*define|typedef\s+$Type)\s+(\w*(?:[A-Z][a-z]|[a-z][A-Z])\w*)/) {
 			$camelcase{$1} = 1;
 		}
-	        elsif ($line =~ /^\s*$Declare\s+(\w*(?:[A-Z][a-z]|[a-z][A-Z])\w*)\s*\(/) {
+	        elsif ($line =~ /^\s*$Declare\s+(\w*(?:[A-Z][a-z]|[a-z][A-Z])\w*)\s*[\(\[,;]/) {
 			$camelcase{$1} = 1;
 		}
 	}
@@ -1593,6 +1593,8 @@ sub process {
 	my @setup_docs = ();
 	my $setup_docs = 0;
 
+	my $camelcase_file_seeded = 0;
+
 	sanitise_line_reset();
 	my $line;
 	foreach my $rawline (@rawlines) {
@@ -3377,7 +3379,13 @@ sub process {
 				while ($var =~ m{($Ident)}g) {
 					my $word = $1;
 					next if ($word !~ /[A-Z][a-z]|[a-z][A-Z]/);
-					seed_camelcase_includes() if ($check);
+					if ($check) {
+						seed_camelcase_includes();
+						if (!$file && !$camelcase_file_seeded) {
+							seed_camelcase_file($realfile);
+							$camelcase_file_seeded = 1;
+						}
+					}
 					if (!defined $camelcase{$word}) {
 						$camelcase{$word} = 1;
 						CHK("CAMELCASE",


