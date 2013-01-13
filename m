Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab3AMRse (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 12:48:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35103 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754900Ab3AMRpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 12:45:45 -0500
Message-Id: <20130113174302.452380110@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 13 Jan 2013 17:43:27 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric Wong <normalperson@yhbt.net>,
        Hans Verkuil <hans.verkuil@cisco.com>, Jiri Olsa <jolsa@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, Al Viro <viro@zeniv.linux.org.uk>,
        Davide Libenzi <davidel@xmailserver.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andreas Voellmy <andreas.voellmy@yale.edu>,
        "Junchang(Jason) Wang" <junchang.wang@yale.edu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 32/49] epoll: prevent missed events on EPOLL_CTL_MOD
In-Reply-To: <20130113174255.736888844@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Wong <normalperson@yhbt.net>

commit 128dd1759d96ad36c379240f8b9463e8acfd37a1 upstream.

EPOLL_CTL_MOD sets the interest mask before calling f_op->poll() to
ensure events are not missed.  Since the modifications to the interest
mask are not protected by the same lock as ep_poll_callback, we need to
ensure the change is visible to other CPUs calling ep_poll_callback.

We also need to ensure f_op->poll() has an up-to-date view of past
events which occured before we modified the interest mask.  So this
barrier also pairs with the barrier in wq_has_sleeper().

This should guarantee either ep_poll_callback or f_op->poll() (or both)
will notice the readiness of a recently-ready/modified item.

This issue was encountered by Andreas Voellmy and Junchang(Jason) Wang in:
http://thread.gmane.org/gmane.linux.kernel/1408782/

Signed-off-by: Eric Wong <normalperson@yhbt.net>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: David Miller <davem@davemloft.net>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Voellmy <andreas.voellmy@yale.edu>
Tested-by: "Junchang(Jason) Wang" <junchang.wang@yale.edu>
Cc: netdev@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/eventpoll.c |   22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1197,10 +1197,30 @@ static int ep_modify(struct eventpoll *e
 	 * otherwise we might miss an event that happens between the
 	 * f_op->poll() call and the new event set registering.
 	 */
-	epi->event.events = event->events;
+	epi->event.events = event->events; /* need barrier below */
 	epi->event.data = event->data; /* protected by mtx */
 
 	/*
+	 * The following barrier has two effects:
+	 *
+	 * 1) Flush epi changes above to other CPUs.  This ensures
+	 *    we do not miss events from ep_poll_callback if an
+	 *    event occurs immediately after we call f_op->poll().
+	 *    We need this because we did not take ep->lock while
+	 *    changing epi above (but ep_poll_callback does take
+	 *    ep->lock).
+	 *
+	 * 2) We also need to ensure we do not miss _past_ events
+	 *    when calling f_op->poll().  This barrier also
+	 *    pairs with the barrier in wq_has_sleeper (see
+	 *    comments for wq_has_sleeper).
+	 *
+	 * This barrier will now guarantee ep_poll_callback or f_op->poll
+	 * (or both) will notice the readiness of an item.
+	 */
+	smp_mb();
+
+	/*
 	 * Get current event bits. We can safely use the file* here because
 	 * its usage count has been increased by the caller of this function.
 	 */


