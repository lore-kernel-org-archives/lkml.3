Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab3LSMXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:23:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45095 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919Ab3LSL6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:58:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Andy Walls <awalls@md.metrocast.net>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 137/208] [media] wm8775: fix broken audio routing
Date: Thu, 19 Dec 2013 11:53:55 +0000
Message-Id: <1387454106-19326-138-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/i2c/wm8775.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/media/i2c/wm8775.c b/drivers/media/i2c/wm8775.c
index 3f584a7..bee7946 100644
--- a/drivers/media/i2c/wm8775.c
+++ b/drivers/media/i2c/wm8775.c
@@ -130,12 +130,10 @@ static int wm8775_s_routing(struct v4l2_subdev *sd,
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
-- 
1.8.3.2

