Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbaIHPh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:37:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322AbaIHPh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:37:26 -0400
Subject: [RFC][PATCH 00/13] MODSIGN: Use PKCS#7 for module signatures
From: David Howells <dhowells@redhat.com>
To: rusty@rustcorp.com.au
Cc: keyrings@linux-nfs.org, jwboyer@redhat.com, linux-kernel@vger.kernel.org,
        dhowells@redhat.com, linux-security-module@vger.kernel.org,
        pjones@redhat.com, vgoyal@redhat.com
Date: Mon, 08 Sep 2014 16:37:05 +0100
Message-ID: <20140908153704.28301.41578.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here's a set of patches that does the following:

 (1) Improves asymmetric keys identification.

     Keys derived from X.509 certs now get labelled with IDs derived from their
     issuer and certificate number (required to match PKCS#7) and from their
     SKID and subject (required to match X.509).

     IDs are now binary and match criterion preparsing is provided so that
     criteria can be turned into binary blobs to make matching faster.

 (2) Improves PKCS#7 message handling to permit PKCS#7 messages without X.509
     cert lists to be matched to trusted keys, thereby allowing minimally sized
     PKCS#7 certs to be used.

 (3) Improves PKCS#7 message handling to better handle certificate chains that
     are broken due to unsupported crypto that can otherwise by used to
     intersect a trust keyring.

 (4) Makes use of the PKCS#7 facility to provide module signatures.

     sign-file is replaced with a program that generates a PKCS#7 message that
     has no X.509 certs embedded and that has detached data (the module
     content) and adds it onto the message with magic string and descriptor.

 (5) The PKCS#7 message (and matching X.509 cert) supply all the information
     that is needed to select the X.509 cert to be used to verify the signature
     by standard means (including selection of digest algorithm and public key
     algorithm).  No kernel-specific magic values are required.

The following need to be considered also:

 (1) How to support externally generated signatures (sign-file -s).  Ideally,
     externally generated signatures would be provided as PKCS#7 certificates.

 (2) How to handle the old signature format: do we change the magic number and
     just pretend they don't exist (which would allow us to get rid of most of
     the descriptor), do we give an error (which I've chosen to do) or do we
     have to support them still?

 (3) Do I really need to make one of the X.509-derived IDs out of the subjKeyId
     and the subject, or can I just use the subjKeyId by itself?  (And likewise
     for auth + issuer)

They can be found here also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=modsign-pkcs7

David
---
David Howells (13):
      Provide a binary to hex conversion utility
      KEYS: Preparse match data
      KEYS: Remove key_type::def_lookup_type
      KEYS: Remove key_type::match in favour of overriding default by match_preparse
      KEYS: Make the key matching functions return bool
      KEYS: Implement binary asymmetric key ID handling
      PKCS#7: Clean up the signed info freeing and fix the parser cleanup
      KEYS: Overhaul key identification when searching for asymmetric keys
      PKCS#7: Better handling of unsupported crypto
      PKCS#7: Handle PKCS#7 messages that contain no X.509 certs
      PKCS#7: Allow detached data to be supplied for signature checking purposes
      MODSIGN: Provide a utility to append a PKCS#7 signature to a module
      MODSIGN: Use PKCS#7 messages as module signatures


 crypto/asymmetric_keys/asymmetric_keys.h  |    8 -
 crypto/asymmetric_keys/asymmetric_type.c  |  213 ++++++++++-----
 crypto/asymmetric_keys/pkcs7_key_type.c   |    2 
 crypto/asymmetric_keys/pkcs7_parser.c     |   66 +++--
 crypto/asymmetric_keys/pkcs7_parser.h     |    7 
 crypto/asymmetric_keys/pkcs7_trust.c      |   72 +++--
 crypto/asymmetric_keys/pkcs7_verify.c     |  131 +++++++--
 crypto/asymmetric_keys/x509_cert_parser.c |   55 ++--
 crypto/asymmetric_keys/x509_parser.h      |    6 
 crypto/asymmetric_keys/x509_public_key.c  |  102 ++++---
 fs/cifs/cifs_spnego.c                     |    1 
 fs/cifs/cifsacl.c                         |    1 
 fs/nfs/idmap.c                            |    2 
 include/crypto/pkcs7.h                    |    3 
 include/crypto/public_key.h               |    6 
 include/keys/asymmetric-type.h            |   38 +++
 include/keys/user-type.h                  |    1 
 include/linux/kernel.h                    |    1 
 include/linux/key-type.h                  |   34 ++
 init/Kconfig                              |    1 
 kernel/module_signing.c                   |  220 +++------------
 lib/hexdump.c                             |   18 +
 net/dns_resolver/dns_key.c                |   18 +
 net/rxrpc/ar-key.c                        |    2 
 scripts/Makefile                          |    2 
 scripts/sign-file                         |  421 -----------------------------
 scripts/sign-file.c                       |  189 +++++++++++++
 security/keys/big_key.c                   |    2 
 security/keys/encrypted-keys/encrypted.c  |    1 
 security/keys/internal.h                  |   10 -
 security/keys/key.c                       |    2 
 security/keys/keyring.c                   |   59 +++-
 security/keys/proc.c                      |    8 -
 security/keys/process_keys.c              |   13 -
 security/keys/request_key.c               |   21 +
 security/keys/request_key_auth.c          |    6 
 security/keys/trusted.c                   |    1 
 security/keys/user_defined.c              |   14 -
 38 files changed, 869 insertions(+), 888 deletions(-)
 delete mode 100755 scripts/sign-file
 create mode 100755 scripts/sign-file.c

