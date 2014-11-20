Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406AbaKTQyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 11:54:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932352AbaKTQyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 11:54:14 -0500
Subject: [PATCH 0/5] MODSIGN: Use PKCS#7 for module signatures
From: David Howells <dhowells@redhat.com>
To: mmarek@suse.cz, d.kasatkin@samsung.com, rusty@rustcorp.com.au,
        vgoyal@redhat.com
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, zohar@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Nov 2014 16:53:51 +0000
Message-ID: <20141120165351.5264.61930.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here's a set of patches that does the following:

 (1) Extracts both parts of an X.509 AuthorityKeyIdentifier (AKID) extension.
     We already extract the bit that can match the subjectKeyIdentifier (SKID)
     of the parent X.509 cert, but we currently ignore the bits that can match
     the issuer and serialNumber.

     Looks up an X.509 cert by issuer and serialNumber if those are provided in
     the AKID.  If the keyIdentifier is also provided, checks that the
     subjectKeyIdentifier of the cert found matches that also.

     If no issuer and serialNumber are provided in the AKID, looks up an X.509
     cert by SKID using the AKID keyIdentifier.

     This allows module signing to be done with certificates that don't have an
     SKID by which they can be looked up.

 (2) Makes use of the PKCS#7 facility to provide module signatures.

     sign-file is replaced with a program that generates a PKCS#7 message that
     has no X.509 certs embedded and that has detached data (the module
     content) and adds it onto the message with magic string and descriptor.

 (3) The PKCS#7 message (and matching X.509 cert) supply all the information
     that is needed to select the X.509 cert to be used to verify the signature
     by standard means (including selection of digest algorithm and public key
     algorithm).  No kernel-specific magic values are required.

Note that the revised sign-file program no longer supports the "-s <signature>"
option as I'm not sure what the best way to deal with this is.  Do we generate
a PKCS#7 cert from the signature given, or do we get given a PKCS#7 cert?  I
lean towards the latter.

They can be found here also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=modsign-pkcs7

These patches are based on the security tree's next branch.

David
---
David Howells (5):
      X.509: Extract both parts of the AuthorityKeyIdentifier
      X.509: Support X.509 lookup by Issuer+Serial form AuthorityKeyIdentifier
      PKCS#7: Allow detached data to be supplied for signature checking purposes
      MODSIGN: Provide a utility to append a PKCS#7 signature to a module
      MODSIGN: Use PKCS#7 messages as module signatures


 crypto/asymmetric_keys/Makefile           |    8 -
 crypto/asymmetric_keys/pkcs7_trust.c      |   10 -
 crypto/asymmetric_keys/pkcs7_verify.c     |   81 ++++--
 crypto/asymmetric_keys/x509_akid.asn1     |   35 ++
 crypto/asymmetric_keys/x509_cert_parser.c |  142 ++++++----
 crypto/asymmetric_keys/x509_parser.h      |    3 
 crypto/asymmetric_keys/x509_public_key.c  |   85 ++++--
 include/crypto/pkcs7.h                    |    3 
 include/crypto/public_key.h               |    4 
 init/Kconfig                              |    1 
 kernel/module_signing.c                   |  220 +++------------
 scripts/Makefile                          |    2 
 scripts/sign-file                         |  421 -----------------------------
 scripts/sign-file.c                       |  189 +++++++++++++
 14 files changed, 505 insertions(+), 699 deletions(-)
 create mode 100644 crypto/asymmetric_keys/x509_akid.asn1
 delete mode 100755 scripts/sign-file
 create mode 100755 scripts/sign-file.c

