Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964944AbbA1EXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:23:24 -0500
Received: from mail.kernel.org ([198.145.29.136]:40309 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934403AbbA1EXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:23:20 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 108/177] ALSA: pcm: Zero-clear reserved fields of PCM status ioctl in compat mode
Date: Wed, 28 Jan 2015 12:09:26 +0800
Message-Id: <1422418236-12852-199-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 317168d0c766defd14b3d0e9c2c4a9a258b803ee upstream.

In compat mode, we copy each field of snd_pcm_status struct but don't
touch the reserved fields, and this leaves uninitialized values
there.  Meanwhile the native ioctl does zero-clear the whole
structure, so we should follow the same rule in compat mode, too.

Reported-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 sound/core/pcm_compat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/core/pcm_compat.c b/sound/core/pcm_compat.c
index 91cdf94..4dbb66e 100644
--- a/sound/core/pcm_compat.c
+++ b/sound/core/pcm_compat.c
@@ -204,6 +204,8 @@ static int snd_pcm_status_user_compat(struct snd_pcm_substream *substream,
 	if (err < 0)
 		return err;
 
+	if (clear_user(src, sizeof(*src)))
+		return -EFAULT;
 	if (put_user(status.state, &src->state) ||
 	    put_user(status.trigger_tstamp.tv_sec, &src->trigger_tstamp.tv_sec) ||
 	    put_user(status.trigger_tstamp.tv_nsec, &src->trigger_tstamp.tv_nsec) ||
-- 
1.9.1

