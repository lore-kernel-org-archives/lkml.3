Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab3LKSEG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 13:04:06 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:64488 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751606Ab3LKSEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 13:04:04 -0500
From: vinayakm.list@gmail.com
To: mgorman@suse.de, rob@landley.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vinayak Menon <vinayakm.list@gmail.com>
Subject: [PATCH] vmscan: tracing: Fix the traceevent regex
Date: Wed, 11 Dec 2013 23:33:49 +0530
Message-Id: <1386785029-3548-1-git-send-email-vinayakm.list@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vinayak Menon <vinayakm.list@gmail.com>

When irq, preempt and lockdep fields are printed
(field 3 in the e.g. below) in the trace output,
the script fails.

An e.g. entry.
kswapd0-610   [000] ...1   158.112152: mm_vmscan_kswapd_wake: nid=0 order=0

Signed-off-by: Vinayak Menon <vinayakm.list@gmail.com>
---
 .../trace/postprocess/trace-vmscan-postprocess.pl  |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl b/Documentation/trace/postprocess/trace-vmscan-postprocess.pl
index 4a37c47..00e425f 100644
--- a/Documentation/trace/postprocess/trace-vmscan-postprocess.pl
+++ b/Documentation/trace/postprocess/trace-vmscan-postprocess.pl
@@ -123,7 +123,7 @@ my $regex_writepage;
 
 # Static regex used. Specified like this for readability and for use with /o
 #                      (process_pid)     (cpus      )   ( time  )   (tpoint    ) (details)
-my $regex_traceevent = '\s*([a-zA-Z0-9-]*)\s*(\[[0-9]*\])\s*([0-9.]*):\s*([a-zA-Z_]*):\s*(.*)';
+my $regex_traceevent = '\s*([a-zA-Z0-9-]*)\s*(\[[0-9]*\])(\s*[dX.][Nnp.][Hhs.][0-9a-fA-F.]*|)\s*([0-9.]*):\s*([a-zA-Z_]*):\s*(.*)';
 my $regex_statname = '[-0-9]*\s\((.*)\).*';
 my $regex_statppid = '[-0-9]*\s\(.*\)\s[A-Za-z]\s([0-9]*).*';
 
@@ -270,8 +270,8 @@ EVENT_PROCESS:
 	while ($traceevent = <STDIN>) {
 		if ($traceevent =~ /$regex_traceevent/o) {
 			$process_pid = $1;
-			$timestamp = $3;
-			$tracepoint = $4;
+			$timestamp = $4;
+			$tracepoint = $5;
 
 			$process_pid =~ /(.*)-([0-9]*)$/;
 			my $process = $1;
@@ -299,7 +299,7 @@ EVENT_PROCESS:
 			$perprocesspid{$process_pid}->{MM_VMSCAN_DIRECT_RECLAIM_BEGIN}++;
 			$perprocesspid{$process_pid}->{STATE_DIRECT_BEGIN} = $timestamp;
 
-			$details = $5;
+			$details = $6;
 			if ($details !~ /$regex_direct_begin/o) {
 				print "WARNING: Failed to parse mm_vmscan_direct_reclaim_begin as expected\n";
 				print "         $details\n";
@@ -322,7 +322,7 @@ EVENT_PROCESS:
 				$perprocesspid{$process_pid}->{HIGH_DIRECT_RECLAIM_LATENCY}[$index] = "$order-$latency";
 			}
 		} elsif ($tracepoint eq "mm_vmscan_kswapd_wake") {
-			$details = $5;
+			$details = $6;
 			if ($details !~ /$regex_kswapd_wake/o) {
 				print "WARNING: Failed to parse mm_vmscan_kswapd_wake as expected\n";
 				print "         $details\n";
@@ -356,7 +356,7 @@ EVENT_PROCESS:
 		} elsif ($tracepoint eq "mm_vmscan_wakeup_kswapd") {
 			$perprocesspid{$process_pid}->{MM_VMSCAN_WAKEUP_KSWAPD}++;
 
-			$details = $5;
+			$details = $6;
 			if ($details !~ /$regex_wakeup_kswapd/o) {
 				print "WARNING: Failed to parse mm_vmscan_wakeup_kswapd as expected\n";
 				print "         $details\n";
@@ -366,7 +366,7 @@ EVENT_PROCESS:
 			my $order = $3;
 			$perprocesspid{$process_pid}->{MM_VMSCAN_WAKEUP_KSWAPD_PERORDER}[$order]++;
 		} elsif ($tracepoint eq "mm_vmscan_lru_isolate") {
-			$details = $5;
+			$details = $6;
 			if ($details !~ /$regex_lru_isolate/o) {
 				print "WARNING: Failed to parse mm_vmscan_lru_isolate as expected\n";
 				print "         $details\n";
@@ -387,7 +387,7 @@ EVENT_PROCESS:
 			}
 			$perprocesspid{$process_pid}->{HIGH_NR_CONTIG_DIRTY} += $nr_contig_dirty;
 		} elsif ($tracepoint eq "mm_vmscan_lru_shrink_inactive") {
-			$details = $5;
+			$details = $6;
 			if ($details !~ /$regex_lru_shrink_inactive/o) {
 				print "WARNING: Failed to parse mm_vmscan_lru_shrink_inactive as expected\n";
 				print "         $details\n";
@@ -397,7 +397,7 @@ EVENT_PROCESS:
 			my $nr_reclaimed = $4;
 			$perprocesspid{$process_pid}->{HIGH_NR_RECLAIMED} += $nr_reclaimed;
 		} elsif ($tracepoint eq "mm_vmscan_writepage") {
-			$details = $5;
+			$details = $6;
 			if ($details !~ /$regex_writepage/o) {
 				print "WARNING: Failed to parse mm_vmscan_writepage as expected\n";
 				print "         $details\n";
-- 
1.7.6

