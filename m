Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbaKFWkf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:40:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58649 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609AbaKFWk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:40:26 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 141/162] ALSA: pcm: Zero-clear reserved fields of PCM status ioctl in compat mode
Date: Thu,  6 Nov 2014 14:36:45 -0800
Message-Id: <1415313426-9622-142-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 317168d0c766defd14b3d0e9c2c4a9a258b803ee upstream.

In compat mode, we copy each field of snd_pcm_status struct but don't
touch the reserved fields, and this leaves uninitialized values
there.  Meanwhile the native ioctl does zero-clear the whole
structure, so we should follow the same rule in compat mode, too.

Reported-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/core/pcm_compat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/core/pcm_compat.c b/sound/core/pcm_compat.c
index af49721..c4ac3c1 100644
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
1.9.1

