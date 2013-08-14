Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760110Ab3HNQU4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:20:56 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40030 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760023Ab3HNQUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:20:54 -0400
Message-ID: <1376497253.1949.75.camel@joe-AO722>
Subject: [PATCH] checkpatch: Reduce runtime/cpu time used
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 14 Aug 2013 09:20:53 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some cases where checkpatch can take
a long time to complete.  Reduce the likelihood
of this long run-time by adding a new test for
lines with and without comments and eliminating
checks on lines with only comments.

This reduces the number of "ctx_statement_block"
calls, and also the number of tests of $stat,
which is now undefined for these blank lines.

One test in particular, the "check for switch/default
statements without a break", could take an extremely
long time to parse as it tries to skip interleaving
comments within the ctx_statement_block/$stat and
that could be done multiple times unnecessarily.

A small test case taken from cfg80211.h before this
patch would take 1000's of seconds to run, now it's
just a couple seconds.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 3ba2db6..c9e01ab 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1662,6 +1662,8 @@ sub process {
 	$linenr = 0;
 	foreach my $line (@lines) {
 		$linenr++;
+		my $sline = $line;	#copy of $line
+		$sline =~ s/$;/ /g;	#with comments as spaces
 
 		my $rawline = $rawlines[$linenr - 1];
 
@@ -2178,7 +2180,7 @@ sub process {
 		    $realline_next);
 #print "LINE<$line>\n";
 		if ($linenr >= $suppress_statement &&
-		    $realcnt && $line =~ /.\s*\S/) {
+		    $realcnt && $sline =~ /.\s*\S/) {
 			($stat, $cond, $line_nr_next, $remain_next, $off_next) =
 				ctx_statement_block($linenr, $realcnt, 0);
 			$stat =~ s/\n./\n /g;


