Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab3CNS2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 14:28:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104Ab3CNS2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 14:28:49 -0400
Date: Thu, 14 Mar 2013 14:28:15 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org
Subject: [RFC PATCH] integrity: Use a new type for asymmetric signature
Message-ID: <20130314182815.GB24238@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry/Mimi,

Here is an RFC patch. I am playing with exporting some functions from
ima/integrity and make reuse of IMA signature format and reuse of some
of IMA verification code.

One of the things required is that caller wants trusts only certain
type of signatures. For example, it might not trust DIGEST or HMAC
but might trust only digital signatures. So caller needs to know what
kind of signature are stored in IMA security attribute (if any) and
decide what to do.

Currently there seem to be two types of digital signatures. Old one and
that is RSA and new one which is being called asymmetric. Right now they
both fall in the categorty of EVM_IMA_XATTR_DIGSIG and one differentiates
between two using signature version. Version 1 is old type and version 2
is new type.

How about asymmetric signature using a new type say
EVM_IMA_XATTR_DIGSIG_ASYMMETRIC. And version numbering can be used for
structure variation with-in signature type.

This can allow caller to differentiate between two kinds of digital
signatures as understood by IMA.  And calling subsystems will call into
ima/integrity for verification only if digital signatures are of certain 
type.

asymmetric support has gone in just now. Before it becomes an ABI, it
might be worth to discuss it.

Yet-to-by-signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 security/integrity/digsig.c           |   11 +++++++----
 security/integrity/evm/evm_main.c     |    4 +++-
 security/integrity/ima/ima_appraise.c |    7 +++++--
 security/integrity/integrity.h        |    9 ++++++---
 4 files changed, 21 insertions(+), 10 deletions(-)

Index: linux-2.6/security/integrity/integrity.h
===================================================================
--- linux-2.6.orig/security/integrity/integrity.h	2013-03-14 13:44:30.000000000 -0400
+++ linux-2.6/security/integrity/integrity.h	2013-03-14 14:02:43.404474646 -0400
@@ -63,6 +63,7 @@ enum evm_ima_xattr_type {
 	IMA_XATTR_DIGEST = 0x01,
 	EVM_XATTR_HMAC,
 	EVM_IMA_XATTR_DIGSIG,
+	EVM_IMA_XATTR_DIGSIG_ASYMMETRIC,
 };
 
 struct evm_ima_xattr_data {
@@ -98,12 +99,14 @@ struct integrity_iint_cache *integrity_i
 
 #ifdef CONFIG_INTEGRITY_SIGNATURE
 
-int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
-					const char *digest, int digestlen);
+int integrity_digsig_verify(enum evm_ima_xattr_type sig_type,
+	const unsigned int id, const char *sig, int siglen,
+	const char *digest, int digestlen);
 
 #else
 
-static inline int integrity_digsig_verify(const unsigned int id,
+static inline int integrity_digsig_verify(enum evm_ima_xattr_type sig_type,
+					  const unsigned int id,
 					  const char *sig, int siglen,
 					  const char *digest, int digestlen)
 {
Index: linux-2.6/security/integrity/ima/ima_appraise.c
===================================================================
--- linux-2.6.orig/security/integrity/ima/ima_appraise.c	2013-03-14 13:44:30.000000000 -0400
+++ linux-2.6/security/integrity/ima/ima_appraise.c	2013-03-14 14:00:06.027469811 -0400
@@ -188,8 +188,10 @@ int ima_appraise_measurement(int func, s
 		status = INTEGRITY_PASS;
 		break;
 	case EVM_IMA_XATTR_DIGSIG:
+	case EVM_IMA_XATTR_DIGSIG_ASYMMETRIC:
 		iint->flags |= IMA_DIGSIG;
-		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
+		rc = integrity_digsig_verify(xattr_value->type,
+					     INTEGRITY_KEYRING_IMA,
 					     xattr_value->digest, rc - 1,
 					     iint->ima_xattr.digest,
 					     IMA_DIGEST_SIZE);
@@ -210,7 +212,8 @@ out:
 	if (status != INTEGRITY_PASS) {
 		if ((ima_appraise & IMA_APPRAISE_FIX) &&
 		    (!xattr_value ||
-		     xattr_value->type != EVM_IMA_XATTR_DIGSIG)) {
+		     (xattr_value->type != EVM_IMA_XATTR_DIGSIG &&
+		      xattr_value->type != EVM_IMA_XATTR_DIGSIG_ASYMMETRIC))) {
 			if (!ima_fix_xattr(dentry, iint))
 				status = INTEGRITY_PASS;
 		}
Index: linux-2.6/security/integrity/evm/evm_main.c
===================================================================
--- linux-2.6.orig/security/integrity/evm/evm_main.c	2013-03-14 09:51:46.000000000 -0400
+++ linux-2.6/security/integrity/evm/evm_main.c	2013-03-14 14:00:52.265471232 -0400
@@ -134,11 +134,13 @@ static enum integrity_status evm_verify_
 			rc = -EINVAL;
 		break;
 	case EVM_IMA_XATTR_DIGSIG:
+	case EVM_IMA_XATTR_DIGSIG_ASYMMETRIC:
 		rc = evm_calc_hash(dentry, xattr_name, xattr_value,
 				xattr_value_len, calc.digest);
 		if (rc)
 			break;
-		rc = integrity_digsig_verify(INTEGRITY_KEYRING_EVM,
+		rc = integrity_digsig_verify(xattr_data->type,
+					INTEGRITY_KEYRING_EVM,
 					xattr_data->digest, xattr_len,
 					calc.digest, sizeof(calc.digest));
 		if (!rc) {
Index: linux-2.6/security/integrity/digsig.c
===================================================================
--- linux-2.6.orig/security/integrity/digsig.c	2013-03-12 15:06:54.000000000 -0400
+++ linux-2.6/security/integrity/digsig.c	2013-03-14 14:06:53.721482335 -0400
@@ -27,7 +27,8 @@ static const char *keyring_name[INTEGRIT
 	"_ima",
 };
 
-int integrity_digsig_verify(const unsigned int id, const char *sig, int siglen,
+int integrity_digsig_verify(enum evm_ima_xattr_type sig_type,
+			const unsigned int id, const char *sig, int siglen,
 					const char *digest, int digestlen)
 {
 	if (id >= INTEGRITY_KEYRING_MAX)
@@ -44,13 +45,15 @@ int integrity_digsig_verify(const unsign
 		}
 	}
 
-	switch (sig[0]) {
-	case 1:
+	switch (sig_type) {
+	case EVM_IMA_XATTR_DIGSIG:
 		return digsig_verify(keyring[id], sig, siglen,
 				     digest, digestlen);
-	case 2:
+	case EVM_IMA_XATTR_DIGSIG_ASYMMETRIC:
 		return asymmetric_verify(keyring[id], sig, siglen,
 					 digest, digestlen);
+	default:
+		break;
 	}
 
 	return -EOPNOTSUPP;
