Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765085Ab3DKU2l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:28:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:16931 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755182Ab3DKU0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:19 -0400
X-Authority-Analysis: v=2.0 cv=F+XVh9dN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=xKA1wkDHLesA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=v1gATnWItg4A:10 a=tmtSDGaQAAAA:8 a=20KFwNOVAAAA:8 a=omOdbC7AAAAA:8 a=PtDNVHqPAAAA:8 a=drOt6m5kAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=JTmAh97Rboax8_7udQAA:9 a=jkObVMfX7fAA:10 a=jEp0ucaQiEUA:10 a=wYE_KDyynt4A:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202553.690236908@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Vladimir Davydov <vdavydov@parallels.com>,
        Doug Ledford <dledford@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [ 046/171 ] mqueue: sys_mq_open: do not call mnt_drop_write() if read-only
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0046-mqueue-sys_mq_open-do-not-call-mnt_drop_write-if-rea.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Vladimir Davydov <vdavydov@parallels.com>

[ Upstream commit 38d78e587d4960d0db94add518d27ee74bad2301 ]

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
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 ipc/mqueue.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 9a08acc..9e4cf7f 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -841,7 +841,8 @@ out_putfd:
 		fd = error;
 	}
 	mutex_unlock(&root->d_inode->i_mutex);
-	mnt_drop_write(mnt);
+	if (!ro)
+		mnt_drop_write(mnt);
 out_putname:
 	putname(name);
 	return fd;
-- 
1.7.10.4


