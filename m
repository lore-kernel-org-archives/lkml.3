Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165AbaBGLvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:51:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42213 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136AbaBGLve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:51:34 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dan Carpenter <dan.carpenter@oracle.com>, Takashi Iwai <tiwai@suse.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 168/233] ALSA: bits vs bytes bug in snd_card_create()
Date: Fri,  7 Feb 2014 11:46:27 +0000
Message-Id: <1391773652-25214-169-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 4c3773eda49c872a3034382f8ec3080002e715bf upstream.

The test here is intended intended to prevent shift wrapping bugs when
we do "1U << idx2".  We should consider the number of bits in a u32
instead of the number of bytes.

[fix another chunk similarly by tiwai]

Fixes: 7bb2491b35a2 ('ALSA: Add kconfig to specify the max card numbers')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 sound/core/init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/core/init.c b/sound/core/init.c
index 6b90871..d047851 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -170,7 +170,7 @@ int snd_card_create(int idx, const char *xid,
 	if (idx < 0) {
 		for (idx2 = 0; idx2 < SNDRV_CARDS; idx2++) {
 			/* idx == -1 == 0xffff means: take any free slot */
-			if (idx2 < sizeof(int) && !(idx & (1U << idx2)))
+			if (idx2 < 32 && !(idx & (1U << idx2)))
 				continue;
 			if (!test_bit(idx2, snd_cards_lock)) {
 				if (module_slot_match(module, idx2)) {
@@ -183,7 +183,7 @@ int snd_card_create(int idx, const char *xid,
 	if (idx < 0) {
 		for (idx2 = 0; idx2 < SNDRV_CARDS; idx2++) {
 			/* idx == -1 == 0xffff means: take any free slot */
-			if (idx2 < sizeof(int) && !(idx & (1U << idx2)))
+			if (idx2 < 32 && !(idx & (1U << idx2)))
 				continue;
 			if (!test_bit(idx2, snd_cards_lock)) {
 				if (!slots[idx2] || !*slots[idx2]) {
-- 
1.8.3.2

