Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab3JCGTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:19:20 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41560 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab3JCGTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:19:17 -0400
Date: Thu, 03 Oct 2013 07:19:16 +0100
To: torvalds@linux-foundation.org
Subject: [PATCH 11/17] don't bother with vfsmount_lock in mounts_poll()
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VRcFo-0008Bn-Ah@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


wake_up_interruptible/poll_wait provide sufficient barriers;
just use ACCESS_ONCE() to fetch ns->event and that's it.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/proc_namespace.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/proc_namespace.c b/fs/proc_namespace.c
index 5fe34c3..439406e 100644
--- a/fs/proc_namespace.c
+++ b/fs/proc_namespace.c
@@ -20,15 +20,15 @@ static unsigned mounts_poll(struct file *file, poll_table *wait)
 	struct proc_mounts *p = proc_mounts(file->private_data);
 	struct mnt_namespace *ns = p->ns;
 	unsigned res = POLLIN | POLLRDNORM;
+	int event;
 
 	poll_wait(file, &p->ns->poll, wait);
 
-	br_read_lock(&vfsmount_lock);
-	if (p->m.poll_event != ns->event) {
-		p->m.poll_event = ns->event;
+	event = ACCESS_ONCE(ns->event);
+	if (p->m.poll_event != event) {
+		p->m.poll_event = event;
 		res |= POLLERR | POLLPRI;
 	}
-	br_read_unlock(&vfsmount_lock);
 
 	return res;
 }
-- 
1.7.2.5


