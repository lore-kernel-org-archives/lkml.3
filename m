Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815Ab3LJUkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:40:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab3LJUke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:40:34 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org, jmorris@namei.org
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] KEYS: Miscellaneous fixes
Date: Tue, 10 Dec 2013 20:40:27 +0000
Message-ID: <4197.1386708027@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Could you pull the following fixes for the keyring stuff.  They break down into
five sets:

 (1) A patch to error handling in the big_key type for huge payloads.  If the
     payload is larger than the "low limit" and the backing store allocation
     fails, then big_key_instantiate() doesn't clear the payload pointers in
     the key, assuming them to have been previously cleared - but only one of
     them is.

     Unfortunately, the garbage collector still calls big_key_destroy() when
     sees one of the pointers with a weird value in it (and not NULL) which it
     then tries to clean up.

 (2) Three patches to fix the keyring type:

     (a) A patch to fix the hash function to correctly divide keyrings off from
     keys in the topology of the tree inside the associative array.  This is
     only a problem if searching through nested keyrings - and only if the hash
     function incorrectly puts the a keyring outside of the 0 branch of the
     root node.

     (b) A patch to fix keyrings' use of the associative array.  The
     __key_link_begin() function initially passes a NULL key pointer to
     assoc_array_insert() on the basis that it's holding a place in the tree
     whilst it does more allocation and stuff.

     This is only a problem when a node contains 16 keys that match at that
     level and we want to add an also matching 17th.  This should easily be
     manufactured with a keyring full of keyrings (without chucking any other
     sort of key into the mix) - except for (a) above which makes it on average
     adding the 65th keyring.

     (c) A patch to fix searching down through nested keyrings, where any
     keyring in the set has more than 16 keyrings and none of the first
     keyrings we look through has a match (before the tree iteration needs to
     step to a more distal node).

     Test in keyutils test suite:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/keyutils.git/commit/?id=8b4ae963ed92523aea18dfbb8cab3f4979e13bd1

 (3) A patch to fix the big_key type's use of a shmem file as its backing store
     causing audit messages and LSM check failures.  This is done by setting
     S_PRIVATE on the file to avoid LSM checks on the file (access to the shmem
     file goes through the keyctl() interface and so is gated by the LSM that
     way).

     This isn't normally a problem if a key is used by the context that
     generated it - and it's currently only used by libkrb5.

     Test in keyutils test suite:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/keyutils.git/commit/?id=d9a53cbab42c293962f2f78f7190253fc73bd32e

 (4) A patch to add a generated file to .gitignore.

 (5) A patch to fix the alignment of the system certificate data such that it
     it works on S390.  As I understand it, on the S390 arch, symbols must be
     2-byte aligned because loading the address discards the least-significant
     bit.

David
---
The following changes since commit af91706d5ddecb4a9858cca9e90d463037cfd498:

  ima: store address of template_fmt_copy in a pointer before calling strsep (2013-11-30 13:09:53 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git tags/keys-devel-20131210

for you to fetch changes up to 62226983da070f7e51068ec2e3a4da34672964c7:

  KEYS: correct alignment of system_certificate_list content in assembly file (2013-12-10 18:25:28 +0000)

----------------------------------------------------------------
(from the branch description for keys-devel local branch)

Keyrings development
Keyrings fixes 2013-12-10

----------------------------------------------------------------
David Howells (4):
      KEYS: Pre-clear struct key on allocation
      KEYS: Fix the keyring hash function
      KEYS: Fix multiple key add into associative array
      KEYS: Fix searching of nested keyrings

Eric Paris (1):
      security: shmem: implement kernel private shmem inodes

Hendrik Brueckner (1):
      KEYS: correct alignment of system_certificate_list content in assembly file

Rusty Russell (1):
      Ignore generated file kernel/x509_certificate_list

 Documentation/assoc_array.txt |  6 +++---
 include/linux/assoc_array.h   |  6 +++---
 include/linux/shmem_fs.h      |  2 ++
 kernel/.gitignore             |  1 +
 kernel/system_certificates.S  | 14 ++++++++++++--
 kernel/system_keyring.c       |  4 ++--
 lib/assoc_array.c             |  4 ++--
 mm/shmem.c                    | 36 +++++++++++++++++++++++++++++-------
 security/keys/big_key.c       |  2 +-
 security/keys/key.c           |  8 +-------
 security/keys/keyring.c       | 17 ++++++++---------
 11 files changed, 64 insertions(+), 36 deletions(-)
