Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab3DWLlZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 07:41:25 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:65108 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab3DWLlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 07:41:23 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: question about buffer_busy check
User-Agent: Notmuch/0.6.1 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
CC: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 23 Apr 2013 15:41:18 +0400
Message-ID: <8738uh5va9.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=


Hi,
Can anyone please justify me the logic of fs/bufferc.c:buffer_busy()
How can we perform bit-wise operation for ->b_count and ->b_state?
 static inline int buffer_busy(struct buffer_head *bh)
 {
       return atomic_read(&bh->b_count) |
                (bh->b_state & ((1 << BH_Dirty) | (1 << BH_Lock)));
 }

I try to digg inside git/cvs history and it is appeared that 2.4 was
also implemented like this. At least it was so in 2000'th
http://lkml.indiana.edu/hypermail/linux/kernel/0006.0/0412.html
Also I've found similar complain
http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg24377.html
But seems nobody care about it. What's the point?
The only guess I have is that this is a miss typo  because buffer
is busy if some one hold an reference (bh->b_count !=0 )  ||
it is (dirty | locked). So following patch should fix 

--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline; filename=0001-buffer-fix-miss-typo.patch

>From dc45e525b647ed11f26781b80eed3894cc3ba325 Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Tue, 23 Apr 2013 15:24:24 +0400
Subject: [PATCH] buffer: fix miss typo


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 fs/buffer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index b4dcb34..4ffa6c9 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3119,7 +3119,7 @@ EXPORT_SYMBOL(sync_dirty_buffer);
  */
 static inline int buffer_busy(struct buffer_head *bh)
 {
-	return atomic_read(&bh->b_count) |
+	return atomic_read(&bh->b_count) ||
 		(bh->b_state & ((1 << BH_Dirty) | (1 << BH_Lock)));
 }
 
-- 
1.7.1


--=-=-=--
