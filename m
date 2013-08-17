Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab3HQPGk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 11:06:40 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:42473 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459Ab3HQPGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 11:06:39 -0400
Message-ID: <1376751997.21329.8.camel@edumazet-glaptop>
Subject: [PATCH] epoll: add a reschedule point in ep_free()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, edumazet@google.com,
        "Theodore Ts'o" <tytso@mit.edu>
Date: Sat, 17 Aug 2013 08:06:37 -0700
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

ep_free() might iterate on a huge set of epitems and hold
cpu too long. Add two cond_resched() in order to yield cpu
to other tasks. This is safe as we only hold mutexes in
this function.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Theodore Ts'o <tytso@mit.edu>
---
Google-Bug-Id: 8940884

 fs/eventpoll.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 9ad17b15..4ff595d 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -740,6 +740,7 @@ static void ep_free(struct eventpoll *ep)
 		epi = rb_entry(rbp, struct epitem, rbn);
 
 		ep_unregister_pollwait(ep, epi);
+		cond_resched();
 	}
 
 	/*
@@ -754,6 +755,7 @@ static void ep_free(struct eventpoll *ep)
 	while ((rbp = rb_first(&ep->rbr)) != NULL) {
 		epi = rb_entry(rbp, struct epitem, rbn);
 		ep_remove(ep, epi);
+		cond_resched();
 	}
 	mutex_unlock(&ep->mtx);
 



