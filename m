Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932497AbaF1RzI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 13:55:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54562 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932467AbaF1Rxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:53:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Sasha Levin <sasha.levin@oracle.com>, Jason Baron <jbaron@akamai.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.15 136/139] epoll: fix use-after-free in eventpoll_release_file
Date: Sat, 28 Jun 2014 10:48:17 -0700
Message-Id: <20140628174611.614040909@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174605.352098823@linuxfoundation.org>
References: <20140628174605.352098823@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/eventpoll.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -910,7 +910,7 @@ static const struct file_operations even
 void eventpoll_release_file(struct file *file)
 {
 	struct eventpoll *ep;
-	struct epitem *epi;
+	struct epitem *epi, *next;
 
 	/*
 	 * We don't want to get "file->f_lock" because it is not
@@ -926,7 +926,7 @@ void eventpoll_release_file(struct file
 	 * Besides, ep_remove() acquires the lock, so we can't hold it here.
 	 */
 	mutex_lock(&epmutex);
-	list_for_each_entry_rcu(epi, &file->f_ep_links, fllink) {
+	list_for_each_entry_safe(epi, next, &file->f_ep_links, fllink) {
 		ep = epi->ep;
 		mutex_lock_nested(&ep->mtx, 0);
 		ep_remove(ep, epi);


