Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752399Ab3J2WJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 18:09:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39230 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993Ab3J2WJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 18:09:40 -0400
Date: Tue, 29 Oct 2013 15:09:39 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org
Subject: [PATCH] sysfs: move assignment to be under lock in sysfs_remove_dir()
Message-ID: <20131029220939.GA23060@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Linus noticed that the assignment of sd isn't protected by the lock in
sysfs_remove_dir(), so move the assignment of the variable under the
lock to be safe.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Tejun, any objection to this patch?  You consolidated the locks back in
2007 on this function, and nothing has changed there since then, so odds
are it's not a problem, but nice to be safe, right?

 fs/sysfs/dir.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index eab59de4..2609f934 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -856,9 +856,10 @@ void sysfs_remove(struct sysfs_dirent *sd)
  */
 void sysfs_remove_dir(struct kobject *kobj)
 {
-	struct sysfs_dirent *sd = kobj->sd;
+	struct sysfs_dirent *sd;
 
 	spin_lock(&sysfs_assoc_lock);
+	sd = kobj->sd;
 	kobj->sd = NULL;
 	spin_unlock(&sysfs_assoc_lock);
 
