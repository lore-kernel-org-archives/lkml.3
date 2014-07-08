Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754999AbaGHNPl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 09:15:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254AbaGHNPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 09:15:38 -0400
Subject: [PATCH 0/7] KEYS: PKCS#7 asymmetric key parser
From: David Howells <dhowells@redhat.com>
To: keyrings@linux-nfs.org
Cc: linux-security-module@vger.kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Tue, 08 Jul 2014 14:15:04 +0100
Message-ID: <20140708131504.28621.61165.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here's a set of patches that implements a PKCS#7 message parser in the kernel.

The PKCS#7 message parsing will then be used to limit kexec to authenticated
kernels only if so configured.

The patches provide the following facilities:

 (1) Parse an ASN.1 PKCS#7 message and pick out useful bits such as the data
     content and the X.509 certificates used to sign it and all the data
     signatures.

 (2) Verify all the data signatures against the set of X.509 certificates
     available in the message.

 (3) Follow the certificate chains and verify that:

     (a) for every self-signed X.509 certificate, check that it validly signed
     	 itself, and:

     (b) for every non-self-signed certificate, if we have a 'parent'
     	 certificate, the former is validly signed by the latter.

 (4) Look for intersections between the certificate chains and the trusted
     keyring, if any intersections are found, verify that the trusted
     certificates signed the intersection point in the chain.

 (5) For testing purposes, a key type can be made available that will take a
     PKCS#7 message, check that the message is trustworthy, and if so, add its
     data content into the key.

They can be found on this branch also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-modsign.git/log/?h=pkcs7

and are tagged with:

	keys-pkcs7-20140708

David
---
David Howells (7):
      X.509: Export certificate parse and free functions
      PKCS#7: Implement a parser [RFC 2315]
      PKCS#7: Digest the data in a signed-data message
      PKCS#7: Find the right key in the PKCS#7 key list and verify the signature
      PKCS#7: Verify internal certificate chain
      PKCS#7: Find intersection between PKCS#7 message and known, trusted keys
      PKCS#7: Provide a key type for testing PKCS#7


 crypto/asymmetric_keys/Kconfig            |   22 ++
 crypto/asymmetric_keys/Makefile           |   22 ++
 crypto/asymmetric_keys/pkcs7.asn1         |  127 +++++++++
 crypto/asymmetric_keys/pkcs7_key_type.c   |   97 +++++++
 crypto/asymmetric_keys/pkcs7_parser.c     |  396 +++++++++++++++++++++++++++++
 crypto/asymmetric_keys/pkcs7_parser.h     |   61 ++++
 crypto/asymmetric_keys/pkcs7_trust.c      |  219 ++++++++++++++++
 crypto/asymmetric_keys/pkcs7_verify.c     |  323 ++++++++++++++++++++++++
 crypto/asymmetric_keys/x509_cert_parser.c |    3 
 include/crypto/pkcs7.h                    |   36 +++
 include/linux/oid_registry.h              |    1 
 11 files changed, 1307 insertions(+)
 create mode 100644 crypto/asymmetric_keys/pkcs7.asn1
 create mode 100644 crypto/asymmetric_keys/pkcs7_key_type.c
 create mode 100644 crypto/asymmetric_keys/pkcs7_parser.c
 create mode 100644 crypto/asymmetric_keys/pkcs7_parser.h
 create mode 100644 crypto/asymmetric_keys/pkcs7_trust.c
 create mode 100644 crypto/asymmetric_keys/pkcs7_verify.c
 create mode 100644 include/crypto/pkcs7.h

