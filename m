Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964895Ab3CTJZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 05:25:33 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:44776 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752082Ab3CTJZb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 05:25:31 -0400
Date: Wed, 20 Mar 2013 09:25:30 +0000
From: Eric Wong <normalperson@yhbt.net>
To: akpm@linux-foundation.org
Cc: arve@android.com, davidel@xmailserver.org, eric.dumazet@gmail.com,
        neilb@suse.de, oleg@redhat.com, rjw@sisk.pl, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: [PATCH mm] epoll: fix suspicious RCU usage in ep_poll_callback
Message-ID: <20130320092530.GA12277@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit "epoll: use RCU to protect wakeup_source in epitem"
introduced the ep_pm_stay_awake_rcu function for ep_poll_callback
use, but I left it unused on accident.  ep->mtx cannot be held in
ep_poll_callback, so RCU should be used here.

Signed-off-by: Eric Wong <normalperson@yhbt.net>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Oleg Nesterov <oleg@redhat.com>
---
  Oops :x

 fs/eventpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index a4e4ad7..a81f0ea 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1028,7 +1028,7 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
 	/* If this file is already in the ready list we exit soon */
 	if (!ep_is_linked(&epi->rdllink)) {
 		list_add_tail(&epi->rdllink, &ep->rdllist);
-		ep_pm_stay_awake(epi);
+		ep_pm_stay_awake_rcu(epi);
 	}
 
 	/*
-- 
Eric Wong

