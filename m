Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbaFQC6Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 22:58:16 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:45517 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743AbaFQC6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 22:58:14 -0400
Subject: [PATCH] epoll: fix use-after-free in eventpoll_release_file
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        Sasha Levin <sasha.levin@oracle.com>, Jason Baron <jbaron@akamai.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Stable <stable@vger.kernel.org>
Date: Tue, 17 Jun 2014 06:58:05 +0400
Message-ID: <20140617025805.29539.22007.stgit@zurg>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes use-after-free of epi->fllink.next inside list loop macro.
This loop actually releases elements in the body. List is rcu-protected
but here we cannot hold rcu_read_lock because we need to lock mutex inside.

Obvious solution is to use list_for_each_entry_safe(). RCU-ness isn't essential
because nobody can change this list under us, it's final fput for this file.

Bug is here since ae10b2b4eb01bedc91d29d5c5bb9e416fd806c40
("epoll: optimize EPOLL_CTL_DEL using rcu")

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
Reported-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Stable <stable@vger.kernel.org> # 3.13+
Cc: Sasha Levin <sasha.levin@oracle.com>
Cc: Jason Baron <jbaron@akamai.com>
---
 fs/eventpoll.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index b73e062..b10b48c 100644
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

