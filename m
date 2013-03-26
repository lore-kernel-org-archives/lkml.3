Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab3CZW7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:59:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48918 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756378Ab3CZW7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:59:07 -0400
From: Michal Marek <mmarek@suse.cz>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] MODSIGN: Discard previous signature when signing modules
Date: Tue, 26 Mar 2013 23:58:21 +0100
Message-Id: <1364338701-24306-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The format only supports one signature, so discard any previous
signature before signing the module.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/sign-file |   62 ++++++++++++++++++++++++++++++++++++----------------
 1 files changed, 43 insertions(+), 19 deletions(-)

diff --git a/scripts/sign-file b/scripts/sign-file
index 2b7c448..b390dc3 100755
--- a/scripts/sign-file
+++ b/scripts/sign-file
@@ -60,6 +60,23 @@ sub read_file($)
     return $contents;
 }
 
+sub openssl_pipe($$) {
+	my ($input, $cmd) = @_;
+	my ($pid, $res);
+
+	$pid = open2(*read_from, *write_to, $cmd) || die $cmd;
+	binmode write_to;
+	print write_to $input || die "pipe to $cmd";
+	close(write_to) || die "pipe to $cmd";
+
+	binmode read_from;
+	read(read_from, $res, 4096) || die "pipe from $cmd";
+	close(read_from) || die "pipe from $cmd";
+	waitpid($pid, 0) || die;
+	die "$cmd died: $?" if ($? >> 8);
+	return $res;
+}
+
 ###############################################################################
 #
 # First of all, we have to parse the X.509 certificate to find certain details
@@ -350,6 +367,24 @@ if ($dgst eq "sha1") {
     die "Unknown hash algorithm: $dgst\n";
 }
 
+my $unsigned_module = read_file($module);
+
+my $magic_number = "~Module signature appended~\n";
+my $magic_len = length($magic_number);
+my $info_len = 12;
+
+# Truncate existing signarure, if any
+if (substr($unsigned_module, -$magic_len) eq $magic_number) {
+	my $info = substr($unsigned_module, -$magic_len - $info_len, $info_len);
+	my ($name_len, $key_len, $sig_len) = unpack("xxxCCxxxN", $info);
+	my $subtract = $name_len + $key_len + $sig_len + $info_len + $magic_len;
+	if ($subtract > length($unsigned_module)) {
+		die "$module: Existing signature is malformed\n";
+	}
+	$unsigned_module = substr($unsigned_module, 0,
+		length($unsigned_module) - $subtract);
+}
+
 my $signature;
 if ($signature_file) {
 	$signature = read_file($signature_file);
@@ -357,41 +392,30 @@ if ($signature_file) {
 	#
 	# Generate the digest and read from openssl's stdout
 	#
-	my $digest;
-	$digest = readpipe("openssl dgst -$dgst -binary $module") || die "openssl dgst";
+	my $digest = openssl_pipe($unsigned_module,
+		"openssl dgst -$dgst -binary");
 
 	#
 	# Generate the binary signature, which will be just the integer that
 	# comprises the signature with no metadata attached.
 	#
-	my $pid;
-	$pid = open2(*read_from, *write_to,
-		     "openssl rsautl -sign -inkey $private_key -keyform PEM") ||
-	    die "openssl rsautl";
-	binmode write_to;
-	print write_to $prologue . $digest || die "pipe to openssl rsautl";
-	close(write_to) || die "pipe to openssl rsautl";
-
-	binmode read_from;
-	read(read_from, $signature, 4096) || die "pipe from openssl rsautl";
-	close(read_from) || die "pipe from openssl rsautl";
-	waitpid($pid, 0) || die;
-	die "openssl rsautl died: $?" if ($? >> 8);
+	$signature = openssl_pipe($prologue . $digest,
+		     "openssl rsautl -sign -inkey $private_key -keyform PEM");
 }
 $signature = pack("n", length($signature)) . $signature,
 
 #
 # Build the signed binary
 #
-my $unsigned_module = read_file($module);
-
-my $magic_number = "~Module signature appended~\n";
-
 my $info = pack("CCCCCxxxN",
 		$algo, $hash, $id_type,
 		length($signers_name),
 		length($key_identifier),
 		length($signature));
+# Make sure that $info_len value used above matches reality
+if (length($info) != $info_len) {
+	die "Signature info size changed ($info_len -> @{[length($info)]}";
+}
 
 if ($verbose) {
     print "Size of unsigned module: ", length($unsigned_module), "\n";
-- 
1.7.3.1

