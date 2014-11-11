Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaKKLXh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:23:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57793 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754370AbaKKLLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:11:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 138/170] ALSA: pcm: Zero-clear reserved fields of PCM status ioctl in compat mode
Date: Tue, 11 Nov 2014 11:08:17 +0000
Message-Id: <1415704129-12709-139-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 317168d0c766defd14b3d0e9c2c4a9a258b803ee upstream.

In compat mode, we copy each field of snd_pcm_status struct but don't
touch the reserved fields, and this leaves uninitialized values
there.  Meanwhile the native ioctl does zero-clear the whole
structure, so we should follow the same rule in compat mode, too.

Reported-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/core/pcm_compat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/core/pcm_compat.c b/sound/core/pcm_compat.c
index af49721ba0e3..c4ac3c1e19af 100644
--- a/sound/core/pcm_compat.c
+++ b/sound/core/pcm_compat.c
@@ -206,6 +206,8 @@ static int snd_pcm_status_user_compat(struct snd_pcm_substream *substream,
 	if (err < 0)
 		return err;
 
+	if (clear_user(src, sizeof(*src)))
+		return -EFAULT;
 	if (put_user(status.state, &src->state) ||
 	    compat_put_timespec(&status.trigger_tstamp, &src->trigger_tstamp) ||
 	    compat_put_timespec(&status.tstamp, &src->tstamp) ||
-- 
2.1.0

