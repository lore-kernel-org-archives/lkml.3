Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab3LZWDz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 17:03:55 -0500
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:23758 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752140Ab3LZWDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 17:03:54 -0500
To: akpm@linux-foundation.org, torvalds@linux-foundation.org
Cc: paulmck@linux.vnet.ibm.com, normalperson@yhbt.net, nzimmer@sgi.com,
        viro@zeniv.linux.org.uk, nelhage@nelhage.com, davidel@xmailserver.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
From: Jason Baron <jbaron@akamai.com>
Subject: [PATCH] epoll: Do not take the nested ep->mtx on EPOLL_CTL_DEL
Message-Id: <20131226220353.254A9FE054@prod-mail-relay02.akamai.com>
Date: Thu, 26 Dec 2013 22:03:53 +0000 (GMT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EPOLL_CTL_DEL path of epoll contains a classic, ab-ba deadlock. That is,
epoll_ctl(a, EPOLL_CTL_DEL, b, x), will deadlock with epoll_ctl(b,
EPOLL_CTL_DEL, a, x). The deadlock was introduced with commmit 67347fe4e6326
(epoll: do not take global 'epmutex' for simple topologies).

The acquistion of the ep->mtx for the destination 'ep' was added such that a
concurrent EPOLL_CTL_ADD operation would see the correct state of the ep.
(Specifically, the check for '!list_empty(&f.file->f_ep_links'.)
However, by simply not acquiring the lock, we do not serialize behind
the ep->mtx from the add path, and thus may perform a full path check when if we
had waited a little longer it may not have been necessary. However, this is a
transient state, and performing the full loop checking in this case is not
harmful.

The important point is that we wouldn't miss doing the full loop checking when
required, since EPOLL_CTL_ADD always locks any 'ep's that its operating upon.
The reason we don't need to do lock ordering in the add path, is that
we are already are holding the global 'epmutex' whenever we do the
double lock. Further, the original posting of this patch, which was tested
for the intended performance gains, did not perform this additional locking.

Signed-off-by: Jason Baron <jbaron@akamai.com>
---
 fs/eventpoll.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 8b5e258..af90312 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1907,10 +1907,6 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, int, op, int, fd,
 			}
 		}
 	}
-	if (op == EPOLL_CTL_DEL && is_file_epoll(tf.file)) {
-		tep = tf.file->private_data;
-		mutex_lock_nested(&tep->mtx, 1);
-	}
 
 	/*
 	 * Try to lookup the file inside our RB tree, Since we grabbed "mtx"
-- 
1.8.2

