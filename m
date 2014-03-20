Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757918AbaCTMEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 08:04:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55503 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbaCTMEi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 08:04:38 -0400
Subject: [PATCH 00/12] KEYS: Use preparsing in most key types
From: David Howells <dhowells@redhat.com>
To: keyrings@linux-nfs.org
Cc: dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 20 Mar 2014 12:04:29 +0000
Message-ID: <20140320120428.21635.13071.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here are a set of patches that make all but encrypted and trusted keys use
preparsing.  Unfortunately, encrypted and trusted keys incorrectly use the
update op to alter a key, so other changes will need to be made for them.

These changes permit payload parsing when instantiating or updating a key to be
done before locks are taken and to determine the amount of quota that will be
required in advance.  The latter will make it possible to do LRU discard before
any locks are taken.

They can be found here also:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-preparse-1

David
---
David Howells (12):
      KEYS: Provide a generic instantiation function
      KEYS: struct key_preparsed_payload should have two payload pointers
      KEYS: Allow expiry time to be set when preparsing a key
      KEYS: Call ->free_preparse() even after ->preparse() returns an error
      KEYS: user: Use key preparsing
      KEYS: Ceph: Use key preparsing
      KEYS: Ceph: Use user_match()
      KEYS: DNS: Use key preparsing
      KEYS: RxRPC: Use key preparsing
      KEYS: big_key: Use key preparsing
      KEYS: keyring: Provide key preparsing
      KEYS: request_key_auth: Provide key preparsing


 Documentation/security/keys.txt          |   14 ++-
 crypto/asymmetric_keys/asymmetric_type.c |   27 -----
 crypto/asymmetric_keys/x509_public_key.c |    2 
 fs/nfs/idmap.c                           |    8 +
 include/keys/big_key-type.h              |    3 -
 include/keys/user-type.h                 |    3 -
 include/linux/key-type.h                 |    5 +
 net/ceph/crypto.c                        |   26 +++--
 net/dns_resolver/dns_key.c               |   43 +++++---
 net/rxrpc/ar-key.c                       |  165 ++++++++++++++++++------------
 security/keys/big_key.c                  |   41 +++++--
 security/keys/encrypted-keys/encrypted.c |    2 
 security/keys/key.c                      |   49 ++++++++-
 security/keys/keyring.c                  |   34 ++++--
 security/keys/request_key_auth.c         |   13 ++
 security/keys/user_defined.c             |   41 ++++---
 16 files changed, 291 insertions(+), 185 deletions(-)

