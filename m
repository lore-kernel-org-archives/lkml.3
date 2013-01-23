Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab3AWPbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:31:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51996 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755597Ab3AWPbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:31:06 -0500
From: Michal Marek <mmarek@suse.cz>
To: dhowells@redhat.com, rusty@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] MODSIGN: Add -s <signature> option to sign-file
Date: Wed, 23 Jan 2013 16:30:43 +0100
Message-Id: <1358955044-27407-4-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358955044-27407-1-git-send-email-mmarek@suse.cz>
References: <1358955044-27407-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This option allows to append an externally computed singature to the
module. This is needed in setups, where the private key is not directly
available, but a service exists that returns signatures for given files.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/sign-file |   92 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 53 insertions(+), 39 deletions(-)

diff --git a/scripts/sign-file b/scripts/sign-file
index eefdec4..51e3b7b 100755
--- a/scripts/sign-file
+++ b/scripts/sign-file
@@ -2,31 +2,42 @@
 #
 # Sign a module file using the given key.
 #
-# Format:
-#
-#	./scripts/sign-file [-v] <key> <x509> <module> [<dest>]
-#
-#
+
+my $USAGE =
+"Usage: scripts/sign-file [-v] -a <hash algo> <key> <x509> <module> [<dest>]\n" .
+"       scripts/sign-file [-v] -a <hash algo> -s <raw sig> <x509> ...\n";
+
 use strict;
 use FileHandle;
 use IPC::Open2;
 use Getopt::Std;
 
-our ($opt_v, $opt_a);
+our ($opt_v, $opt_a, $opt_s);
 
-my $res = getopts('va:');
+getopts('va:s:') or die $USAGE;
 my $verbose = $opt_v;
 my $dgst = $opt_a;
+my $signature_file = $opt_s;
 
-die "Format: ./scripts/sign-file [-v] -a <hash algo> <key> <x509> <module> [<dest>]\n"
-    if (!$res || !$dgst || $#ARGV != 2 && $#ARGV != 3);
+die $USAGE if !$dgst || $#ARGV > 3;
+die $USAGE if !$signature_file && $#ARGV < 2 || $signature_file && $#ARGV < 1;
 
-my $private_key = $ARGV[0];
-my $x509 = $ARGV[1];
-my $module = $ARGV[2];
-my $dest = ($#ARGV == 3) ? $ARGV[3] : $ARGV[2] . "~";
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
+die "Can't read private key\n" if !$signature_file && !-r $private_key;
+die "Can't read signature file\n" if $signature_file && !-r $signature_file;
 die "Can't read X.509 certificate\n" unless (-r $x509);
 die "Can't read module\n" unless (-r $module);
 
@@ -340,33 +351,36 @@ if ($dgst eq "sha1") {
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
@@ -403,6 +417,6 @@ print FD
     ;
 close FD || die $dest;
 
-if ($#ARGV != 3) {
+if (!$keep_orig) {
     rename($dest, $module) || die $module;
 }
-- 
1.7.10.4

