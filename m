Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab3J3Scn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 14:32:43 -0400
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:63592 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646Ab3J3Scm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 14:32:42 -0400
To: akpm@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, normalperson@yhbt.net, nzimmer@sgi.com,
        viro@zeniv.linux.org.uk, nelhage@nelhage.com, davidel@xmailserver.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH] epoll: remove the on_list check for 'struct epitem'
Message-Id: <20131030183241.AE8201FF9@prod-mail-relay06.akamai.com>
Date: Wed, 30 Oct 2013 18:32:41 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By removing the 'int on_list' field from 'struct epitem', we avoid hitting the
BUILD_BUG_ON() for 'struct epitem' being larger than 128 bytes.

In file included from include/linux/init.h:4:0,
                 from fs/eventpoll.c:14:
fs/eventpoll.c: In function 'eventpoll_init':
include/linux/compiler.h:321:20: error: call to '__compiletime_assert_2137' declared with attribute error: BUILD_BUG_ON failed: sizeof(void *) <= 8 && sizeof(struct epitem) > 128
    prefix ## suffix();    \

The check to make sure that the 'struct epitem' was actually linked via
epi->fllink was added to avoid having the list removal primitives called twice
for the same 'struct epitem'. However, the double call possibility was removed
by 'Subject: epoll: optimize EPOLL_CTL_DEL using rcu'. There, the call to
'list_del_init()' in eventpoll_release_file() was removed (we now rely on the
list delete happening entirely in 'ep_remove()', which is called from
eventpoll_release_file()).

There is also the question as to whether multiple ep_remove() calls could
happen concurrently. This can not happen since EPOLL_CTL_DEL can't
race with eventpoll_release_file() or ep_free() - it has to do an fget()
to proceed. Further, eventpoll_release_file() can not race with ep_free(),
since they both acquire the 'epmutex'.

Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 fs/eventpoll.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 755bda0..69de7a6 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -171,9 +171,6 @@ struct epitem {
 
 	/* The structure that describe the interested events and the source fd */
 	struct epoll_event event;
-
-	/* The fllink is in use. Since rcu can't do 'list_del_init()' */
-	int on_list;
 };
 
 /*
@@ -710,10 +707,7 @@ static int ep_remove(struct eventpoll *ep, struct epitem *epi)
 
 	/* Remove the current item from the list of epoll hooks */
 	spin_lock(&file->f_lock);
-	if (epi->on_list) {
-		list_del_rcu(&epi->fllink);
-		epi->on_list = 0;
-	}
+	list_del_rcu(&epi->fllink);
 	spin_unlock(&file->f_lock);
 
 	rb_erase(&epi->rbn, &ep->rbr);
@@ -1295,7 +1289,6 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	epi->event = *event;
 	epi->nwait = 0;
 	epi->next = EP_UNACTIVE_PTR;
-	epi->on_list = 0;
 	if (epi->event.events & EPOLLWAKEUP) {
 		error = ep_create_wakeup_source(epi);
 		if (error)
@@ -1329,7 +1322,6 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 	/* Add the current item to the list of active epoll hook for this file */
 	spin_lock(&tfile->f_lock);
 	list_add_tail_rcu(&epi->fllink, &tfile->f_ep_links);
-	epi->on_list = 1;
 	spin_unlock(&tfile->f_lock);
 
 	/*
@@ -1370,8 +1362,7 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
 
 error_remove_epi:
 	spin_lock(&tfile->f_lock);
-	if (epi->on_list)
-		list_del_rcu(&epi->fllink);
+	list_del_rcu(&epi->fllink);
 	spin_unlock(&tfile->f_lock);
 
 	rb_erase(&epi->rbn, &ep->rbr);
-- 
1.8.2

