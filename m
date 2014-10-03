Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbaJCOaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 10:30:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811AbaJCOar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 10:30:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 3/3] MODSIGN: Use PKCS#7 messages as module signatures
From: David Howells <dhowells@redhat.com>
To: rusty@rustcorp.com.au
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Date: Fri, 03 Oct 2014 15:30:40 +0100
Message-ID: <20141003143040.26457.41550.stgit@warthog.procyon.org.uk>
In-Reply-To: <20141003143012.26457.54004.stgit@warthog.procyon.org.uk>
References: <20141003143012.26457.54004.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move to using PKCS#7 messages as module signatures because:

 (1) We have to be able to support the use of X.509 certificates that don't
     have a subjKeyId set.  We're currently relying on this to look up the
     X.509 certificate in the trusted keyring list.

 (2) PKCS#7 message signed information blocks have a field that supplies the
     data required to match with the X.509 certificate that signed it.

 (3) The PKCS#7 certificate carries fields that specify the digest algorithm
     used to generate the signature in a standardised way and the X.509
     certificates specify the public key algorithm in a standardised way - so
     we don't need our own methods of specifying these.

 (4) We now have PKCS#7 message support in the kernel for signed kexec purposes
     and we can make use of this.

To make this work, the old sign-file script has been replaced with a program
that needs compiling in a previous patch.  The rules to build it are added
here.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 init/Kconfig            |    1 
 kernel/module_signing.c |  220 +++++--------------------
 scripts/Makefile        |    2 
 scripts/sign-file       |  421 -----------------------------------------------
 4 files changed, 47 insertions(+), 597 deletions(-)
 delete mode 100755 scripts/sign-file

diff --git a/init/Kconfig b/init/Kconfig
index 9d76b99af1b9..8bd1dd8c402d 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1794,6 +1794,7 @@ config MODULE_SIG
 	select ASN1
 	select OID_REGISTRY
 	select X509_CERTIFICATE_PARSER
+	select PKCS7_MESSAGE_PARSER
 	help
 	  Check modules for valid signatures upon load: the signature
 	  is simply appended to the module. For more information see
diff --git a/kernel/module_signing.c b/kernel/module_signing.c
index be5b8fac4bd0..8eb20cc66b39 100644
--- a/kernel/module_signing.c
+++ b/kernel/module_signing.c
@@ -11,10 +11,9 @@
 
 #include <linux/kernel.h>
 #include <linux/err.h>
-#include <crypto/public_key.h>
-#include <crypto/hash.h>
-#include <keys/asymmetric-type.h>
 #include <keys/system_keyring.h>
+#include <crypto/public_key.h>
+#include <crypto/pkcs7.h>
 #include "module-internal.h"
 
 /*
@@ -28,157 +27,53 @@
  *	- Information block
  */
 struct module_signature {
-	u8	algo;		/* Public-key crypto algorithm [enum pkey_algo] */
-	u8	hash;		/* Digest algorithm [enum hash_algo] */
-	u8	id_type;	/* Key identifier type [enum pkey_id_type] */
-	u8	signer_len;	/* Length of signer's name */
-	u8	key_id_len;	/* Length of key identifier */
+	u8	algo;		/* Public-key crypto algorithm [0] */
+	u8	hash;		/* Digest algorithm [0] */
+	u8	id_type;	/* Key identifier type [PKEY_ID_PKCS7] */
+	u8	signer_len;	/* Length of signer's name [0] */
+	u8	key_id_len;	/* Length of key identifier [0] */
 	u8	__pad[3];
 	__be32	sig_len;	/* Length of signature data */
 };
 
 /*
- * Digest the module contents.
+ * Verify a PKCS#7-based signature on a module.
  */
