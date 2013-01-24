Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422693Ab3AXVVw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:21:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33647 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422651Ab3AXVUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:20:48 -0500
From: Michal Marek <mmarek@suse.cz>
To: dhowells@redhat.com, rusty@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] MODSIGN: Add -s <signature> option to sign-file
Date: Thu, 24 Jan 2013 22:20:28 +0100
Message-Id: <1359062429-27295-3-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1359062429-27295-1-git-send-email-mmarek@suse.cz>
References: <1359062429-27295-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This option allows to append an externally computed singature to the
module. This is needed in setups, where the private key is not directly
available, but a service exists that returns signatures for given files.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
v2: Use two-argument version of getopts to avoid global variables
    Use parentheses in EXPR if (...) constructs

---
 scripts/sign-file |   99 ++++++++++++++++++++++++++++++-----------------------
 1 files changed, 56 insertions(+), 43 deletions(-)

diff --git a/scripts/sign-file b/scripts/sign-file
index 2c2bbd1..2b7c448 100755
--- a/scripts/sign-file
+++ b/scripts/sign-file
@@ -2,31 +2,41 @@
 #
 # Sign a module file using the given key.
 #
-# Format:
-#
-#	./scripts/sign-file [-v] <hash algo> <key> <x509> <module> [<dest>]
-#
-#
+
+my $USAGE =
+"Usage: scripts/sign-file [-v] <hash algo> <key> <x509> <module> [<dest>]\n" .
+"       scripts/sign-file [-v] -s <raw sig> <hash algo> <x509> <module> [<dest>]\n";
+
 use strict;
 use FileHandle;
 use IPC::Open2;
+use Getopt::Std;
 
-my $verbose = 0;
-if ($#ARGV >= 0 && $ARGV[0] eq "-v") {
-    $verbose = 1;
-    shift;
-}
+my %opts;
+getopts('vs:', \%opts) or die $USAGE;
+my $verbose = $opts{'v'};
+my $signature_file = $opts{'s'};
 
-die "Format: ./scripts/sign-file [-v] <hash algo> <key> <x509> <module> [<dest>]\n"
-    if ($#ARGV != 3 && $#ARGV != 4);
+die $USAGE if ($#ARGV > 4);
+die $USAGE if (!$signature_file && $#ARGV < 3 || $signature_file && $#ARGV < 2);
 
-my $dgst = $ARGV[0];
-my $private_key = $ARGV[1];
-my $x509 = $ARGV[2];
-my $module = $ARGV[3];
-my $dest = ($#ARGV == 4) ? $ARGV[4] : $ARGV[3] . "~";
+my $dgst = shift @ARGV;
+my $private_key;
+if (!$signature_file) {
+	$private_key = shift @ARGV;
+}
+my $x509 = shift @ARGV;
+my $module = shift @ARGV;
+my ($dest, $keep_orig);
+if (@ARGV) {
+	$dest = $ARGV[0];
+	$keep_orig = 1;
+} else {
+	$dest = $module . "~";
+}
 
-die "Can't read private key\n" unless (-r $private_key);
+die "Can't read private key\n" if (!$signature_file && !-r $private_key);
+die "Can't read signature file\n" if ($signature_file && !-r $signature_file);
 die "Can't read X.509 certificate\n" unless (-r $x509);
 die "Can't read module\n" unless (-r $module);
 
@@ -340,33 +350,36 @@ if ($dgst eq "sha1") {
     die "Unknown hash algorithm: $dgst\n";
 }
 
-#
-# Generate the digest and read from openssl's stdout
-#
-my $digest;
-$digest = readpipe("openssl dgst -$dgst -binary $module") || die "openssl dgst";
-
-#
-# Generate the binary signature, which will be just the integer that comprises
-# the signature with no metadata attached.
-#
-my $pid;
-$pid = open2(*read_from, *write_to,
-	     "openssl rsautl -sign -inkey $private_key -keyform PEM") ||
-    die "openssl rsautl";
-binmode write_to;
-print write_to $prologue . $digest || die "pipe to openssl rsautl";
-close(write_to) || die "pipe to openssl rsautl";
-
-binmode read_from;
 my $signature;
-read(read_from, $signature, 4096) || die "pipe from openssl rsautl";
-close(read_from) || die "pipe from openssl rsautl";
+if ($signature_file) {
+	$signature = read_file($signature_file);
+} else {
+	#
+	# Generate the digest and read from openssl's stdout
+	#
+	my $digest;
+	$digest = readpipe("openssl dgst -$dgst -binary $module") || die "openssl dgst";
+
+	#
+	# Generate the binary signature, which will be just the integer that
+	# comprises the signature with no metadata attached.
+	#
+	my $pid;
+	$pid = open2(*read_from, *write_to,
+		     "openssl rsautl -sign -inkey $private_key -keyform PEM") ||
+	    die "openssl rsautl";
+	binmode write_to;
+	print write_to $prologue . $digest || die "pipe to openssl rsautl";
+	close(write_to) || die "pipe to openssl rsautl";
+
+	binmode read_from;
+	read(read_from, $signature, 4096) || die "pipe from openssl rsautl";
+	close(read_from) || die "pipe from openssl rsautl";
+	waitpid($pid, 0) || die;
+	die "openssl rsautl died: $?" if ($? >> 8);
+}
 $signature = pack("n", length($signature)) . $signature,
 
-waitpid($pid, 0) || die;
-die "openssl rsautl died: $?" if ($? >> 8);
-
 #
 # Build the signed binary
 #
@@ -403,6 +416,6 @@ print FD
     ;
 close FD || die $dest;
 
-if ($#ARGV != 3) {
+if (!$keep_orig) {
     rename($dest, $module) || die $module;
 }
-- 
1.7.8.3

