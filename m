Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbaF3MT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:19:29 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:51940 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753113AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Konstantin Khlebnikov <koct9i@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Jason Baron <jbaron@akamai.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 005/181] epoll: fix use-after-free in eventpoll_release_file
Date: Mon, 30 Jun 2014 13:50:26 +0200
Message-Id: <c79460f67d0b02465904193764328ceeacfdd549.1404128997.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konstantin Khlebnikov <koct9i@gmail.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Cc: Stable <stable@vger.kernel.org> # 3.13+
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Jason Baron <jbaron@akamai.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/eventpoll.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index d76c9744c774..55ebb8886014 100644
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
2.0.0

