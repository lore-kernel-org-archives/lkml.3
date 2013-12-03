Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754862Ab3LCOxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 09:53:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961Ab3LCOw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 09:52:59 -0500
Subject: [RFC][PATCH0/5] Keys patches
From: David Howells <dhowells@redhat.com>
To: torvalds@linux-foundation.org, jmorris@namei.org
Cc: keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 03 Dec 2013 14:52:50 +0000
Message-ID: <20131203145250.30689.28039.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus, James,

Here are some fixes for the new keyring stuff.  They break down into three
sets:

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

 (3) A patch to fix the big_key type's use of a shmem file as its backing store
     causing audit messages and LSM check failures.  This is done by setting
     S_PRIVATE on the file to avoid LSM checks on the file (access to the shmem
     file goes through the keyctl() interface and so is gated by the LSM that
     way).

     This isn't normally a problem if a key is used by the context that
     generated it - and it's currently only used by libkrb5.

David
---
David Howells (4):
      KEYS: Pre-clear struct key on allocation
      KEYS: Fix the keyring hash function
      KEYS: Fix multiple key add into associative array
      KEYS: Fix searching of nested keyrings

Eric Paris (1):
      security: shmem: implement kernel private shmem inodes


 Documentation/assoc_array.txt |    6 +++---
 include/linux/assoc_array.h   |    6 +++---
 include/linux/shmem_fs.h      |    2 ++
 lib/assoc_array.c             |    4 ++--
 mm/shmem.c                    |   36 +++++++++++++++++++++++++++++-------
 security/keys/big_key.c       |    2 +-
 security/keys/key.c           |    8 +-------
 security/keys/keyring.c       |   17 ++++++++---------
 8 files changed, 49 insertions(+), 32 deletions(-)

