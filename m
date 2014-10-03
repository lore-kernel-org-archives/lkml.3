Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932851AbaJCXeQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:34:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46349 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757356AbaJCWDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Subject: [PATCH 3.16 325/357] media: em28xx: fix VBI handling logic
Date: Fri,  3 Oct 2014 14:31:51 -0700
Message-Id: <20141003212943.229859240@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

commit c7854c2c5d692a329b4d9a9a73bcf36ae137ee7c upstream.

When both VBI and video are streaming, and video stream is stopped,
a subsequent trial to restart it will fail, because S_FMT will
return -EBUSY.

That prevents applications like zvbi to work properly.

Please notice that, while this fix it fully for zvbi, the
best is to get rid of streaming_users and res_get logic as a hole.

However, this single-line patch is better to be merged at -stable.

Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/em28xx/em28xx-video.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/usb/em28xx/em28xx-video.c
+++ b/drivers/media/usb/em28xx/em28xx-video.c
@@ -1344,7 +1344,7 @@ static int vidioc_s_fmt_vid_cap(struct f
 	struct em28xx *dev = video_drvdata(file);
 	struct em28xx_v4l2 *v4l2 = dev->v4l2;
 
-	if (v4l2->streaming_users > 0)
+	if (vb2_is_busy(&v4l2->vb_vidq))
 		return -EBUSY;
 
 	vidioc_try_fmt_vid_cap(file, priv, f);


