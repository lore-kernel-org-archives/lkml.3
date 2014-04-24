Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987AbaDXJ46 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 05:56:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46735 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330AbaDXIyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:54:25 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 103/182] [media] saa7134: fix WARN_ON during resume
Date: Thu, 24 Apr 2014 09:50:28 +0100
Message-Id: <1398329507-5911-104-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hans.verkuil@cisco.com>

commit 30d652823de5fd7907d40e969a2d8e23938d8d03 upstream.

Do not attempt to reload the tuner modules when resuming after a suspend.
This triggers a WARN_ON in kernel/kmod.c:148 __request_module.

This fixes https://bugzilla.kernel.org/show_bug.cgi?id=69581.

This has always been wrong, but it was never noticed until the WARN_ON
was added in 3.9.

Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/media/pci/saa7134/saa7134-cards.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/pci/saa7134/saa7134-cards.c b/drivers/media/pci/saa7134/saa7134-cards.c
index d45e7f6..e87a734 100644
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
1.9.1

