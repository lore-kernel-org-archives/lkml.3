Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbaAUVlC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:41:02 -0500
Received: from mail.windriver.com ([147.11.1.11]:56343 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbaAUVY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:24:58 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arch@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH 20/73] arm: use subsys_initcall in non-modular pl320 IPC code
Date: Tue, 21 Jan 2014 16:22:23 -0500
Message-ID: <1390339396-3479-21-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.4.1
In-Reply-To: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
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

Note that direct use of __initcall is discouraged, vs. one
of the priority categorized subgroups.  As __initcall gets
mapped onto device_initcall, our use of subsys_initcall (which
seems to make sense for netfilter code) will thus change this
registration from level 6-device to level 4-subsys (i.e. slightly
earlier).  However no impact of that small difference is expected.

Cc: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/mailbox/pl320-ipc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/pl320-ipc.c b/drivers/mailbox/pl320-ipc.c
index d873cba..b2737a2 100644
--- a/drivers/mailbox/pl320-ipc.c
+++ b/drivers/mailbox/pl320-ipc.c
@@ -195,4 +195,4 @@ static int __init ipc_init(void)
 {
 	return amba_driver_register(&pl320_driver);
 }
-module_init(ipc_init);
+subsys_initcall(ipc_init);
-- 
1.8.4.1

