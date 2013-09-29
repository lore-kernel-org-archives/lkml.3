Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533Ab3I2UGp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 16:06:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59153 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232Ab3I2T1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:27:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Boyd Yang <boyd.yang@gmail.com>,
        Lino Sanfilippo <LinoSanfilipp@gmx.de>, Eric Paris <eparis@redhat.com>,
        =?UTF-8?q?Mihai=20Don=C8=9Bu?= <mihai.dontu@gmail.com>
Subject: [ 14/17] fanotify: dont merge permission events
Date: Sun, 29 Sep 2013 12:26:53 -0700
Message-Id: <20130929190758.113469341@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929190757.138351117@linuxfoundation.org>
References: <20130929190757.138351117@linuxfoundation.org>
User-Agent: quilt/0.60-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Mihai Donțu <mihai.dontu@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/notify/fanotify/fanotify.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -18,6 +18,12 @@ static bool should_merge(struct fsnotify
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


