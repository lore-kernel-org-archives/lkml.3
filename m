Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934408Ab3CNDJD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 23:09:03 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:50996 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932743Ab3CNDJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 23:09:01 -0400
Date: Thu, 14 Mar 2013 03:09:00 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        NeilBrown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH mm] epoll: lock ep->mtx in ep_free to silence lockdep
Message-ID: <20130314030900.GA30154@dcvr.yhbt.net>
References: <20130307112639.GA25130@dcvr.yhbt.net>
 <20130308013027.GA31830@dcvr.yhbt.net>
 <CAMP5Xgdsam2DGLshL5Uu5Q4La_nAq=u1YRNBwAxDstgCvJiqfw@mail.gmail.com>
 <20130308204944.GA27379@dcvr.yhbt.net>
 <CAMP5Xgc4-oX=-V57Mu5PARCWdfpkjck0VnZNAXH-JisvKi5tAg@mail.gmail.com>
 <20130309071037.GA13360@dcvr.yhbt.net>
 <20130310011136.GA4815@dcvr.yhbt.net>
 <1362891577.4051.21.camel@edumazet-glaptop>
 <20130310115028.GB16551@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130310115028.GB16551@dcvr.yhbt.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Technically we do not need to hold ep->mtx during ep_free since we are
certain there are no other users of ep at that point.  However, lockdep
complains with a "suspicious rcu_dereference_check() usage!" message;
so lock the mutex before ep_remove to silence the warning.

Signed-off-by: Eric Wong <normalperson@yhbt.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Davide Libenzi <davidel@xmailserver.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: NeilBrown <neilb@suse.de>,
Cc: Rafael J. Wysocki <rjw@sisk.pl>
---
  I considered using lockdep_off()/lockdep_on(), but I figure that may
  hide other bugs...

 fs/eventpoll.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 633e69f..d71b754 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -745,11 +745,15 @@ static void ep_free(struct eventpoll *ep)
 	 * point we are sure no poll callbacks will be lingering around, and also by
 	 * holding "epmutex" we can be sure that no file cleanup code will hit
 	 * us during this operation. So we can avoid the lock on "ep->lock".
+	 * We do not need to lock ep->mtx, either, we only do it to prevent
+	 * a lockdep warning.
 	 */
+	mutex_lock(&ep->mtx);
 	while ((rbp = rb_first(&ep->rbr)) != NULL) {
 		epi = rb_entry(rbp, struct epitem, rbn);
 		ep_remove(ep, epi);
 	}
+	mutex_unlock(&ep->mtx);
 
 	mutex_unlock(&epmutex);
 	mutex_destroy(&ep->mtx);
-- 
Eric Wong
