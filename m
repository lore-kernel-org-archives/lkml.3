Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaGTEvQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 00:51:16 -0400
Received: from m12-12.163.com ([220.181.12.12]:41692 "EHLO m12-12.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778AbaGTEvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 00:51:14 -0400
X-Coremail-DSSMTP: 180.110.162.144
From: weiyj_lk@163.com
To: Clemens Ladisch <clemens@ladisch.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH -next] ALSA: bebob: Fix missing unlock on error in special_clk_ctl_put()
Date: Sun, 20 Jul 2014 12:50:35 +0800
Message-Id: <1405831835-26499-1-git-send-email-weiyj_lk@163.com>
X-Mailer: git-send-email 1.9.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: DMCowEAZKX6cSstTtAsvAQ--.220S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7WryUCw45GF18GrW3Zw13Jwb_yoWfZwc_ur
	W8Jr4vgr4YgF1fK348KrWfArsxtrn7ur47WFsIyay7C34qqFWvyFyjqryfZr97trWkt342
	9rnakr40qrn7CjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUYoSotUUUUU==
X-Originating-IP: [180.110.162.144]
X-CM-SenderInfo: pzhl5yxbonqiywtou0bp/xtbByh7O1lO+WvmthQAAsq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock before return from function special_clk_ctl_put()
in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/firewire/bebob/bebob_maudio.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/firewire/bebob/bebob_maudio.c b/sound/firewire/bebob/bebob_maudio.c
index 6af50eb..6748515 100644
--- a/sound/firewire/bebob/bebob_maudio.c
+++ b/sound/firewire/bebob/bebob_maudio.c
@@ -382,8 +382,10 @@ static int special_clk_ctl_put(struct snd_kcontrol *kctl,
 	mutex_lock(&bebob->mutex);
 
 	id = uval->value.enumerated.item[0];
-	if (id >= ARRAY_SIZE(special_clk_labels))
+	if (id >= ARRAY_SIZE(special_clk_labels)) {
+		mutex_unlock(&bebob->mutex);
 		return 0;
+	}
 
 	err = avc_maudio_set_special_clk(bebob, id,
 					 params->dig_in_fmt,

