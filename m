Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab3JCVu5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 17:50:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873Ab3JCVu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 17:50:56 -0400
Date: Thu, 3 Oct 2013 14:50:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Baron <jbaron@akamai.com>
Cc: normalperson@yhbt.net, nzimmer@sgi.com, viro@zeniv.linux.org.uk,
        nelhage@nelhage.com, davidel@xmailserver.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] epoll: Do not take global 'epmutex' for simple
 topologies
Message-Id: <20131003145054.efcf3f4ffc64abcc7e09a87f@linux-foundation.org>
In-Reply-To: <355cdd8dc79b7bcca59509999a972cc9d6b4b673.1380645717.git.jbaron@akamai.com>
References: <cover.1380645717.git.jbaron@akamai.com>
	<355cdd8dc79b7bcca59509999a972cc9d6b4b673.1380645717.git.jbaron@akamai.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  1 Oct 2013 17:08:14 +0000 (GMT) Jason Baron <jbaron@akamai.com> wrote:

> When calling EPOLL_CTL_ADD for an epoll file descriptor that is attached
> directly to a wakeup source, we do not need to take the global 'epmutex',
> unless the epoll file descriptor is nested. The purpose of taking
> the 'epmutex' on add is to prevent complex topologies such as loops and
> deep wakeup paths from forming in parallel through multiple EPOLL_CTL_ADD
> operations. However, for the simple case of an epoll file descriptor
> attached directly to a wakeup source (with no nesting), we do not need
> to hold the 'epmutex'.
> 
> This patch along with 'epoll: optimize EPOLL_CTL_DEL using rcu' improves
> scalability on larger systems. Quoting Nathan Zimmer's mail on SPECjbb
> performance:
> 
> "
> On the 16 socket run the performance went from 35k jOPS to 125k jOPS.
> In addition the benchmark when from scaling well on 10 sockets to scaling well
> on just over 40 sockets.
> 
> ...
> 
> Currently the benchmark stops scaling at around 40-44 sockets but it seems like
> I found a second unrelated bottleneck.
> "

I couldn't resist fiddling.  Please review:

From: Andrew Morton <akpm@linux-foundation.org>
Subject: epoll-do-not-take-global-epmutex-for-simple-topologies-fix

- use `bool' for boolean variables
- remove unneeded/undesirable cast of void*
- add missed ep_scan_ready_list() kerneldoc 

Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Eric Wong <normalperson@yhbt.net>
Cc: Jason Baron <jbaron@akamai.com>
Cc: Nathan Zimmer <nzimmer@sgi.com>
Cc: Nelson Elhage <nelhage@nelhage.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff -puN fs/eventpoll.c~epoll-do-not-take-global-epmutex-for-simple-topologies-fix fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-do-not-take-global-epmutex-for-simple-topologies-fix
+++ a/fs/eventpoll.c
@@ -589,13 +589,14 @@ static inline void ep_pm_stay_awake_rcu(
  * @sproc: Pointer to the scan callback.
  * @priv: Private opaque data passed to the @sproc callback.
  * @depth: The current depth of recursive f_op->poll calls.
+ * @ep_locked: caller already holds ep->mtx
  *
  * Returns: The same integer error code returned by the @sproc callback.
  */
 static int ep_scan_ready_list(struct eventpoll *ep,
 			      int (*sproc)(struct eventpoll *,
 					   struct list_head *, void *),
-			      void *priv, int depth, int ep_locked)
+			      void *priv, int depth, bool ep_locked)
 {
 	int error, pwake = 0;
 	unsigned long flags;
@@ -836,12 +837,12 @@ static void ep_ptable_queue_proc(struct
 
 struct readyevents_arg {
 	struct eventpoll *ep;
-	int locked;
+	bool locked;
 };
 
 static int ep_poll_readyevents_proc(void *priv, void *cookie, int call_nests)
 {
-	struct readyevents_arg *arg = (struct readyevents_arg *)priv;
+	struct readyevents_arg *arg = priv;
 
 	return ep_scan_ready_list(arg->ep, ep_read_events_proc, NULL,
 				  call_nests + 1, arg->locked);
@@ -857,7 +858,7 @@ static unsigned int ep_eventpoll_poll(st
 	 * During ep_insert() we already hold the ep->mtx for the tfile.
 	 * Prevent re-aquisition.
 	 */
-	arg.locked = ((wait && (wait->_qproc == ep_ptable_queue_proc)) ? 1 : 0);
+	arg.locked = wait && (wait->_qproc == ep_ptable_queue_proc);
 	arg.ep = ep;
 
 	/* Insert inside our poll wait queue */
@@ -1563,7 +1564,7 @@ static int ep_send_events(struct eventpo
 	esed.maxevents = maxevents;
 	esed.events = events;
 
-	return ep_scan_ready_list(ep, ep_send_events_proc, &esed, 0, 0);
+	return ep_scan_ready_list(ep, ep_send_events_proc, &esed, 0, false);
 }
 
 static inline struct timespec ep_set_mstimeout(long ms)
_

