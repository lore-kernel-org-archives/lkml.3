Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754931AbaEDPmt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:42:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36739 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754873AbaEDPmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:42:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.10 68/86] media: saa7134: fix WARN_ON during resume
Date: Sun,  4 May 2014 11:41:43 -0400
Message-Id: <20140504154149.705011135@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154140.444932005@linuxfoundation.org>
References: <20140504154140.444932005@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/pci/saa7134/saa7134-cards.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/pci/saa7134/saa7134-cards.c
+++ b/drivers/media/pci/saa7134/saa7134-cards.c
@@ -8045,8 +8045,8 @@ int saa7134_board_init2(struct saa7134_d
 		break;
 	} /* switch() */
 
-	/* initialize tuner */
-	if (TUNER_ABSENT != dev->tuner_type) {
+	/* initialize tuner (don't do this when resuming) */
+	if (!dev->insuspend && TUNER_ABSENT != dev->tuner_type) {
 		int has_demod = (dev->tda9887_conf & TDA9887_PRESENT);
 
 		/* Note: radio tuner address is always filled in,


