Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500AbaFGBnF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 21:43:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35992 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752564AbaFGBXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 21:23:37 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Mauro Carvalho Chehab" <m.chehab@samsung.com>,
        "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
        "Laurent Pinchart" <laurent.pinchart@ideasonboard.com>
Date: Sat, 07 Jun 2014 02:26:29 +0100
Message-ID: <lsq.1402104389.469833317@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 68/92] [media] V4L2: fix VIDIOC_CREATE_BUFS in 64- /
 32-bit compatibility mode
In-Reply-To: <lsq.1402104388.385007124@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.60-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/media/video/v4l2-compat-ioctl32.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/media/video/v4l2-compat-ioctl32.c
+++ b/drivers/media/video/v4l2-compat-ioctl32.c
@@ -178,6 +178,9 @@ struct v4l2_create_buffers32 {
 
 static int __get_v4l2_format32(struct v4l2_format *kp, struct v4l2_format32 __user *up)
 {
+	if (get_user(kp->type, &up->type))
+		return -EFAULT;
+
 	switch (kp->type) {
 	case V4L2_BUF_TYPE_VIDEO_CAPTURE:
 	case V4L2_BUF_TYPE_VIDEO_OUTPUT:
@@ -208,17 +211,16 @@ static int __get_v4l2_format32(struct v4
 
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
 

