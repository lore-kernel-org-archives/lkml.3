Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945997Ab3AXVVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:21:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945947Ab3AXVUq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:20:46 -0500
From: Michal Marek <mmarek@suse.cz>
To: dhowells@redhat.com, rusty@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] MODSIGN: Specify the hash algorithm on sign-file command line
Date: Thu, 24 Jan 2013 22:20:27 +0100
Message-Id: <1359062429-27295-2-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1359062429-27295-1-git-send-email-mmarek@suse.cz>
References: <1359062429-27295-1-git-send-email-mmarek@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make the script usable without a .config file.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
v2: Add the hash algorithm as the first positional argument

---
 Makefile          |    2 +-
 scripts/sign-file |   53 ++++++++++++++++-------------------------------------
 2 files changed, 17 insertions(+), 38 deletions(-)

diff --git a/Makefile b/Makefile
index 51a9bda..0e7e736 100644
--- a/Makefile
+++ b/Makefile
@@ -723,7 +723,7 @@ ifeq ($(CONFIG_MODULE_SIG),y)
 MODSECKEY = ./signing_key.priv
 MODPUBKEY = ./signing_key.x509
 export MODPUBKEY
-mod_sign_cmd = perl $(srctree)/scripts/sign-file $(MODSECKEY) $(MODPUBKEY)
+mod_sign_cmd = perl $(srctree)/scripts/sign-file $(CONFIG_MODULE_SIG_HASH) $(MODSECKEY) $(MODPUBKEY)
 else
 mod_sign_cmd = true
 endif
diff --git a/scripts/sign-file b/scripts/sign-file
index 974a20b..2c2bbd1 100755
--- a/scripts/sign-file
+++ b/scripts/sign-file
@@ -4,7 +4,7 @@
 #
 # Format:
 #
-#	./scripts/sign-file [-v] <key> <x509> <module> [<dest>]
+#	./scripts/sign-file [-v] <hash algo> <key> <x509> <module> [<dest>]
 #
 #
 use strict;
@@ -17,36 +17,20 @@ if ($#ARGV >= 0 && $ARGV[0] eq "-v") {
     shift;
 }
 
-die "Format: ./scripts/sign-file [-v] <key> <x509> <module> [<dest>]\n"
-    if ($#ARGV != 2 && $#ARGV != 3);
+die "Format: ./scripts/sign-file [-v] <hash algo> <key> <x509> <module> [<dest>]\n"
+    if ($#ARGV != 3 && $#ARGV != 4);
 
-my $private_key = $ARGV[0];
-my $x509 = $ARGV[1];
-my $module = $ARGV[2];
-my $dest = ($#ARGV == 3) ? $ARGV[3] : $ARGV[2] . "~";
+my $dgst = $ARGV[0];
+my $private_key = $ARGV[1];
+my $x509 = $ARGV[2];
+my $module = $ARGV[3];
+my $dest = ($#ARGV == 4) ? $ARGV[4] : $ARGV[3] . "~";
 
 die "Can't read private key\n" unless (-r $private_key);
 die "Can't read X.509 certificate\n" unless (-r $x509);
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
1.7.8.3

