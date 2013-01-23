Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab3AWPbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:31:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51993 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755567Ab3AWPbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:31:05 -0500
From: Michal Marek <mmarek@suse.cz>
To: dhowells@redhat.com, rusty@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] MODSIGN: Specify the hash algorithm on sign-file command line
Date: Wed, 23 Jan 2013 16:30:42 +0100
Message-Id: <1358955044-27407-3-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358955044-27407-1-git-send-email-mmarek@suse.cz>
References: <1358955044-27407-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the script usable without a .config file.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 Makefile          |    2 +-
 scripts/sign-file |   53 ++++++++++++++++-------------------------------------
 2 files changed, 17 insertions(+), 38 deletions(-)

diff --git a/Makefile b/Makefile
index 51a9bda..860dc21 100644
--- a/Makefile
+++ b/Makefile
@@ -723,7 +723,7 @@ ifeq ($(CONFIG_MODULE_SIG),y)
 MODSECKEY = ./signing_key.priv
 MODPUBKEY = ./signing_key.x509
 export MODPUBKEY
-mod_sign_cmd = perl $(srctree)/scripts/sign-file $(MODSECKEY) $(MODPUBKEY)
+mod_sign_cmd = perl $(srctree)/scripts/sign-file -a $(CONFIG_MODULE_SIG_HASH) $(MODSECKEY) $(MODPUBKEY)
 else
 mod_sign_cmd = true
 endif
diff --git a/scripts/sign-file b/scripts/sign-file
index 974a20b..eefdec4 100755
--- a/scripts/sign-file
+++ b/scripts/sign-file
@@ -10,15 +10,16 @@
 use strict;
 use FileHandle;
 use IPC::Open2;
+use Getopt::Std;
 
-my $verbose = 0;
-if ($#ARGV >= 0 && $ARGV[0] eq "-v") {
-    $verbose = 1;
-    shift;
-}
+our ($opt_v, $opt_a);
+
+my $res = getopts('va:');
+my $verbose = $opt_v;
+my $dgst = $opt_a;
 
-die "Format: ./scripts/sign-file [-v] <key> <x509> <module> [<dest>]\n"
-    if ($#ARGV != 2 && $#ARGV != 3);
+die "Format: ./scripts/sign-file [-v] -a <hash algo> <key> <x509> <module> [<dest>]\n"
+    if (!$res || !$dgst || $#ARGV != 2 && $#ARGV != 3);
 
 my $private_key = $ARGV[0];
 my $x509 = $ARGV[1];
@@ -30,23 +31,6 @@ die "Can't read X.509 certificate\n" unless (-r $x509);
 die "Can't read module\n" unless (-r $module);
 
 #
-# Read the kernel configuration
-#
-my %config = (
-    CONFIG_MODULE_SIG_SHA512 => 1
-    );
-
-if (-r ".config") {
-    open(FD, "<.config") || die ".config";
-    while (<FD>) {
-	if ($_ =~ /^(CONFIG_.*)=[ym]/) {
-	    $config{$1} = 1;
-	}
-    }
-    close(FD);
-}
-
-#
 # Function to read the contents of a file into a variable.
 #
 sub read_file($)
@@ -321,51 +305,46 @@ my $id_type = 1;	# Identifier type: X.509
 #
 # Digest the data
 #
-my ($dgst, $prologue) = ();
-if (exists $config{"CONFIG_MODULE_SIG_SHA1"}) {
+my $prologue;
+if ($dgst eq "sha1") {
     $prologue = pack("C*",
 		     0x30, 0x21, 0x30, 0x09, 0x06, 0x05,
 		     0x2B, 0x0E, 0x03, 0x02, 0x1A,
 		     0x05, 0x00, 0x04, 0x14);
-    $dgst = "-sha1";
     $hash = 2;
-} elsif (exists $config{"CONFIG_MODULE_SIG_SHA224"}) {
+} elsif ($dgst eq "sha224") {
     $prologue = pack("C*",
 		     0x30, 0x2d, 0x30, 0x0d, 0x06, 0x09,
 		     0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x04,
 		     0x05, 0x00, 0x04, 0x1C);
-    $dgst = "-sha224";
     $hash = 7;
-} elsif (exists $config{"CONFIG_MODULE_SIG_SHA256"}) {
+} elsif ($dgst eq "sha256") {
     $prologue = pack("C*",
 		     0x30, 0x31, 0x30, 0x0d, 0x06, 0x09,
 		     0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x01,
 		     0x05, 0x00, 0x04, 0x20);
-    $dgst = "-sha256";
     $hash = 4;
-} elsif (exists $config{"CONFIG_MODULE_SIG_SHA384"}) {
+} elsif ($dgst eq "sha384") {
     $prologue = pack("C*",
 		     0x30, 0x41, 0x30, 0x0d, 0x06, 0x09,
 		     0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x02,
 		     0x05, 0x00, 0x04, 0x30);
-    $dgst = "-sha384";
     $hash = 5;
-} elsif (exists $config{"CONFIG_MODULE_SIG_SHA512"}) {
+} elsif ($dgst eq "sha512") {
     $prologue = pack("C*",
 		     0x30, 0x51, 0x30, 0x0d, 0x06, 0x09,
 		     0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x03,
 		     0x05, 0x00, 0x04, 0x40);
-    $dgst = "-sha512";
     $hash = 6;
 } else {
-    die "Can't determine hash algorithm";
+    die "Unknown hash algorithm: $dgst\n";
 }
 
 #
 # Generate the digest and read from openssl's stdout
 #
 my $digest;
-$digest = readpipe("openssl dgst $dgst -binary $module") || die "openssl dgst";
+$digest = readpipe("openssl dgst -$dgst -binary $module") || die "openssl dgst";
 
 #
 # Generate the binary signature, which will be just the integer that comprises
-- 
1.7.10.4

