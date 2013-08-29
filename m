Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab3H2AVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 20:21:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752206Ab3H2AU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 20:20:59 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: jmorris@namei.org
cc: dhowells@redhat.com, simo@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Expand keyring capacity and provide support for libkrb5
Date: Thu, 29 Aug 2013 01:20:48 +0100
Message-ID: <11520.1377735648@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi James,

Could you pull these patches into the security tree?

The patches can be viewed as three sets:

 (1) KEYS: Skip key state checks when checking for possession

     This is a fix for determining the possessed status of keys that have been
     invalidated or revoked or that have expired.  If nothing else, can you
     please pick this and pass it upstream.

 (2) KEYS: Expand the capacity of a keyring
     Add a generic associative array implementation
     KEYS: Drop the permissions argument from __keyring_search_one()
     KEYS: Define a __key_get() wrapper to use rather than atomic_inc()
     KEYS: Search for auth-key by name rather than target key ID
     KEYS: Introduce a search context structure
     KEYS: Consolidate the concept of an 'index key' for key access
     KEYS: key_is_dead() should take a const key pointer argument
     KEYS: Use bool in make_key_ref() and is_key_possessed()

     Patches to to expand the capacity of a keyring by using an associative
     array rather than a flat list and patches to do some preparatory cleanups
     for those.

 (3) KEYS: Add per-user_namespace registers for persistent per-UID kerberos caches
     KEYS: Implement a big key type that can save to tmpfs

     Patches to add better support for libkrb5 to save its tokens in a kernel
     keyring rather than in files.  It already has this ability to some
     extent, but that has two problems: your tokens get deleted when you log
     out (so your cron jobs can't use them) and the capacity of a user type
     key is not sufficient for some of the huge Kerberos tickets one can get.
     These patches address that.

If you need the patches basing on your tree instead, that can be done.

David
---
The following changes since commit f1d6e17f540af37bb1891480143669ba7636c4cf:

  Merge branch 'akpm' (patches from Andrew Morton) (2013-08-14 10:04:43 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/keys-krb-support

for you to fetch changes up to 0f8d966ebc86d7ab9fb7fd074ae589c2d81de08f:

  KEYS: Add per-user_namespace registers for persistent per-UID kerberos caches (2013-08-28 18:56:14 +0100)

----------------------------------------------------------------
(from the branch description for keys-devel local branch)

clone of "master"
Kerberos ticket persistence support

----------------------------------------------------------------
David Howells (12):
      KEYS: Skip key state checks when checking for possession
      KEYS: Use bool in make_key_ref() and is_key_possessed()
      KEYS: key_is_dead() should take a const key pointer argument
      KEYS: Consolidate the concept of an 'index key' for key access
      KEYS: Introduce a search context structure
      KEYS: Search for auth-key by name rather than target key ID
      KEYS: Define a __key_get() wrapper to use rather than atomic_inc()
      KEYS: Drop the permissions argument from __keyring_search_one()
      Add a generic associative array implementation.
      KEYS: Expand the capacity of a keyring
      KEYS: Implement a big key type that can save to tmpfs
      KEYS: Add per-user_namespace registers for persistent per-UID kerberos caches

 Documentation/assoc_array.txt    |  574 +++++++++++++
 Documentation/security/keys.txt  |   20 +-
 include/keys/big_key-type.h      |   25 +
 include/keys/keyring-type.h      |   17 +-
 include/linux/assoc_array.h      |   92 ++
 include/linux/assoc_array_priv.h |  182 ++++
 include/linux/key-type.h         |    5 +
 include/linux/key.h              |   49 +-
 include/linux/user_namespace.h   |    6 +
 include/uapi/linux/keyctl.h      |    1 +
 kernel/user.c                    |    4 +
 kernel/user_namespace.c          |    4 +
 lib/Kconfig                      |   14 +
 lib/Makefile                     |    1 +
 lib/assoc_array.c                | 1745 ++++++++++++++++++++++++++++++++++++++
 security/keys/Kconfig            |   29 +
 security/keys/Makefile           |    2 +
 security/keys/big_key.c          |  204 +++++
 security/keys/compat.c           |    3 +
 security/keys/gc.c               |   33 +-
 security/keys/internal.h         |   74 +-
 security/keys/key.c              |   91 +-
 security/keys/keyctl.c           |    3 +
 security/keys/keyring.c          | 1481 ++++++++++++++++----------------
 security/keys/persistent.c       |  169 ++++
 security/keys/proc.c             |   17 +-
 security/keys/process_keys.c     |  131 +--
 security/keys/request_key.c      |   56 +-
 security/keys/request_key_auth.c |   31 +-
 security/keys/sysctl.c           |   11 +
 security/keys/user_defined.c     |   18 +-
 31 files changed, 4124 insertions(+), 968 deletions(-)
 create mode 100644 Documentation/assoc_array.txt
 create mode 100644 include/keys/big_key-type.h
 create mode 100644 include/linux/assoc_array.h
 create mode 100644 include/linux/assoc_array_priv.h
 create mode 100644 lib/assoc_array.c
 create mode 100644 security/keys/big_key.c
 create mode 100644 security/keys/persistent.c

