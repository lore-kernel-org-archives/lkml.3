Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935264Ab3JPSJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:09:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35748 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761538Ab3JPRqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 13:46:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Sedat Dilek <sedat.dilek@gmail.com>, Rik van Riel <riel@redhat.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mike Galbraith <efault@gmx.de>
Subject: [ 58/69] ipc: document general ipc locking scheme
Date: Wed, 16 Oct 2013 10:45:07 -0700
Message-Id: <20131016174319.968142238@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131016174312.844154919@linuxfoundation.org>
References: <20131016174312.844154919@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Davidlohr Bueso <davidlohr.bueso@hp.com>

commit 05603c44a7627793219b0bd9a7b236099dc9cd9d upstream.

As suggested by Andrew, add a generic initial locking scheme used
throughout all sysv ipc mechanisms.  Documenting the ids rwsem, how rcu
can be enough to do the initial checks and when to actually acquire the
kern_ipc_perm.lock spinlock.

I found that adding it to util.c was generic enough.

Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/util.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/ipc/util.c
+++ b/ipc/util.c
@@ -15,6 +15,14 @@
  * Jun 2006 - namespaces ssupport
  *            OpenVZ, SWsoft Inc.
  *            Pavel Emelianov <xemul@openvz.org>
+ *
+ * General sysv ipc locking scheme:
+ *  when doing ipc id lookups, take the ids->rwsem
+ *      rcu_read_lock()
+ *          obtain the ipc object (kern_ipc_perm)
+ *          perform security, capabilities, auditing and permission checks, etc.
+ *          acquire the ipc lock (kern_ipc_perm.lock) throught ipc_lock_object()
+ *             perform data updates (ie: SET, RMID, LOCK/UNLOCK commands)
  */
 
 #include <linux/mm.h>


