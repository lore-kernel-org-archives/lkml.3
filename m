Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585AbaANAUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:20:45 -0500
Received: from mail1.windriver.com ([147.11.146.13]:61794 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752421AbaANAUh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:20:37 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Russell King <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 1/3] arm: use subsys_initcall in non-modular pl320 IPC code
Date: Mon, 13 Jan 2014 19:19:41 -0500
Message-ID: <1389658783-9876-2-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389658783-9876-1-git-send-email-paul.gortmaker@windriver.com>
References: <1389658783-9876-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The drivers/mailbox/pl320-ipc.o is dependent on config PL320_MBOX
which is declared as a bool.  Hence the code is never going to be
modular.  So using module_init as an alias for __initcall can be
somewhat misleading.

Fix this up now, so that we can relocate module_init from
init.h into module.h in the future.  If we don't do this, we'd
have to add module.h to obviously non-modular code, and that
would be a worse thing.  Also add an inclusion of init.h, as
that was previously implicit.

Note that direct use of __initcall is discouraged, vs. one of the
priority categorized subgroups.  As __initcall gets mapped onto
device_initcall, our use of subsys_initcall (which seems to make
sense for IPC code) will thus change this registration from a
level 6-device to a level 4-subsys (i.e. slightly earlier).
However no impact of that small difference is expected.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/mailbox/pl320-ipc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/pl320-ipc.c b/drivers/mailbox/pl320-ipc.c
index d873cbae2fbb..b2737a2df1d3 100644
--- a/drivers/mailbox/pl320-ipc.c
+++ b/drivers/mailbox/pl320-ipc.c
@@ -195,4 +195,4 @@ static int __init ipc_init(void)
 {
 	return amba_driver_register(&pl320_driver);
 }
-module_init(ipc_init);
+subsys_initcall(ipc_init);
-- 
1.8.5.2

