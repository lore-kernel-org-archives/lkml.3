Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753775AbaFDXXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:23:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40569 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbaFDXXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:23:23 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.14 228/228] media: V4L2: fix VIDIOC_CREATE_BUFS in 64- / 32-bit compatibility mode
Date: Wed,  4 Jun 2014 16:24:17 -0700
Message-Id: <20140604232355.369021069@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

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
@@ -204,17 +207,16 @@ static int __get_v4l2_format32(struct v4
 
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
 


