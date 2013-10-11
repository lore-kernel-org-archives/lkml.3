Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab3JKKnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:43:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58685 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758012Ab3JKKnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:43:47 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lino Sanfilippo <LinoSanfilipp@gmx.de>, Eric Paris <eparis@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 067/100] fanotify: dont merge permission events
Date: Fri, 11 Oct 2013 11:41:37 +0100
Message-Id: <1381488130-30235-68-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/notify/fanotify/fanotify.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index a506360..0c2f912 100644
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
-- 
1.8.3.2

