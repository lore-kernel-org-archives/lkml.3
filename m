Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934795AbaBDVMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:12:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934441AbaBDVMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:12:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 3.13 090/140] ALSA: bits vs bytes bug in snd_card_create()
Date: Tue,  4 Feb 2014 13:11:17 -0800
Message-Id: <20140204211039.538015801@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/core/init.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -170,7 +170,7 @@ int snd_card_create(int idx, const char
 	if (idx < 0) {
 		for (idx2 = 0; idx2 < SNDRV_CARDS; idx2++) {
 			/* idx == -1 == 0xffff means: take any free slot */
-			if (idx2 < sizeof(int) && !(idx & (1U << idx2)))
+			if (idx2 < 32 && !(idx & (1U << idx2)))
 				continue;
 			if (!test_bit(idx2, snd_cards_lock)) {
 				if (module_slot_match(module, idx2)) {
@@ -183,7 +183,7 @@ int snd_card_create(int idx, const char
 	if (idx < 0) {
 		for (idx2 = 0; idx2 < SNDRV_CARDS; idx2++) {
 			/* idx == -1 == 0xffff means: take any free slot */
-			if (idx2 < sizeof(int) && !(idx & (1U << idx2)))
+			if (idx2 < 32 && !(idx & (1U << idx2)))
 				continue;
 			if (!test_bit(idx2, snd_cards_lock)) {
 				if (!slots[idx2] || !*slots[idx2]) {


