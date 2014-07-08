Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278AbaGHTYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:24:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54206 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755717AbaGHTIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:41 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Takashi Iwai" <tiwai@suse.de>,
        "Jaroslav Kysela" <perex@perex.cz>,
        "Lars-Peter Clausen" <lars@metafoo.de>
Date: Tue, 08 Jul 2014 20:01:50 +0100
Message-ID: <lsq.1404846110.924949232@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 084/125] ALSA: control: Fix replacing user controls
In-Reply-To: <lsq.1404846109.699842714@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.61-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

commit 82262a46627bebb0febcc26664746c25cef08563 upstream.

There are two issues with the current implementation for replacing user
controls. The first is that the code does not check if the control is actually a
user control and neither does it check if the control is owned by the process
that tries to remove it. That allows userspace applications to remove arbitrary
controls, which can cause a user after free if a for example a driver does not
expect a control to be removed from under its feed.

The second issue is that on one hand when a control is replaced the
user_ctl_count limit is not checked and on the other hand the user_ctl_count is
increased (even though the number of user controls does not change). This allows
userspace, once the user_ctl_count limit as been reached, to repeatedly replace
a control until user_ctl_count overflows. Once that happens new controls can be
added effectively bypassing the user_ctl_count limit.

Both issues can be fixed by instead of open-coding the removal of the control
that is to be replaced to use snd_ctl_remove_user_ctl(). This function does
proper permission checks as well as decrements user_ctl_count after the control
has been removed.

Note that by using snd_ctl_remove_user_ctl() the check which returns -EBUSY at
beginning of the function if the control already exists is removed. This is not
a problem though since the check is quite useless, because the lock that is
protecting the control list is released between the check and before adding the
new control to the list, which means that it is possible that a different
control with the same settings is added to the list after the check. Luckily
there is another check that is done while holding the lock in snd_ctl_add(), so
we'll rely on that to make sure that the same control is not added twice.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/core/control.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -1151,8 +1151,6 @@ static int snd_ctl_elem_add(struct snd_c
 	struct user_element *ue;
 	int idx, err;
 
-	if (!replace && card->user_ctl_count >= MAX_USER_CONTROLS)
-		return -ENOMEM;
 	if (info->count < 1)
 		return -EINVAL;
 	access = info->access == 0 ? SNDRV_CTL_ELEM_ACCESS_READWRITE :
@@ -1161,21 +1159,16 @@ static int snd_ctl_elem_add(struct snd_c
 				 SNDRV_CTL_ELEM_ACCESS_TLV_READWRITE));
 	info->id.numid = 0;
 	memset(&kctl, 0, sizeof(kctl));
-	down_write(&card->controls_rwsem);
-	_kctl = snd_ctl_find_id(card, &info->id);
-	err = 0;
-	if (_kctl) {
-		if (replace)
-			err = snd_ctl_remove(card, _kctl);
-		else
-			err = -EBUSY;
-	} else {
-		if (replace)
-			err = -ENOENT;
+
+	if (replace) {
+		err = snd_ctl_remove_user_ctl(file, &info->id);
+		if (err)
+			return err;
 	}
-	up_write(&card->controls_rwsem);
-	if (err < 0)
-		return err;
+
+	if (card->user_ctl_count >= MAX_USER_CONTROLS)
+		return -ENOMEM;
+
 	memcpy(&kctl.id, &info->id, sizeof(info->id));
 	kctl.count = info->owner ? info->owner : 1;
 	access |= SNDRV_CTL_ELEM_ACCESS_USER;

