Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755710AbaF3MKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:10:45 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52011 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753542AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Takashi Iwai <tiwai@suse.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 077/181] ALSA: control: Protect user controls against concurrent access
Date: Mon, 30 Jun 2014 13:51:38 +0200
Message-Id: <63e3edcbe69760fe21880183074b0084d3a3501a.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 07f4d9d74a04aa7c72c5dae0ef97565f28f17b92 upstream.

The user-control put and get handlers as well as the tlv do not protect against
concurrent access from multiple threads. Since the state of the control is not
updated atomically it is possible that either two write operations or a write
and a read operation race against each other. Both can lead to arbitrary memory
disclosure. This patch introduces a new lock that protects user-controls from
concurrent access. Since applications typically access controls sequentially
than in parallel a single lock per card should be fine.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/sound/core.h |  2 ++
 sound/core/control.c | 31 +++++++++++++++++++++++++------
 sound/core/init.c    |  1 +
 3 files changed, 28 insertions(+), 6 deletions(-)

diff --git a/include/sound/core.h b/include/sound/core.h
index 2a14f1f02d4f..d6bc9616058b 100644
--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -121,6 +121,8 @@ struct snd_card {
 	int user_ctl_count;		/* count of all user controls */
 	struct list_head controls;	/* all controls for this card */
 	struct list_head ctl_files;	/* active control files */
+	struct mutex user_ctl_lock;	/* protects user controls against
+					   concurrent access */
 
 	struct snd_info_entry *proc_root;	/* root for soundcard specific files */
 	struct snd_info_entry *proc_id;	/* the card id */
diff --git a/sound/core/control.c b/sound/core/control.c
index d8aa206e8bde..183fab277b69 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -992,6 +992,7 @@ static int snd_ctl_elem_unlock(struct snd_ctl_file *file,
 
 struct user_element {
 	struct snd_ctl_elem_info info;
+	struct snd_card *card;
 	void *elem_data;		/* element data */
 	unsigned long elem_data_size;	/* size of element data in bytes */
 	void *tlv_data;			/* TLV data */
@@ -1035,7 +1036,9 @@ static int snd_ctl_elem_user_get(struct snd_kcontrol *kcontrol,
 {
 	struct user_element *ue = kcontrol->private_data;
 
+	mutex_lock(&ue->card->user_ctl_lock);
 	memcpy(&ucontrol->value, ue->elem_data, ue->elem_data_size);
+	mutex_unlock(&ue->card->user_ctl_lock);
 	return 0;
 }
 
@@ -1044,10 +1047,12 @@ static int snd_ctl_elem_user_put(struct snd_kcontrol *kcontrol,
 {
 	int change;
 	struct user_element *ue = kcontrol->private_data;
-	
+
+	mutex_lock(&ue->card->user_ctl_lock);
 	change = memcmp(&ucontrol->value, ue->elem_data, ue->elem_data_size) != 0;
 	if (change)
 		memcpy(ue->elem_data, &ucontrol->value, ue->elem_data_size);
+	mutex_unlock(&ue->card->user_ctl_lock);
 	return change;
 }
 
@@ -1067,19 +1072,32 @@ static int snd_ctl_elem_user_tlv(struct snd_kcontrol *kcontrol,
 		new_data = memdup_user(tlv, size);
 		if (IS_ERR(new_data))
 			return PTR_ERR(new_data);
+		mutex_lock(&ue->card->user_ctl_lock);
 		change = ue->tlv_data_size != size;
 		if (!change)
 			change = memcmp(ue->tlv_data, new_data, size);
 		kfree(ue->tlv_data);
 		ue->tlv_data = new_data;
 		ue->tlv_data_size = size;
+		mutex_unlock(&ue->card->user_ctl_lock);
 	} else {
-		if (! ue->tlv_data_size || ! ue->tlv_data)
-			return -ENXIO;
-		if (size < ue->tlv_data_size)
-			return -ENOSPC;
+		int ret = 0;
+
+		mutex_lock(&ue->card->user_ctl_lock);
+		if (!ue->tlv_data_size || !ue->tlv_data) {
+			ret = -ENXIO;
+			goto err_unlock;
+		}
+		if (size < ue->tlv_data_size) {
+			ret = -ENOSPC;
+			goto err_unlock;
+		}
 		if (copy_to_user(tlv, ue->tlv_data, ue->tlv_data_size))
-			return -EFAULT;
+			ret = -EFAULT;
+err_unlock:
+		mutex_unlock(&ue->card->user_ctl_lock);
+		if (ret)
+			return ret;
 	}
 	return change;
 }
@@ -1211,6 +1229,7 @@ static int snd_ctl_elem_add(struct snd_ctl_file *file,
 	ue = kzalloc(sizeof(struct user_element) + private_size, GFP_KERNEL);
 	if (ue == NULL)
 		return -ENOMEM;
+	ue->card = card;
 	ue->info = *info;
 	ue->info.access = 0;
 	ue->elem_data = (char *)ue + sizeof(*ue);
diff --git a/sound/core/init.c b/sound/core/init.c
index d04785144601..b9268a55126b 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -215,6 +215,7 @@ int snd_card_create(int idx, const char *xid,
 	INIT_LIST_HEAD(&card->devices);
 	init_rwsem(&card->controls_rwsem);
 	rwlock_init(&card->ctl_files_rwlock);
+	mutex_init(&card->user_ctl_lock);
 	INIT_LIST_HEAD(&card->controls);
 	INIT_LIST_HEAD(&card->ctl_files);
 	spin_lock_init(&card->files_lock);
-- 
2.0.0

