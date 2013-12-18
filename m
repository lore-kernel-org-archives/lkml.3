Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab3LRV2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:28:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754263Ab3LRVNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:50 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Walls <awalls@md.metrocast.net>,
        Rajil Saraswat <rajil.s@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.12 075/118] media: wm8775: fix broken audio routing
Date: Wed, 18 Dec 2013 13:11:52 -0800
Message-Id: <20131218211221.573141917@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hans.verkuil@cisco.com>

commit 3af41a337a5b270de3e65466a07f106ad97ad0c6 upstream.

Commit 5aa9ae5ed5d449a85fbf7aac3d1fdc241c542a79 inverted the mute control
state test in s_routing which caused the audio routing to fail. This broke
ivtv support for the Hauppauge video/audio input bracket (which adds additional
video and audio inputs) all the way back in kernel 2.6.36.
This fix fixes the condition and it also removes a nonsense check on the
balance control.
Bisected-by: Rajil Saraswat <rajil.s@gmail.com>

Signed-off-by: Andy Walls <awalls@md.metrocast.net>
Reported-by: Rajil Saraswat <rajil.s@gmail.com>
Tested-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/i2c/wm8775.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/media/i2c/wm8775.c
+++ b/drivers/media/i2c/wm8775.c
@@ -130,12 +130,10 @@ static int wm8775_s_routing(struct v4l2_
 		return -EINVAL;
 	}
 	state->input = input;
-	if (!v4l2_ctrl_g_ctrl(state->mute))
+	if (v4l2_ctrl_g_ctrl(state->mute))
 		return 0;
 	if (!v4l2_ctrl_g_ctrl(state->vol))
 		return 0;
-	if (!v4l2_ctrl_g_ctrl(state->bal))
-		return 0;
 	wm8775_set_audio(sd, 1);
 	return 0;
 }


