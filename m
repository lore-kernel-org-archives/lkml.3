Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933065AbaDBTiI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:38:08 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:8291 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932768AbaDBTiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:38:06 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArobAGxmPFNbtAq4/2dsb2JhbABZgwY7qxmZIgICgSAXdIJmHCMYF2skE4d9Ac8+jHKBfoQ/BJhXAYEzkQaDMjs
Date: Wed, 2 Apr 2014 21:39:52 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH v2] scripts/bootgraph.pl: Add graphic header
Message-Id: <20140402213952.7c05ff6d77a85f97b3b3e19e@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding -header + help function like other .pl in /scripts.

Cc: linux-kbuild@vger.kernel.org
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 v2: fix some typos

 scripts/bootgraph.pl | 42 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/scripts/bootgraph.pl b/scripts/bootgraph.pl
index b78fca9..9ca667b 100644
--- a/scripts/bootgraph.pl
+++ b/scripts/bootgraph.pl
@@ -38,6 +38,31 @@
 #
 
 use strict;
+use Getopt::Long;
+my $header = 0;
+
+sub help {
+	my $text = << "EOM";
+Usage:
+1) dmesg | perl scripts/bootgraph.pl [OPTION] > output.svg
+2) perl scripts/bootgraph.pl -h
+
+Options:
+	-header	Insert kernel version and date
+EOM
+	my $std=shift;
+	if ($std == 1) {
+		print STDERR $text;
+	} else {
+		print $text;
+	}
+	exit;
+}
+
+GetOptions(
+	'h|help'	=>\&help,
+	'header'	=>\$header
+);
 
 my %start;
 my %end;
@@ -49,6 +74,11 @@ my $count = 0;
 my %pids;
 my %pidctr;
 
+my $headerstep = 20;
+my $xheader = 15;
+my $yheader = 25;
+my $cyheader = 0;
+
 while (<>) {
 	my $line = $_;
 	if ($line =~ /([0-9\.]+)\] calling  ([a-zA-Z0-9\_\.]+)\+/) {
@@ -112,15 +142,23 @@ if ($count == 0) {
     print STDERR <<END;
 No data found in the dmesg. Make sure that 'printk.time=1' and
 'initcall_debug' are passed on the kernel command line.
-Usage:
-      dmesg | perl scripts/bootgraph.pl > output.svg
 END
+	help(1);
     exit 1;
 }
 
 print "<?xml version=\"1.0\" standalone=\"no\"?> \n";
 print "<svg width=\"2000\" height=\"100%\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">\n";
 
+
+if ($header) {
+	my $version = `uname -a`;
+	my $date = `date`;
+	print "<text transform=\"translate($xheader,$yheader)\">Kernel version: $version</text>\n";
+	$cyheader = $yheader+$headerstep;
+	print "<text transform=\"translate($xheader,$cyheader)\">Date: $date</text>\n";
+}
+
 my @styles;
 
 $styles[0] = "fill:rgb(0,0,255);fill-opacity:0.5;stroke-width:1;stroke:rgb(0,0,0)";
-- 
1.8.4.5

