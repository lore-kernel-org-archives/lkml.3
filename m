Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536AbaEMJeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:34:12 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60932 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760125AbaEMJ25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:57 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 094/182] media: saa7134: fix WARN_ON during resume
Date: Tue, 13 May 2014 11:27:26 +0200
Message-Id: <089d29739d360f4e123e2e7f7a5a23a570ef3ddc.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hans Verkuil <hans.verkuil@cisco.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 30d652823de5fd7907d40e969a2d8e23938d8d03 upstream.

Do not attempt to reload the tuner modules when resuming after a suspend.
This triggers a WARN_ON in kernel/kmod.c:148 __request_module.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=69581.

This has always been wrong, but it was never noticed until the WARN_ON
was added in 3.9.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/media/pci/saa7134/saa7134-cards.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
index d45e7f6ff332..e87a734637a9 100644
--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -8045,8 +8045,8 @@ int saa7134_board_init2(struct saa7134_dev *dev)
 		break;
 	} /* switch() */
 
-	/* initialize tuner */
-	if (TUNER_ABSENT != dev->tuner_type) {
+	/* initialize tuner (don't do this when resuming) */
+	if (!dev->insuspend && TUNER_ABSENT != dev->tuner_type) {
 		int has_demod = (dev->tda9887_conf & TDA9887_PRESENT);
 
 		/* Note: radio tuner address is always filled in,
-- 
1.9.3