-static struct public_key_signature *mod_make_digest(enum hash_algo hash,
-						    const void *mod,
-						    unsigned long modlen)
+static int mod_verify_pkcs7(const void *mod, unsigned long modlen,
+			    const void *raw_pkcs7, size_t pkcs7_len)
 {
-	struct public_key_signature *pks;
-	struct crypto_shash *tfm;
-	struct shash_desc *desc;
-	size_t digest_size, desc_size;
+	struct pkcs7_message *pkcs7;
+	bool trusted;
 	int ret;
 
-	pr_devel("==>%s()\n", __func__);
-	
-	/* Allocate the hashing algorithm we're going to need and find out how
-	 * big the hash operational data will be.
-	 */
-	tfm = crypto_alloc_shash(hash_algo_name[hash], 0, 0);
-	if (IS_ERR(tfm))
-		return (PTR_ERR(tfm) == -ENOENT) ? ERR_PTR(-ENOPKG) : ERR_CAST(tfm);
-
-	desc_size = crypto_shash_descsize(tfm) + sizeof(*desc);
-	digest_size = crypto_shash_digestsize(tfm);
-
-	/* We allocate the hash operational data storage on the end of our
-	 * context data and the digest output buffer on the end of that.
-	 */
-	ret = -ENOMEM;
-	pks = kzalloc(digest_size + sizeof(*pks) + desc_size, GFP_KERNEL);
-	if (!pks)
-		goto error_no_pks;
-
-	pks->pkey_hash_algo	= hash;
-	pks->digest		= (u8 *)pks + sizeof(*pks) + desc_size;
-	pks->digest_size	= digest_size;
-
-	desc = (void *)pks + sizeof(*pks);
-	desc->tfm   = tfm;
-	desc->flags = CRYPTO_TFM_REQ_MAY_SLEEP;
-
-	ret = crypto_shash_init(desc);
+	pkcs7 = pkcs7_parse_message(raw_pkcs7, pkcs7_len);
+	if (IS_ERR(pkcs7))
+		return PTR_ERR(pkcs7);
+
+	/* The data should be detached - so we need to supply it. */
+	if (pkcs7_supply_detached_data(pkcs7, mod, modlen) < 0) {
+		pr_err("PKCS#7 signature with non-detached data\n");
+		ret = -EBADMSG;
+		goto error;
+	}
+
+	ret = pkcs7_verify(pkcs7);
 	if (ret < 0)
 		goto error;
 
-	ret = crypto_shash_finup(desc, mod, modlen, pks->digest);
+	ret = pkcs7_validate_trust(pkcs7, system_trusted_keyring, &trusted);
 	if (ret < 0)
 		goto error;
 
-	crypto_free_shash(tfm);
-	pr_devel("<==%s() = ok\n", __func__);
-	return pks;
+	if (!trusted) {
+		pr_err("PKCS#7 signature not signed with a trusted key\n");
+		ret = -ENOKEY;
+	}
 
 error:
-	kfree(pks);
-error_no_pks:
-	crypto_free_shash(tfm);
+	pkcs7_free_message(pkcs7);
 	pr_devel("<==%s() = %d\n", __func__, ret);
-	return ERR_PTR(ret);
-}
-
-/*
- * Extract an MPI array from the signature data.  This represents the actual
- * signature.  Each raw MPI is prefaced by a BE 2-byte value indicating the
- * size of the MPI in bytes.
- *
- * RSA signatures only have one MPI, so currently we only read one.
- */
-static int mod_extract_mpi_array(struct public_key_signature *pks,
-				 const void *data, size_t len)
-{
-	size_t nbytes;
-	MPI mpi;
-
-	if (len < 3)
-		return -EBADMSG;
-	nbytes = ((const u8 *)data)[0] << 8 | ((const u8 *)data)[1];
-	data += 2;
-	len -= 2;
-	if (len != nbytes)
-		return -EBADMSG;
-
-	mpi = mpi_read_raw_data(data, nbytes);
-	if (!mpi)
-		return -ENOMEM;
-	pks->mpi[0] = mpi;
-	pks->nr_mpi = 1;
-	return 0;
-}
-
-/*
- * Request an asymmetric key.
- */
-static struct key *request_asymmetric_key(const char *signer, size_t signer_len,
-					  const u8 *key_id, size_t key_id_len)
-{
-	key_ref_t key;
-	size_t i;
-	char *id, *q;
-
-	pr_devel("==>%s(,%zu,,%zu)\n", __func__, signer_len, key_id_len);
-
-	/* Construct an identifier. */
-	id = kmalloc(signer_len + 2 + key_id_len * 2 + 1, GFP_KERNEL);
-	if (!id)
-		return ERR_PTR(-ENOKEY);
-
-	memcpy(id, signer, signer_len);
-
-	q = id + signer_len;
-	*q++ = ':';
-	*q++ = ' ';
-	for (i = 0; i < key_id_len; i++) {
-		*q++ = hex_asc[*key_id >> 4];
-		*q++ = hex_asc[*key_id++ & 0x0f];
-	}
-
-	*q = 0;
-
-	pr_debug("Look up: \"%s\"\n", id);
-
-	key = keyring_search(make_key_ref(system_trusted_keyring, 1),
-			     &key_type_asymmetric, id);
-	if (IS_ERR(key))
-		pr_warn("Request for unknown module key '%s' err %ld\n",
-			id, PTR_ERR(key));
-	kfree(id);
-
-	if (IS_ERR(key)) {
-		switch (PTR_ERR(key)) {
-			/* Hide some search errors */
-		case -EACCES:
-		case -ENOTDIR:
-		case -EAGAIN:
-			return ERR_PTR(-ENOKEY);
-		default:
-			return ERR_CAST(key);
-		}
-	}
-
-	pr_devel("<==%s() = 0 [%x]\n", __func__, key_serial(key_ref_to_ptr(key)));
-	return key_ref_to_ptr(key);
+	return ret;
 }
 
 /*
@@ -186,12 +81,8 @@ static struct key *request_asymmetric_key(const char *signer, size_t signer_len,
  */
 int mod_verify_sig(const void *mod, unsigned long *_modlen)
 {
-	struct public_key_signature *pks;
 	struct module_signature ms;
-	struct key *key;
-	const void *sig;
 	size_t modlen = *_modlen, sig_len;
-	int ret;
 
 	pr_devel("==>%s(,%zu)\n", __func__, modlen);
 
@@ -205,46 +96,23 @@ int mod_verify_sig(const void *mod, unsigned long *_modlen)
 	if (sig_len >= modlen)
 		return -EBADMSG;
 	modlen -= sig_len;
-	if ((size_t)ms.signer_len + ms.key_id_len >= modlen)
-		return -EBADMSG;
-	modlen -= (size_t)ms.signer_len + ms.key_id_len;
-
 	*_modlen = modlen;
-	sig = mod + modlen;
-
-	/* For the moment, only support RSA and X.509 identifiers */
-	if (ms.algo != PKEY_ALGO_RSA ||
-	    ms.id_type != PKEY_ID_X509)
-		return -ENOPKG;
 
-	if (ms.hash >= PKEY_HASH__LAST ||
-	    !hash_algo_name[ms.hash])
+	if (ms.id_type != PKEY_ID_PKCS7) {
+		pr_err("Module is not signed with expected PKCS#7 message\n");
 		return -ENOPKG;
-
-	key = request_asymmetric_key(sig, ms.signer_len,
-				     sig + ms.signer_len, ms.key_id_len);
-	if (IS_ERR(key))
-		return PTR_ERR(key);
-
-	pks = mod_make_digest(ms.hash, mod, modlen);
-	if (IS_ERR(pks)) {
-		ret = PTR_ERR(pks);
-		goto error_put_key;
 	}
 
-	ret = mod_extract_mpi_array(pks, sig + ms.signer_len + ms.key_id_len,
-				    sig_len);
-	if (ret < 0)
-		goto error_free_pks;
-
-	ret = verify_signature(key, pks);
-	pr_devel("verify_signature() = %d\n", ret);
+	if (ms.algo != 0 ||
+	    ms.hash != 0 ||
+	    ms.signer_len != 0 ||
+	    ms.key_id_len != 0 ||
+	    ms.__pad[0] != 0 ||
+	    ms.__pad[1] != 0 ||
+	    ms.__pad[2] != 0) {
+		pr_err("PKCS#7 signature info has unexpected non-zero params\n");
+		return -EBADMSG;
+	}
 
-error_free_pks:
-	mpi_free(pks->rsa.s);
-	kfree(pks);
-error_put_key:
-	key_put(key);
-	pr_devel("<==%s() = %d\n", __func__, ret);
-	return ret;	
+	return mod_verify_pkcs7(mod, modlen, mod + modlen, sig_len);
 }
diff --git a/scripts/Makefile b/scripts/Makefile
index 890df5c6adfb..c5479a4535a9 100644
--- a/scripts/Makefile
+++ b/scripts/Makefile
@@ -17,9 +17,11 @@ hostprogs-$(CONFIG_IKCONFIG)     += bin2c
 hostprogs-$(BUILD_C_RECORDMCOUNT) += recordmcount
 hostprogs-$(CONFIG_BUILDTIME_EXTABLE_SORT) += sortextable
 hostprogs-$(CONFIG_ASN1)	 += asn1_compiler
+hostprogs-$(CONFIG_MODULE_SIG)	 += sign-file
 
 HOSTCFLAGS_sortextable.o = -I$(srctree)/tools/include
 HOSTCFLAGS_asn1_compiler.o = -I$(srctree)/include
+HOSTCFLAGS_sign-file.o = -lcrypto
 
 always		:= $(hostprogs-y) $(hostprogs-m)
 
diff --git a/scripts/sign-file b/scripts/sign-file
deleted file mode 100755
index 2b7c4484d46c..000000000000
--- a/scripts/sign-file
+++ /dev/null
@@ -1,421 +0,0 @@
-#!/usr/bin/perl -w
-#
-# Sign a module file using the given key.
-#
-
-my $USAGE =
-"Usage: scripts/sign-file [-v] <hash algo> <key> <x509> <module> [<dest>]\n" .
-"       scripts/sign-file [-v] -s <raw sig> <hash algo> <x509> <module> [<dest>]\n";
-
-use strict;
-use FileHandle;
-use IPC::Open2;
-use Getopt::Std;
-
-my %opts;
-getopts('vs:', \%opts) or die $USAGE;
-my $verbose = $opts{'v'};
-my $signature_file = $opts{'s'};
-
-die $USAGE if ($#ARGV > 4);
-die $USAGE if (!$signature_file && $#ARGV < 3 || $signature_file && $#ARGV < 2);
-
-my $dgst = shift @ARGV;
-my $private_key;
-if (!$signature_file) {
-	$private_key = shift @ARGV;
-}
-my $x509 = shift @ARGV;
-my $module = shift @ARGV;
-my ($dest, $keep_orig);
-if (@ARGV) {
-	$dest = $ARGV[0];
-	$keep_orig = 1;
-} else {
-	$dest = $module . "~";
-}
-
-die "Can't read private key\n" if (!$signature_file && !-r $private_key);
-die "Can't read signature file\n" if ($signature_file && !-r $signature_file);
-die "Can't read X.509 certificate\n" unless (-r $x509);
-die "Can't read module\n" unless (-r $module);
-
-#
-# Function to read the contents of a file into a variable.
-#
-sub read_file($)
-{
-    my ($file) = @_;
-    my $contents;
-    my $len;
-
-    open(FD, "<$file") || die $file;
-    binmode FD;
-    my @st = stat(FD);
-    die $file if (!@st);
-    $len = read(FD, $contents, $st[7]) || die $file;
-    close(FD) || die $file;
-    die "$file: Wanted length ", $st[7], ", got ", $len, "\n"
-	if ($len != $st[7]);
-    return $contents;
-}
-
-###############################################################################
-#
-# First of all, we have to parse the X.509 certificate to find certain details
-# about it.
-#
-# We read the DER-encoded X509 certificate and parse it to extract the Subject
-# name and Subject Key Identifier.  Theis provides the data we need to build
-# the certificate identifier.
-#
-# The signer's name part of the identifier is fabricated from the commonName,
-# the organizationName or the emailAddress components of the X.509 subject
-# name.
-#
-# The subject key ID is used to select which of that signer's certificates
-# we're intending to use to sign the module.
-#
-###############################################################################
-my $x509_certificate = read_file($x509);
-
-my $UNIV = 0 << 6;
-my $APPL = 1 << 6;
-my $CONT = 2 << 6;
-my $PRIV = 3 << 6;
-
-my $CONS = 0x20;
-
-my $BOOLEAN	= 0x01;
-my $INTEGER	= 0x02;
-my $BIT_STRING	= 0x03;
-my $OCTET_STRING = 0x04;
-my $NULL	= 0x05;
-my $OBJ_ID	= 0x06;
-my $UTF8String	= 0x0c;
-my $SEQUENCE	= 0x10;
-my $SET		= 0x11;
-my $UTCTime	= 0x17;
-my $GeneralizedTime = 0x18;
-
-my %OIDs = (
-    pack("CCC", 85, 4, 3)	=> "commonName",
-    pack("CCC", 85, 4, 6)	=> "countryName",
-    pack("CCC", 85, 4, 10)	=> "organizationName",
-    pack("CCC", 85, 4, 11)	=> "organizationUnitName",
-    pack("CCCCCCCCC", 42, 134, 72, 134, 247, 13, 1, 1, 1) => "rsaEncryption",
-    pack("CCCCCCCCC", 42, 134, 72, 134, 247, 13, 1, 1, 5) => "sha1WithRSAEncryption",
-    pack("CCCCCCCCC", 42, 134, 72, 134, 247, 13, 1, 9, 1) => "emailAddress",
-    pack("CCC", 85, 29, 35)	=> "authorityKeyIdentifier",
-    pack("CCC", 85, 29, 14)	=> "subjectKeyIdentifier",
-    pack("CCC", 85, 29, 19)	=> "basicConstraints"
-);
-
-###############################################################################
-#
-# Extract an ASN.1 element from a string and return information about it.
-#
-###############################################################################
-sub asn1_extract($$@)
-{
-    my ($cursor, $expected_tag, $optional) = @_;
-
-    return [ -1 ]
-	if ($cursor->[1] == 0 && $optional);
-
-    die $x509, ": ", $cursor->[0], ": ASN.1 data underrun (elem ", $cursor->[1], ")\n"
-	if ($cursor->[1] < 2);
-
-    my ($tag, $len) = unpack("CC", substr(${$cursor->[2]}, $cursor->[0], 2));
-
-    if ($expected_tag != -1 && $tag != $expected_tag) {
-	return [ -1 ]
-	    if ($optional);
-	die $x509, ": ", $cursor->[0], ": ASN.1 unexpected tag (", $tag,
-	" not ", $expected_tag, ")\n";
-    }
-
-    $cursor->[0] += 2;
-    $cursor->[1] -= 2;
-
-    die $x509, ": ", $cursor->[0], ": ASN.1 long tag\n"
-	if (($tag & 0x1f) == 0x1f);
-    die $x509, ": ", $cursor->[0], ": ASN.1 indefinite length\n"
-	if ($len == 0x80);
-
-    if ($len > 0x80) {
-	my $l = $len - 0x80;
-	die $x509, ": ", $cursor->[0], ": ASN.1 data underrun (len len $l)\n"
-	    if ($cursor->[1] < $l);
-
-	if ($l == 0x1) {
-	    $len = unpack("C", substr(${$cursor->[2]}, $cursor->[0], 1));
-	} elsif ($l == 0x2) {
-	    $len = unpack("n", substr(${$cursor->[2]}, $cursor->[0], 2));
-	} elsif ($l == 0x3) {
-	    $len = unpack("C", substr(${$cursor->[2]}, $cursor->[0], 1)) << 16;
-	    $len = unpack("n", substr(${$cursor->[2]}, $cursor->[0] + 1, 2));
-	} elsif ($l == 0x4) {
-	    $len = unpack("N", substr(${$cursor->[2]}, $cursor->[0], 4));
-	} else {
-	    die $x509, ": ", $cursor->[0], ": ASN.1 element too long (", $l, ")\n";
-	}
-
-	$cursor->[0] += $l;
-	$cursor->[1] -= $l;
-    }
-
-    die $x509, ": ", $cursor->[0], ": ASN.1 data underrun (", $len, ")\n"
-	if ($cursor->[1] < $len);
-
-    my $ret = [ $tag, [ $cursor->[0], $len, $cursor->[2] ] ];
-    $cursor->[0] += $len;
-    $cursor->[1] -= $len;
-
-    return $ret;
-}
-
-###############################################################################
-#
-# Retrieve the data referred to by a cursor
-#
-###############################################################################
-sub asn1_retrieve($)
-{
-    my ($cursor) = @_;
-    my ($offset, $len, $data) = @$cursor;
-    return substr($$data, $offset, $len);
-}
-
-###############################################################################
-#
-# Roughly parse the X.509 certificate
-#
-###############################################################################
-my $cursor = [ 0, length($x509_certificate), \$x509_certificate ];
-
-my $cert = asn1_extract($cursor, $UNIV | $CONS | $SEQUENCE);
-my $tbs = asn1_extract($cert->[1], $UNIV | $CONS | $SEQUENCE);
-my $version = asn1_extract($tbs->[1], $CONT | $CONS | 0, 1);
-my $serial_number = asn1_extract($tbs->[1], $UNIV | $INTEGER);
-my $sig_type = asn1_extract($tbs->[1], $UNIV | $CONS | $SEQUENCE);
-my $issuer = asn1_extract($tbs->[1], $UNIV | $CONS | $SEQUENCE);
-my $validity = asn1_extract($tbs->[1], $UNIV | $CONS | $SEQUENCE);
-my $subject = asn1_extract($tbs->[1], $UNIV | $CONS | $SEQUENCE);
-my $key = asn1_extract($tbs->[1], $UNIV | $CONS | $SEQUENCE);
-my $issuer_uid = asn1_extract($tbs->[1], $CONT | $CONS | 1, 1);
-my $subject_uid = asn1_extract($tbs->[1], $CONT | $CONS | 2, 1);
-my $extension_list = asn1_extract($tbs->[1], $CONT | $CONS | 3, 1);
-
-my $subject_key_id = ();
-my $authority_key_id = ();
-
-#
-# Parse the extension list
-#
-if ($extension_list->[0] != -1) {
-    my $extensions = asn1_extract($extension_list->[1], $UNIV | $CONS | $SEQUENCE);
-
-    while ($extensions->[1]->[1] > 0) {
-	my $ext = asn1_extract($extensions->[1], $UNIV | $CONS | $SEQUENCE);
-	my $x_oid = asn1_extract($ext->[1], $UNIV | $OBJ_ID);
-	my $x_crit = asn1_extract($ext->[1], $UNIV | $BOOLEAN, 1);
-	my $x_val = asn1_extract($ext->[1], $UNIV | $OCTET_STRING);
-
-	my $raw_oid = asn1_retrieve($x_oid->[1]);
-	next if (!exists($OIDs{$raw_oid}));
-	my $x_type = $OIDs{$raw_oid};
-
-	my $raw_value = asn1_retrieve($x_val->[1]);
-
-	if ($x_type eq "subjectKeyIdentifier") {
-	    my $vcursor = [ 0, length($raw_value), \$raw_value ];
-
-	    $subject_key_id = asn1_extract($vcursor, $UNIV | $OCTET_STRING);
-	}
-    }
-}
-
-###############################################################################
-#
-# Determine what we're going to use as the signer's name.  In order of
-# preference, take one of: commonName, organizationName or emailAddress.
-#
-###############################################################################
-my $org = "";
-my $cn = "";
-my $email = "";
-
-while ($subject->[1]->[1] > 0) {
-    my $rdn = asn1_extract($subject->[1], $UNIV | $CONS | $SET);
-    my $attr = asn1_extract($rdn->[1], $UNIV | $CONS | $SEQUENCE);
-    my $n_oid = asn1_extract($attr->[1], $UNIV | $OBJ_ID);
-    my $n_val = asn1_extract($attr->[1], -1);
-
-    my $raw_oid = asn1_retrieve($n_oid->[1]);
-    next if (!exists($OIDs{$raw_oid}));
-    my $n_type = $OIDs{$raw_oid};
-
-    my $raw_value = asn1_retrieve($n_val->[1]);
-
-    if ($n_type eq "organizationName") {
-	$org = $raw_value;
-    } elsif ($n_type eq "commonName") {
-	$cn = $raw_value;
-    } elsif ($n_type eq "emailAddress") {
-	$email = $raw_value;
-    }
-}
-
-my $signers_name = $email;
-
-if ($org && $cn) {
-    # Don't use the organizationName if the commonName repeats it
-    if (length($org) <= length($cn) &&
-	substr($cn, 0, length($org)) eq $org) {
-	$signers_name = $cn;
-	goto got_id_name;
-    }
-
-    # Or a signifcant chunk of it
-    if (length($org) >= 7 &&
-	length($cn) >= 7 &&
-	substr($cn, 0, 7) eq substr($org, 0, 7)) {
-	$signers_name = $cn;
-	goto got_id_name;
-    }
-
-    $signers_name = $org . ": " . $cn;
-} elsif ($org) {
-    $signers_name = $org;
-} elsif ($cn) {
-    $signers_name = $cn;
-}
-
-got_id_name:
-
-die $x509, ": ", "X.509: Couldn't find the Subject Key Identifier extension\n"
-    if (!$subject_key_id);
-
-my $key_identifier = asn1_retrieve($subject_key_id->[1]);
-
-###############################################################################
-#
-# Create and attach the module signature
-#
-###############################################################################
-
-#
-# Signature parameters
-#
-my $algo = 1;		# Public-key crypto algorithm: RSA
-my $hash = 0;		# Digest algorithm
-my $id_type = 1;	# Identifier type: X.509
-
-#
-# Digest the data
-#
-my $prologue;
-if ($dgst eq "sha1") {
-    $prologue = pack("C*",
-		     0x30, 0x21, 0x30, 0x09, 0x06, 0x05,
-		     0x2B, 0x0E, 0x03, 0x02, 0x1A,
-		     0x05, 0x00, 0x04, 0x14);
-    $hash = 2;
-} elsif ($dgst eq "sha224") {
-    $prologue = pack("C*",
-		     0x30, 0x2d, 0x30, 0x0d, 0x06, 0x09,
-		     0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x04,
-		     0x05, 0x00, 0x04, 0x1C);
-    $hash = 7;
-} elsif ($dgst eq "sha256") {
-    $prologue = pack("C*",
-		     0x30, 0x31, 0x30, 0x0d, 0x06, 0x09,
-		     0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x01,
-		     0x05, 0x00, 0x04, 0x20);
-    $hash = 4;
-} elsif ($dgst eq "sha384") {
-    $prologue = pack("C*",
-		     0x30, 0x41, 0x30, 0x0d, 0x06, 0x09,
-		     0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x02,
-		     0x05, 0x00, 0x04, 0x30);
-    $hash = 5;
-} elsif ($dgst eq "sha512") {
-    $prologue = pack("C*",
-		     0x30, 0x51, 0x30, 0x0d, 0x06, 0x09,
-		     0x60, 0x86, 0x48, 0x01, 0x65, 0x03, 0x04, 0x02, 0x03,
-		     0x05, 0x00, 0x04, 0x40);
-    $hash = 6;
-} else {
-    die "Unknown hash algorithm: $dgst\n";
-}
-
-my $signature;
-if ($signature_file) {
-	$signature = read_file($signature_file);
-} else {
-	#
-	# Generate the digest and read from openssl's stdout
-	#
-	my $digest;
-	$digest = readpipe("openssl dgst -$dgst -binary $module") || die "openssl dgst";
-
-	#
-	# Generate the binary signature, which will be just the integer that
-	# comprises the signature with no metadata attached.
-	#
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
-}
-$signature = pack("n", length($signature)) . $signature,
-
-#
-# Build the signed binary
-#
-my $unsigned_module = read_file($module);
-
-my $magic_number = "~Module signature appended~\n";
-
-my $info = pack("CCCCCxxxN",
-		$algo, $hash, $id_type,
-		length($signers_name),
-		length($key_identifier),
-		length($signature));
-
-if ($verbose) {
-    print "Size of unsigned module: ", length($unsigned_module), "\n";
-    print "Size of signer's name  : ", length($signers_name), "\n";
-    print "Size of key identifier : ", length($key_identifier), "\n";
-    print "Size of signature      : ", length($signature), "\n";
-    print "Size of informaton     : ", length($info), "\n";
-    print "Size of magic number   : ", length($magic_number), "\n";
-    print "Signer's name          : '", $signers_name, "'\n";
-    print "Digest                 : $dgst\n";
-}
-
-open(FD, ">$dest") || die $dest;
-binmode FD;
-print FD
-    $unsigned_module,
-    $signers_name,
-    $key_identifier,
-    $signature,
-    $info,
-    $magic_number
-    ;
-close FD || die $dest;
-
-if (!$keep_orig) {
-    rename($dest, $module) || die $module;
-}

