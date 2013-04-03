Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762861Ab3DCO72 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:59:28 -0400
Received: from bender.cm4all.net ([87.106.27.49]:39916 "EHLO bender.cm4all.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760724Ab3DCO70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:59:26 -0400
X-Greylist: delayed 596 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Apr 2013 10:59:26 EDT
Subject: [PATCH] fscache: extended "dying" check before emitting
 EV_INVALIDATE
To: dhowells@redhat.com, linux-cachefs@redhat.com
From: Max Kellermann <mk@cm4all.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 03 Apr 2013 16:48:57 +0200
Message-ID: <20130403144857.22351.67546.stgit@rabbit.intern.cm-ag>
User-Agent: StGit/0.16-39-g0831
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before emitting an FSCACHE_OBJECT_EV_INVALIDATE event, the function
__fscache_invalidate() checks whether the fscache_object is currently
"dying".  This checks only the current state, not the queued events
that will very soon lead to the object's death.

The problem is that fscache_object_state_machine() will
BUG("Unsupported event") when there is object->events includes
EV_INVALIDATE during "terminal_transit".  Even if we would ignore that
check, we could run into "Unexpected event in dead state" later
because object->work may still be queued.

The solution is to check for EV_RETIRE and EV_RELEASE; if one of those
two terminal events is already queued, don't bother to queue
EV_INVALIDATE.

Signed-off-by: Max Kellermann <mk@cm4all.com>
---
 fs/fscache/cookie.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
index 8dcb114..ed80d7f 100644
--- a/fs/fscache/cookie.c
+++ b/fs/fscache/cookie.c
@@ -402,7 +402,8 @@ void __fscache_invalidate(struct fscache_cookie *cookie)
 			object = hlist_entry(cookie->backing_objects.first,
 					     struct fscache_object,
 					     cookie_link);
-			if (object->state < FSCACHE_OBJECT_DYING)
+			if (object->state < FSCACHE_OBJECT_DYING &&
+			    (object->events & (FSCACHE_OBJECT_EV_RETIRE|FSCACHE_OBJECT_EV_RELEASE)) == 0)
 				fscache_raise_event(
 					object, FSCACHE_OBJECT_EV_INVALIDATE);
 		}

