Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab3CZXgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:36:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52560 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754895Ab3CZWoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vladimir Davydov <vdavydov@parallels.com>,
        Doug Ledford <dledford@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 53/98] mqueue: sys_mq_open: do not call mnt_drop_write() if read-only
Date: Tue, 26 Mar 2013 15:42:42 -0700
Message-Id: <20130326224248.053323864@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Davydov <vdavydov@parallels.com>

commit 38d78e587d4960d0db94add518d27ee74bad2301 upstream.

mnt_drop_write() must be called only if mnt_want_write() succeeded,
otherwise the mnt_writers counter will diverge.

mnt_writers counters are used to check if remounting FS as read-only is
OK, so after an extra mnt_drop_write() call, it would be impossible to
remount mqueue FS as read-only.  Besides, on umount a warning would be
printed like this one:

  =====================================
  [ BUG: bad unlock balance detected! ]
  3.9.0-rc3 #5 Not tainted
  -------------------------------------
  a.out/12486 is trying to release lock (sb_writers) at:
  mnt_drop_write+0x1f/0x30
  but there are no more locks to release!

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 ipc/mqueue.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -840,7 +840,8 @@ out_putfd:
 		fd = error;
 	}
 	mutex_unlock(&root->d_inode->i_mutex);
-	mnt_drop_write(mnt);
+	if (!ro)
+		mnt_drop_write(mnt);
 out_putname:
 	putname(name);
 	return fd;


