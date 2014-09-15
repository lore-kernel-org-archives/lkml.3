Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbaIOUpH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:45:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682AbaIOUpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 16:45:04 -0400
Subject: [PATCH 00/10] KEYS: Improve asymmetric key and PKCS#7 handling [ver
 #2]
From: David Howells <dhowells@redhat.com>
To: vgoyal@redhat.com
Cc: dhowells@redhat.com, keyrings@linux-nfs.org, linux-kernel@vger.kernel.org
Date: Mon, 15 Sep 2014 21:44:57 +0100
Message-ID: <20140915204456.27499.40234.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here are some patches to improve the matching of asymmetric keys and to
improve the handling of PKCS#7 certificates:

 (1) Provide a method to preparse the data supplied for matching a key.  This
     permits they key type to extract out the bits it needs for matching once
     only.

     Further, the type of search (direct lookup or iterative) can be set and
     the function used to actually check the match can be set by preparse
     rather than being hard coded for the type.

 (2) Improves asymmetric keys identification.

     Keys derived from X.509 certs now get labelled with IDs derived from their
     issuer and certificate number (required to match PKCS#7) and from their
     SKID and subject (required to match X.509).

     IDs are now binary and match criterion preparsing is provided so that
     criteria can be turned into binary blobs to make matching faster.

 (3) Improves PKCS#7 message handling to permit PKCS#7 messages without X.509
     cert lists to be matched to trusted keys, thereby allowing minimally sized
     PKCS#7 certs to be used.

 (4) Improves PKCS#7 message handling to better handle certificate chains that
     are broken due to unsupported crypto that can otherwise by used to
     intersect a trust keyring.

They can be found here also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-pkcs7

Changes:

 (*) Documentation for the keys API changes.

 (*) Doc comments and exports put on new key ID functions that are used across
     modules.

 (*) The four debugging 0xff bytes are removed from the middle of key IDs.

 (*) Attempt to suppress the warning about not checking the redundant return
     of hex2bin().

 (*) pkcs->unsupported_crypto can be removed in favour of working the error
     code out in pkcs7_validate_trust() from the error codes of
     pkcs7_validate_trust_one().

 (*) bin2hex() now uses hex_byte_pack().

 (*) KEYRING_SEARCH_LOOKUP_TYPE is unused and got removed.

 (*) ctx.match_data.cmp will always be set in keyring_search() so the check
     for NULL there can be removed.

David
---
David Howells (10):
      Provide a binary to hex conversion function
      KEYS: Preparse match data
      KEYS: Remove key_type::def_lookup_type
      KEYS: Remove key_type::match in favour of overriding default by match_preparse
      KEYS: Make the key matching functions return bool
      KEYS: Update the keyrings documentation for match changes
      KEYS: Implement binary asymmetric key ID handling
      KEYS: Overhaul key identification when searching for asymmetric keys
      PKCS#7: Better handling of unsupported crypto
      PKCS#7: Handle PKCS#7 messages that contain no X.509 certs


 Documentation/security/keys.txt           |   65 +++++++-
 crypto/asymmetric_keys/asymmetric_keys.h  |    8 +
 crypto/asymmetric_keys/asymmetric_type.c  |  222 +++++++++++++++++++++--------
 crypto/asymmetric_keys/pkcs7_key_type.c   |    2 
 crypto/asymmetric_keys/pkcs7_parser.c     |   38 ++++-
 crypto/asymmetric_keys/pkcs7_parser.h     |    6 -
 crypto/asymmetric_keys/pkcs7_trust.c      |   82 +++++++----
 crypto/asymmetric_keys/pkcs7_verify.c     |  102 +++++++++----
 crypto/asymmetric_keys/x509_cert_parser.c |   55 ++++---
 crypto/asymmetric_keys/x509_parser.h      |    6 +
 crypto/asymmetric_keys/x509_public_key.c  |  102 ++++++++-----
 fs/cifs/cifs_spnego.c                     |    1 
 fs/cifs/cifsacl.c                         |    1 
 fs/nfs/idmap.c                            |    2 
 include/crypto/public_key.h               |    5 -
 include/keys/asymmetric-type.h            |   38 +++++
 include/keys/user-type.h                  |    1 
 include/linux/kernel.h                    |    1 
 include/linux/key-type.h                  |   34 ++++
 lib/hexdump.c                             |   16 ++
 net/ceph/crypto.c                         |    1 
 net/dns_resolver/dns_key.c                |   18 ++
 net/rxrpc/ar-key.c                        |    2 
 security/keys/big_key.c                   |    2 
 security/keys/encrypted-keys/encrypted.c  |    1 
 security/keys/internal.h                  |   21 +--
 security/keys/key.c                       |    2 
 security/keys/keyring.c                   |   58 +++++---
 security/keys/proc.c                      |    8 +
 security/keys/process_keys.c              |   13 +-
 security/keys/request_key.c               |   21 ++-
 security/keys/request_key_auth.c          |    6 -
 security/keys/trusted.c                   |    1 
 security/keys/user_defined.c              |   14 --
 34 files changed, 649 insertions(+), 306 deletions(-)

