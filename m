Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506AbaKYKtv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:49:51 -0500
Received: from smtp81.ord1c.emailsrvr.com ([108.166.43.81]:54499 "EHLO
	smtp81.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753073AbaKYKtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:49:49 -0500
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, lgirdwood@gmail.com,
        broonie@kernel.org, Pramod Gurav <pramod.gurav@smartplayin.com>
Subject: [RFC PATCH] regulator: core: do not disable regulator if boot_on is set
Date: Tue, 25 Nov 2014 16:23:23 +0530
Message-Id: <1416912803-10772-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the regulator core disables the regulators which are unused
or whose reference count is zero or if they are configured always_on.
This change adds a check in this logic to see if a regulator is
configured as boot_on and does not disable it if found true.

Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>

---

The issue was found on apq8064 based IFC6410 on which a fixed regulator
configured as regulator-boot-on in DT and was being disabled when not in
use. Tested this change on this board and found working.

 drivers/regulator/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index cd87c0c..9f7a13f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -4019,7 +4019,7 @@ static int __init regulator_init_complete(void)
 		ops = rdev->desc->ops;
 		c = rdev->constraints;
 
-		if (c && c->always_on)
+		if (c && (c->always_on || c->boot_on))
 			continue;
 
 		if (c && !(c->valid_ops_mask & REGULATOR_CHANGE_STATUS))
-- 
1.7.9.5

