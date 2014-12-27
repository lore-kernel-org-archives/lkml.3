Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751552AbaL0LcI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 06:32:08 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:51877 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbaL0Lb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 06:31:59 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        silverhammermba@gmail.com, Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: [PATCH 2/2] input: synaptics - fix width calculation on image sensors
Date: Sat, 27 Dec 2014 12:31:29 +0100
Message-Id: <1419679889-6582-3-git-send-email-gabriele.mzt@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1419679889-6582-1-git-send-email-gabriele.mzt@gmail.com>
References: <1419679889-6582-1-git-send-email-gabriele.mzt@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When two or more fingers are on the touchpad, the 'w' slot holds the
finger count rather than the width. Retrieve the correct value encoded
in the lower bits of 'x', 'y' and 'z'.

The minimum width reported is 8 rather than 4 in this case, while the
maximum remains 15.

Signed-off-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
---
 drivers/input/mouse/synaptics.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index ea0563e..5ff4c5b 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -593,7 +593,9 @@ static void synaptics_parse_agm(const unsigned char buf[],
 	switch (agm_packet_type) {
 	case 1:
 		/* Gesture packet: (x, y, z) half resolution */
-		agm->w = hw->w;
+		agm->w = ((buf[1] & 0x01) |
+			  ((buf[2] & 0x01) << 1) |
+			  ((buf[5] & 0x01) << 2)) + 8;
 		agm->x = (((buf[4] & 0x0f) << 8) | buf[1]) << 1;
 		agm->y = (((buf[4] & 0xf0) << 4) | buf[2]) << 1;
 		agm->z = ((buf[3] & 0x30) | (buf[5] & 0x0f)) << 1;
-- 
2.1.4

