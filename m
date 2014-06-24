Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965258AbaFXP5M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 11:57:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33469 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932480AbaFXP5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:57:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.15 55/61] ALSA: control: Protect user controls against concurrent access
Date: Tue, 24 Jun 2014 11:51:38 -0400
Message-Id: <20140624154955.300775475@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154952.751713761@linuxfoundation.org>
References: <20140624154952.751713761@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lars-Peter Clausen <lars@metafoo.de>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/sound/core.h |    2 ++
 sound/core/control.c |   31 +++++++++++++++++++++++++------
 sound/core/init.c    |    1 +
 3 files changed, 28 insertions(+), 6 deletions(-)

--- a/include/sound/core.h
+++ b/include/sound/core.h
@@ -116,6 +116,8 @@ struct snd_card {
 	int user_ctl_count;		/* count of all user controls */
 	struct list_head controls;	/* all controls for this card */
 	struct list_head ctl_files;	/* active control files */
+	struct mutex user_ctl_lock;	/* protects user controls against
+					   concurrent access */
 
 	struct snd_info_entry *proc_root;	/* root for soundcard specific files */
 	struct snd_info_entry *proc_id;	/* the card id */
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -991,6 +991,7 @@ static int snd_ctl_elem_unlock(struct sn
 
 struct user_element {
 	struct snd_ctl_elem_info info;
+	struct snd_card *card;
 	void *elem_data;		/* element data */
 	unsigned long elem_data_size;	/* size of element data in bytes */
 	void *tlv_data;			/* TLV data */
@@ -1034,7 +1035,9 @@ static int snd_ctl_elem_user_get(struct
 {
 	struct user_element *ue = kcontrol->private_data;
 
+	mutex_lock(&ue->card->user_ctl_lock);
 	memcpy(&ucontrol->value, ue->elem_data, ue->elem_data_size);
+	mutex_unlock(&ue->card->user_ctl_lock);
 	return 0;
 }
 
@@ -1043,10 +1046,12 @@ static int snd_ctl_elem_user_put(struct
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
 
@@ -1066,19 +1071,32 @@ static int snd_ctl_elem_user_tlv(struct
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
@@ -1210,6 +1228,7 @@ static int snd_ctl_elem_add(struct snd_c
 	ue = kzalloc(sizeof(struct user_element) + private_size, GFP_KERNEL);
 	if (ue == NULL)
 		return -ENOMEM;
+	ue->card = card;
 	ue->info = *info;
 	ue->info.access = 0;
 	ue->elem_data = (char *)ue + sizeof(*ue);
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -232,6 +232,7 @@ int snd_card_new(struct device *parent,
 	INIT_LIST_HEAD(&card->devices);
 	init_rwsem(&card->controls_rwsem);
 	rwlock_init(&card->ctl_files_rwlock);
+	mutex_init(&card->user_ctl_lock);
 	INIT_LIST_HEAD(&card->controls);
 	INIT_LIST_HEAD(&card->ctl_files);
 	spin_lock_init(&card->files_lock);


