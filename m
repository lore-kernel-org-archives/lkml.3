Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbaFIJgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:36:53 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933253AbaFIJ0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:26:44 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 142/146] media: V4L2: fix VIDIOC_CREATE_BUFS in 64- / 32-bit compatibility mode
Date: Mon,  9 Jun 2014 10:51:17 +0200
Message-Id: <953d7307f00ff6baed3ebf3bd40ca2bb4793b922.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 97d9d23dda6f37d90aefeec4ed619d52df525382 upstream.

If a struct contains 64-bit fields, it is aligned on 64-bit boundaries
within containing structs in 64-bit compilations. This is the case with
struct v4l2_window, which contains pointers and is embedded into struct
v4l2_format, and that one is embedded into struct v4l2_create_buffers.
Unlike some other structs, used as a part of the kernel ABI as ioctl()
arguments, that are packed, these structs aren't packed. This isn't a
problem per se, but the ioctl-compat code for VIDIOC_CREATE_BUFS contains
a bug, that triggers in such 64-bit builds. That code wrongly assumes,
that in struct v4l2_create_buffers, struct v4l2_format immediately follows
the __u32 memory field, which in fact isn't the case. This bug wasn't
visible until now, because until recently hardly any applications used
this ioctl() and mostly embedded 32-bit only drivers implemented it. This
is changing now with addition of this ioctl() to some USB drivers, e.g.
UVC. This patch fixes the bug by copying parts of struct
v4l2_create_buffers separately.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
index b63a5e584aa0..fca336b65351 100644
--- a/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
+++ b/drivers/media/v4l2-core/v4l2-compat-ioctl32.c
@@ -178,6 +178,9 @@ struct v4l2_create_buffers32 {
 
 static int __get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
 {
+	if (get_user(kp->type, &up->type))
+		return -EFAULT;
+
 	switch (kp->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
@@ -204,17 +207,16 @@ static int __get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __us
 
 static int get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
 {
-	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_format32)) ||
-			get_user(kp->type, &up->type))
-			return -EFAULT;
+	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_format32)))
+		return -EFAULT;
 	return __get_v4l2_format32(kp, up);
 }
 
 static int get_v4l2_create32(struct v4l2_create_buffers *kp, struct v4l2_create_buffers32 __user *up)
 {
 	if (!access_ok(VERIFY_READ, up, sizeof(struct v4l2_create_buffers32)) ||
-	    copy_from_user(kp, up, offsetof(struct v4l2_create_buffers32, format.fmt)))
-			return -EFAULT;
+	    copy_from_user(kp, up, offsetof(struct v4l2_create_buffers32, format)))
+		return -EFAULT;
 	return __get_v4l2_format32(&kp->format, &up->format);
 }
 
-- 
1.9.3

