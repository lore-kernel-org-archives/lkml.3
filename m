Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482AbaIPQ7Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:59:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086AbaIPQ7W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:59:22 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: James Morris <jmorris@namei.org>
cc: dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] KEYS: Changes for keyrings for security/next
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <32369.1410886755.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Tue, 16 Sep 2014 17:59:15 +0100
Message-ID: <32370.1410886755@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Can you please pull these changes into security/next.  They include the fixes
tag I previously requested as there's a dependency between these changes and
the fixes.

So, there are the fixes to go upstream:

 (1) Reinstate the production of EPERM for key types beginning with '.' in
     requests from userspace.

 (2) Tidy up the cleanup of PKCS#7 message signed information blocks and fix a
     bug this made more obvious.

There are some additional fixes which can go through security/next:

 (1) Insert some missing 'static' annotations.

And then there are some improvements to X.509 and PKCS#7:

Changes for next to improve the matching of asymmetric keys and to improve the
handling of PKCS#7 certificates:

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

David
---
The following changes since commit ac60ab4b4968b54fb5af20eac9dd78e36ad910c1:

  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/zohar/linux-integrity into next (2014-09-12 22:40:22 +1000)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/keys-next-20140916

for you to fetch changes up to d3e4f41973753a7768a5728be53c7d9a3fdf86cb:

  Merge tag 'keys-pkcs7-20140916' into keys-next (2014-09-16 17:38:07 +0100)

----------------------------------------------------------------

(from the branch description for keys-next local branch)

Keyrings for linux-next
Keyrings changes for next

----------------------------------------------------------------
David Howells (18):
      KEYS: Fix missing statics
      PKCS#7: Add a missing static
      KEYS: Reinstate EPERM for a key type name beginning with a '.'
      PKCS#7: Provide a single place to do signed info block freeing
      PKCS#7: Fix the parser cleanup to drain parsed out X.509 certs
      Merge tag 'keys-fixes-20140916' into keys-next
      Merge tag 'keys-next-fixes-20140916' into keys-next
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
      Merge tag 'keys-pkcs7-20140916' into keys-next

 Documentation/security/keys.txt           |  65 +++++++--
 crypto/asymmetric_keys/asymmetric_keys.h  |   8 +-
 crypto/asymmetric_keys/asymmetric_type.c  | 222 +++++++++++++++++++++---------
 crypto/asymmetric_keys/pkcs7_key_type.c   |   2 -
 crypto/asymmetric_keys/pkcs7_parser.c     |  99 +++++++------
 crypto/asymmetric_keys/pkcs7_parser.h     |   6 +-
 crypto/asymmetric_keys/pkcs7_trust.c      |  87 ++++++++----
 crypto/asymmetric_keys/pkcs7_verify.c     | 102 +++++++++-----
 crypto/asymmetric_keys/x509_cert_parser.c |  55 +++++---
 crypto/asymmetric_keys/x509_parser.h      |   6 +-
 crypto/asymmetric_keys/x509_public_key.c  | 102 ++++++++------
 fs/cifs/cifs_spnego.c                     |   1 -
 fs/cifs/cifsacl.c                         |   1 -
 fs/nfs/idmap.c                            |   2 -
 include/crypto/public_key.h               |   5 +-
 include/keys/asymmetric-type.h            |  38 +++++
 include/keys/user-type.h                  |   1 -
 include/linux/kernel.h                    |   1 +
 include/linux/key-type.h                  |  34 ++++-
 lib/hexdump.c                             |  16 +++
 net/ceph/crypto.c                         |   1 -
 net/dns_resolver/dns_key.c                |  18 ++-
 net/rxrpc/ar-key.c                        |   2 -
 security/keys/big_key.c                   |   2 -
 security/keys/encrypted-keys/encrypted.c  |   1 -
 security/keys/internal.h                  |  21 ++-
 security/keys/key.c                       |   2 +-
 security/keys/keyctl.c                    |   2 +
 security/keys/keyring.c                   |  58 +++++---
 security/keys/proc.c                      |   8 +-
 security/keys/process_keys.c              |  13 +-
 security/keys/request_key.c               |  21 ++-
 security/keys/request_key_auth.c          |  10 +-
 security/keys/trusted.c                   |   1 -
 security/keys/user_defined.c              |  14 --
 35 files changed, 689 insertions(+), 338 deletions(-)
