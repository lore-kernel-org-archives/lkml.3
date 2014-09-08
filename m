Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbaIHObo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 10:31:44 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:41544 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794AbaIHObn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:31:43 -0400
Date: Mon, 8 Sep 2014 16:31:38 +0200
From: Robert Richter <rric@kernel.org>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        linux-arm-kernel@lists.infradead.org,
        Robert Richter <rrichter@cavium.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ITS: Fixing 32 bit compatibility
Message-ID: <20140908143138.GZ4703@rric.localhost>
References: <1410185480-5153-1-git-send-email-rric@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410185480-5153-1-git-send-email-rric@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc,

On 08.09.14 16:11:19, Robert Richter wrote:
> From: Robert Richter <rrichter@cavium.com>
> 
> Fixing 32 bit compatibility by using ULL for u64 constants.

the same is true for gicv3-its (branch 'gicv3/its' of
git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms). See
the patch below. You may merge the fixes with your patches or apply it
on top of yours.

-Robert



>From 38a71030b9b93a14afada6979c709f6addac5112 Mon Sep 17 00:00:00 2001
From: Robert Richter <rrichter@cavium.com>
Date: Tue, 26 Aug 2014 18:08:56 +0200
Subject: [PATCH] ITS: Fixing 32 bit compatibility

Fixing 32 bit compatibility by using ULL for u64 constants.

Signed-off-by: Robert Richter <rrichter@cavium.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 26927521fc28..2fda6935ad32 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -173,55 +173,55 @@ static struct rdist *gic_rdist;
 
 static void its_encode_cmd(struct its_cmd_block *cmd, u8 cmd_nr)
 {
-	cmd->raw_cmd[0] &= ~0xffUL;
+	cmd->raw_cmd[0] &= ~0xffULL;
 	cmd->raw_cmd[0] |= cmd_nr;
 }
 
 static void its_encode_devid(struct its_cmd_block *cmd, u32 devid)
 {
-	cmd->raw_cmd[0] &= 0xffffffffUL;
+	cmd->raw_cmd[0] &= 0xffffffffULL;
 	cmd->raw_cmd[0] |= ((u64)devid) << 32;
 }
 
 static void its_encode_event_id(struct its_cmd_block *cmd, u32 id)
 {
-	cmd->raw_cmd[1] &= ~0xffffffffUL;
+	cmd->raw_cmd[1] &= ~0xffffffffULL;
 	cmd->raw_cmd[1] |= id;
 }
 
 static void its_encode_phys_id(struct its_cmd_block *cmd, u32 phys_id)
 {
-	cmd->raw_cmd[1] &= 0xffffffffUL;
+	cmd->raw_cmd[1] &= 0xffffffffULL;
 	cmd->raw_cmd[1] |= ((u64)phys_id) << 32;
 }
 
 static void its_encode_size(struct its_cmd_block *cmd, u8 size)
 {
-	cmd->raw_cmd[1] &= ~0xffUL;
-	cmd->raw_cmd[1] |= size & 0xff;
+	cmd->raw_cmd[1] &= ~0xffULL;
+	cmd->raw_cmd[1] |= size;
 }
 
 static void its_encode_itt(struct its_cmd_block *cmd, u64 itt_addr)
 {
-	cmd->raw_cmd[2] &= ~0xffffffffffffUL;
-	cmd->raw_cmd[2] |= itt_addr & 0xffffffffff00UL;
+	cmd->raw_cmd[2] &= ~0xffffffffffffULL;
+	cmd->raw_cmd[2] |= itt_addr & 0xffffffffff00ULL;
 }
 
 static void its_encode_valid(struct its_cmd_block *cmd, int valid)
 {
-	cmd->raw_cmd[2] &= ~(1UL << 63);
+	cmd->raw_cmd[2] &= ~(1ULL << 63);
 	cmd->raw_cmd[2] |= ((u64)!!valid) << 63;
 }
 
 static void its_encode_target(struct its_cmd_block *cmd, u64 target_addr)
 {
-	cmd->raw_cmd[2] &= ~(0xffffffffUL << 16);
-	cmd->raw_cmd[2] |= (target_addr & (0xffffffffUL << 16));
+	cmd->raw_cmd[2] &= ~(0xffffffffULL << 16);
+	cmd->raw_cmd[2] |= (target_addr & (0xffffffffULL << 16));
 }
 
 static void its_encode_collection(struct its_cmd_block *cmd, u16 col)
 {
-	cmd->raw_cmd[2] &= ~0xffffUL;
+	cmd->raw_cmd[2] &= ~0xffffULL;
 	cmd->raw_cmd[2] |= col;
 }
 
@@ -1221,8 +1221,8 @@ static int its_msi_setup_irq(struct msi_chip *chip,
 
 	addr = its->phys_base + GITS_TRANSLATER;
 
-	msg.address_lo		= addr & ((1UL << 32) - 1);
-	msg.address_hi		= addr >> 32;
+	msg.address_lo		= (u32)addr;
+	msg.address_hi		= (u32)(addr >> 32);
 	msg.data		= vec_nr;
 
 	write_msi_msg(irq, &msg);
-- 
2.0.1

