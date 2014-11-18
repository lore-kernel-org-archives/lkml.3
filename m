Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932105AbaKROJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:09:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754930AbaKROJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:35 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 072/206] ALSA: pcm: Zero-clear reserved fields of PCM status ioctl in compat mode
Date: Tue, 18 Nov 2014 15:07:07 +0100
Message-Id: <12f36730da98ee45a2e16bff0122b3357291f7d6.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 317168d0c766defd14b3d0e9c2c4a9a258b803ee upstream.

In compat mode, we copy each field of snd_pcm_status struct but don't
touch the reserved fields, and this leaves uninitialized values
there.  Meanwhile the native ioctl does zero-clear the whole
structure, so we should follow the same rule in compat mode, too.

Reported-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.1.3

