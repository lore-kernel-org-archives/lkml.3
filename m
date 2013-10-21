Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662Ab3JUIxe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:53:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39886 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754516Ab3JUIxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:53:25 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Lino Sanfilippo" <LinoSanfilippo@gmx.de>,
        "Boyd Yang" <boyd.yang@gmail.com>, "Eric Paris" <eparis@redhat.com>,
        "Lino Sanfilippo" <LinoSanfilipp@gmx.de>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.177963512@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 135/149] fanotify: dont merge permission events
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Lino Sanfilippo <LinoSanfilippo@gmx.de>

commit 03a1cec1f17ac1a6041996b3e40f96b5a2f90e1b upstream.

Boyd Yang reported a problem for the case that multiple threads of the same
thread group are waiting for a reponse for a permission event.
In this case it is possible that some of the threads are never woken up, even
if the response for the event has been received
(see http://marc.info/?l=linux-kernel&m=131822913806350&w=2).

The reason is that we are currently merging permission events if they belong to
the same thread group. But we are not prepared to wake up more than one waiter
for each event. We do

wait_event(group->fanotify_data.access_waitq, event->response ||
			atomic_read(&group->fanotify_data.bypass_perm));
and after that
  event->response = 0;

which is the reason that even if we woke up all waiters for the same event
some of them may see event->response being already set 0 again, then go back to
sleep and block forever.

With this patch we avoid that more than one thread is waiting for a response
by not merging permission events for the same thread group any more.

Reported-by: Boyd Yang <boyd.yang@gmail.com>
Signed-off-by: Lino Sanfilippo <LinoSanfilipp@gmx.de>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/notify/fanotify/fanotify.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index f35794b..aeb5b5a 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -18,6 +18,12 @@ static bool should_merge(struct fsnotify_event *old, struct fsnotify_event *new)
 	    old->tgid == new->tgid) {
 		switch (old->data_type) {
 		case (FSNOTIFY_EVENT_PATH):
+#ifdef CONFIG_FANOTIFY_ACCESS_PERMISSIONS
+			/* dont merge two permission events */
+			if ((old->mask & FAN_ALL_PERM_EVENTS) &&
+			    (new->mask & FAN_ALL_PERM_EVENTS))
+				return false;
+#endif
 			if ((old->path.mnt == new->path.mnt) &&
 			    (old->path.dentry == new->path.dentry))
 				return true;

