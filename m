Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab3FZRnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 13:43:55 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:32606 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab3FZRnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 13:43:53 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v2 0/2] Lockless update of reference count protected by spinlock
Date: Wed, 26 Jun 2013 13:43:21 -0400
Message-Id: <1372268603-46748-1-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1->v2:
 - Add one more layer of indirection to LOCK_WITH_REFCOUNT macro.
 - Add __LINUX_SPINLOCK_REFCOUNT_H protection to spinlock_refcount.h.
 - Add some generic get/put macros into spinlock_refcount.h.

This patchset supports a generic mechanism to atomically update
a reference count that is protected by a spinlock without actually
acquiring the lock itself. If the update doesn't succeeed, the caller
will have to acquire the lock and update the reference count in the
the old way.  This will help in situation where there is a lot of
spinlock contention because of frequent reference count update.

The new mechanism was designed in such a way to easily retrofit
into existing code with minimal changes. Both the spinlock and the
reference count can be accessed in the same way as before.

The d_lock and d_count fields of the struct dentry in dcache.h was
modified to use the new mechanism. This serves as an example of how
to convert existing spinlock and reference count combo to use the
new way of locklessly updating the reference count.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>

Waiman Long (2):
  spinlock: New spinlock_refcount.h for lockless update of refcount
  dcache: Locklessly update d_count whenever possible

 fs/dcache.c                       |   14 +++-
 include/linux/dcache.h            |    6 +-
 include/linux/spinlock_refcount.h |  177 +++++++++++++++++++++++++++++++++++++
 include/linux/spinlock_types.h    |   19 ++++
 4 files changed, 212 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/spinlock_refcount.h

