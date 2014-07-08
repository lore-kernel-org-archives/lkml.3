Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbaGHT37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:29:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54177 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755698AbaGHTIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:08:40 -0400
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
Message-ID: <lsq.1404846110.971401728@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 086/125] ALSA: control: Handle numid overflow
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

commit ac902c112d90a89e59916f751c2745f4dbdbb4bd upstream.

Each control gets automatically assigned its numids when the control is created.
The allocation is done by incrementing the numid by the amount of allocated
numids per allocation. This means that excessive creation and destruction of
controls (e.g. via SNDRV_CTL_IOCTL_ELEM_ADD/REMOVE) can cause the id to
eventually overflow. Currently when this happens for the control that caused the
overflow kctl->id.numid + kctl->count will also over flow causing it to be
smaller than kctl->id.numid. Most of the code assumes that this is something
that can not happen, so we need to make sure that it won't happen

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 sound/core/control.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -288,6 +288,10 @@ static bool snd_ctl_remove_numid_conflic
 {
 	struct snd_kcontrol *kctl;
 
+	/* Make sure that the ids assigned to the control do not wrap around */
+	if (card->last_numid >= UINT_MAX - count)
+		card->last_numid = 0;
+
 	list_for_each_entry(kctl, &card->controls, list) {
 		if (kctl->id.numid < card->last_numid + 1 + count &&
 		    kctl->id.numid + kctl->count > card->last_numid + 1) {

