Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbaKLBeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:34:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59565 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbaKLBeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:34:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Andrea Adami <andrea.adami@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH 3.17 273/319] mtd: cfi_cmdset_0001.c: fix resume for LH28F640BF chips
Date: Wed, 12 Nov 2014 10:16:51 +0900
Message-Id: <20141112011037.946825129@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

commit 89cf38dd536a7301d6b5f5ddd73f42074c01bfaa upstream.

After '#echo mem > /sys/power/state' some devices can not be properly resumed
because apparently the MTD Partition Configuration Register has been reset
to default thus the rootfs cannot be mounted cleanly on resume.
An example of this can be found in the SA-1100 Developer's Manual at 9.5.3.3
where the second step of the Sleep Shutdown Sequence is described:
"An internal reset is applied to the SA-1100. All units are reset...".

As workaround we refresh the PCR value as done initially on chip setup.

This behavior and the fix are confirmed by our tests done on 2 different Zaurus
collie units with kernel 3.17.

Fixes: 812c5fa82bae: ("mtd: cfi_cmdset_0001.c: add support for Sharp LH28F640BF NOR")
Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Signed-off-by: Andrea Adami <andrea.adami@gmail.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/chips/cfi_cmdset_0001.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mtd/chips/cfi_cmdset_0001.c
+++ b/drivers/mtd/chips/cfi_cmdset_0001.c
@@ -2590,6 +2590,8 @@ static void cfi_intelext_resume(struct m
 
 		/* Go to known state. Chip may have been power cycled */
 		if (chip->state == FL_PM_SUSPENDED) {
+			/* Refresh LH28F640BF Partition Config. Register */
+			fixup_LH28F640BF(mtd);
 			map_write(map, CMD(0xFF), cfi->chips[i].start);
 			chip->oldstate = chip->state = FL_READY;
 			wake_up(&chip->wq);


