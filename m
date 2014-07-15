Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934237AbaGOWCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:02:07 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54697 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932859AbaGOVhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:37:47 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Jason Baron <jbaron@akamai.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 149/198] epoll: fix use-after-free in eventpoll_release_file
Date: Tue, 15 Jul 2014 14:30:19 -0700
Message-Id: <1405459868-15089-150-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Khlebnikov <koct9i@gmail.com>

commit ebe06187bf2aec10d537ce4595e416035367d703 upstream.

This fixes use-after-free of epi->fllink.next inside list loop macro.
This loop actually releases elements in the body.  The list is
rcu-protected but here we cannot hold rcu_read_lock because we need to
lock mutex inside.

The obvious solution is to use list_for_each_entry_safe().  RCU-ness
isn't essential because nobody can change this list under us, it's final
fput for this file.

The bug was introduced by ae10b2b4eb01 ("epoll: optimize EPOLL_CTL_DEL
using rcu")

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Reported-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Jason Baron <jbaron@akamai.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/eventpoll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index af90312..ead0046 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -910,7 +910,7 @@ static const struct file_operations eventpoll_fops = {
 void eventpoll_release_file(struct file *file)
 {
 	struct eventpoll *ep;
-	struct epitem *epi;
+	struct epitem *epi, *next;
 
 	/*
 	 * We don't want to get "file->f_lock" because it is not
@@ -926,7 +926,7 @@ void eventpoll_release_file(struct file *file)
 	 * Besides, ep_remove() acquires the lock, so we can't hold it here.
 	 */
 	mutex_lock(&epmutex);
-	list_for_each_entry_rcu(epi, &file->f_ep_links, fllink) {
+	list_for_each_entry_safe(epi, next, &file->f_ep_links, fllink) {
 		ep = epi->ep;
 		mutex_lock_nested(&ep->mtx, 0);
 		ep_remove(ep, epi);
-- 
1.9.1

