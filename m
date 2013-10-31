Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab3JaXUf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 19:20:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34923 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3JaXUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 19:20:20 -0400
Date: Thu, 31 Oct 2013 16:20:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jason Baron <jbaron@akamai.com>, paulmck@linux.vnet.ibm.com,
        normalperson@yhbt.net, nzimmer@sgi.com, viro@zeniv.linux.org.uk,
        nelhage@nelhage.com, davidel@xmailserver.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] epoll: remove the on_list check for 'struct epitem'
Message-Id: <20131031162019.aeb38873819cbbc78f7e8948@linux-foundation.org>
In-Reply-To: <20131101100912.1d83667289bcca24c882b109@canb.auug.org.au>
References: <20131030183241.AE8201FF9@prod-mail-relay06.akamai.com>
	<20131101100912.1d83667289bcca24c882b109@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Nov 2013 10:09:12 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> On Wed, 30 Oct 2013 18:32:41 +0000 (GMT) Jason Baron <jbaron@akamai.com> wrote:
> >
> > By removing the 'int on_list' field from 'struct epitem', we avoid hitting the
> > BUILD_BUG_ON() for 'struct epitem' being larger than 128 bytes.
> > 
> > In file included from include/linux/init.h:4:0,
> >                  from fs/eventpoll.c:14:
> > fs/eventpoll.c: In function 'eventpoll_init':
> > include/linux/compiler.h:321:20: error: call to '__compiletime_assert_2137' declared with attribute error: BUILD_BUG_ON failed: sizeof(void *) <= 8 && sizeof(struct epitem) > 128
> >     prefix ## suffix();    \
> > 
> > The check to make sure that the 'struct epitem' was actually linked via
> > epi->fllink was added to avoid having the list removal primitives called twice
> > for the same 'struct epitem'. However, the double call possibility was removed
> > by 'Subject: epoll: optimize EPOLL_CTL_DEL using rcu'. There, the call to
> > 'list_del_init()' in eventpoll_release_file() was removed (we now rely on the
> > list delete happening entirely in 'ep_remove()', which is called from
> > eventpoll_release_file()).
> > 
> > There is also the question as to whether multiple ep_remove() calls could
> > happen concurrently. This can not happen since EPOLL_CTL_DEL can't
> > race with eventpoll_release_file() or ep_free() - it has to do an fget()
> > to proceed. Further, eventpoll_release_file() can not race with ep_free(),
> > since they both acquire the 'epmutex'.
> > 
> > Signed-off-by: Jason Baron <jbaron@akamai.com>
> 
> Do you want me to put this in my copy of the mmotm instead of reverting
> these three?
> 
> epoll-do-not-take-global-epmutex-for-simple-topologies-fix
> epoll: do not take global 'epmutex' for simple topologies
> epoll: optimize EPOLL_CTL_DEL using rcu

Sure.  Here's my epoll-optimize-epoll_ctl_del-using-rcu-fix.patch:

From: Jason Baron <jbaron@akamai.com>
Subject: epoll: remove the on_list check for 'struct epitem'

By removing the 'int on_list' field from 'struct epitem', we avoid hitting
the BUILD_BUG_ON() for 'struct epitem' being larger than 128 bytes.

In file included from include/linux/init.h:4:0,
                 from fs/eventpoll.c:14:
fs/eventpoll.c: In function 'eventpoll_init':
include/linux/compiler.h:321:20: error: call to '__compiletime_assert_2137' declared with attribute error: BUILD_BUG_ON failed: sizeof(void *) <= 8 && sizeof(struct epitem) > 128
    prefix ## suffix();    \

The check to make sure that the 'struct epitem' was actually linked via
epi->fllink was added to avoid having the list removal primitives called
twice for the same 'struct epitem'.  However, the double call possibility
was removed by 'Subject: epoll: optimize EPOLL_CTL_DEL using rcu'.  There,
the call to 'list_del_init()' in eventpoll_release_file() was removed (we
now rely on the list delete happening entirely in 'ep_remove()', which is
called from eventpoll_release_file()).

There is also the question as to whether multiple ep_remove() calls could
happen concurrently.  This can not happen since EPOLL_CTL_DEL can't race
with eventpoll_release_file() or ep_free() - it has to do an fget() to
proceed.  Further, eventpoll_release_file() can not race with ep_free(),
since they both acquire the 'epmutex'.

Signed-off-by: Jason Baron <jbaron@akamai.com>
Reported-by: Wu Fengguang <fengguang.wu@intel.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Eric Wong <normalperson@yhbt.net>
Cc: Nelson Elhage <nelhage@nelhage.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff -puN fs/eventpoll.c~epoll-optimize-epoll_ctl_del-using-rcu-fix fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-optimize-epoll_ctl_del-using-rcu-fix
+++ a/fs/eventpoll.c
@@ -171,9 +171,6 @@ struct epitem {
 
 	/* The structure that describe the interested events and the source fd */
 	struct epoll_event event;
-
-	/* The fllink is in use. Since rcu can't do 'list_del_init()' */
-	int on_list;
 };
 
 /*
@@ -707,10 +704,7 @@ static int ep_remove(struct eventpoll *e
 
 	/* Remove the current item from the list of epoll hooks */
 	spin_lock(&file->f_lock);
-	if (epi->on_list) {
-		list_del_rcu(&epi->fllink);
-		epi->on_list = 0;
-	}
+	list_del_rcu(&epi->fllink);
 	spin_unlock(&file->f_lock);
 
 	rb_erase(&epi->rbn, &ep->rbr);
@@ -1273,7 +1267,6 @@ static int ep_insert(struct eventpoll *e
 	epi->event = *event;
 	epi->nwait = 0;
 	epi->next = EP_UNACTIVE_PTR;
-	epi->on_list = 0;
 	if (epi->event.events & EPOLLWAKEUP) {
 		error = ep_create_wakeup_source(epi);
 		if (error)
@@ -1307,7 +1300,6 @@ static int ep_insert(struct eventpoll *e
 	/* Add the current item to the list of active epoll hook for this file */
 	spin_lock(&tfile->f_lock);
 	list_add_tail_rcu(&epi->fllink, &tfile->f_ep_links);
-	epi->on_list = 1;
 	spin_unlock(&tfile->f_lock);
 
 	/*
@@ -1348,8 +1340,7 @@ static int ep_insert(struct eventpoll *e
 
 error_remove_epi:
 	spin_lock(&tfile->f_lock);
-	if (epi->on_list)
-		list_del_rcu(&epi->fllink);
+	list_del_rcu(&epi->fllink);
 	spin_unlock(&tfile->f_lock);
 
 	rb_erase(&epi->rbn, &ep->rbr);
_

