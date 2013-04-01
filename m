Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab3DASAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 14:00:41 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:65057 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753003Ab3DASAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 14:00:40 -0400
Message-ID: <1364839238.21627.66.camel@x61.thuisdomein>
Subject: [PATCH 4/8] headers_check: check kernel types inside #define
From: Paul Bolle <pebolle@tiscali.nl>
To: linux-kernel@vger.kernel.org
Date: Mon, 01 Apr 2013 20:00:38 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Apr 2013 18:00:38.0778 (UTC) FILETIME=[D145DDA0:01CE2F02]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel integer types are sometimes used inside defines too. Expand
check_kerneltypes() to notice these too.

Annoyingly, lines like
    #define VFIO_IRQ_SET_DATA_BOOL		(1 << 1) /* Data is bool (u8) */

force me to first strip oneline comments from the processed line. Both
regexes added here are just complicated enough to catch all current uses
of kernel integer types inside preprocessor #defines.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 scripts/headers_check.pl | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/scripts/headers_check.pl b/scripts/headers_check.pl
index 317aa3a..dc7b34c 100644
--- a/scripts/headers_check.pl
+++ b/scripts/headers_check.pl
@@ -163,7 +163,18 @@ sub check_sizetypes
 
 sub check_kerneltypes
 {
-	if ($line =~ m/^[[:space:]]*([us](8|16|32|64))\b/) {
+	my $match = 0;
+	# delete oneline comment
+	(my $scrubbed = $line) =~ s/\/\*.*\*\///;
+
+	if ($scrubbed =~ m/^[[:space:]]*([us](8|16|32|64))\b/) {
+		$match = 1;
+	} elsif ($scrubbed =~ m/# *define *.*\b([us](8|16|32|64))\b/) {
+		# matches lines like
+		#    #define BAR bar(MAGIC, u64)
+		$match = 1;
+	}
+	if ($match) {
 		printf STDERR "$filename:$lineno: " .
 		              "found $1 type exported to userspace; " .
 		              "use __$1 instead\n";
-- 
1.7.11.7

