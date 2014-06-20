Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529AbaFTTmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 15:42:53 -0400
Received: from mail-we0-f178.google.com ([74.125.82.178]:55485 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaFTTmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 15:42:52 -0400
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH 1/4] thunderbolt: Add casts to prevent endianness warnings
Date: Fri, 20 Jun 2014 21:42:22 +0200
Message-Id: <1403293345-20772-1-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thunderbolt packets are big endian. Cast pkg->buffer to __be32* when
accessing the checksum.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/thunderbolt/ctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thunderbolt/ctl.c b/drivers/thunderbolt/ctl.c
index 4c6da92..799634b 100644
--- a/drivers/thunderbolt/ctl.c
+++ b/drivers/thunderbolt/ctl.c
@@ -355,7 +355,7 @@ static int tb_ctl_tx(struct tb_ctl *ctl, void *data, size_t len,
 	pkg->frame.sof = type;
 	pkg->frame.eof = type;
 	cpu_to_be32_array(pkg->buffer, data, len / 4);
-	*(u32 *) (pkg->buffer + len) = tb_crc(pkg->buffer, len);
+	*(__be32 *) (pkg->buffer + len) = tb_crc(pkg->buffer, len);
 
 	res = ring_tx(ctl->tx, &pkg->frame);
 	if (res) /* ring is stopped */
@@ -412,7 +412,7 @@ static void tb_ctl_rx_callback(struct tb_ring *ring, struct ring_frame *frame,
 	}
 
 	frame->size -= 4; /* remove checksum */
-	if (*(u32 *) (pkg->buffer + frame->size)
+	if (*(__be32 *) (pkg->buffer + frame->size)
 			!= tb_crc(pkg->buffer, frame->size)) {
 		tb_ctl_err(pkg->ctl,
 			   "RX: checksum mismatch, dropping packet\n");
-- 
2.0.0

