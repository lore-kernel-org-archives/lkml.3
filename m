Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003AbaGVOLM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:11:12 -0400
Received: from smtp311.phy.lolipop.jp ([210.157.22.79]:38952 "EHLO
	smtp311.phy.lolipop.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963AbaGVOLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:11:11 -0400
From: Takashi Sakamoto <o-takashi@sakamocchi.jp>
To: clemens@ladisch.de, tiwai@suse.de, perex@perex.cz
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        darrena092@gmail.com, weiyj_lk@163.com
Subject: [PATCH 1/3] bebob: Fix a missing to unlock mutex in error handling case
Date: Tue, 22 Jul 2014 23:11:03 +0900
Message-Id: <1406038263-18558-1-git-send-email-o-takashi@sakamocchi.jp>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405831835-26499-1-git-send-email-weiyj_lk@163.com>
References: <1405831835-26499-1-git-send-email-weiyj_lk@163.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In error handling case, special_clk_ctl_put() returns without unlock_mutex(),
therefore the mutex is still locked. This commit moves mutex_lock() after
the error handling case.

This commit is my solution for this post.

[PATCH -next] ALSA: bebob: Fix missing unlock on error in special_clk_ctl_put()
https://lkml.org/lkml/2014/7/20/12

Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
---
 sound/firewire/bebob/bebob_maudio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/firewire/bebob/bebob_maudio.c b/sound/firewire/bebob/bebob_maudio.c
index 6af50eb..fc470c6 100644
--- a/sound/firewire/bebob/bebob_maudio.c
+++ b/sound/firewire/bebob/bebob_maudio.c
@@ -379,12 +379,12 @@ static int special_clk_ctl_put(struct snd_kcontrol *kctl,
 	struct special_params *params = bebob->maudio_special_quirk;
 	int err, id;
 
-	mutex_lock(&bebob->mutex);
-
 	id = uval->value.enumerated.item[0];
 	if (id >= ARRAY_SIZE(special_clk_labels))
 		return 0;
 
+	mutex_lock(&bebob->mutex);
+
 	err = avc_maudio_set_special_clk(bebob, id,
 					 params->dig_in_fmt,
 					 params->dig_out_fmt,
-- 
1.9.1

