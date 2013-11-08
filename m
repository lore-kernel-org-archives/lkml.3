Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab3KHC1Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 21:27:24 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34885 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932673Ab3KHCVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 21:21:53 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Takashi Iwai <tiwai@suse.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 69/91] ALSA: hda - Fix unbalanced runtime PM refcount after S3/S4
Date: Thu,  7 Nov 2013 18:15:24 -0800
Message-Id: <1383876946-2396-70-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1383876946-2396-1-git-send-email-kamal@canonical.com>
References: <1383876946-2396-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit e6bbe666673ab044a3d39ddb74e4d9a401cf1d6f upstream.

When a machine goes to S3/S4 after power-save is enabled, the runtime
PM refcount might be incorrectly decreased because the power-down
triggered soon after resume assumes that the controller was already
powered up, and issues the pm_notify down.

This patch fixes the incorrect pm_notify call simply by checking the
current value properly.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 sound/pci/hda/hda_codec.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index f283157..d048204 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -4514,8 +4514,8 @@ static void hda_power_work(struct work_struct *work)
 	spin_unlock(&codec->power_lock);
 
 	state = hda_call_codec_suspend(codec, true);
-	codec->pm_down_notified = 0;
-	if (!bus->power_keep_link_on && (state & AC_PWRST_CLK_STOP_OK)) {
+	if (!codec->pm_down_notified &&
+	    !bus->power_keep_link_on && (state & AC_PWRST_CLK_STOP_OK)) {
 		codec->pm_down_notified = 1;
 		hda_call_pm_notify(bus, false);
 	}
-- 
1.8.1.2

