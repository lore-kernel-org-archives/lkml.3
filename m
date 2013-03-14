Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab3CNKoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:44:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52038 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757295Ab3CNKiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:38:04 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 68/88] ALSA: vmaster: Fix slave change notification
Date: Thu, 14 Mar 2013 10:36:01 +0000
Message-Id: <1363257381-15900-69-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 2069d483b39a603a5f3428a19d3b4ac89aa97f48 upstream.

When a value of a vmaster slave control is changed, the ctl change
notification is sometimes ignored.  This happens when the master
control overrides, e.g. when the corresponding master control is
muted.  The reason is that slave_put() returns the value of the actual
slave put callback, and it doesn't reflect the virtual slave value
change.

This patch fixes the function just to return 1 whenever a slave value
is changed.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/core/vmaster.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/core/vmaster.c b/sound/core/vmaster.c
index 8575861..0097f36 100644
--- a/sound/core/vmaster.c
+++ b/sound/core/vmaster.c
@@ -213,7 +213,10 @@ static int slave_put(struct snd_kcontrol *kcontrol,
 	}
 	if (!changed)
 		return 0;
-	return slave_put_val(slave, ucontrol);
+	err = slave_put_val(slave, ucontrol);
+	if (err < 0)
+		return err;
+	return 1;
 }
 
 static int slave_tlv_cmd(struct snd_kcontrol *kcontrol,
-- 
1.8.1.2

