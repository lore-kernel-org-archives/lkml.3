Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab3DVH56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 03:57:58 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:44292 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab3DVH55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 03:57:57 -0400
From: Dmitry Monakhov <dmonakhov@openvz.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] relay: move remove_buf_file inside relay_close_buf
User-Agent: Notmuch/0.6.1 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
CC: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk
Date: Mon, 22 Apr 2013 11:57:52 +0400
Message-ID: <87ppxnhu9r.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=


Hi, 
Let someone please finally take care of this patch.
Originally it was submitted here https://lkml.org/lkml/2010/2/28/103
This patch fix very annoying issue. I've got OK from Jens and Tom
Zanussi but no one accept it. MAINTAINERS file has no info about relayfs.
So I've added to CC all people which may be interested in that.


--=-=-=
Content-Type: text/x-patch
Content-Disposition: inline;
 filename=0001-relay-move-remove_buf_file-inside-relay_close_buf.patch

>From 1c0d96aece60a8a81c3f0cf1f681a5ff4333a2ff Mon Sep 17 00:00:00 2001
From: Dmitry Monakhov <dmonakhov@openvz.org>
Date: Mon, 22 Apr 2013 11:41:41 +0400
Subject: [PATCH] relay: move remove_buf_file inside relay_close_buf

Currently remove_buf_file callback is called from from kobject
release method. This result in follow issue:
# blktrace -d /dev/sda1 -d /dev/sda -o test

blktrace_setup()
 dir = create_dir()
 rchan = relay_open(dir,...)
 ->create_buf_file_callback
    buf_file  = debugfs_create_file(dir, )

Userspace will open buf_file.
Later we make a decision to stop tracing
blktrace_down()
  relay_close(rhcan)  /* just decrement kobj reference  */
                      /* since it is not zero then callback not called */
  debugfs_remove(dir) /* FAIL due to non empty dir   */

Later user space will close the file and file will be deleted,
but directory still exist.
user_space_close()
 ->file_release
   ->release_buf_file_callback
     ->debugfs_remove(buf_file
## TESTCASE:
# blktrace -d /dev/sda1 -d /dev/sda -o test
# After that blktrace infrastructure will remain broken in
# an unusable state so: blktrace -d /dev/sda1 will not work.

In fact this is general issue, blktrace is just one of examples.
We can not reliably remove parent dir until all users close the
buf_file.

Solution: We don't have to wait that long. File should be deleted inside
relay_close_buf().

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Acked-by : Jens Axboe <axboe@kernel.dk>

---
 kernel/relay.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/relay.c b/kernel/relay.c
index 01ab081..a0d2000 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -234,7 +234,6 @@ static void relay_destroy_buf(struct rchan_buf *buf)
 static void relay_remove_buf(struct kref *kref)
 {
 	struct rchan_buf *buf = container_of(kref, struct rchan_buf, kref);
-	buf->chan->cb->remove_buf_file(buf->dentry);
 	relay_destroy_buf(buf);
 }
 
@@ -484,6 +483,7 @@ static void relay_close_buf(struct rchan_buf *buf)
 {
 	buf->finalized = 1;
 	del_timer_sync(&buf->timer);
+	buf->chan->cb->remove_buf_file(buf->dentry);
 	kref_put(&buf->kref, relay_remove_buf);
 }
 
-- 
1.7.1


--=-=-=--
